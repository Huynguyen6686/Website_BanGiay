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
@Table(name = "ThanhToan")
public class ThanhToan {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @ManyToOne
    @JoinColumn(name = "HoaDonId")
    private HoaDon hoaDon;

    @Column(name = "MaGiaoDich")
    private String maGiaoDich;

    @Column(name = "HinhThuc")
    private int hinhThuc; // tien_mat = 1, the = 2, vi_dien_tu = 3

    @Column(name = "SoTien")
    private double soTien;

    @Column(name = "TrangThai")
    private int trangThai;

    // getters & setters
}

