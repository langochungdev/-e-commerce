package com.ecommerce.feature.user.service;

import com.ecommerce.feature.user.dto.UserDto;

import java.util.UUID;

public interface UserService {
    UserDto getUserById(UUID id);
}
