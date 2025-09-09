package com.boilerplate.feature.user.service;

import com.boilerplate.feature.user.dto.UserDto;

import java.util.UUID;

public interface UserService {
    UserDto getUserById(UUID id);
}
