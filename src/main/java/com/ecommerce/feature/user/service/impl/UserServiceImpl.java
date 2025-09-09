package com.ecommerce.feature.user.service.impl;

import com.ecommerce.feature.user.dto.UserDTO;
import com.ecommerce.feature.user.entity.User;
import com.ecommerce.feature.user.mapper.UserMapper;
import com.ecommerce.feature.user.repository.UserRepository;
import com.ecommerce.feature.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.UUID;

@Service
@Transactional
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {
    private final UserRepository userRepository;

    @Override
    public UserDTO getUserById(UUID id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return UserMapper.toDTO(user);
    }


}
