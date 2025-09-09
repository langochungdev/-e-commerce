package com.ecommerce.feature.user.service.impl;

import com.ecommerce.feature.user.dto.UserDto;
import com.ecommerce.feature.user.entity.User;
import com.ecommerce.feature.user.mapper.UserMapper;
import com.ecommerce.feature.user.repository.UserRepository;
import com.ecommerce.feature.user.service.UserService;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    public UserServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDto getUserById(UUID id) {
        User user = userRepository.findByIdAndIsDeletedFalse(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return UserMapper.toDto(user);
    }
}
