package com.ecommerce.feature.user.mapper;

import com.ecommerce.feature.user.dto.UserDto;
import com.ecommerce.feature.user.entity.Role;
import com.ecommerce.feature.user.entity.User;
import com.ecommerce.feature.user.entity.UserRole;

import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

public class UserMapper {

    public static UserDto toDto(User user) {
        if (user == null) return null;

        return UserDto.builder()
                .id(user.getId())
                .username(user.getUsername())
                .email(user.getEmail())
                .phone(user.getPhone())
                .fullName(user.getFullName())
                .dob(user.getDob())
                .gender(user.getGender())
                .avatarUrl(user.getAvatarUrl())
                .roles(user.getUserRoles() != null
                        ? user.getUserRoles()
                        .stream()
                        .map(ur -> ur.getRole().getName())
                        .collect(Collectors.toSet())
                        : Set.of()
                )
                .build();
    }

    public static User toEntity(UserDto dto) {
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

        // Map roles nếu cần convert ngược lại
        if (dto.getRoles() != null && !dto.getRoles().isEmpty()) {
            Set<UserRole> userRoles = new HashSet<>();
            for (String roleName : dto.getRoles()) {
                Role role = new Role();
                role.setName(roleName);

                UserRole ur = new UserRole();
                ur.setUser(user);
                ur.setRole(role);

                userRoles.add(ur);
            }
            user.setUserRoles(userRoles);
        }

        return user;
    }
}
