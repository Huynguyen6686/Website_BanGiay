package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.HoaDon;
import com.example.ASM.entity.KhachHang;
import com.example.ASM.entity.NhanVien;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;

import java.util.UUID;
public class HoaDonRepository {

    private static final int PAGE_SIZE = 10;
    public HoaDon getById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon h LEFT JOIN FETCH h.khachHang LEFT JOIN FETCH h.nhanVien WHERE h.id = :id",
                    HoaDon.class)
                    .setParameter("id", id)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<HoaDon> search(String keyword, Integer trangThai, int page) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "FROM HoaDon hd " +
                            "LEFT JOIN FETCH hd.khachHang kh " +
                            "LEFT JOIN FETCH hd.nhanVien nv " +
                            "WHERE 1=1 ");

            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append("AND (hd.ma LIKE :key OR kh.hoTen LIKE :key OR kh.sdt LIKE :key) ");
            }

            if (trangThai != null) {
                hql.append("AND hd.trangThai = :status ");
            }

            hql.append("ORDER BY hd.ngayLap DESC");

            Query<HoaDon> query = session.createQuery(hql.toString(), HoaDon.class);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("key", "%" + keyword.trim() + "%");
            }
            if (trangThai != null) {
                query.setParameter("status", trangThai);
            }

            // Phân trang
            int first = (page - 1) * PAGE_SIZE;
            query.setFirstResult(first);
            query.setMaxResults(PAGE_SIZE);

            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    /**
     * Hàm đếm tổng số kết quả tìm được (để tính số trang)
     */
    public long countSearch(String keyword, Integer trangThai) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder(
                    "SELECT COUNT(hd) FROM HoaDon hd " +
                            "LEFT JOIN hd.khachHang kh " +
                            "WHERE 1=1 ");

            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append("AND (hd.ma LIKE :key OR kh.hoTen LIKE :key OR kh.sdt LIKE :key) ");
            }

            if (trangThai != null) {
                hql.append("AND hd.trangThai = :status ");
            }

            Query<Long> query = session.createQuery(hql.toString(), Long.class);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("key", "%" + keyword.trim() + "%");
            }
            if (trangThai != null) {
                query.setParameter("status", trangThai);
            }

            return query.uniqueResult();
        }
    }
    public List<HoaDon> getAll() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon hd " +
                            "LEFT JOIN FETCH hd.khachHang " +
                            "LEFT JOIN FETCH hd.nhanVien " +
                            "ORDER BY hd.ngayLap DESC",
                    HoaDon.class)
                    .list();
        }
    }

    public HoaDon findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon hd LEFT JOIN FETCH hd.khachHang LEFT JOIN FETCH hd.nhanVien LEFT JOIN FETCH hd.chiTiets WHERE hd.id = :id",
                    HoaDon.class)
                    .setParameter("id", id)
                    .uniqueResult();
        }
    }

    public List<HoaDon> getPage(int page) {
        int first = (page - 1) * PAGE_SIZE;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDon hd " +
                            "LEFT JOIN FETCH hd.khachHang " +
                            "LEFT JOIN FETCH hd.nhanVien " +
                            "ORDER BY hd.ngayLap DESC",
                    HoaDon.class)
                    .setFirstResult(first)
                    .setMaxResults(PAGE_SIZE)
                    .list();
        }
    }

    public long getTotalCount() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("SELECT COUNT(hd) FROM HoaDon hd", Long.class)
                    .uniqueResult();
        }
    }

    public void update(HoaDon hd) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.merge(hd);
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lỗi cập nhật hóa đơn", e);
        }
    }
}