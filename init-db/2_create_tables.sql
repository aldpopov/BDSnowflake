CREATE SCHEMA IF NOT EXISTS snowflake;

CREATE TABLE IF NOT EXISTS snowflake.dim_pet_category (
    pet_category_id SERIAL PRIMARY KEY,
    pet_category_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS snowflake.dim_product_category (
    product_category_id SERIAL PRIMARY KEY,
    product_category_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS snowflake.dim_customer (
    customer_id SERIAL PRIMARY KEY,
    original_id INTEGER,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INTEGER,
    email VARCHAR(200),
    country VARCHAR(100),
    postal_code VARCHAR(50),
    pet_type VARCHAR(50),
    pet_name VARCHAR(100),
    pet_breed VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS snowflake.dim_seller (
    seller_id SERIAL PRIMARY KEY,
    original_id INTEGER,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(200),
    country VARCHAR(100),
    postal_code VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS snowflake.dim_store (
    store_id SERIAL PRIMARY KEY,
    store_name VARCHAR(200),
    location VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    phone VARCHAR(50),
    email VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS snowflake.dim_supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(200),
    contact VARCHAR(200),
    email VARCHAR(200),
    phone VARCHAR(50),
    address TEXT,
    city VARCHAR(100),
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS snowflake.dim_product (
    product_id SERIAL PRIMARY KEY,
    original_id INTEGER,
    product_name VARCHAR(200),
    product_category_id INTEGER REFERENCES snowflake.dim_product_category(product_category_id),
    pet_category_id INTEGER REFERENCES snowflake.dim_pet_category(pet_category_id),
    price DECIMAL(10,2),
    quantity INTEGER,
    weight DECIMAL(10,2),
    color VARCHAR(50),
    size VARCHAR(50),
    brand VARCHAR(100),
    material VARCHAR(100),
    description TEXT,
    rating DECIMAL(3,2),
    reviews INTEGER,
    release_date DATE,
    expiry_date DATE,
    supplier_id INTEGER REFERENCES snowflake.dim_supplier(supplier_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS snowflake.fact_sales (
    sale_id SERIAL PRIMARY KEY,
    sale_date DATE,
    customer_id INTEGER REFERENCES snowflake.dim_customer(customer_id),
    seller_id INTEGER REFERENCES snowflake.dim_seller(seller_id),
    product_id INTEGER REFERENCES snowflake.dim_product(product_id),
    store_id INTEGER REFERENCES snowflake.dim_store(store_id),
    quantity INTEGER,
    total_price DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_fact_sales_date ON snowflake.fact_sales(sale_date);
CREATE INDEX idx_fact_sales_customer ON snowflake.fact_sales(customer_id);
CREATE INDEX idx_fact_sales_product ON snowflake.fact_sales(product_id);
CREATE INDEX idx_fact_sales_store ON snowflake.fact_sales(store_id);