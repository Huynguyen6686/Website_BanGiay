package com.example.ASM.controller;

import com.example.ASM.entity.NhanVien;
import com.example.ASM.entity.Role;
import com.example.ASM.repository.NhanVienRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet({
        "/quan-ly-nhan-vien",
        "/quan-ly-nhan-vien/add",
        "/quan-ly-nhan-vien/update",
        "/quan-ly-nhan-vien/delete",
        "/quan-ly-nhan-vien/unlock",
        "/chi-tiet-nhan-vien"  // CHI TIẾT NHÂN VIÊN
})
public class QuanLyNhanVienServlet extends HttpServlet {

    private final NhanVienRepository nvRepo = new NhanVienRepository();
    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.endsWith("/delete")) {
            String id = req.getParameter("id");
            if (id != null) {
                nvRepo.lock(id);
                req.getSession().setAttribute("message", "Đã ngừng hoạt động nhân viên!");
            }
        } else if (uri.endsWith("/unlock")) {
            String id = req.getParameter("id");
            if (id != null) {
                nvRepo.unlock(id);
                req.getSession().setAttribute("message", "Đã kích hoạt lại nhân viên!");
            }
        } else if (uri.contains("/chi-tiet-nhan-vien")) {
            String id = req.getParameter("id");
            if (id != null) {
                NhanVien nv = nvRepo.findById(id);
                req.setAttribute("nhanVien", nv);
                req.getRequestDispatcher("/view/ChiTietNhanVien.jsp").forward(req, resp);
                return;
            }
        }

        loadData(req);
        req.setAttribute("listRole", nvRepo.getAllRoles());
        req.getRequestDispatcher("/view/QuanLyNhanVien.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            String id = req.getParameter("id");
            String hoTen = req.getParameter("hoTen");
            String email = req.getParameter("email");
            String sdt = req.getParameter("sdt");
            String diaChi = req.getParameter("diaChi");
            String tenDangNhap = req.getParameter("tenDangNhap");
            String matKhau = req.getParameter("matKhau");
            String roleId = req.getParameter("roleId");
            int trangThai = 1;
            try {
                trangThai = Integer.parseInt(req.getParameter("trangThai"));
            } catch (Exception ignored) {}

            // VALIDATE
            if (hoTen == null || hoTen.trim().isEmpty()) throw new Exception("Họ tên không được để trống");
            if (email == null || !email.matches("^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}$")) throw new Exception("Email không hợp lệ");
            if (sdt == null || !sdt.matches("^0[3|5|7|8|9]\\d{8}$")) throw new Exception("Số điện thoại không hợp lệ");
            if (tenDangNhap == null || tenDangNhap.trim().isEmpty()) throw new Exception("Tên đăng nhập không được để trống");
            if ((id == null || id.isEmpty()) && (matKhau == null || matKhau.isBlank())) throw new Exception("Mật khẩu không được để trống khi thêm mới");
            if (roleId == null || roleId.isEmpty()) throw new Exception("Vui lòng chọn vai trò");

            // Kiểm tra trùng tên đăng nhập
            NhanVien exist = nvRepo.findByTenDangNhap(tenDangNhap);
            if (exist != null && (id == null || !exist.getId().toString().equals(id))) {
                throw new Exception("Tên đăng nhập đã tồn tại!");
            }

            NhanVien nv = new NhanVien();
            nv.setHoTen(hoTen.trim());
            nv.setEmail(email.trim());
            nv.setSdt(sdt);
            nv.setDiaChi(diaChi != null ? diaChi.trim() : null);
            nv.setTenDangNhap(tenDangNhap.trim());
            nv.setMatKhau(matKhau != null && !matKhau.isBlank() ? matKhau : (exist != null ? exist.getMatKhau() : "123456"));
            nv.setTrangThai(trangThai);

            // SỬA: TẠO MÃ NHÂN VIÊN TỰ ĐỘNG (VD: NV001, NV002...)
            if (id == null || id.isEmpty()) {
                String ma = "NV" + String.format("%03d", nvRepo.getAll().size() + 1);
                nv.setMa(ma);
            }

            Role role = new Role();
            role.setId(UUID.fromString(roleId));
            nv.setRole(role);

            if (id == null || id.isEmpty()) {
                nv.setId(UUID.randomUUID());
                nvRepo.saveOrUpdate(nv);
                req.getSession().setAttribute("message", "Thêm nhân viên thành công!");
            } else {
                nv.setId(UUID.fromString(id));
                nvRepo.saveOrUpdate(nv);
                req.getSession().setAttribute("message", "Cập nhật thành công!");
            }
        } catch (Exception e) {
            req.getSession().setAttribute("error", e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/quan-ly-nhan-vien");
    }

    private void loadData(HttpServletRequest req) {
        List<NhanVien> all = nvRepo.getAll();
        int page = 1;
        try {
            String p = req.getParameter("page");
            if (p != null) page = Integer.parseInt(p);
            if (page < 1) page = 1;
        } catch (Exception ignored) {}

        int totalItems = all.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) page = totalPages;

        int from = (page - 1) * PAGE_SIZE;
        int to = Math.min(from + PAGE_SIZE, totalItems);
        List<NhanVien> pageItems = all.subList(from, to);

        long quanLy = all.stream().filter(nv -> "Admin".equals(nv.getRole().getTen())).count();
        long hoatDong = all.stream().filter(nv -> nv.getTrangThai() == 1).count();

        req.setAttribute("listNhanVien", all);
        req.setAttribute("pageItems", pageItems);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalNhanVien", totalItems);
        req.setAttribute("soQuanLy", quanLy);
        req.setAttribute("nhanVienHoatDong", hoatDong);
    }
}