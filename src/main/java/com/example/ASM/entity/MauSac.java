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
@Table(name = "MauSac")
public class MauSac {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "Id")
    private int id;

    @Column(name = "Ma", unique = true)
    private String ma;

    @Column(name = "Ten")
    private String ten;

    @Column(name = "MaMauHex")
    private String maMauHex;

    @Column(name = "UrlHinhAnh")
    private String urlHinhAnh;

    // getters & setters
}

