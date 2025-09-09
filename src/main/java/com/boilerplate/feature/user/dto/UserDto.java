package com.boilerplate.feature.user.dto;

import lombok.*;

import java.time.LocalDate;
import java.util.Set;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDto {
    private UUID id;
    private String username;
    private String email;
    private String phone;
    private String fullName;
    private LocalDate dob;
    private String gender;
    private String avatarUrl;
    private Set<String> roles;   // chỉ expose tên role
}
