INSERT INTO snowflake.dim_pet_category (pet_category_name)
SELECT DISTINCT pet_category 
FROM raw_mock_data 
WHERE pet_category IS NOT NULL
ON CONFLICT (pet_category_name) DO NOTHING;

INSERT INTO snowflake.dim_product_category (product_category_name)
SELECT DISTINCT product_category 
FROM raw_mock_data 
WHERE product_category IS NOT NULL
ON CONFLICT (product_category_name) DO NOTHING;

INSERT INTO snowflake.dim_supplier (supplier_name, contact, email, phone, address, city, country)
SELECT DISTINCT 
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM raw_mock_data
WHERE supplier_name IS NOT NULL
ON CONFLICT (supplier_name) DO NOTHING;

INSERT INTO snowflake.dim_store (store_name, location, city, state, country, phone, email)
SELECT DISTINCT 
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM raw_mock_data
WHERE store_name IS NOT NULL
ON CONFLICT (store_name) DO NOTHING;

INSERT INTO snowflake.dim_customer (
    original_id, first_name, last_name, age, email, 
    country, postal_code, pet_type, pet_name, pet_breed
)
SELECT DISTINCT 
    id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
FROM raw_mock_data
ON CONFLICT (email) DO NOTHING;

INSERT INTO snowflake.dim_seller (
    original_id, first_name, last_name, email, country, postal_code
)
SELECT DISTINCT 
    sale_seller_id,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM raw_mock_data
ON CONFLICT (email) DO NOTHING;

INSERT INTO snowflake.dim_product (
    original_id, product_name, product_category_id, pet_category_id,
    price, quantity, weight, color, size, brand, material,
    description, rating, reviews, release_date, expiry_date, supplier_id
)
SELECT DISTINCT
    rmd.sale_product_id,
    rmd.product_name,
    pc.product_category_id,
    pc2.pet_category_id,
    rmd.product_price,
    rmd.product_quantity,
    rmd.product_weight,
    rmd.product_color,
    rmd.product_size,
    rmd.product_brand,
    rmd.product_material,
    rmd.product_description,
    rmd.product_rating,
    rmd.product_reviews,
    rmd.product_release_date,
    rmd.product_expiry_date,
    s.supplier_id
FROM raw_mock_data rmd
LEFT JOIN snowflake.dim_product_category pc ON pc.product_category_name = rmd.product_category
LEFT JOIN snowflake.dim_pet_category pc2 ON pc2.pet_category_name = rmd.pet_category
LEFT JOIN snowflake.dim_supplier s ON s.supplier_name = rmd.supplier_name
WHERE rmd.product_name IS NOT NULL;

INSERT INTO snowflake.fact_sales (
    sale_date, customer_id, seller_id, product_id, store_id, quantity, total_price
)
SELECT DISTINCT
    rmd.sale_date,
    c.customer_id,
    s.seller_id,
    p.product_id,
    st.store_id,
    rmd.sale_quantity,
    rmd.sale_total_price
FROM raw_mock_data rmd
LEFT JOIN snowflake.dim_customer c ON c.email = rmd.customer_email
LEFT JOIN snowflake.dim_seller s ON s.email = rmd.seller_email
LEFT JOIN snowflake.dim_product p ON p.original_id = rmd.sale_product_id
LEFT JOIN snowflake.dim_store st ON st.store_name = rmd.store_name
WHERE rmd.sale_date IS NOT NULL;

CREATE OR REPLACE VIEW snowflake.v_sales_analytics AS
SELECT 
    fs.sale_id,
    fs.sale_date,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.country AS customer_country,
    s.first_name || ' ' || s.last_name AS seller_name,
    p.product_name,
    pc.product_category_name,
    pc2.pet_category_name,
    p.price,
    p.brand,
    st.store_name,
    st.city AS store_city,
    st.country AS store_country,
    fs.quantity,
    fs.total_price
FROM snowflake.fact_sales fs
LEFT JOIN snowflake.dim_customer c ON c.customer_id = fs.customer_id
LEFT JOIN snowflake.dim_seller s ON s.seller_id = fs.seller_id
LEFT JOIN snowflake.dim_product p ON p.product_id = fs.product_id
LEFT JOIN snowflake.dim_product_category pc ON pc.product_category_id = p.product_category_id
LEFT JOIN snowflake.dim_pet_category pc2 ON pc2.pet_category_id = p.pet_category_id
LEFT JOIN snowflake.dim_store st ON st.store_id = fs.store_id;