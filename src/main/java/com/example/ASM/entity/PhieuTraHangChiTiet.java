package com.example.ASM.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "PhieuTraHangChiTiet")
public class PhieuTraHangChiTiet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @ManyToOne
    @JoinColumn(name = "PhieuTraHangId")
    private PhieuTraHang phieuTraHang;

    @ManyToOne
    @JoinColumn(name = "HoaDonChiTietId")
    private HoaDonChiTiet hoaDonChiTiet;

    @ManyToOne
    @JoinColumn(name = "GiayChiTietId")
    private GiayChiTiet giayChiTiet;

    @Column(name = "SoLuongTra")
    private int soLuongTra;

    @Column(name = "GiaBan")
    private double giaBan;

    @Column(name = "ThanhTien")
    private double thanhTien;

    @Column(name = "GhiChu")
    private String ghiChu;

    // getters & setters
}


