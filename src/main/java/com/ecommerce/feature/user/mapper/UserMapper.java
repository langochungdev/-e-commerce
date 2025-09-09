package com.ecommerce.feature.user.mapper;
import com.ecommerce.feature.user.dto.UserDTO;
import com.ecommerce.feature.user.entity.User;

import java.util.List;
import java.util.stream.Collectors;

public class UserMapper {

    public static UserDTO toDTO(User user) {
        if (user == null) return null;

        return UserDTO.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .phone(user.getPhone())
                .fullName(user.getFullName())
                .dob(user.getDob())
                .gender(user.getGender())
                .avatarUrl(user.getAvatarUrl())
                .createdAt(user.getCreatedAt())
                .updatedAt(user.getUpdatedAt())
                .build();
    }

    public static User toEntity(UserDTO dto) {
        if (dto == null) return null;

        User user = new User();
        user.setId(dto.getId());
        user.setUsername(dto.getUsername());
        user.setEmail(dto.getEmail());
        user.setPhone(dto.getPhone());
        user.setFullName(dto.getFullName());
        user.setDob(dto.getDob());
        user.setGender(dto.getGender());
        user.setAvatarUrl(dto.getAvatarUrl());
        user.setCreatedAt(dto.getCreatedAt());
        user.setUpdatedAt(dto.getUpdatedAt());
        return user;
    }

    public static List<UserDTO> toDTOList(List<User> users) {
        if (users == null) return null;
        return users.stream().map(UserMapper::toDTO).collect(Collectors.toList());
    }

    public static List<User> toEntityList(List<UserDTO> dtos) {
        if (dtos == null) return null;
        return dtos.stream().map(UserMapper::toEntity).collect(Collectors.toList());
    }
}
