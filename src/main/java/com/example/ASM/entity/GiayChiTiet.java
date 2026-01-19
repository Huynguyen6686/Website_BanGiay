// src/main/java/com/example/ASM/entity/GiayChiTiet.java

package com.example.ASM.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal; // Cần thiết cho kiểu DECIMAL
import java.time.LocalDateTime; // Cần thiết cho kiểu DATETIME2

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "GiayChiTiet")
public class GiayChiTiet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    // -----------------------------------------------------------------
    // 1. QUAN HỆ KHÓA NGOẠI (FOREIGN KEYS)
    // -----------------------------------------------------------------

    // Khóa ngoại bắt buộc: Giay
    @ManyToOne
    @JoinColumn(name = "GiayId", nullable = false)
    private Giay giay;

    // Khóa ngoại thuộc tính mở rộng (Nullable trong DB)
    @ManyToOne
    @JoinColumn(name = "ThuocTinhKieuId")
    private ThuocTinhGiay kieu;

    @ManyToOne
    @JoinColumn(name = "ThuocTinhChatLieuId")
    private ThuocTinhGiay chatLieu;

    @ManyToOne
    @JoinColumn(name = "ThuocTinhDayId")
    private ThuocTinhGiay day;

    @ManyToOne
    @JoinColumn(name = "ThuocTinhCoId")
    private ThuocTinhGiay co;

    @ManyToOne
    @JoinColumn(name = "ThuocTinhDeId")
    private ThuocTinhGiay de;

    // Khóa ngoại bắt buộc: Màu sắc và Kích cỡ
    @ManyToOne
    @JoinColumn(name = "MauSacId", nullable = false)
    private MauSac mauSac;

    @ManyToOne
    @JoinColumn(name = "KichCoId", nullable = false)
    private KichCo kichCo;

    // -----------------------------------------------------------------
    // 2. THUỘC TÍNH CHI TIẾT
    // -----------------------------------------------------------------

    @Column(name = "MaBienThe")
    private String maBienThe;

    @Column(name = "SoLuong", nullable = false)
    private int soLuong;

    @Column(name = "GiaGoc", precision = 18, scale = 2)
    private BigDecimal giaGoc;

    @Column(name = "GiaBan", precision = 18, scale = 2)
    private BigDecimal giaBan;

    @Column(name = "SKU", unique = true)
    private String sku;

    @Column(name = "KichHoat")
    private Boolean kichHoat; // Sử dụng Boolean để ánh xạ kiểu BIT/DEFAULT 1

    @Column(name = "NgayTao", updatable = false)
    private LocalDateTime ngayTao;

    @Column(name = "NgayCapNhat")
    private LocalDateTime ngayCapNhat;

    // -----------------------------------------------------------------
    // Thêm các Annotation tự động (Tùy chọn)
    // -----------------------------------------------------------------

    @PrePersist // Tự động set NgayTao khi thêm mới
    protected void onCreate() {
        this.ngayTao = LocalDateTime.now();
        this.kichHoat = this.kichHoat != null ? this.kichHoat : true;
    }

    @PreUpdate // Tự động set NgayCapNhat khi cập nhật
    protected void onUpdate() {
        this.ngayCapNhat = LocalDateTime.now();
    }
}