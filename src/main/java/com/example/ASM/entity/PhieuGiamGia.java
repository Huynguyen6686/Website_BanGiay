package com.example.ASM.entity;

import jakarta.persistence.*;
import lombok.*;

import java.sql.Date;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "PhieuGiamGia")
public class PhieuGiamGia {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @Column(name = "Ma", unique = true, nullable = false, length = 100)
    private String ma;

    @Column(name = "Ten", length = 200)
    private String ten;

    @Column(name = "Loai")
    private int loai;

    @Column(name = "GiaTri", precision = 18, scale = 2)
    private Double giaTri;

    @Column(name = "NgayBatDau")
    private java.sql.Date ngayBatDau;   // SỬA THÀNH java.sql.Date

    @Column(name = "NgayKetThuc")
    private java.sql.Date ngayKetThuc;  // SỬA THÀNH java.sql.Date

    @Column(name = "SoLuong")
    private Integer soLuong;

    @Column(name = "KichHoat")
    private Integer kichHoat = 1;

    @Column(name = "DieuKien", precision = 18, scale = 2)
    private Double dieuKien;

    @Column(name = "GiaTriToiDa", precision = 18, scale = 2)
    private Double giaTriToiDa;

    @Column(name = "NgayTao")
    private java.util.Date ngayTao;

    @Column(name = "NgayCapNhat")
    private java.util.Date ngayCapNhat;

    @OneToMany(mappedBy = "phieuGiamGia", fetch = FetchType.LAZY)
    private Set<PhieuGiamGiaKH> phieuKHs;
}