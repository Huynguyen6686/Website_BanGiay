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
@Table(name = "PhieuTraHang")
public class PhieuTraHang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @Column(name = "Ma", unique = true)
    private String ma;

    @ManyToOne
    @JoinColumn(name = "HoaDonId")
    private HoaDon hoaDon;

    @ManyToOne
    @JoinColumn(name = "KhachHangId")
    private KhachHang khachHang;

    @ManyToOne
    @JoinColumn(name = "NhanVienId")
    private NhanVien nhanVien;

    @Column(name = "LyDo")
    private String lyDo;

    @Column(name = "TongTienHoan")
    private double tongTienHoan;

    @Column(name = "HinhThucHoan")
    private int hinhThucHoan; // tien_mat = 1, chuyen_khoan = 2, doi_san_pham = 3

    @Column(name = "TrangThai")
    private int trangThai;

    @OneToMany(mappedBy = "phieuTraHang", fetch = FetchType.LAZY)
    private Set<PhieuTraHangChiTiet> chiTiets;

    // getters & setters
}
