package com.example.ASM.security;

import com.example.ASM.entity.NhanVien;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "LoginFilter", urlPatterns = {
        "/ban-hang-tai-quay/*", "/hoa-don/*", "/khach-hang/*", "/quan-ly-khach-hang/*",
        "/san-pham/*", "/quan-ly-san-pham/*", "/quan-ly-bien-the/*", "/quan-ly-thuoc-tinh/*",
        "/nhan-vien/*", "/quan-ly-nhan-vien/*", "/phieu-giam-gia/*", "/quan-ly-phieu-giam-gia/*",
        "/quan-ly-dot-giam-gia/*", "/thong-ke", "/chi-tiet-hoa-don", "/chi-tiet-san-pham"
})
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession();

        NhanVien nhanVien = (NhanVien) session.getAttribute("nhanVienLogin");

        if (nhanVien == null) {
            resp.sendRedirect(req.getContextPath() + "/Login/login.jsp");
            return;
        }

        String roleName = nhanVien.getRole() != null && nhanVien.getRole().getTen() != null
                ? nhanVien.getRole().getTen().trim()
                : "Nhân viên";

        String uri = req.getRequestURI().toLowerCase();
        String method = req.getMethod().toUpperCase();

        // ADMIN → full quyền
        if ("Admin".equalsIgnoreCase(roleName)) {
            chain.doFilter(request, response);
            return;
        }
        if ("Nhân viên".equalsIgnoreCase(roleName) || "NhanVien".equalsIgnoreCase(roleName)) {
            if (uri.contains("/ban-hang-tai-quay") ||
                    uri.contains("/hoa-don") ||
                    uri.contains("/khach-hang") ||
                    uri.contains("/quan-ly-khach-hang") ||
                    uri.contains("/chi-tiet-hoa-don")) {
                chain.doFilter(request, response);
                return;
            }
            // Sản phẩm, biến thể, thuộc tính → chỉ được XEM
            if (uri.contains("/san-pham") || uri.contains("/quan-ly-san-pham") ||
                    uri.contains("/quan-ly-bien-the") || uri.contains("/quan-ly-thuoc-tinh") ||
                    uri.contains("/chi-tiet-san-pham")) {
                if (method.equals("GET") && !isModifyAction(uri)) {
                    chain.doFilter(request, response);
                    return;
                } else {
                    session.setAttribute("error", "Nhân viên không được phép chỉnh sửa!");
                    resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
                    return;
                }
            }
            session.setAttribute("error", "Bạn không có quyền truy cập trang này!");
            resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/Login/login.jsp");
    }

    private boolean isModifyAction(String uri) {
        String lower = uri.toLowerCase();
        return lower.contains("add") || lower.contains("create") ||
                lower.contains("update") || lower.contains("edit") ||
                lower.contains("delete") || lower.contains("remove") ||
                lower.contains("save") || lower.contains("toggle") ||
                lower.contains("lock") || lower.contains("unlock");
    }
}