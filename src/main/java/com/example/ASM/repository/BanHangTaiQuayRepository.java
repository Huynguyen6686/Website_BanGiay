package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.*;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public class BanHangTaiQuayRepository {

    // ============================================================
    // 1. QUẢN LÝ SẢN PHẨM & HIỂN THỊ
    // ============================================================

    /**
     * Lấy danh sách sản phẩm cha (Group theo tên)
     * CẬP NHẬT: Đã thêm g.ngayTao vào GROUP BY và ORDER BY
     */
    public List<Object[]> getDanhSachGiayHienThi() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = """
            SELECT g, 
                   COALESCE(SUM(gct.soLuong), 0),
                   MIN(gct.giaBan),
                   MAX(gct.giaBan)
            FROM Giay g
            LEFT JOIN g.chiTiets gct WITH gct.soLuong > 0 AND gct.kichHoat = true
            WHERE g.trangThai = 1
               OR EXISTS (
                   SELECT 1 FROM GiayChiTiet x 
                   WHERE x.giay = g AND x.soLuong > 0 AND x.kichHoat = true
               )
            GROUP BY g.id, g.ma, g.ten, g.thuongHieu, g.moTa, g.trangThai, g.ngayTao
            ORDER BY g.ngayTao DESC, g.id DESC
            """;

            return session.createQuery(hql, Object[].class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Lấy danh sách biến thể (Màu/Size) của 1 giày
     */
    public List<GiayChiTiet> getBienTheGiay(int idGiay) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM GiayChiTiet gct " +
                            "JOIN FETCH gct.mauSac JOIN FETCH gct.kichCo " +
                            "WHERE gct.giay.id = :idGiay AND gct.soLuong > 0 " +
                            "ORDER BY gct.mauSac.ten, gct.kichCo.giaTri",
                    GiayChiTiet.class)
                    .setParameter("idGiay", idGiay).list();
        }
    }

    public GiayChiTiet findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = """
            FROM GiayChiTiet gct
            JOIN FETCH gct.giay g
            JOIN FETCH gct.mauSac
            JOIN FETCH gct.kichCo
            LEFT JOIN FETCH gct.kieu
            LEFT JOIN FETCH gct.chatLieu
            LEFT JOIN FETCH gct.day
            LEFT JOIN FETCH gct.co
            LEFT JOIN FETCH gct.de
            WHERE gct.id = :id
            """;
            return session.createQuery(hql, GiayChiTiet.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    // ============================================================
    // 2. QUẢN LÝ HÓA ĐƠN (POS)
    // ============================================================

    /**
     * Lấy danh sách hóa đơn chờ (Trạng thái = 0)
     */
    public List<HoaDon> getAllHoaDonCho() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon h LEFT JOIN FETCH h.khachHang WHERE h.trangThai = 0 ORDER BY h.ngayLap DESC",
                    HoaDon.class).list();
        }
    }

    public int countHoaDonCho() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Long count = session.createQuery(
                    "SELECT COUNT(h) FROM HoaDon h WHERE h.trangThai = 0", Long.class).uniqueResult();
            return count != null ? count.intValue() : 0;
        }
    }

    public HoaDon getHoaDonById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon h LEFT JOIN FETCH h.khachHang WHERE h.id = :id", HoaDon.class)
                    .setParameter("id", id).uniqueResult();
        }
    }

    /**
     * Tạo hóa đơn mới
     */
    public HoaDon taoHoaDon(NhanVien nv) {
        HoaDon hd = new HoaDon();
        hd.setMa("HD" + System.currentTimeMillis());
        hd.setNgayLap(new Date());
        hd.setTrangThai(0); // 0: Chờ xác nhận
        hd.setTongTien(0.0);
        hd.setNhanVien(nv);
        hd.setKhachHang(null); // Mặc định khách lẻ (Lưu ý: DB phải cho phép NULL)

        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Transaction tx = session.beginTransaction();
            session.persist(hd);
            tx.commit();
            return hd;
        }
    }

    /**
     * Hủy hóa đơn (Chuyển trạng thái sang -1)
     */
    public void huyHoaDon(int hoaDonId) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Transaction tx = session.beginTransaction();
            HoaDon hd = session.get(HoaDon.class, hoaDonId);
            if (hd != null && hd.getTrangThai() == 0) { // Chỉ hủy khi đang chờ
                hd.setTrangThai(-1); // -1: Hủy
                session.merge(hd);
            }
            tx.commit();
        }
    }

    // ============================================================
    // 3. QUẢN LÝ GIỎ HÀNG (HOA_DON_CHI_TIET)
    // ============================================================

    public List<HoaDonChiTiet> getChiTietHoaDon(int hoaDonId) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDonChiTiet h " +
                            "JOIN FETCH h.giayChiTiet g " +
                            "JOIN FETCH g.giay JOIN FETCH g.mauSac JOIN FETCH g.kichCo " +
                            "WHERE h.hoaDon.id = :id", HoaDonChiTiet.class)
                    .setParameter("id", hoaDonId).list();
        }
    }
    public double huyVoucher(int hoaDonId) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Transaction tx = session.beginTransaction();
            HoaDon hd = session.get(HoaDon.class, hoaDonId);

            // Logic: Tính lại tổng tiền dựa trên số lượng * đơn giá của từng item
            // (Hàm updateTongTienHoaDon bạn đã có, ta tái sử dụng logic đó nhưng public ra)
            Double tongGoc = session.createQuery(
                    "SELECT SUM(h.soLuong * h.giaDonVi) FROM HoaDonChiTiet h WHERE h.hoaDon.id = :id", Double.class)
                    .setParameter("id", hoaDonId).uniqueResult();

            double finalTotal = (tongGoc == null) ? 0.0 : tongGoc;

            hd.setTongTien(finalTotal);
            // Lưu ý: Nếu Entity HoaDon có trường idVoucher, bạn cần set nó về null ở đây.
            // Ví dụ: hd.setPhieuGiamGia(null);

            session.merge(hd);
            tx.commit();

            return finalTotal;
        }
    }
    /**
     * Thêm hoặc Cập nhật số lượng sản phẩm trong hóa đơn
     */
    public void addOrUpdateCartItem(int hoaDonId, int giayChiTietId, int soLuong) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Transaction tx = session.beginTransaction();
            HoaDon hd = session.get(HoaDon.class, hoaDonId);
            GiayChiTiet sp = session.get(GiayChiTiet.class, giayChiTietId);

            if (hd.getTrangThai() != 0) throw new RuntimeException("Hóa đơn không ở trạng thái chờ!");

            // Kiểm tra sản phẩm đã có trong hóa đơn chưa
            HoaDonChiTiet hdct = session.createQuery(
                    "FROM HoaDonChiTiet WHERE hoaDon.id = :hdId AND giayChiTiet.id = :spId", HoaDonChiTiet.class)
                    .setParameter("hdId", hoaDonId).setParameter("spId", giayChiTietId).uniqueResult();

            if (hdct != null) {
                // Đã có -> Cộng dồn số lượng
                int newQty = hdct.getSoLuong() + soLuong;
                if (newQty <= 0) {
                    session.remove(hdct); // Nếu giảm về 0 thì xóa
                } else {
                    if (sp.getSoLuong() < newQty)
                        throw new RuntimeException("Kho không đủ hàng! (Còn: " + sp.getSoLuong() + ")");
                    hdct.setSoLuong(newQty);
                    session.merge(hdct);
                }
            } else if (soLuong > 0) {
                // Chưa có -> Thêm mới
                if (sp.getSoLuong() < soLuong)
                    throw new RuntimeException("Kho không đủ hàng! (Còn: " + sp.getSoLuong() + ")");
                hdct = new HoaDonChiTiet();
                hdct.setHoaDon(hd);
                hdct.setGiayChiTiet(sp);
                hdct.setSoLuong(soLuong);
                // Lưu giá bán tại thời điểm thêm vào giỏ
                hdct.setGiaDonVi(sp.getGiaBan().doubleValue());
                session.persist(hdct);
            }

            // Tính lại tổng tiền hóa đơn
            session.flush();
            updateTongTienHoaDon(session, hd);

            tx.commit();
        }
    }

    public void removeCartItem(int idHDCT) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Transaction tx = session.beginTransaction();
            HoaDonChiTiet hdct = session.get(HoaDonChiTiet.class, idHDCT);
            if (hdct != null) {
                HoaDon hd = hdct.getHoaDon();
                session.remove(hdct);
                session.flush();
                updateTongTienHoaDon(session, hd);
            }
            tx.commit();
        }
    }

    // Helper tính tổng tiền
    private void updateTongTienHoaDon(Session session, HoaDon hd) {
        Double tong = session.createQuery(
                "SELECT SUM(h.soLuong * h.giaDonVi) FROM HoaDonChiTiet h WHERE h.hoaDon.id = :id", Double.class)
                .setParameter("id", hd.getId()).uniqueResult();
        hd.setTongTien(tong == null ? 0.0 : tong);
        session.merge(hd);
    }

    // ============================================================
    // 4. THANH TOÁN (CHECKOUT)
    // ============================================================

    public void thanhToan(int hoaDonId, int hinhThuc, double tienKhachDua) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Transaction tx = session.beginTransaction();
            HoaDon hd = session.get(HoaDon.class, hoaDonId);

            if (hd == null || hd.getTrangThai() != 0) {
                throw new RuntimeException("Hóa đơn không hợp lệ hoặc đã xử lý!");
            }

            // 1. Cập nhật trạng thái hóa đơn
            hd.setTrangThai(4); // 4: Đã thanh toán
            hd.setNgayLap(new Date()); // Cập nhật lại ngày giờ thanh toán
            session.merge(hd);

            // 2. Tạo record ThanhToan
            ThanhToan tt = new ThanhToan();
            tt.setHoaDon(hd);
            tt.setHinhThuc(hinhThuc); // 1: Tiền mặt, 2: CK
            tt.setSoTien(hd.getTongTien());
            tt.setMaGiaoDich("PAY-" + System.currentTimeMillis());
            tt.setTrangThai(1); // Thành công
            session.persist(tt);

            // 3. Trừ tồn kho thực tế
            List<HoaDonChiTiet> list = session.createQuery(
                    "FROM HoaDonChiTiet WHERE hoaDon.id=:id", HoaDonChiTiet.class)
                    .setParameter("id", hoaDonId).list();

            for (HoaDonChiTiet ct : list) {
                GiayChiTiet sp = ct.getGiayChiTiet();
                if (sp.getSoLuong() < ct.getSoLuong()) {
                    throw new RuntimeException("Sản phẩm " + sp.getGiay().getTen() + " không đủ hàng!");
                }
                sp.setSoLuong(sp.getSoLuong() - ct.getSoLuong());
                session.merge(sp);
            }

            tx.commit();
        }
    }

    // ============================================================
    // 5. KHÁCH HÀNG & VOUCHER
    // ============================================================

    public List<KhachHang> searchKhachHang(String keyword) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = "FROM KhachHang WHERE (sdt LIKE :key OR hoTen LIKE :key OR email LIKE :key) AND trangThai = 1";
            return session.createQuery(hql, KhachHang.class)
                    .setParameter("key", "%" + keyword + "%")
                    .setMaxResults(10).list();
        }
    }

    public void setKhachHangChoHoaDon(int hoaDonId, UUID khachHangId) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Transaction tx = session.beginTransaction();
            HoaDon hd = session.get(HoaDon.class, hoaDonId);
            if (hd != null) {
                if (khachHangId == null) {
                    hd.setKhachHang(null);
                } else {
                    KhachHang kh = session.get(KhachHang.class, khachHangId);
                    hd.setKhachHang(kh);
                }
                session.merge(hd);
            }
            tx.commit();
        }
    }

    public BigDecimal getGiaHienTai(int giayChiTietId) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = """
                    SELECT COALESCE(
                        dggg.soTienThayThe,
                        gct.giaBan * (100.0 - COALESCE(dggg.phanTramThayThe, 0)) / 100.0,
                        gct.giaBan - COALESCE(dgg.soTienGiam, 0),
                        gct.giaBan * (100.0 - COALESCE(dgg.phanTram, 0)) / 100.0,
                        gct.giaBan
                    )
                    FROM GiayChiTiet gct
                    LEFT JOIN DotGiamGiaGiay dggg ON dggg.giayChiTiet.id = gct.id
                    LEFT JOIN dggg.dotGiamGia dgg ON dgg.kichHoat = true
                        AND :now BETWEEN dgg.ngayBatDau AND dgg.ngayKetThuc
                    WHERE gct.id = :id
                    """;

            BigDecimal result = (BigDecimal) session.createQuery(hql, Object.class)
                    .setParameter("id", giayChiTietId)
                    .setParameter("now", new Date())
                    .uniqueResult();

            // Nếu không có giảm giá → trả giá gốc
            if (result == null) {
                GiayChiTiet gct = session.get(GiayChiTiet.class, giayChiTietId);
                return gct != null ? gct.getGiaBan() : BigDecimal.ZERO;
            }

            return result;
        } catch (Exception e) {
            e.printStackTrace();
            // Fallback an toàn: lấy giá gốc nếu có lỗi
            try (Session session = HibernalUtil.getFACTORY().openSession()) {
                GiayChiTiet gct = session.get(GiayChiTiet.class, giayChiTietId);
                return gct != null ? gct.getGiaBan() : BigDecimal.ZERO;
            }
        }
    }

    public List<PhieuGiamGia> getListVoucherKhaDung() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Date now = new Date();
            String hql = """
                FROM PhieuGiamGia 
                WHERE kichHoat = 1 
                  AND soLuong > 0 
                  AND :now BETWEEN ngayBatDau AND ngayKetThuc
                ORDER BY giaTri DESC
            """;
            return session.createQuery(hql, PhieuGiamGia.class)
                    .setParameter("now", now)
                    .list();
        }
    }

    /**
     * Áp dụng mã giảm giá và tính lại tiền
     */
    public double apDungPhieuGiamGia(int hoaDonId, String codeVoucher) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            // 1. Reset về giá gốc trước khi check
            this.huyVoucher(hoaDonId);

            Transaction tx = session.beginTransaction();
            HoaDon hd = session.get(HoaDon.class, hoaDonId);

            PhieuGiamGia pgg = session.createQuery(
                    "FROM PhieuGiamGia WHERE ma = :code AND kichHoat = 1", PhieuGiamGia.class)
                    .setParameter("code", codeVoucher).uniqueResult();

            // --- CHECK CÁC ĐIỀU KIỆN ---

            if (pgg == null) throw new RuntimeException("Mã giảm giá không tồn tại!");

            Date now = new java.sql.Date(System.currentTimeMillis());
            if (pgg.getNgayBatDau().after(now) || pgg.getNgayKetThuc().before(now)) {
                throw new RuntimeException("Mã giảm giá chưa bắt đầu hoặc đã hết hạn!");
            }
            if (pgg.getSoLuong() <= 0) {
                throw new RuntimeException("Mã giảm giá đã hết lượt sử dụng!");
            }

            // [MỚI] CHECK ĐIỀU KIỆN ĐƠN HÀNG TỐI THIỂU
            double dieuKien = (pgg.getDieuKien() == null) ? 0 : pgg.getDieuKien();
            if (hd.getTongTien() < dieuKien) {
                throw new RuntimeException("Hóa đơn chưa đủ điều kiện áp dụng! (Tối thiểu: "
                        + String.format("%,.0f", dieuKien) + " đ)");
            }

            // --- TÍNH TIỀN GIẢM ---
            double tienGiam = 0;
            if (pgg.getLoai() == 1) { // Phần trăm
                tienGiam = (hd.getTongTien() * pgg.getGiaTri()) / 100;
            } else { // Tiền mặt
                tienGiam = pgg.getGiaTri();
            }

            // Không giảm quá tổng tiền
            if (tienGiam > hd.getTongTien()) tienGiam = hd.getTongTien();

            // Cập nhật hóa đơn & trừ số lượng voucher
            hd.setTongTien(hd.getTongTien() - tienGiam);
            pgg.setSoLuong(pgg.getSoLuong() - 1);

            session.merge(hd);
            session.merge(pgg);
            tx.commit();

            return tienGiam;
        }
    }
}