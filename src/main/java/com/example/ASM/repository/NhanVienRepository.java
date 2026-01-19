package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.NhanVien;
import com.example.ASM.entity.Role;
import org.hibernate.Session;

import java.util.List;
import java.util.UUID;

public class NhanVienRepository {

    public List<NhanVien> getAll() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM NhanVien nv LEFT JOIN FETCH nv.role ORDER BY nv.hoTen", NhanVien.class).list();
        }
    }

    public NhanVien findById(String idStr) {
        if (idStr == null || idStr.isEmpty()) return null;
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(NhanVien.class, UUID.fromString(idStr));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public NhanVien findByTenDangNhap(String tenDangNhap) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM NhanVien WHERE tenDangNhap = :ten", NhanVien.class)
                    .setParameter("ten", tenDangNhap)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ĐĂNG NHẬP NHÂN VIÊN
    public NhanVien login(String tenDangNhap, String matKhau) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = """
            FROM NhanVien nv 
            LEFT JOIN FETCH nv.role 
            WHERE nv.tenDangNhap = :ten 
              AND nv.matKhau = :mk 
              AND nv.trangThai = 1
            """;
            return session.createQuery(hql, NhanVien.class)
                    .setParameter("ten", tenDangNhap)
                    .setParameter("mk", matKhau)
                    .uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // KIỂM TRA TRÙNG TÊN ĐĂNG NHẬP HOẶC EMAIL
    public boolean isExist(String tenDangNhap, String email) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            String hql = "SELECT COUNT(n) FROM NhanVien n WHERE n.tenDangNhap = :ten OR n.email = :email";
            Long count = session.createQuery(hql, Long.class)
                    .setParameter("ten", tenDangNhap)
                    .setParameter("email", email)
                    .uniqueResult();
            return count != null && count > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Role> getAllRoles() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM Role ORDER BY ten", Role.class).list();
        }
    }

    public void saveOrUpdate(NhanVien nv) {
        Session session = null;
        org.hibernate.Transaction tx = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            tx = session.beginTransaction();
            if (nv.getId() == null) {
                nv.setId(UUID.randomUUID());
                session.persist(nv);
            } else {
                session.merge(nv);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Lưu nhân viên thất bại: " + e.getMessage());
        } finally {
            if (session != null && session.isOpen()) session.close();
        }
    }

    public void lock(String idStr) {
        updateStatus(idStr, 0);
    }

    public void unlock(String idStr) {
        updateStatus(idStr, 1);
    }

    private void updateStatus(String idStr, int status) {
        Session session = null;
        org.hibernate.Transaction tx = null;
        try {
            session = HibernalUtil.getFACTORY().openSession();
            tx = session.beginTransaction();
            NhanVien nv = findById(idStr);
            if (nv != null) {
                nv.setTrangThai(status);
                session.merge(nv);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Cập nhật trạng thái thất bại", e);
        } finally {
            if (session != null && session.isOpen()) session.close();
        }
    }
}