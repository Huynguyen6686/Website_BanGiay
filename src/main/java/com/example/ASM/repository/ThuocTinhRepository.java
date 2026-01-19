package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.KichCo;
import com.example.ASM.entity.MauSac;
import com.example.ASM.entity.ThuocTinhGiay;
import org.hibernate.Session;
import java.util.List;

public class ThuocTinhRepository {
    public List<MauSac> getAllMauSac() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM MauSac", MauSac.class).list();
        }
    }

    public List<KichCo> getAllKichCo() {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery("FROM KichCo", KichCo.class).list();
        }
    }

    public List<ThuocTinhGiay> getByLoai(int loai) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            // loai: 1=Kiểu, 2=Chất liệu, 3=Loại dây, 4=Cổ, 5=Đế (Theo SQL)
            return session.createQuery("FROM ThuocTinhGiay WHERE loaiThuocTinh = :loai AND kichHoat = 1", ThuocTinhGiay.class)
                    .setParameter("loai", loai)
                    .list();
        }
    }
    public ThuocTinhGiay findById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(ThuocTinhGiay.class, id);
        }
    }

    public MauSac findMauSacById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(MauSac.class, id);
        }
    }

    public KichCo findKichCoById(int id) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.get(KichCo.class, id);
        }
    }
}