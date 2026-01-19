package com.example.ASM.controller;

import com.example.ASM.entity.HoaDon;
import com.example.ASM.entity.HoaDonChiTiet;
import com.example.ASM.repository.HoaDonRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet({
        "/chi-tiet-hoa-don",      // API lấy nội dung Modal (GET)
        "/cap-nhat-hoa-don"       // API cập nhật trạng thái (POST)
})
public class ChiTietHoaDonServlet extends HttpServlet {

    private final HoaDonRepository repo = new HoaDonRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 1. Lấy ID từ request AJAX
            int id = Integer.parseInt(req.getParameter("id"));
            HoaDon hd = repo.findById(id);

            if (hd == null) {
                resp.setContentType("text/html;charset=UTF-8");
                resp.getWriter().write("<div class='p-4 text-center text-danger'>Không tìm thấy hóa đơn!</div>");
                return;
            }

            // 2. Tính toán tiền hàng và tiền giảm giá
            double tongTienHang = 0;
            if (hd.getChiTiets() != null) {
                for (HoaDonChiTiet ct : hd.getChiTiets()) {
                    tongTienHang += ct.getSoLuong() * ct.getGiaDonVi();
                }
            }
            // Tiền giảm = Tổng hàng (gốc) - Tổng tiền thực tế khách trả
            double tienGiam = tongTienHang - hd.getTongTien();
            if (tienGiam < 0) tienGiam = 0;

            // 3. Đẩy dữ liệu sang JSP Fragment
            req.setAttribute("hoaDon", hd);
            req.setAttribute("tongTienHang", tongTienHang);
            req.setAttribute("tienGiam", tienGiam);

            // Forward sang file JSP giao diện (chỉ chứa nội dung thẻ div)
            req.getRequestDispatcher("/view/ChiTietHoaDon.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("<div class='p-4 text-center text-danger'>Lỗi server: " + e.getMessage() + "</div>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int trangThai = Integer.parseInt(req.getParameter("trangThai"));

            HoaDon hd = repo.findById(id);
            if (hd != null) {
                hd.setTrangThai(trangThai);
                repo.update(hd);
                req.getSession().setAttribute("message", "Cập nhật hóa đơn " + hd.getMa() + " thành công!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi cập nhật: " + e.getMessage());
        }
        // Redirect về trang danh sách để tải lại dữ liệu mới
        resp.sendRedirect(req.getContextPath() + "/quan-ly-hoa-don");
    }
}