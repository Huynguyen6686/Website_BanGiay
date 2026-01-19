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
@Table(name = "Giay")
public class Giay {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @Column(name = "Ma", unique = true)
    private String ma;

    @Column(name = "Ten")
    private String ten;

    @Column(name = "MoTa")
    private String moTa;

    @Column(name = "ThuongHieu")
    private String thuongHieu;

    @Column(name = "TrangThai")
    private int trangThai;

    @Column(name = "NgayTao")
    private java.util.Date ngayTao;

    @OneToMany(mappedBy = "giay", fetch = FetchType.LAZY)
    private Set<GiayChiTiet> chiTiets;

    // getters & setters
}

