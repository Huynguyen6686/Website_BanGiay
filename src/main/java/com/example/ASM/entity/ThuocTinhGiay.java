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
@Table(name = "ThuocTinhGiay")
public class ThuocTinhGiay {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @Column(name = "LoaiThuocTinh")
    private Integer loaiThuocTinh;

    @Column(name = "Ma", unique = true)
    private String ma;

    @Column(name = "Ten")
    private String ten;

    @Column(name = "MoTa")
    private String moTa;

    @Column(name = "ThuTuSapXep")
    private Integer thuTuSapXep;

    @Column(name = "KichHoat")
    private Integer kichHoat;

    // getters & setters
}

