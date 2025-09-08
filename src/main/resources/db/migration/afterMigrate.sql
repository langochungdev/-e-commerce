-- aftermigrate.sql

-- Insert roles if not exists
IF NOT EXISTS (SELECT 1 FROM roles WHERE name = N'user')
    INSERT INTO roles (name) VALUES (N'user');

IF NOT EXISTS (SELECT 1 FROM roles WHERE name = N'admin')
    INSERT INTO roles (name) VALUES (N'admin');

-- Insert users if not exists
IF NOT EXISTS (SELECT 1 FROM app_users WHERE username = N'user')
    INSERT INTO app_users (username, email, phone, password, full_name)
    VALUES (N'user', N'user@example.com', N'0123456789', N'$2a$12$kktHGK4Yhri7qcR9c2YGouBvBNztPu.1303pHiqLfXrFeOhFakBUm', N'User Role User');

IF NOT EXISTS (SELECT 1 FROM app_users WHERE username = N'admin')
    INSERT INTO app_users (username, email, phone, password, full_name)
    VALUES (N'admin', N'admin@example.com', N'0987654321', N'$2a$12$kktHGK4Yhri7qcR9c2YGouBvBNztPu.1303pHiqLfXrFeOhFakBUm', N'Admin Role Admin');

-- Assign roles to users if not exists
IF NOT EXISTS (
    SELECT 1 FROM user_roles ur
    JOIN app_users u ON ur.user_id = u.id
    JOIN roles r ON ur.role_id = r.id
    WHERE u.username = N'user' AND r.name = N'user'
)
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM app_users u
         JOIN roles r ON r.name = N'user'
WHERE u.username = N'user';

IF NOT EXISTS (
    SELECT 1 FROM user_roles ur
    JOIN app_users u ON ur.user_id = u.id
    JOIN roles r ON ur.role_id = r.id
    WHERE u.username = N'admin' AND r.name = N'admin'
)
INSERT INTO user_roles (user_id, role_id)
SELECT u.id, r.id
FROM app_users u
         JOIN roles r ON r.name = N'admin'
WHERE u.username = N'admin';
