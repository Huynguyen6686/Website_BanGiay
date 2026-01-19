package com.example.ASM.controller;

import com.example.ASM.entity.KhachHang;
import com.example.ASM.repository.KhachHangRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "QuanLyKhachHangServlet", urlPatterns = {
        "/quan-ly-khach-hang",
        "/quan-ly-khach-hang/add",
        "/quan-ly-khach-hang/update",
        "/quan-ly-khach-hang/delete",    // khóa tài khoản
        "/quan-ly-khach-hang/unlock"     // mở khóa tài khoản
})
public class QuanLyKhachHangServlet extends HttpServlet {

    private final KhachHangRepository khRepo = new KhachHangRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.endsWith("/delete")) {
            String id = req.getParameter("id");
            if (id != null && !id.isEmpty()) {
                try {
                    khRepo.lock(id);
                    req.getSession().setAttribute("message", "Đã khóa tài khoản khách hàng!");
                } catch (Exception e) {
                    req.getSession().setAttribute("error", "Khóa thất bại: " + e.getMessage());
                }
            }
        }

        if (uri.endsWith("/unlock")) {
            String id = req.getParameter("id");
            if (id != null && !id.isEmpty()) {
                try {
                    khRepo.unlock(id);
                    req.getSession().setAttribute("message", "Đã mở khóa tài khoản khách hàng!");
                } catch (Exception e) {
                    req.getSession().setAttribute("error", "Mở khóa thất bại: " + e.getMessage());
                }
            }
        }

        loadData(req);
        req.setAttribute("pageTitle", "Quản lý khách hàng");
        req.getRequestDispatcher("/view/QuanLyKH.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        try {
            String id = req.getParameter("id");
            String hoTen = req.getParameter("hoTen");
            String sdt = req.getParameter("sdt");
            String email = req.getParameter("email");
            String diaChi = req.getParameter("diaChi");
            String tenDangNhap = req.getParameter("tenDangNhap");
            String matKhau = req.getParameter("matKhau");
            int trangThai = Integer.parseInt(req.getParameter("trangThai"));

            KhachHang kh = new KhachHang();
            kh.setHoTen(hoTen);
            kh.setSdt(sdt);
            kh.setEmail(email == null || email.isBlank() ? null : email.trim());
            kh.setDiaChi(diaChi == null || diaChi.isBlank() ? null : diaChi.trim());
            kh.setTenDangNhap(tenDangNhap);
            kh.setMatKhau(matKhau != null && !matKhau.isBlank() ? matKhau : "123456"); // Mật khẩu mặc định nếu trống
            kh.setTrangThai(trangThai);

            if (uri.contains("/add")) {
                kh.setId(UUID.randomUUID());
                khRepo.saveOrUpdate(kh);
                req.getSession().setAttribute("message", "Thêm khách hàng thành công!");
            }
            else if (uri.contains("/update") && id != null && !id.isBlank()) {
                kh.setId(UUID.fromString(id));
                // Nếu không nhập mật khẩu mới → giữ nguyên mật khẩu cũ
                if (matKhau == null || matKhau.isBlank()) {
                    KhachHang old = khRepo.findById(id);
                    if (old != null) kh.setMatKhau(old.getMatKhau());
                }
                khRepo.saveOrUpdate(kh);
                req.getSession().setAttribute("message", "Cập nhật khách hàng thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/quan-ly-khach-hang");
    }

    private static final int PAGE_SIZE = 5;

    private void loadData(HttpServletRequest req) {
        List<KhachHang> all = khRepo.getAll();

        // Lấy trang hiện tại
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
        List<KhachHang> pageItems = all.subList(from, to);

        // Thống kê
        long hoatDong = all.stream().filter(kh -> kh.getTrangThai() == 1).count();
        long tamKhoa = totalItems - hoatDong;

        req.setAttribute("listKhachHang", all);           // để tìm kiếm
        req.setAttribute("pageItems", pageItems);         // hiển thị
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalKhachHang", totalItems);
        req.setAttribute("khachHangHoatDong", hoatDong);
        req.setAttribute("khachHangTamKhoa", tamKhoa);
    }
}