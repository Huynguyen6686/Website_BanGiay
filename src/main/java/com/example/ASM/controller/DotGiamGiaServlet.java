package com.example.ASM.controller;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.*;
import com.example.ASM.repository.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet({
        "/quan-ly-dot-giam-gia",
        "/quan-ly-dot-giam-gia/add",
        "/quan-ly-dot-giam-gia/update",
        "/quan-ly-dot-giam-gia/toggle"  // ĐỔI THÀNH TOGGLE THAY VÌ DELETE
})
public class DotGiamGiaServlet extends HttpServlet {

    private final DotGiamGiaRepository dggRepo = new DotGiamGiaRepository();
    private final GiayRepository giayRepo = new GiayRepository();
    private final GiayChiTietRepository gctRepo = new GiayChiTietRepository();
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        loadData(req);
        req.setAttribute("listGiay", giayRepo.getAll());
        req.getRequestDispatcher("/view/DotGiamGia.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        // XỬ LÝ BẬT/TẮT TRẠNG THÁI
        if (uri.endsWith("/toggle")) {
            toggleStatus(req, resp);
            return;
        }

        // XỬ LÝ THÊM / SỬA ĐỢT GIẢM GIÁ
        handleAddOrUpdate(req, resp);
    }

    // PHƯƠNG THỨC MỚI: BẬT/TẮT TRẠNG THÁI
    private void toggleStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            String idParam = req.getParameter("id");
            if (idParam == null || idParam.isEmpty()) {
                throw new Exception("ID không hợp lệ");
            }

            int id = Integer.parseInt(idParam);
            DotGiamGia dgg = dggRepo.findById(id);

            if (dgg == null) {
                throw new Exception("Không tìm thấy đợt giảm giá");
            }

            // ĐẢO TRẠNG THÁI: 1 → 0, 0 → 1
            dgg.setKichHoat(dgg.getKichHoat() == 1 ? 0 : 1);
            dggRepo.saveOrUpdate(dgg);

            resp.getWriter().write("{\"success\": true}");
        } catch (Exception e) {
            resp.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    // PHƯƠNG THỨC CHÍNH: THÊM / SỬA ĐỢT GIẢM GIÁ
    private void handleAddOrUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String idParam = req.getParameter("id");
            String ma = req.getParameter("ma");
            String ten = req.getParameter("ten");
            String moTa = req.getParameter("moTa");

            double phanTram = 0;
            String pt = req.getParameter("phanTram");
            if (pt != null && !pt.isEmpty()) phanTram = Double.parseDouble(pt);

            double soTienGiam = 0;
            String stg = req.getParameter("soTienGiam");
            if (stg != null && !stg.isEmpty()) soTienGiam = Double.parseDouble(stg);

            int kichHoat = Integer.parseInt(req.getParameter("kichHoat"));
            String ngayBatDau = req.getParameter("ngayBatDau");
            String ngayKetThuc = req.getParameter("ngayKetThuc");
            String[] giayIds = req.getParameterValues("giayIds");

            // Validate
            if (ma == null || ma.trim().isEmpty()) throw new Exception("Mã đợt không được để trống");
            if (ten == null || ten.trim().isEmpty()) throw new Exception("Tên đợt không được để trống");
            if (phanTram <= 0 && soTienGiam <= 0) throw new Exception("Phải nhập ít nhất phần trăm hoặc số tiền giảm");
            if (ngayBatDau == null || ngayKetThuc == null || ngayBatDau.isEmpty() || ngayKetThuc.isEmpty())
                throw new Exception("Vui lòng chọn đầy đủ ngày");

            Date ngayBatDauDate = Date.valueOf(ngayBatDau);
            Date ngayKetThucDate = Date.valueOf(ngayKetThuc);
            if (ngayKetThucDate.before(ngayBatDauDate)) throw new Exception("Ngày kết thúc phải sau ngày bắt đầu");

            boolean isUpdate = idParam != null && !idParam.isEmpty();

            // Kiểm tra trùng mã
            boolean maExists = dggRepo.getAll().stream()
                    .anyMatch(d -> d.getMa().equalsIgnoreCase(ma.trim()) &&
                            (!isUpdate || !d.getId().equals(Integer.parseInt(idParam))));
            if (maExists) throw new Exception("Mã đợt giảm giá đã tồn tại!");

            DotGiamGia dgg = isUpdate
                    ? dggRepo.findById(Integer.parseInt(idParam))
                    : new DotGiamGia();

            if (isUpdate && dgg == null) {
                throw new Exception("Không tìm thấy đợt giảm giá để sửa!");
            }

            // Gán dữ liệu
            dgg.setMa(ma.trim().toUpperCase());
            dgg.setTen(ten.trim());
            dgg.setMoTa(moTa != null ? moTa.trim() : null);
            dgg.setPhanTram(phanTram > 0 ? phanTram : null);
            dgg.setSoTienGiam(soTienGiam > 0 ? soTienGiam : null);
            dgg.setNgayBatDau(ngayBatDauDate);
            dgg.setNgayKetThuc(ngayKetThucDate);
            dgg.setKichHoat(kichHoat);

            dggRepo.saveOrUpdate(dgg);

            // Lấy ID an toàn sau khi lưu
            Integer dotId = dgg.getId();
            if (dotId == null) {
                dotId = dggRepo.getAll().stream()
                        .filter(x -> x.getMa().equals(dgg.getMa()))
                        .findFirst()
                        .map(DotGiamGia::getId)
                        .orElseThrow(() -> new Exception("Lỗi lấy ID sau khi lưu"));
            }

            // Xử lý sản phẩm
            try (var session = HibernalUtil.getFACTORY().openSession()) {
                var tx = session.beginTransaction();

                session.createQuery("DELETE FROM DotGiamGiaGiay d WHERE d.dotGiamGia.id = :dotId")
                        .setParameter("dotId", dotId)
                        .executeUpdate();

                if (giayIds != null && giayIds.length > 0) {
                    for (String gId : giayIds) {
                        int giayId = Integer.parseInt(gId);
                        gctRepo.getByGiayId(giayId).forEach(gct -> {
                            DotGiamGiaGiay link = new DotGiamGiaGiay();
                            link.setDotGiamGia(dgg);
                            link.setGiayChiTiet(gct);
                            session.persist(link);
                        });
                    }
                }
                tx.commit();
            }

            req.getSession().setAttribute("message", isUpdate ? "Cập nhật thành công!" : "Tạo đợt giảm giá thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/quan-ly-dot-giam-gia");
    }

    private void loadData(HttpServletRequest req) {
        HibernalUtil.getFACTORY().getCache().evictAllRegions(); // luôn lấy dữ liệu mới nhất

        List<DotGiamGia> all = dggRepo.getAll();

        int page = 1;
        String p = req.getParameter("page");
        if (p != null) {
            try { page = Integer.parseInt(p); } catch (Exception ignored) {}
        }
        if (page < 1) page = 1;

        int totalItems = all.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) page = totalPages;

        int from = (page - 1) * PAGE_SIZE;
        int to = Math.min(from + PAGE_SIZE, totalItems);
        List<DotGiamGia> pageItems = all.subList(from, to);

        req.setAttribute("pageItems", pageItems);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalDot", totalItems);
        req.setAttribute("dangDienRa", dggRepo.countDangDienRa());
        req.setAttribute("sapDienRa", dggRepo.countSapDienRa());
        req.setAttribute("daKetThuc", dggRepo.countDaKetThuc());
    }
}