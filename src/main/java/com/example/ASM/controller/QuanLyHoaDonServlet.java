package com.example.ASM.controller;

import com.example.ASM.entity.HoaDon;
import com.example.ASM.repository.HoaDonRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/quan-ly-hoa-don")
public class QuanLyHoaDonServlet extends HttpServlet {

    private final HoaDonRepository repo = new HoaDonRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String trangThaiStr = req.getParameter("trangThai");
        String pageStr = req.getParameter("page");

        // ... (Giữ nguyên phần xử lý logic int/Integer cho trangThai, page như cũ) ...
        Integer trangThai = null;
        try { if(trangThaiStr != null && !trangThaiStr.isEmpty()) trangThai = Integer.parseInt(trangThaiStr); } catch(Exception e){}

        int page = 1;
        try { if(pageStr != null) page = Integer.parseInt(pageStr); } catch(Exception e){}

        // Gọi Repo lấy dữ liệu
        List<HoaDon> list = repo.search(keyword, trangThai, page);
        long total = repo.countSearch(keyword, trangThai);
        int totalPages = (int) Math.ceil((double) total / 10);

        req.setAttribute("listHoaDon", list);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        // --- KHÔNG CẦN IF/ELSE CHECK AJAX Ở ĐÂY NỮA ---
        // Cứ forward thẳng về file chính, việc hiển thị gì để JSP lo
        req.getRequestDispatcher("/view/QuanLyHoaDon.jsp").forward(req, resp);
    }
}
