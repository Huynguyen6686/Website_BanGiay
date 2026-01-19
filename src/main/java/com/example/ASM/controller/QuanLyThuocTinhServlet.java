package com.example.ASM.controller;

import com.example.ASM.entity.KichCo;
import com.example.ASM.entity.MauSac;
import com.example.ASM.entity.ThuocTinhGiay;
import com.example.ASM.repository.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet({
        "/quan-ly-thuoc-tinh",
        "/quan-ly-thuoc-tinh/add",
        "/quan-ly-thuoc-tinh/update",
        "/quan-ly-thuoc-tinh/delete"
})
public class QuanLyThuocTinhServlet extends HttpServlet {

    private final MauSacRepository mauSacRepo = new MauSacRepository();
    private final KichCoRepository kichCoRepo = new KichCoRepository();
    private final ThuocTinhGiayRepository ttgRepo = new ThuocTinhGiayRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        loadData(req);
        req.setAttribute("pageTitle", "Quản lý thuộc tính");
        req.getRequestDispatcher("/view/QuanLyThuocTinh.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String uri = req.getRequestURI();

        try {
            String type = req.getParameter("type");
            if ("mauSac".equals(type)) {
                if (uri.contains("/add")) saveMauSac(req);
                else if (uri.contains("/update")) updateMauSac(req);
            } else if ("kichCo".equals(type)) {
                if (uri.contains("/add")) saveKichCo(req);
                else if (uri.contains("/update")) updateKichCo(req);
            } else if ("ttg".equals(type)) {
                if (uri.contains("/add")) saveThuocTinhGiay(req);
                else if (uri.contains("/update")) updateThuocTinhGiay(req);
            } else if (uri.contains("/delete")) {
                delete(req);
            }
            req.getSession().setAttribute("message", "Thao tác thành công!");
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/quan-ly-thuoc-tinh");
    }

    private void loadData(HttpServletRequest req) {
        req.setAttribute("listMauSac", mauSacRepo.getAll());
        req.setAttribute("listKichCo", kichCoRepo.getAll());
        req.setAttribute("listKieu", ttgRepo.getByLoai(1));
        req.setAttribute("listChatLieu", ttgRepo.getByLoai(2));
        req.setAttribute("listDay", ttgRepo.getByLoai(3));
        req.setAttribute("listCo", ttgRepo.getByLoai(4));
        req.setAttribute("listDe", ttgRepo.getByLoai(5));
    }

    private void saveMauSac(HttpServletRequest req) {
        MauSac ms = new MauSac();
        ms.setMa(req.getParameter("ma"));
        ms.setTen(req.getParameter("ten"));
        ms.setMaMauHex(req.getParameter("maMauHex"));
        mauSacRepo.save(ms);
    }

    private void updateMauSac(HttpServletRequest req) {
        int id = Integer.parseInt(req.getParameter("id"));
        MauSac ms = mauSacRepo.findById(id);
        if (ms != null) {
            ms.setMa(req.getParameter("ma"));
            ms.setTen(req.getParameter("ten"));
            ms.setMaMauHex(req.getParameter("maMauHex"));
            mauSacRepo.update(ms);
        }
    }

    private void saveKichCo(HttpServletRequest req) {
        KichCo kc = new KichCo();
        kc.setGiaTri(req.getParameter("giaTri"));
        kc.setGhiChu(req.getParameter("ghiChu"));
        kichCoRepo.save(kc);
    }

    private void updateKichCo(HttpServletRequest req) {
        int id = Integer.parseInt(req.getParameter("id"));
        KichCo kc = kichCoRepo.findById(id);
        if (kc != null) {
            kc.setGiaTri(req.getParameter("giaTri"));
            kc.setGhiChu(req.getParameter("ghiChu"));
            kichCoRepo.update(kc);
        }
    }

    private void saveThuocTinhGiay(HttpServletRequest req) {
        ThuocTinhGiay tt = new ThuocTinhGiay();
        tt.setLoaiThuocTinh(Integer.parseInt(req.getParameter("loaiThuocTinh")));
        tt.setMa(req.getParameter("ma"));
        tt.setTen(req.getParameter("ten"));
        tt.setMoTa(req.getParameter("moTa"));
        tt.setKichHoat("1".equals(req.getParameter("kichHoat")) ? 1 : 0);
        ttgRepo.save(tt);
    }

    private void updateThuocTinhGiay(HttpServletRequest req) {
        int id = Integer.parseInt(req.getParameter("id"));
        ThuocTinhGiay tt = ttgRepo.findById(id);
        if (tt != null) {
            tt.setLoaiThuocTinh(Integer.parseInt(req.getParameter("loaiThuocTinh")));
            tt.setMa(req.getParameter("ma"));
            tt.setTen(req.getParameter("ten"));
            tt.setMoTa(req.getParameter("moTa"));
            tt.setKichHoat("1".equals(req.getParameter("kichHoat")) ? 1 : 0);
            ttgRepo.update(tt);
        }
    }

    private void delete(HttpServletRequest req) {
        String type = req.getParameter("type");
        int id = Integer.parseInt(req.getParameter("id"));

        if ("mauSac".equals(type)) {
            mauSacRepo.delete(id);
        } else if ("kichCo".equals(type)) {
            kichCoRepo.delete(id);
        } else if ("ttg".equals(type)) {
            ttgRepo.delete(id); // soft delete
        }
    }
}