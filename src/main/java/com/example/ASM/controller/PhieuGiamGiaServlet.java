package com.example.ASM.controller;

import com.example.ASM.entity.PhieuGiamGia;
import com.example.ASM.repository.PhieuGiamGiaRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet({
        "/quan-ly-phieu-giam-gia",
        "/quan-ly-phieu-giam-gia/add",
        "/quan-ly-phieu-giam-gia/update",
        "/quan-ly-phieu-giam-gia/delete"
})
public class PhieuGiamGiaServlet extends HttpServlet {

    private final PhieuGiamGiaRepository pggRepo = new PhieuGiamGiaRepository();
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        // XÓA PHIẾU
        if (uri.endsWith("/delete")) {
            String idParam = req.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    pggRepo.delete(Integer.parseInt(idParam));
                    req.getSession().setAttribute("message", "Xóa phiếu giảm giá thành công!");
                } catch (Exception e) {
                    req.getSession().setAttribute("error", "Xóa thất bại: " + e.getMessage());
                }
            }
        }

        loadDataWithPaging(req);
        req.setAttribute("pageTitle", "Quản lý phiếu giảm giá");
        req.getRequestDispatcher("/view/PhieuGiamGia.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String idParam = req.getParameter("id");
            String ma = req.getParameter("ma");
            String ten = req.getParameter("ten");
            int loai = Integer.parseInt(req.getParameter("loai"));
            double giaTri = loai == 3 ? 0 : Double.parseDouble(req.getParameter("giaTri"));
            int soLuong = Integer.parseInt(req.getParameter("soLuong"));
            int kichHoat = Integer.parseInt(req.getParameter("kichHoat"));
            String ngayBatDauStr = req.getParameter("ngayBatDau");
            String ngayKetThucStr = req.getParameter("ngayKetThuc");

            // Lấy tham số Điều kiện
            String dieuKienStr = req.getParameter("dieuKien");
            double dieuKien = (dieuKienStr == null || dieuKienStr.trim().isEmpty())
                    ? 0 : Double.parseDouble(dieuKienStr);

            // [MỚI] Lấy tham số Giá trị tối đa
            String giaTriToiDaStr = req.getParameter("giaTriToiDa");
            double giaTriToiDa = (giaTriToiDaStr == null || giaTriToiDaStr.trim().isEmpty())
                    ? 0 : Double.parseDouble(giaTriToiDaStr);

            // --- VALIDATE DỮ LIỆU ---
            if (ma == null || ma.trim().isEmpty()) throw new Exception("Mã phiếu không được để trống");
            if (ten == null || ten.trim().isEmpty()) throw new Exception("Tên phiếu không được để trống");
            if (loai != 1 && loai != 2 && loai != 3) throw new Exception("Loại phiếu không hợp lệ");
            if (loai != 3 && giaTri <= 0) throw new Exception("Giá trị phải lớn hơn 0");
            if (soLuong < 0) throw new Exception("Số lượng không được âm");
            if (ngayBatDauStr == null || ngayKetThucStr == null) throw new Exception("Vui lòng chọn ngày");
            if (dieuKien < 0) throw new Exception("Điều kiện đơn hàng không được âm");

            // [LOGIC MỚI] Check giá trị tối đa khi loại là Phần trăm (1)
            if (loai == 1) {
                if (giaTriToiDa <= 0) throw new Exception("Voucher phần trăm phải có mức giảm tối đa lớn hơn 0");
            }

            // [LOGIC CŨ] Check giá trị giảm <= Điều kiện khi loại là Tiền mặt (2)
            if (loai == 2 && giaTri > dieuKien) {
                throw new Exception("Giá trị giảm (" + String.format("%,.0f", giaTri) + ") không được lớn hơn đơn tối thiểu (" + String.format("%,.0f", dieuKien) + ")");
            }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            java.sql.Date ngayBatDau = java.sql.Date.valueOf(ngayBatDauStr);
            java.sql.Date ngayKetThuc = java.sql.Date.valueOf(ngayKetThucStr);

            if (ngayKetThuc.before(ngayBatDau)) throw new Exception("Ngày kết thúc phải sau ngày bắt đầu");

            // SET DATA
            PhieuGiamGia pgg = new PhieuGiamGia();
            pgg.setMa(ma.trim().toUpperCase());
            pgg.setTen(ten.trim());
            pgg.setLoai(loai);
            pgg.setGiaTri(giaTri);
            pgg.setDieuKien(dieuKien);
            pgg.setGiaTriToiDa(giaTriToiDa); // [MỚI]
            pgg.setSoLuong(soLuong);
            pgg.setKichHoat(kichHoat);
            pgg.setNgayBatDau(ngayBatDau);
            pgg.setNgayKetThuc(ngayKetThuc);

            if (idParam == null || idParam.isEmpty()) {
                if (ma.trim().isEmpty()) {
                    int count = pggRepo.getAll().size() + 1;
                    pgg.setMa("PGG" + String.format("%04d", count));
                }
                pggRepo.saveOrUpdate(pgg);
                req.getSession().setAttribute("message", "Tạo phiếu giảm giá thành công!");
            } else {
                pgg.setId(Integer.parseInt(idParam));
                pggRepo.saveOrUpdate(pgg);
                req.getSession().setAttribute("message", "Cập nhật phiếu giảm giá thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/quan-ly-phieu-giam-gia");
    }

    private void loadDataWithPaging(HttpServletRequest req) {
        List<PhieuGiamGia> all = pggRepo.getAll();
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null && !p.isEmpty()) {
                page = Integer.parseInt(p);
                if (page < 1) page = 1;
            }
        } catch (Exception ignored) {}

        int totalItems = all.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) page = totalPages;

        int from = (page - 1) * PAGE_SIZE;
        int to = Math.min(from + PAGE_SIZE, totalItems);
        List<PhieuGiamGia> pageItems = all.subList(from, to);

        req.setAttribute("listPhieu", all);
        req.setAttribute("pageItems", pageItems);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalPhieu", totalItems);
        req.setAttribute("dangHoatDong", pggRepo.countDangHoatDong());
        req.setAttribute("hetHan", pggRepo.countHetHan());
        req.setAttribute("hetSoLuong", pggRepo.countHetSoLuong());
    }
}