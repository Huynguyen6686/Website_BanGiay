package com.example.ASM.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.Set;
import java.util.UUID;
@Builder
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "Role")
public class Role {
    @Id
    @GeneratedValue
    @Column(name = "Id", columnDefinition = "UNIQUEIDENTIFIER")
    private UUID id;

    @Column(name = "Ten", nullable = false, unique = true)
    private String ten;

    @OneToMany(mappedBy = "role", fetch = FetchType.LAZY)
    private Set<NhanVien> nhanViens;

    // getters & setters
}


