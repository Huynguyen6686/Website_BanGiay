package com.example.ASM.controller;

import com.example.ASM.entity.*;
import com.example.ASM.repository.BanHangTaiQuayRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "BanHangTaiQuayServlet", urlPatterns = {
        "/ban-hang-tai-quay",
        "/ban-hang-tai-quay/tao-hoa-don",
        "/ban-hang-tai-quay/chon-hoa-don",
        "/ban-hang-tai-quay/them-san-pham",
        "/ban-hang-tai-quay/xoa-san-pham",
        "/ban-hang-tai-quay/thanh-toan-chot",
        "/ban-hang-tai-quay/huy-hoa-don",
        "/ban-hang-tai-quay/lay-chi-tiet-san-pham",
        "/ban-hang-tai-quay/tim-khach-hang",
        "/ban-hang-tai-quay/chon-khach-hang",
        "/ban-hang-tai-quay/ap-dung-voucher", // API Áp dụng
        "/ban-hang-tai-quay/huy-voucher"      // <--- API Hủy Voucher
})
public class BanHangTaiQuayServlet extends HttpServlet {

    private final BanHangTaiQuayRepository repo = new BanHangTaiQuayRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if (path.equals("/ban-hang-tai-quay")) {
            loadPageData(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/tao-hoa-don")) {
            taoHoaDonMoi(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/chon-hoa-don")) {
            String id = req.getParameter("id");
            resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay?idHD=" + id);
        } else if (path.equals("/ban-hang-tai-quay/xoa-san-pham")) {
            xoaSanPham(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/huy-hoa-don")) {
            huyHoaDon(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/lay-chi-tiet-san-pham")) {
            getProductDetailsJson(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/tim-khach-hang")) {
            searchCustomerJson(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if (path.equals("/ban-hang-tai-quay/them-san-pham")) {
            themSanPham(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/thanh-toan-chot")) {
            thanhToan(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/chon-khach-hang")) {
            chonKhachHang(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/ap-dung-voucher")) {
            apDungVoucherJson(req, resp);
        } else if (path.equals("/ban-hang-tai-quay/huy-voucher")) { // <--- Xử lý Hủy
            huyVoucherJson(req, resp);
        }
    }

    // --- LOGIC LOAD DATA ---
    private void loadPageData(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<HoaDon> listHDCho = repo.getAllHoaDonCho();
        req.setAttribute("listHDCho", listHDCho);

        HoaDon currentHD = null;
        String selectedId = req.getParameter("idHD");

        if (selectedId != null) {
            currentHD = repo.getHoaDonById(Integer.parseInt(selectedId));
        } else if (req.getSession().getAttribute("currentHdId") != null) {
            int sessId = (int) req.getSession().getAttribute("currentHdId");
            currentHD = repo.getHoaDonById(sessId);
            if (currentHD == null || currentHD.getTrangThai() != 0) {
                currentHD = null;
                req.getSession().removeAttribute("currentHdId");
            }
        } else if (!listHDCho.isEmpty()) {
            currentHD = listHDCho.get(0);
        }

        if (currentHD != null) {
            req.setAttribute("currentHD", currentHD);
            req.setAttribute("cartItems", repo.getChiTietHoaDon(currentHD.getId()));
            req.setAttribute("listVoucher", repo.getListVoucherKhaDung()); // Load voucher
            req.getSession().setAttribute("currentHdId", currentHD.getId());
        } else {
            req.getSession().removeAttribute("currentHdId");
        }

        req.setAttribute("listGiay", repo.getDanhSachGiayHienThi());
        req.getRequestDispatcher("/view/BanHangTaiQuay.jsp").forward(req, resp);
    }

    // --- CÁC HÀM XỬ LÝ CHÍNH ---
    private void taoHoaDonMoi(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (repo.countHoaDonCho() >= 10) {
            req.getSession().setAttribute("error", "Tối đa 10 hóa đơn chờ!");
        } else {
            NhanVien nv = (NhanVien) req.getSession().getAttribute("nhanVienLogin");
            repo.taoHoaDon(nv);
        }
        resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
    }

    private void huyHoaDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            repo.huyHoaDon(id);
            req.getSession().removeAttribute("currentHdId");
            req.getSession().setAttribute("message", "Đã hủy hóa đơn thành công!");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
    }

    private void xoaSanPham(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int idHDCT = Integer.parseInt(req.getParameter("idHDCT"));
        String hdId = req.getParameter("hdId");
        repo.removeCartItem(idHDCT);
        resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay?idHD=" + hdId);
    }

    private void themSanPham(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int hdId = Integer.parseInt(req.getParameter("hoaDonId"));
            int spId = Integer.parseInt(req.getParameter("sanPhamId"));
            int soLuong = Integer.parseInt(req.getParameter("soLuong"));
            repo.addOrUpdateCartItem(hdId, spId, soLuong);
            resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay?idHD=" + hdId);
        } catch (Exception e) {
            req.getSession().setAttribute("error", e.getMessage());
            String hdId = req.getParameter("hoaDonId");
            resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay" + (hdId != null ? "?idHD=" + hdId : ""));
        }
    }

    private void thanhToan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int hdId = Integer.parseInt(req.getParameter("hoaDonId"));
            double tienKhach = Double.parseDouble(req.getParameter("tienKhachDua"));
            int hinhThuc = Integer.parseInt(req.getParameter("hinhThuc"));
            repo.thanhToan(hdId, hinhThuc, tienKhach);
            req.getSession().setAttribute("message", "Thanh toán thành công!");
            req.getSession().removeAttribute("currentHdId");
        } catch (Exception e) {
            req.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
    }

    private void chonKhachHang(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int hdId = Integer.parseInt(req.getParameter("hoaDonId"));
            String khIdStr = req.getParameter("khachHangId");
            UUID khId = (khIdStr == null || khIdStr.isEmpty()) ? null : UUID.fromString(khIdStr);
            repo.setKhachHangChoHoaDon(hdId, khId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/ban-hang-tai-quay");
    }

    // --- JSON API ---
    private void getProductDetailsJson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        try {
            int idGiay = Integer.parseInt(req.getParameter("idGiay"));
            List<GiayChiTiet> listGct = repo.getBienTheGiay(idGiay);
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < listGct.size(); i++) {
                GiayChiTiet gct = listGct.get(i);
                json.append(String.format("{\"id\":%d, \"mauSac\":\"%s\", \"kichCo\":\"%s\", \"soLuong\":%d, \"giaBan\":%.0f}",
                        gct.getId(), gct.getMauSac().getTen(), gct.getKichCo().getGiaTri(), gct.getSoLuong(), gct.getGiaBan()));
                if (i < listGct.size() - 1) json.append(",");
            }
            json.append("]");
            resp.getWriter().write(json.toString());
        } catch (Exception e) {
            resp.getWriter().write("[]");
        }
    }

    private void searchCustomerJson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        String keyword = req.getParameter("keyword");
        List<KhachHang> list = repo.searchKhachHang(keyword);
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            KhachHang kh = list.get(i);
            json.append(String.format("{\"id\":\"%s\", \"hoTen\":\"%s\", \"sdt\":\"%s\"}",
                    kh.getId(), kh.getHoTen(), kh.getSdt()));
            if (i < list.size() - 1) json.append(",");
        }
        json.append("]");
        resp.getWriter().write(json.toString());
    }

    private void apDungVoucherJson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        try {
            int hdId = Integer.parseInt(req.getParameter("hoaDonId"));
            String code = req.getParameter("voucherCode");

            double tienGiam = repo.apDungPhieuGiamGia(hdId, code);
            HoaDon hd = repo.getHoaDonById(hdId);

            resp.getWriter().write(String.format(
                    "{\"success\": true, \"message\": \"Áp dụng thành công!\", \"tienGiam\": %.0f, \"tongTienMoi\": %.0f}",
                    tienGiam, hd.getTongTien()
            ));
        } catch (Exception e) {
            resp.getWriter().write(String.format("{\"success\": false, \"message\": \"%s\"}", e.getMessage()));
        }
    }

    // --- MỚI: API HỦY VOUCHER ---
    private void huyVoucherJson(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        try {
            int hdId = Integer.parseInt(req.getParameter("hoaDonId"));
            // Gọi repo tính lại tiền gốc (reset giá)
            double tongTienGoc = repo.huyVoucher(hdId);

            resp.getWriter().write(String.format(
                    "{\"success\": true, \"message\": \"Đã hủy mã giảm giá!\", \"tongTienMoi\": %.0f}",
                    tongTienGoc
            ));
        } catch (Exception e) {
            resp.getWriter().write("{\"success\": false, \"message\": \"Lỗi hủy voucher\"}");
        }
    }
}