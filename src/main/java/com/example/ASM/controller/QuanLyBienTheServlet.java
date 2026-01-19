package com.example.ASM.controller;

import com.example.ASM.entity.*;
import com.example.ASM.repository.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "QuanLyBienTheServlet", value = {
        "/quan-ly-bien-the",
        "/quan-ly-bien-the/add",
        "/quan-ly-bien-the/update",
        "/quan-ly-bien-the/delete"
})
public class QuanLyBienTheServlet extends HttpServlet {

    private final GiayRepository giayRepo = new GiayRepository();
    private final GiayChiTietRepository gctRepo = new GiayChiTietRepository();
    private final ThuocTinhRepository ttRepo = new ThuocTinhRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("giayId");
        if (idStr == null || idStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/quan-ly-san-pham");
            return;
        }

        int giayId = Integer.parseInt(idStr);
        Giay giay = giayRepo.findById(giayId);
        if (giay == null) {
            resp.sendRedirect(req.getContextPath() + "/quan-ly-san-pham");
            return;
        }

        req.setAttribute("pageTitle", "Quản lý Biến thể: " + giay.getTen());
        req.setAttribute("giayHienTai", giay);
        req.setAttribute("listGiayChiTiet", gctRepo.getByGiayId(giayId));

        req.setAttribute("listMauSac", ttRepo.getAllMauSac());
        req.setAttribute("listKichCo", ttRepo.getAllKichCo());
        req.setAttribute("listKieu", ttRepo.getByLoai(1));
        req.setAttribute("listChatLieu", ttRepo.getByLoai(2));
        req.setAttribute("listDay", ttRepo.getByLoai(3));
        req.setAttribute("listCo", ttRepo.getByLoai(4));
        req.setAttribute("listDe", ttRepo.getByLoai(5));

        req.getRequestDispatcher("/view/QuanLyBienThe.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        try {
            String giayIdStr = req.getParameter("giayId");
            if (giayIdStr == null || giayIdStr.isEmpty()) {
                throw new RuntimeException("Thiếu thông tin sản phẩm (giayId)");
            }
            int giayId = Integer.parseInt(giayIdStr);
            Giay giay = giayRepo.findById(giayId);
            if (giay == null) throw new RuntimeException("Không tìm thấy sản phẩm");

            if (uri.contains("/add")) {
                handleSave(req, giay);
            } else if (uri.contains("/update")) {
                handleUpdate(req, giay);
            } else if (uri.contains("/delete")) {
                handleDelete(req, giayId);
            }

            resp.sendRedirect(req.getContextPath() + "/quan-ly-bien-the?giayId=" + giayId);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi: " + e.getMessage());
            doGet(req, resp); // Forward lại để hiển thị lỗi
        }
    }

    private void handleSave(HttpServletRequest req, Giay giay) throws Exception {
        GiayChiTiet gct = new GiayChiTiet();

        // CỐT LÕI: KHÔNG ĐƯỢC THIẾU DÒNG NÀY
        gct.setGiay(giay);

        gct.setMauSac(ttRepo.findMauSacById(Integer.parseInt(req.getParameter("mauSac"))));
        gct.setKichCo(ttRepo.findKichCoById(Integer.parseInt(req.getParameter("kichCo"))));

        gct.setSoLuong(Integer.parseInt(req.getParameter("soLuong")));
        BigDecimal giaBan = new BigDecimal(req.getParameter("giaBan"));
        gct.setGiaBan(giaBan);

        String giaGocStr = req.getParameter("giaGoc");
        BigDecimal giaGoc = (giaGocStr != null && !giaGocStr.trim().isEmpty())
                ? new BigDecimal(giaGocStr) : giaBan;
        gct.setGiaGoc(giaGoc);

        String sku = req.getParameter("sku");
        if (sku == null || sku.trim().isEmpty()) {
            sku = "SKU" + System.currentTimeMillis();
        }
        gct.setSku(sku);

        String maBt = req.getParameter("ma");
        gct.setMaBienThe(maBt != null && !maBt.isEmpty() ? maBt : "BT-" + System.currentTimeMillis());
        gct.setKichHoat(true);

        // 5 thuộc tính mở rộng
        gct.setKieu(getThuocTinhGiay(req.getParameter("kieu")));
        gct.setChatLieu(getThuocTinhGiay(req.getParameter("chatLieu")));
        gct.setDay(getThuocTinhGiay(req.getParameter("day")));
        gct.setCo(getThuocTinhGiay(req.getParameter("co")));
        gct.setDe(getThuocTinhGiay(req.getParameter("de")));

        gctRepo.save(gct);
    }

    private void handleUpdate(HttpServletRequest req, Giay giay) throws Exception {
        int id = Integer.parseInt(req.getParameter("id"));
        GiayChiTiet gct = gctRepo.findById(id);
        if (gct == null) throw new RuntimeException("Không tìm thấy biến thể");

        gct.setMauSac(ttRepo.findMauSacById(Integer.parseInt(req.getParameter("mauSac"))));
        gct.setKichCo(ttRepo.findKichCoById(Integer.parseInt(req.getParameter("kichCo"))));

        gct.setMaBienThe(req.getParameter("ma"));
        gct.setSoLuong(Integer.parseInt(req.getParameter("soLuong")));
        gct.setGiaBan(new BigDecimal(req.getParameter("giaBan")));

        String giaGocStr = req.getParameter("giaGoc");
        BigDecimal giaGoc = (giaGocStr != null && !giaGocStr.trim().isEmpty())
                ? new BigDecimal(giaGocStr) : gct.getGiaBan();
        gct.setGiaGoc(giaGoc);

        String sku = req.getParameter("sku");
        if (sku != null && !sku.trim().isEmpty()) {
            gct.setSku(sku);
        }

        gct.setKichHoat(Boolean.parseBoolean(req.getParameter("kichHoat")));

        gct.setKieu(getThuocTinhGiay(req.getParameter("kieu")));
        gct.setChatLieu(getThuocTinhGiay(req.getParameter("chatLieu")));
        gct.setDay(getThuocTinhGiay(req.getParameter("day")));
        gct.setCo(getThuocTinhGiay(req.getParameter("co")));
        gct.setDe(getThuocTinhGiay(req.getParameter("de")));

        gctRepo.update(gct);
    }

    private void handleDelete(HttpServletRequest req, int giayId) {
        int id = Integer.parseInt(req.getParameter("id"));
        gctRepo.delete(id);
    }

    private ThuocTinhGiay getThuocTinhGiay(String idStr) {
        if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                return ttRepo.findById(Integer.parseInt(idStr));
            } catch (NumberFormatException e) {
                return null;
            }
        }
        return null;
    }
}