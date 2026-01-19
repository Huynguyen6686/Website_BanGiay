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
@Table(name = "HoaDonChiTiet")
public class HoaDonChiTiet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @ManyToOne
    @JoinColumn(name = "HoaDonId")
    private HoaDon hoaDon;

    @ManyToOne
    @JoinColumn(name = "GiayChiTietId")
    private GiayChiTiet giayChiTiet;

    @Column(name = "SoLuong")
    private int soLuong;

    @Column(name = "GiaDonVi")
    private double giaDonVi;

    // getters & setters
}
