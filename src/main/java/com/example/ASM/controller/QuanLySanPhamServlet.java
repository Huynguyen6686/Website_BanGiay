package com.example.ASM.controller;

import com.example.ASM.entity.Giay;
import com.example.ASM.repository.GiayRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "QuanLySanPhamServlet", value = {
        "/quan-ly-san-pham",           // xem danh sách + phân trang
        "/quan-ly-san-pham/add",       // thêm mới
        "/quan-ly-san-pham/update",    // cập nhật
        "/quan-ly-san-pham/delete",    // xóa mềm
        "/quan-ly-san-pham/detail"     // chi tiết (dùng để sửa)
})
public class QuanLySanPhamServlet extends HttpServlet {

    private final GiayRepository giayRepo = new GiayRepository();
    private static final int PAGE_SIZE = 5; // 5 sản phẩm mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        // Xem chi tiết (để sửa)
        if (uri.contains("/detail")) {
            Integer id = Integer.parseInt(request.getParameter("id"));
            request.setAttribute("giayEdit", giayRepo.findById(id));
        }

        // Xóa mềm
        else if (uri.contains("/delete")) {
            Integer id = Integer.parseInt(request.getParameter("id"));
            giayRepo.delete(id);
        }

        // Luôn load danh sách + phân trang
        loadDataWithPaging(request);

        // Forward về JSP
        request.getRequestDispatcher("/view/QuanLySanPham.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        String ma = request.getParameter("ma");
        String ten = request.getParameter("ten");
        String thuongHieu = request.getParameter("thuongHieu");
        String moTa = request.getParameter("moTa");

        Integer trangThai = 1;
        try {
            trangThai = Integer.parseInt(request.getParameter("trangThai"));
        } catch (NumberFormatException ignored) {}

        Giay giay = new Giay();
        giay.setMa(ma);
        giay.setTen(ten);
        giay.setThuongHieu(thuongHieu);
        giay.setMoTa(moTa);
        giay.setTrangThai(trangThai);

        try {
            if (uri.contains("/add")) {
                giayRepo.save(giay);
                request.getSession().setAttribute("message", "Thêm sản phẩm thành công!");
            } else if (uri.contains("/update")) {
                Integer id = Integer.parseInt(request.getParameter("id"));
                giay.setId(id);
                giayRepo.update(giay);
                request.getSession().setAttribute("message", "Cập nhật sản phẩm thành công!");
            }
        } catch (RuntimeException e) {
            request.getSession().setAttribute("error", e.getMessage());
        }

        // Redirect về trang danh sách (giữ nguyên trang hiện tại nếu có)
        String currentPage = request.getParameter("page");
        String redirectUrl = request.getContextPath() + "/quan-ly-san-pham";
        if (currentPage != null && !currentPage.isEmpty()) {
            redirectUrl += "?page=" + currentPage;
        }
        response.sendRedirect(redirectUrl);
    }

    // Hàm load dữ liệu + phân trang
    private void loadDataWithPaging(HttpServletRequest request) {
        List<Giay> allGiay = giayRepo.getAll();

        // Lấy trang hiện tại
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            }
        } catch (NumberFormatException ignored) {}

        int totalItems = allGiay.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) page = totalPages;

        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<Giay> pageItems = allGiay.subList(fromIndex, toIndex);

        // Gửi dữ liệu cho JSP
        request.setAttribute("listGiay", allGiay);         // để tìm kiếm/lọc
        request.setAttribute("pageItems", pageItems);     // hiển thị trên trang hiện tại
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
    }
}