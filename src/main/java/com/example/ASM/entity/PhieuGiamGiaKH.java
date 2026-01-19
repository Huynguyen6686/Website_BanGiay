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
@Table(name = "PhieuGiamGiaKH")
public class PhieuGiamGiaKH {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @ManyToOne
    @JoinColumn(name = "PhieuGiamGiaId")
    private PhieuGiamGia phieuGiamGia;

    @ManyToOne
    @JoinColumn(name = "KhachHangId")
    private KhachHang khachHang;

    @Column(name = "DaSuDung")
    private int daSuDung;

    @Column(name = "NgaySuDung")
    private java.util.Date ngaySuDung;

    // getters & setters
}

