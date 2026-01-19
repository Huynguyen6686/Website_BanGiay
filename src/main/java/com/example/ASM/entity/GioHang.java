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
@Table(name = "GioHang")
public class GioHang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @ManyToOne
    @JoinColumn(name = "KhachHangId")
    private KhachHang khachHang;

    @Column(name = "KichHoat")
    private int kichHoat;

    @OneToMany(mappedBy = "gioHang", fetch = FetchType.LAZY)
    private Set<GioHangChiTiet> chiTiets;

    // getters & setters
}
