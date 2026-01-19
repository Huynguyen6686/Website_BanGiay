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
@Table(name = "GioHangChiTiet")
public class GioHangChiTiet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @ManyToOne
    @JoinColumn(name = "GioHangId")
    private GioHang gioHang;

    @ManyToOne
    @JoinColumn(name = "GiayChiTietId")
    private GiayChiTiet giayChiTiet;

    @Column(name = "SoLuong")
    private int soLuong;

    @Column(name = "GiaTaiThoiDiem")
    private double giaTaiThoiDiem;

    // getters & setters
}
