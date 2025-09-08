CREATE TABLE app_users (
                           id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                           username NVARCHAR(50) UNIQUE NOT NULL,
                           email NVARCHAR(100) UNIQUE NOT NULL,
                           phone NVARCHAR(15) UNIQUE,
                           password NVARCHAR(MAX) NOT NULL,
                           full_name NVARCHAR(100),
                           dob DATE,
                           gender NVARCHAR(10),
                           avatar_url NVARCHAR(MAX),
                           created_at DATETIME DEFAULT GETDATE(),
                           updated_at DATETIME DEFAULT GETDATE(),
                           is_deleted BIT DEFAULT 0,
                           deleted_at DATETIME NULL
);

CREATE TABLE roles (
                       id INT IDENTITY(1,1) PRIMARY KEY,
                       name NVARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE user_roles (
                            id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                            user_id UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES app_users(id),
                            role_id INT NOT NULL FOREIGN KEY REFERENCES roles(id),
                            CONSTRAINT uq_user_roles UNIQUE (user_id, role_id)
);

CREATE TABLE devices (
                         id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                         user_id UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES app_users(id),
                         device_id NVARCHAR(255) NOT NULL,
                         device_name NVARCHAR(100) NOT NULL,
                         last_login DATETIME NOT NULL,
                         is_active BIT NOT NULL,
                         push_token NVARCHAR(255),
                         created_at DATETIME DEFAULT GETDATE(),
                         updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE addresses (
                           id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                           user_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES app_users(id),
                           receiver NVARCHAR(100) NOT NULL,
                           phone NVARCHAR(15) NOT NULL,
                           address NVARCHAR(MAX) NOT NULL,
                           ward NVARCHAR(100),
                           district NVARCHAR(100),
                           province NVARCHAR(100),
                           is_default BIT DEFAULT 0,
                           is_deleted BIT DEFAULT 0,
                           deleted_at DATETIME NULL,
                           created_at DATETIME DEFAULT GETDATE(),
                           updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE categories (
                            id INT IDENTITY(1,1) PRIMARY KEY,
                            name NVARCHAR(100) NOT NULL,
                            parent_id INT NULL FOREIGN KEY REFERENCES categories(id),
                            is_deleted BIT DEFAULT 0,
                            deleted_at DATETIME NULL,
                            created_at DATETIME DEFAULT GETDATE(),
                            updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE shops (
                       id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                       seller_id UNIQUEIDENTIFIER UNIQUE NOT NULL FOREIGN KEY REFERENCES app_users(id),
                       name NVARCHAR(150) NOT NULL,
                       description NVARCHAR(MAX),
                       logo_url NVARCHAR(MAX),
                       background_url NVARCHAR(MAX),
                       created_at DATETIME DEFAULT GETDATE(),
                       updated_at DATETIME DEFAULT GETDATE(),
                       is_deleted BIT DEFAULT 0,
                       deleted_at DATETIME NULL
);

CREATE TABLE shop_addresses (
                                id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                                shop_id UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES shops(id),
                                label NVARCHAR(100),
                                receiver NVARCHAR(100),
                                phone NVARCHAR(15),
                                address NVARCHAR(MAX) NOT NULL,
                                ward NVARCHAR(100),
                                district NVARCHAR(100),
                                province NVARCHAR(100),
                                is_default BIT DEFAULT 0,
                                created_at DATETIME DEFAULT GETDATE(),
                                updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE user_shop_follows (
                                   user_id UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES app_users(id),
                                   shop_id UNIQUEIDENTIFIER NOT NULL FOREIGN KEY REFERENCES shops(id),
                                   followed_at DATETIME DEFAULT GETDATE(),
                                   PRIMARY KEY (user_id, shop_id)
);

CREATE TABLE brands (
                        id INT IDENTITY(1,1) PRIMARY KEY,
                        name NVARCHAR(100) UNIQUE NOT NULL,
                        is_active BIT DEFAULT 0,
                        is_deleted BIT DEFAULT 0,
                        deleted_at DATETIME NULL,
                        created_at DATETIME DEFAULT GETDATE(),
                        updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE products (
                          id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                          shop_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES shops(id),
                          brand_id INT FOREIGN KEY REFERENCES brands(id),
                          category_id INT FOREIGN KEY REFERENCES categories(id),
                          name NVARCHAR(200) NOT NULL,
                          description NVARCHAR(MAX),
                          status NVARCHAR(20) DEFAULT 'ACTIVE',
                          created_at DATETIME DEFAULT GETDATE(),
                          updated_at DATETIME DEFAULT GETDATE(),
                          is_deleted BIT DEFAULT 0,
                          deleted_at DATETIME NULL
);

CREATE TABLE product_variants (
                                  id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                                  product_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES products(id),
                                  sku NVARCHAR(100) UNIQUE,
                                  price DECIMAL(15,2) NOT NULL,
                                  stock INT NOT NULL,
                                  created_at DATETIME DEFAULT GETDATE(),
                                  updated_at DATETIME DEFAULT GETDATE(),
                                  is_deleted BIT DEFAULT 0,
                                  deleted_at DATETIME NULL
);

CREATE TABLE attributes (
                            id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                            product_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES products(id),
                            name NVARCHAR(100) NOT NULL,
                            created_at DATETIME DEFAULT GETDATE(),
                            updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE product_attribute_values (
                                          id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                                          attribute_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES attributes(id),
                                          value NVARCHAR(100) NOT NULL,
                                          created_at DATETIME DEFAULT GETDATE(),
                                          updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE product_variant_attributes (
                                            variant_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES product_variants(id),
                                            attribute_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES attributes(id),
                                            value_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES product_attribute_values(id),
                                            PRIMARY KEY (variant_id, attribute_id)
);

CREATE TABLE product_media (
                               id INT IDENTITY(1,1) PRIMARY KEY,
                               product_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES products(id),
                               url NVARCHAR(MAX) NOT NULL,
                               media_type NVARCHAR(20) NOT NULL CHECK (media_type IN ('IMAGE','VIDEO')),
                               sort_order INT DEFAULT 0,
                               created_at DATETIME DEFAULT GETDATE(),
                               updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE product_reviews (
                                 id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                                 product_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES products(id),
                                 user_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES app_users(id),
                                 rating INT CHECK (rating >= 1 AND rating <= 5),
                                 comment NVARCHAR(MAX),
                                 created_at DATETIME DEFAULT GETDATE(),
                                 updated_at DATETIME DEFAULT GETDATE(),
                                 parent_id UNIQUEIDENTIFIER NULL FOREIGN KEY REFERENCES product_reviews(id),
                                 is_deleted BIT DEFAULT 0,
                                 deleted_at DATETIME NULL
);

CREATE TABLE product_review_reactions (
                                          user_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES app_users(id),
                                          review_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES product_reviews(id),
                                          reaction NVARCHAR(10) CHECK (reaction IN ('LIKE','DISLIKE')),
                                          created_at DATETIME DEFAULT GETDATE(),
                                          PRIMARY KEY (user_id, review_id)
);

CREATE TABLE review_media (
                              id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                              review_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES product_reviews(id),
                              url NVARCHAR(MAX) NOT NULL,
                              media_type NVARCHAR(20) NOT NULL CHECK (media_type IN ('IMAGE','VIDEO')),
                              sort_order INT DEFAULT 0,
                              created_at DATETIME DEFAULT GETDATE(),
                              updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE carts (
                       id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                       user_id UNIQUEIDENTIFIER UNIQUE FOREIGN KEY REFERENCES app_users(id),
                       created_at DATETIME DEFAULT GETDATE(),
                       updated_at DATETIME DEFAULT GETDATE(),
                       is_deleted BIT DEFAULT 0,
                       deleted_at DATETIME NULL
);

CREATE TABLE cart_items (
                            id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                            cart_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES carts(id),
                            product_variant_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES product_variants(id),
                            quantity INT NOT NULL CHECK (quantity > 0),
                            created_at DATETIME DEFAULT GETDATE(),
                            updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE wishlists (
                           user_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES app_users(id),
                           product_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES products(id),
                           is_deleted BIT DEFAULT 0,
                           deleted_at DATETIME NULL,
                           created_at DATETIME DEFAULT GETDATE(),
                           updated_at DATETIME DEFAULT GETDATE(),
                           PRIMARY KEY (user_id, product_id)
);

CREATE TABLE orders (
                        id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                        user_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES app_users(id),
                        total_price DECIMAL(15,2) NOT NULL,
                        status NVARCHAR(20) DEFAULT 'PENDING',
                        payment_method NVARCHAR(50),
                        shipping_address_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES addresses(id),
                        created_at DATETIME DEFAULT GETDATE(),
                        updated_at DATETIME DEFAULT GETDATE(),
                        is_deleted BIT DEFAULT 0,
                        deleted_at DATETIME NULL
);

CREATE TABLE order_items (
                             id UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
                             order_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES orders(id),
                             product_variant_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES product_variants(id),
                             price DECIMAL(15,2) NOT NULL,
                             quantity INT NOT NULL,
                             subtotal AS (price * quantity) PERSISTED,
                             created_at DATETIME DEFAULT GETDATE(),
                             updated_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE order_status_logs (
                                   id INT IDENTITY(1,1) PRIMARY KEY,
                                   order_id UNIQUEIDENTIFIER FOREIGN KEY REFERENCES orders(id),
                                   status NVARCHAR(20) NOT NULL,
                                   changed_at DATETIME DEFAULT GETDATE()
);

CREATE TABLE notifications (
                               id UNIQUEIDENTIFIER PRIMARY KEY,
                               user_id UNIQUEIDENTIFIER NOT NULL,
                               type NVARCHAR(50) NOT NULL,
                               message NVARCHAR(255) NOT NULL,
                               link NVARCHAR(255) NULL,
                               target_id UNIQUEIDENTIFIER NULL,
                               target_type NVARCHAR(20) NULL CHECK (target_type IN ('POST', 'COMMENT', 'USER', 'CHAT')),
                               is_read BIT NOT NULL DEFAULT 0,
                               created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
                               FOREIGN KEY (user_id) REFERENCES app_users(id)
);