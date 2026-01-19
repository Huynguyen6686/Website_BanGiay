package com.example.ASM.repository;

import com.example.ASM.entity.ThuocTinhGiay;
import com.example.ASM.config.HibernalUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class ThuocTinhGiayRepository {

    public List<ThuocTinhGiay> getAllActive() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM ThuocTinhGiay WHERE kichHoat = 1 ORDER BY loaiThuocTinh, thuTuSapXep, ten",
                    ThuocTinhGiay.class).list();
        }
    }

    public List<ThuocTinhGiay> getByLoai(int loai) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM ThuocTinhGiay WHERE loaiThuocTinh = :loai ORDER BY ten",
                    ThuocTinhGiay.class)
                    .setParameter("loai", loai)
                    .list();
        }
    }


    public ThuocTinhGiay findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(ThuocTinhGiay.class, id);
        }
    }

    public void save(ThuocTinhGiay tt) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            if (tt.getKichHoat() == null) tt.setKichHoat(1);
            session.persist(tt);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi thêm thuộc tính", e);
        }
    }

    public void update(ThuocTinhGiay tt) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(tt);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật thuộc tính", e);
        }
    }

    public void delete(int id) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            ThuocTinhGiay tt = session.get(ThuocTinhGiay.class, id);
            if (tt != null) {
                tt.setKichHoat(0); // Soft delete
                session.merge(tt);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi xóa thuộc tính", e);
        }
    }
}