package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.GiayChiTiet;
import org.hibernate.Session;
import org.hibernate.Transaction;
import java.util.List;

public class GiayChiTietRepository {

    // Lấy danh sách biến thể theo ID Giày (kèm JOIN FETCH để tránh lỗi Lazy)
    public List<GiayChiTiet> getByGiayId(int giayId) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            // Cập nhật HQL để JOIN FETCH các thuộc tính mới
            String hql = "FROM GiayChiTiet g " +
                    "JOIN FETCH g.mauSac " +
                    "JOIN FETCH g.kichCo " +
                    "LEFT JOIN FETCH g.kieu " +
                    "LEFT JOIN FETCH g.chatLieu " +
                    "LEFT JOIN FETCH g.day " +
                    "LEFT JOIN FETCH g.co " +
                    "LEFT JOIN FETCH g.de " +
                    "WHERE g.giay.id = :gid ORDER BY g.id DESC";

            return session.createQuery(hql, GiayChiTiet.class)
                    .setParameter("gid", giayId)
                    .list();
        }
    }
    public List<GiayChiTiet> getAll() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM GiayChiTiet g " +
                            "JOIN FETCH g.giay " +
                            "JOIN FETCH g.mauSac " +
                            "JOIN FETCH g.kichCo " +
                            "LEFT JOIN FETCH g.kieu " +
                            "LEFT JOIN FETCH g.chatLieu " +
                            "LEFT JOIN FETCH g.day " +
                            "LEFT JOIN FETCH g.co " +
                            "LEFT JOIN FETCH g.de " +
                            "WHERE g.kichHoat = true ORDER BY g.id DESC",
                    GiayChiTiet.class)
                    .list();
        }
    }
    // ------------------------- CÁC PHƯƠNG THỨC MỚI -------------------------

    // 1. Tìm kiếm theo ID (findById)
    public GiayChiTiet findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            // Sử dụng JOIN FETCH để tải đầy đủ các đối tượng liên quan khi tìm chi tiết
            String hql = "FROM GiayChiTiet g " +
                    "JOIN FETCH g.mauSac " +
                    "JOIN FETCH g.kichCo " +
                    "LEFT JOIN FETCH g.kieu " +
                    "LEFT JOIN FETCH g.chatLieu " +
                    "LEFT JOIN FETCH g.day " +
                    "LEFT JOIN FETCH g.co " +
                    "LEFT JOIN FETCH g.de " +
                    "WHERE g.id = :id";
            return session.createQuery(hql, GiayChiTiet.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    // 2. Thêm mới (save/persist)
    public void save(GiayChiTiet gct) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.persist(gct);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // 3. Cập nhật (update)
    public void update(GiayChiTiet gct) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.update(gct); // Có thể dùng session.merge(gct) nếu đối tượng bị detached
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }

    // 4. Xóa mềm (Soft Delete: đặt KichHoat = false)
    public void delete(int id) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            // Lấy đối tượng GiayChiTiet cần xóa
            GiayChiTiet gct = session.get(GiayChiTiet.class, id);
            if (gct != null) {
                // Thực hiện xóa mềm
                gct.setKichHoat(false);
                session.update(gct);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        }
    }
}