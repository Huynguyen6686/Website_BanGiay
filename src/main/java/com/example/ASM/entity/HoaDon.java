package com.example.ASM.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "HoaDon")
public class HoaDon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @Column(name = "Ma", unique = true)
    private String ma;

    @ManyToOne
    @JoinColumn(name = "KhachHangId")
    private KhachHang khachHang;

    @ManyToOne
    @JoinColumn(name = "NhanVienId")
    private NhanVien nhanVien;

    @Column(name = "NgayLap")
    private java.util.Date ngayLap;

    @Column(name = "TrangThai")
    private int trangThai;

    @Column(name = "TongTien")
    private double tongTien;

    @Column(name = "GhiChu")
    private String ghiChu;

    @Column(name = "NgayThanhToan")
    private java.util.Date ngayThanhToan;

    @OneToMany(mappedBy = "hoaDon", fetch = FetchType.LAZY)
    private Set<HoaDonChiTiet> chiTiets;

    @OneToMany(mappedBy = "hoaDon", fetch = FetchType.LAZY)
    private Set<ThanhToan> thanhToans;

    @ManyToOne
    @JoinColumn(name = "PhieuGiamGiaId") // Đảm bảo trong DB bảng HoaDon đã có cột này
    private PhieuGiamGia phieuGiamGia;
    // getters & setters
}


