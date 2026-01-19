package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.DotGiamGia;
import org.hibernate.Session;

import java.util.*;

public class ThongKeRepository {

    // 1. Doanh thu 7 ngày gần nhất
    public Map<String, Object> getDoanhThu7Ngay() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.HOUR_OF_DAY, 0); cal.set(Calendar.MINUTE, 0); cal.set(Calendar.SECOND, 0); cal.set(Calendar.MILLISECOND, 0);
            Date toDate = cal.getTime();
            cal.add(Calendar.DAY_OF_MONTH, -6);
            Date fromDate = cal.getTime();

            String hql = """
            SELECT COALESCE(SUM(hd.tongTien), 0), COUNT(hd)
            FROM HoaDon hd 
            WHERE hd.trangThai IN (3, 4) 
              AND hd.ngayLap BETWEEN :from AND :to
            """;

            Object[] result = (Object[]) session.createQuery(hql, Object[].class)
                    .setParameter("from", fromDate)
                    .setParameter("to", toDate)
                    .uniqueResult();

            Map<String, Object> map = new HashMap<>();
            map.put("doanhThu", result != null && result[0] != null ? ((Number) result[0]).doubleValue() : 0.0);
            map.put("soDon", result != null && result[1] != null ? ((Number) result[1]).longValue() : 0L);
            return map;
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> fallback = new HashMap<>();
            fallback.put("doanhThu", 0.0);
            fallback.put("soDon", 0L);
            return fallback;
        }
    }

    // 2. Top 5 sản phẩm bán chạy
    public List<Object[]> getTop5SanPham() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = """
            SELECT g.ten, COALESCE(SUM(hdct.soLuong), 0)
            FROM HoaDonChiTiet hdct
            JOIN hdct.giayChiTiet gct
            JOIN gct.giay g
            JOIN hdct.hoaDon hd
            WHERE hd.trangThai IN (3, 4)
            GROUP BY g.ten
            ORDER BY SUM(hdct.soLuong) DESC
            """;

            return session.createQuery(hql, Object[].class)
                    .setMaxResults(5)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // 3. Thống kê phiếu giảm giá
    // Trong hàm getPhieuGiamGiaStats

    public Map<String, Object> getPhieuGiamGiaStats() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Map<String, Object> result = new HashMap<>();

            long tongPhieu = (Long) session.createQuery("SELECT COUNT(p) FROM PhieuGiamGia p").uniqueResult();

            long daPhatHanh = (Long) session.createQuery("SELECT COUNT(p) FROM PhieuGiamGiaKH p").uniqueResult();

            long daSuDung = (Long) session.createQuery(
                    "SELECT COUNT(hd) FROM HoaDon hd WHERE hd.phieuGiamGia IS NOT NULL AND hd.trangThai IN (3, 4)"
            ).uniqueResult();

            Double tongThucTe = session.createQuery(
                    "SELECT COALESCE(SUM(hd.tongTien), 0) FROM HoaDon hd WHERE hd.phieuGiamGia IS NOT NULL AND hd.trangThai IN (3, 4)",
                    Double.class).uniqueResult();

            Double tongTienHang = session.createQuery(
                    "SELECT COALESCE(SUM(ct.soLuong * ct.giaDonVi), 0) " +
                            "FROM HoaDonChiTiet ct " +
                            "WHERE ct.hoaDon.phieuGiamGia IS NOT NULL AND ct.hoaDon.trangThai IN (3, 4)",
                    Double.class).uniqueResult();

            double tongGiaTri = (tongTienHang != null ? tongTienHang : 0) - (tongThucTe != null ? tongThucTe : 0);
            if (tongGiaTri < 0) tongGiaTri = 0;

            result.put("tongPhieu", tongPhieu);
            result.put("daPhatHanh", daPhatHanh);
            result.put("daSuDung", daSuDung);
            result.put("tongGiaTri", tongGiaTri);

            return result;
        }
    }

    public Map<Integer, Long> getTrangThaiDonHang() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            List<Object[]> list = session.createQuery(
                    "SELECT hd.trangThai, COUNT(hd) FROM HoaDon hd GROUP BY hd.trangThai", Object[].class).list();
            Map<Integer, Long> map = new HashMap<>();
            for (Object[] row : list) {
                int status = row[0] != null ? (Integer) row[0] : 0;
                long count = (Long) row[1];
                map.put(status, count);
            }
            return map;
        }
    }
    public double getTongDoanhThuAllTime() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = """
            SELECT COALESCE(SUM(hd.tongTien), 0)
            FROM HoaDon hd 
            WHERE hd.trangThai IN (3, 4)
            """;
            Object result = session.createQuery(hql, Object.class).uniqueResult();
            return result != null ? ((Number) result).doubleValue() : 0.0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
    // 5. Doanh thu theo tháng (12 tháng gần nhất)
    public List<Object[]> getDoanhThuTheoThang() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.MONTH, -11);
            cal.set(Calendar.DAY_OF_MONTH, 1);
            cal.set(Calendar.HOUR_OF_DAY, 0); cal.clear(Calendar.MINUTE); cal.clear(Calendar.SECOND); cal.clear(Calendar.MILLISECOND);
            Date startDate = cal.getTime();

            String hql = """
            SELECT MONTH(hd.ngayLap), YEAR(hd.ngayLap), COALESCE(SUM(hd.tongTien), 0)
            FROM HoaDon hd
            WHERE hd.trangThai IN (3, 4) AND hd.ngayLap >= :startDate
            GROUP BY YEAR(hd.ngayLap), MONTH(hd.ngayLap)
            ORDER BY YEAR(hd.ngayLap), MONTH(hd.ngayLap)
            """;

            return session.createQuery(hql, Object[].class)
                    .setParameter("startDate", startDate)
                    .getResultList();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // 6. Thống kê đợt giảm giá
    public long countDangDienRa() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Date today = new Date();
            return session.createQuery(
                    "SELECT COUNT(d) FROM DotGiamGia d WHERE d.kichHoat = 1 AND d.ngayBatDau <= :today AND d.ngayKetThuc >= :today", Long.class)
                    .setParameter("today", today).uniqueResult();
        }
    }
    public List<DotGiamGia> getAllDotGiamGia() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM DotGiamGia ORDER BY ngayBatDau DESC", DotGiamGia.class).list();
        }
    }
    public long countSapDienRa() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Date today = new Date();
            return session.createQuery(
                    "SELECT COUNT(d) FROM DotGiamGia d WHERE d.kichHoat = 1 AND d.ngayBatDau > :today", Long.class)
                    .setParameter("today", today).uniqueResult();
        }
    }

    public long countDaKetThuc() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Date today = new Date();
            return session.createQuery(
                    "SELECT COUNT(d) FROM DotGiamGia d WHERE d.ngayKetThuc < :today", Long.class)
                    .setParameter("today", today).uniqueResult();
        }
    }
}