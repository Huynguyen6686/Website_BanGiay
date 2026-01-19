package com.example.ASM.controller;

import com.example.ASM.entity.GiayChiTiet;
import com.example.ASM.repository.BanHangTaiQuayRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/chi-tiet-san-pham")
public class ChiTietSanPhamServlet extends HttpServlet {
    private final BanHangTaiQuayRepository repo = new BanHangTaiQuayRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            if (idStr == null) {
                resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
                return;
            }
            int id = Integer.parseInt(idStr);
            GiayChiTiet sp = repo.findById(id);

            if (sp == null) {
                resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
                return;
            }

            // Lấy các anh em (cùng cha) để hiển thị nút chọn Màu/Size khác
            req.setAttribute("relatedVariants", repo.getBienTheGiay(sp.getGiay().getId()));
            req.setAttribute("sp", sp);
            req.setAttribute("giaHienTai", sp.getGiaBan());

            req.getRequestDispatcher("/view/ChiTietSanPham.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
        }
    }
}