package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.DotGiamGia;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.Date;
import java.util.List;

public class DotGiamGiaRepository {

    public List<DotGiamGia> getAll() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "SELECT DISTINCT d FROM DotGiamGia d LEFT JOIN FETCH d.giays ORDER BY d.ngayBatDau DESC",
                    DotGiamGia.class)
                    .list();
        }
    }

    public DotGiamGia findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(DotGiamGia.class, id);
        }
    }

    public void saveOrUpdate(DotGiamGia dgg) {
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            tx = session.beginTransaction();

            if (dgg.getId() == null || dgg.getId() == 0) {
                session.persist(dgg);        // tạo mới
            } else {
                session.merge(dgg);          // cập nhật – luôn dùng merge cho object detached
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lưu đợt giảm giá thất bại: " + e.getMessage(), e);
        } finally {
            if (session != null && session.isOpen()) session.close();
        }
    }

    public void delete(int id) {
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            tx = session.beginTransaction();
            DotGiamGia dgg = session.get(DotGiamGia.class, id);
            if (dgg != null) session.remove(dgg);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Xóa thất bại", e);
        } finally {
            if (session != null && session.isOpen()) session.close();
        }
    }

    // Thống kê (giữ nguyên)
    public long countDangDienRa() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Date today = new Date();
            return session.createQuery(
                    "SELECT COUNT(d) FROM DotGiamGia d WHERE d.kichHoat = 1 AND d.ngayBatDau <= :today AND d.ngayKetThuc >= :today", Long.class)
                    .setParameter("today", today).uniqueResult();
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