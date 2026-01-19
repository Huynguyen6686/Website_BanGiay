package com.example.ASM.controller;

import com.example.ASM.entity.KhachHang;
import com.example.ASM.entity.NhanVien;
import com.example.ASM.repository.KhachHangRepository;
import com.example.ASM.repository.NhanVienRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/login", "/register", "/logout"})
public class LoginServlet extends HttpServlet {

    private final NhanVienRepository nvRepo = new NhanVienRepository();
    private final KhachHangRepository khRepo = new KhachHangRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/logout")) {
            req.getSession().invalidate();
            req.getRequestDispatcher("/Login/login.jsp").forward(req, resp);
            return;
        }
        req.getRequestDispatcher("/Login/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.endsWith("/login")) {
            String tenDangNhap = req.getParameter("tenDangNhap");
            String matKhau = req.getParameter("matKhau");
            String role = req.getParameter("role");

            if ("nhanvien".equals(role)) {
                NhanVien nv = nvRepo.login(tenDangNhap, matKhau);
                if (nv != null) {
                    req.getSession().setAttribute("nhanVienLogin", nv);
                    resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
                } else {
                    req.getSession().setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                    req.getRequestDispatcher("/Login/login.jsp").forward(req, resp);
                }
            } else {
                KhachHang kh = khRepo.login(tenDangNhap, matKhau);
                if (kh != null) {
                    req.getSession().setAttribute("khachHangLogin", kh);
                    resp.sendRedirect(req.getContextPath() + "/trang-chu-khach-hang");
                } else {
                    req.getSession().setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                    req.getRequestDispatcher("/Login/login.jsp").forward(req, resp);
                }
            }
        }

        else if (uri.endsWith("/register")) {
            String hoTen = req.getParameter("hoTen");
            String sdt = req.getParameter("sdt");
            String email = req.getParameter("email");
            String tenDangNhap = req.getParameter("tenDangNhap");
            String matKhau = req.getParameter("matKhau");
            String matKhau2 = req.getParameter("matKhau2");

            if (!matKhau.equals(matKhau2)) {
                req.getSession().setAttribute("error", "Mật khẩu không khớp!");
                resp.sendRedirect(req.getContextPath() + "/Login/register.jsp");
                return;
            }

            KhachHang kh = new KhachHang();
            kh.setHoTen(hoTen);
            kh.setSdt(sdt);
            kh.setEmail(email);
            kh.setTenDangNhap(tenDangNhap);
            kh.setMatKhau(matKhau);
            kh.setTrangThai(1);

            if (khRepo.add(kh)) {
                req.getSession().setAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
                resp.sendRedirect(req.getContextPath() + "/Login/login.jsp");
            } else {
                req.getSession().setAttribute("error", "Tên đăng nhập hoặc email đã tồn tại!");
                resp.sendRedirect(req.getContextPath() + "/Login/register.jsp");
            }
        }
    }
}