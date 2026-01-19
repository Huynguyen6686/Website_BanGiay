// src/main/java/com/example/ASM/repository/GiayRepository.java

package com.example.ASM.repository;

import com.example.ASM.entity.Giay;
import com.example.ASM.config.HibernalUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;

public class GiayRepository {

    // Lấy tất cả sản phẩm (chỉ hiển thị đang hoạt động hoặc cả ngừng bán tùy yêu cầu)
    public List<Giay> getAll() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            // Sử dụng LEFT JOIN FETCH để tải chiTiets cùng lúc với Giay
            // DISTINCT để tránh trùng lặp do JOIN
            String hql = "SELECT DISTINCT g FROM Giay g LEFT JOIN FETCH g.chiTiets ORDER BY g.id DESC";
            Query<Giay> query = session.createQuery(hql, Giay.class);
            return query.list();
        }
    }

    // Tìm theo ID
    public Giay findById(Integer id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(Giay.class, id);
        }
    }
    public boolean checkMaTonTai(String ma, Integer id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            // Câu query cơ bản: Đếm số dòng có mã trùng
            String hql = "SELECT COUNT(g) FROM Giay g WHERE g.ma = :ma";

            // Nếu đang sửa (có ID), thì phải trừ chính ID đó ra
            if (id != null) {
                hql += " AND g.id != :id";
            }

            Query<Long> query = session.createQuery(hql, Long.class);
            query.setParameter("ma", ma);

            if (id != null) {
                query.setParameter("id", id);
            }

            Long count = query.uniqueResult();
            return count > 0; // Nếu lớn hơn 0 nghĩa là đã tồn tại
        }
    }
    // Thêm mới
    public void save(Giay giay) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.persist(giay);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi thêm sản phẩm", e);
        }
    }

    // Cập nhật
    public void update(Giay giay) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.update(giay);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi cập nhật sản phẩm", e);
        }
    }

    // Xóa mềm (đặt trạng thái = 0)
    public void delete(Integer id) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            Giay g = session.get(Giay.class, id);
            if (g != null) {
                g.setTrangThai(0);
                session.update(g);

                // TỰ ĐỘNG tắt hết biến thể con
                session.createQuery(
                        "UPDATE GiayChiTiet SET kichHoat = false WHERE giay.id = :giayId")
                        .setParameter("giayId", id)
                        .executeUpdate();
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi khi xóa sản phẩm", e);
        }
    }

    public static void main(String[] args) {
        System.out.println(new GiayRepository().getAll());
    }
}