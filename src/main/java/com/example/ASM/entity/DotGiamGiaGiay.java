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
@Table(name = "DotGiamGiaGiay")
public class DotGiamGiaGiay {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "DotGiamGiaId")
    private DotGiamGia dotGiamGia;

    @ManyToOne
    @JoinColumn(name = "GiayChiTietId")
    private GiayChiTiet giayChiTiet;

    @Column(name = "PhanTramThayThe")
    private Double phanTramThayThe;

    @Column(name = "SoTienThayThe")
    private Double soTienThayThe;

    // getters & setters
}

