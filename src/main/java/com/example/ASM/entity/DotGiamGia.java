package com.example.ASM.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Date;
import java.util.Set;
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "DotGiamGia")
public class DotGiamGia {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "Ma", unique = true)
    private String ma;

    @Column(name = "Ten")
    private String ten;

    @Column(name = "MoTa")
    private String moTa;

    @Column(name = "PhanTram")
    private Double phanTram;

    @Column(name = "SoTienGiam")
    private Double soTienGiam;

    @Column(name = "NgayBatDau")
    private Date ngayBatDau;

    @Column(name = "NgayKetThuc")
    private Date ngayKetThuc;

    @Column(name = "KichHoat")
    private Integer kichHoat;

    @OneToMany(mappedBy = "dotGiamGia", fetch = FetchType.LAZY)
    private Set<DotGiamGiaGiay> giays;

    // getters & setters
}
