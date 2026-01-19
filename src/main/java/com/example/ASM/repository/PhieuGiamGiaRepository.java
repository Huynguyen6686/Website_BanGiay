package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.PhieuGiamGia;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.Date;
import java.util.List;

public class PhieuGiamGiaRepository {

    public List<PhieuGiamGia> getAll() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM PhieuGiamGia ORDER BY ngayBatDau DESC", PhieuGiamGia.class).list();
        }
    }

    public PhieuGiamGia findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(PhieuGiamGia.class, id);
        }
    }

    public void saveOrUpdate(PhieuGiamGia pgg) {
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            tx = session.beginTransaction();

            if (pgg.getId() == 0) {
                session.persist(pgg);
            } else {
                session.merge(pgg);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lưu phiếu giảm giá thất bại: " + e.getMessage());
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
            PhieuGiamGia pgg = session.get(PhieuGiamGia.class, id);
            if (pgg != null) {
                session.remove(pgg);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Xóa phiếu giảm giá thất bại", e);
        } finally {
            if (session != null && session.isOpen()) session.close();
        }
    }

    // Đếm thống kê
    public long countDangHoatDong() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Date today = new Date();
            return session.createQuery(
                    "SELECT COUNT(p) FROM PhieuGiamGia p WHERE p.kichHoat = 1 AND p.soLuong > 0 AND p.ngayBatDau <= :today AND p.ngayKetThuc >= :today", Long.class)
                    .setParameter("today", today)
                    .uniqueResult();
        }
    }

    public long countHetHan() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            Date today = new Date();
            return session.createQuery(
                    "SELECT COUNT(p) FROM PhieuGiamGia p WHERE p.ngayKetThuc < :today", Long.class)
                    .setParameter("today", today)
                    .uniqueResult();
        }
    }

    public long countHetSoLuong() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "SELECT COUNT(p) FROM PhieuGiamGia p WHERE p.soLuong <= 0", Long.class)
                    .uniqueResult();
        }
    }
}