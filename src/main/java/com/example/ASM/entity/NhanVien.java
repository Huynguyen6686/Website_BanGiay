package com.example.ASM.entity;

import jakarta.persistence.*;

import java.util.UUID;


import lombok.*;


@Getter
@Setter
@RequiredArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "NhanVien")
public class NhanVien {
    @Id
    @GeneratedValue
    @Column(name = "Id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "Ma", unique = true)
    private String ma;

    @Column(name = "HoTen")
    private String hoTen;

    @Column(name = "Email", unique = true)
    private String email;

    @Column(name = "MatKhau")
    private String matKhau;

    @Column(name = "Sdt")
    private String sdt;

    @Column(name = "DiaChi")
    private String diaChi;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "RoleId")
    private Role role;

    @Column(name = "TenDangNhap", unique = true, length = 50)
    private String tenDangNhap;

    @Column(name = "TrangThai")
    private int trangThai;


    public NhanVien(Integer id) {
        this.id = UUID.randomUUID();
    }


}

