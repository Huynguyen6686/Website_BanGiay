package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.*;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.math.BigDecimal;
import java.util.List;

public class GioHangRepository {

    private final BanHangTaiQuayRepository banHangRepo = new BanHangTaiQuayRepository();

    public List<HoaDonChiTiet> getChiTiet(int hoaDonId) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDonChiTiet h " +
                            "JOIN FETCH h.giayChiTiet g " +
                            "JOIN FETCH g.giay JOIN FETCH g.mauSac JOIN FETCH g.kichCo " +
                            "WHERE h.hoaDon.id = :id", HoaDonChiTiet.class)
                    .setParameter("id", hoaDonId)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public void addOrUpdateItem(int hoaDonId, int giayChiTietId, int soLuong) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();

            HoaDon hd = session.get(HoaDon.class, hoaDonId);
            GiayChiTiet sp = session.get(GiayChiTiet.class, giayChiTietId);

            if (hd == null || sp == null) throw new RuntimeException("Không tìm thấy dữ liệu!");
            if (hd.getTrangThai() != 0) throw new RuntimeException("Hóa đơn không ở trạng thái chờ!");

            // LẤY GIÁ SAU KHI ÁP DỤNG FLASH SALE
            BigDecimal giaHienTai = banHangRepo.getGiaHienTai(giayChiTietId);

            HoaDonChiTiet hdct = session.createQuery(
                    "FROM HoaDonChiTiet WHERE hoaDon.id = :hdId AND giayChiTiet.id = :spId",
                    HoaDonChiTiet.class)
                    .setParameter("hdId", hoaDonId)
                    .setParameter("spId", giayChiTietId)
                    .uniqueResult();

            if (hdct != null) {
                int newQty = hdct.getSoLuong() + soLuong;
                if (newQty <= 0) {
                    session.remove(hdct);
                } else {
                    if (sp.getSoLuong() < newQty) {
                        throw new RuntimeException("Kho không đủ! Còn: " + sp.getSoLuong());
                    }
                    hdct.setSoLuong(newQty);
                    hdct.setGiaDonVi(giaHienTai.doubleValue());
                    session.merge(hdct);
                }
            } else if (soLuong > 0) {
                if (sp.getSoLuong() < soLuong) {
                    throw new RuntimeException("Kho không đủ! Còn: " + sp.getSoLuong());
                }
                hdct = new HoaDonChiTiet();
                hdct.setHoaDon(hd);
                hdct.setGiayChiTiet(sp);
                hdct.setSoLuong(soLuong);
                hdct.setGiaDonVi(giaHienTai.doubleValue());
                session.persist(hdct);
            }

            updateTongTien(session, hd);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException(e.getMessage());
        }
    }

    public void removeItem(int idHDCT) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            HoaDonChiTiet hdct = session.get(HoaDonChiTiet.class, idHDCT);
            if (hdct != null) {
                HoaDon hd = hdct.getHoaDon();
                session.remove(hdct);
                updateTongTien(session, hd);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi xóa sản phẩm: " + e.getMessage());
        }
    }

    private void updateTongTien(Session session, HoaDon hd) {
        Double tong = session.createQuery(
                "SELECT COALESCE(SUM(h.soLuong * h.giaDonVi), 0) FROM HoaDonChiTiet h WHERE h.hoaDon.id = :id",
                Double.class)
                .setParameter("id", hd.getId())
                .uniqueResult();
        hd.setTongTien(tong);
        session.merge(hd);
    }
}