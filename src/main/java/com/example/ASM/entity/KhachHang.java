package com.example.ASM.entity;

import jakarta.persistence.*;
import java.util.UUID;
import java.util.Date;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.UUID;
import java.util.Date;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "KhachHang")
public class KhachHang {
    @Id
    @GeneratedValue
    @Column(name = "Id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "HoTen")
    private String hoTen;

    @Column(name = "Email", unique = true)
    private String email;

    @Column(name = "Sdt")
    private String sdt;

    @Column(name = "DiaChi")
    private String diaChi;

    @Column(name = "NgaySinh")
    @Temporal(TemporalType.DATE)
    private Date ngaySinh;

    @Column(name = "MatKhau")
    private String matKhau;

    @Column(name = "TrangThai")
    private int trangThai;

    @Column(name = "TenDangNhap", unique = true, length = 50)
    private String tenDangNhap;
    public KhachHang(UUID id) {
        this.id = id;
    }
}

