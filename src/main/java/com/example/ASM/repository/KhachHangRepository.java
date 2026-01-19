package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.KhachHang;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;
import java.util.UUID;

public class KhachHangRepository {

    // Lấy tất cả khách hàng
    public List<KhachHang> getAll() {
        Session session = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            return session.createQuery("FROM KhachHang ORDER BY hoTen ASC", KhachHang.class)
                    .list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    // Tìm theo ID
    public KhachHang findById(String idStr) {
        if (idStr == null || idStr.isEmpty()) return null;
        Session session = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            UUID id = UUID.fromString(idStr);
            return session.get(KhachHang.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    // ĐĂNG NHẬP KHÁCH HÀNG
    public KhachHang login(String tenDangNhap, String matKhau) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = "FROM KhachHang WHERE tenDangNhap = :ten AND matKhau = :mk AND trangThai = 1";
            return session.createQuery(hql, KhachHang.class)
                    .setParameter("ten", tenDangNhap)
                    .setParameter("mk", matKhau)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ĐĂNG KÝ KHÁCH HÀNG
    public boolean add(KhachHang kh) {
        Transaction tx = null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            tx = session.beginTransaction();

            // Kiểm tra trùng tên đăng nhập hoặc email
            String checkHql = "SELECT COUNT(k) FROM KhachHang k WHERE k.tenDangNhap = :ten OR k.email = :email";
            Long count = session.createQuery(checkHql, Long.class)
                    .setParameter("ten", kh.getTenDangNhap())
                    .setParameter("email", kh.getEmail())
                    .uniqueResult();

            if (count != null && count > 0) {
                return false; // đã tồn tại
            }

            kh.setId(UUID.randomUUID());
            session.persist(kh);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    // saveOrUpdate (thêm hoặc sửa)
    public void saveOrUpdate(KhachHang kh) {
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            tx = session.beginTransaction();

            if (kh.getId() == null) {
                kh.setId(UUID.randomUUID());
                session.persist(kh);
            } else {
                session.merge(kh);
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lưu khách hàng thất bại: " + e.getMessage(), e);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }

    // KHÓA TÀI KHOẢN
    public void lock(String idStr) {
        updateStatus(idStr, 0);
    }

    // MỞ KHÓA TÀI KHOẢN
    public void unlock(String idStr) {
        updateStatus(idStr, 1);
    }

    private void updateStatus(String idStr, int status) {
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            tx = session.beginTransaction();
            KhachHang kh = findById(idStr);
            if (kh != null) {
                kh.setTrangThai(status);
                session.merge(kh);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Cập nhật trạng thái thất bại", e);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
    }
}