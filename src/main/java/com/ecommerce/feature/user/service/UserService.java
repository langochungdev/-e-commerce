package com.ecommerce.feature.user.service;
import com.ecommerce.feature.user.dto.UserDTO;
import java.util.UUID;

public interface UserService {
    UserDTO getUserById(UUID id);
}

