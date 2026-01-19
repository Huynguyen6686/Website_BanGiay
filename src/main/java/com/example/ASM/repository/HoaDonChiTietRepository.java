package com.example.ASM.repository;

import com.example.ASM.config.HibernalUtil;
import com.example.ASM.entity.HoaDonChiTiet;
import org.hibernate.Session;

import java.util.List;

public class HoaDonChiTietRepository {

    public List<HoaDonChiTiet> getByHoaDonId(int hoaDonId) {
        try (Session session = HibernalUtil.getFACTORY().openSession()) {
            return session.createQuery(
                    "FROM HoaDonChiTiet ct LEFT JOIN FETCH ct.giayChiTiet gct LEFT JOIN FETCH gct.giay LEFT JOIN FETCH gct.mauSac LEFT JOIN FETCH gct.kichCo WHERE ct.hoaDon.id = :id",
                    HoaDonChiTiet.class)
                    .setParameter("id", hoaDonId)
                    .list();
        }
    }
}