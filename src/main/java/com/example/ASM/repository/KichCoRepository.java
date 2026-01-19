package com.example.ASM.repository;

import com.example.ASM.entity.KichCo;
import com.example.ASM.config.HibernalUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class KichCoRepository {

    public List<KichCo> getAll() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM KichCo ORDER BY CAST(giaTri AS int)", KichCo.class).list();
        }
    }

    public KichCo findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(KichCo.class, id);
        }
    }

    public void save(KichCo kc) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.persist(kc);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi thêm kích cỡ", e);
        }
    }

    public void update(KichCo kc) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(kc);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật kích cỡ", e);
        }
    }

    public void delete(int id) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            KichCo kc = session.get(KichCo.class, id);
            if (kc != null) session.remove(kc);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi xóa kích cỡ", e);
        }
    }
}