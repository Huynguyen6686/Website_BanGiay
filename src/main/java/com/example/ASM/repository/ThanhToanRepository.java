package com.example.ASM.repository;

import com.example.ASM.entity.*;
import com.example.ASM.config.HibernalUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

public class ThanhToanRepository {

    public double tinhGiamGia(int hoaDonId, String code) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            HoaDon hd = session.get(HoaDon.class, hoaDonId);
            if (hd == null) throw new RuntimeException("Không tìm thấy hóa đơn!");

            if (code == null || code.trim().isEmpty()) return 0.0;

            PhieuGiamGia pgg = session.createQuery(
                    "FROM PhieuGiamGia WHERE ma = :code AND kichHoat = 1 AND soLuong > 0", PhieuGiamGia.class)
                    .setParameter("code", code)
                    .uniqueResult();

            if (pgg == null) throw new RuntimeException("Mã giảm giá không hợp lệ hoặc đã hết!");

            Date now = new Date();
            if (pgg.getNgayBatDau().after(now) || pgg.getNgayKetThuc().before(now)) {
                throw new RuntimeException("Mã giảm giá đã hết hạn hoặc chưa bắt đầu!");
            }

            double tongTien = hd.getTongTien();
            double tienGiam = 0;

            if (pgg.getLoai() == 1) { // %
                tienGiam = tongTien * pgg.getGiaTri() / 100;
                tienGiam = Math.min(tienGiam, 500000); // giới hạn tối đa 500k
            } else { // tiền cố định
                tienGiam = Math.min(pgg.getGiaTri(), tongTien);
            }

            return tienGiam;
        } catch (Exception e) {
            throw new RuntimeException(e.getMessage());
        }
    }

    public List<PhieuGiamGia> getVoucherKhaDung() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = """
                FROM PhieuGiamGia p 
                WHERE p.kichHoat = 1 
                  AND p.soLuong > 0 
                  AND :now BETWEEN p.ngayBatDau AND p.ngayKetThuc
                ORDER BY p.giaTri DESC
                """;
            return session.createQuery(hql, PhieuGiamGia.class)
                    .setParameter("now", new Date())
                    .setMaxResults(20)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }

    public void thanhToan(int hoaDonId, int hinhThuc, double tienKhachDua, String maVoucher) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();

            HoaDon hd = session.get(HoaDon.class, hoaDonId);
            if (hd == null || hd.getTrangThai() != 0) {
                throw new RuntimeException("Hóa đơn không hợp lệ!");
            }

            double tongPhaiTra = hd.getTongTien();
            if (tienKhachDua < tongPhaiTra) {
                throw new RuntimeException("Số tiền khách đưa không đủ!");
            }

            // Cập nhật trạng thái hóa đơn
            hd.setTrangThai(4);
            hd.setNgayThanhToan(new Date());
            session.merge(hd);

            // Tạo bản ghi thanh toán
            ThanhToan tt = new ThanhToan();
            tt.setHoaDon(hd);
            tt.setHinhThuc(hinhThuc);
            tt.setSoTien(tongPhaiTra);
            tt.setMaGiaoDich("PAY-" + System.currentTimeMillis());
            tt.setTrangThai(1);
            session.persist(tt);

            // Trừ tồn kho
            List<HoaDonChiTiet> listCT = session.createQuery(
                    "FROM HoaDonChiTiet WHERE hoaDon.id = :id", HoaDonChiTiet.class)
                    .setParameter("id", hoaDonId)
                    .getResultList();

            for (HoaDonChiTiet ct : listCT) {
                GiayChiTiet sp = ct.getGiayChiTiet();
                if (sp.getSoLuong() < ct.getSoLuong()) {
                    throw new RuntimeException("Sản phẩm " + sp.getGiay().getTen() + " không đủ hàng!");
                }
                sp.setSoLuong(sp.getSoLuong() - ct.getSoLuong());
                session.merge(sp);
            }

            // Trừ lượt voucher nếu có
            if (maVoucher != null && !maVoucher.trim().isEmpty()) {
                PhieuGiamGia pgg = session.createQuery(
                        "FROM PhieuGiamGia WHERE ma = :code", PhieuGiamGia.class)
                        .setParameter("code", maVoucher)
                        .uniqueResult();
                if (pgg != null && pgg.getSoLuong() > 0) {
                    pgg.setSoLuong(pgg.getSoLuong() - 1);
                    session.merge(pgg);
                }
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException(e.getMessage());
        }
    }
}