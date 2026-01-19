package com.example.ASM.repository;

import com.example.ASM.entity.MauSac;
import com.example.ASM.config.HibernalUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class MauSacRepository {

    public List<MauSac> getAll() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM MauSac ORDER BY id DESC", MauSac.class).list();
        }
    }

    public MauSac findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(MauSac.class, id);
        }
    }

    public void save(MauSac ms) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.persist(ms);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi thêm màu sắc", e);
        }
    }

    public void update(MauSac ms) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(ms);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật màu sắc", e);
        }
    }

    public void delete(int id) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            MauSac ms = session.get(MauSac.class, id);
            if (ms != null) {
                session.remove(ms);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi xóa màu sắc", e);
        }
    }
}