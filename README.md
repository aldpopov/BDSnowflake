# Лабораторная работа №1: Нормализация данных в модель "Снежинка"
## Выполнил студент группы М8О-308Б-23 Попов Александр

## Структура проекта

```
LW_1/
├── docker-compose.yml
├── README.md
├── init-db/
│   ├── 1_import_data.sql
│   ├── 2_create_tables.sql
│   ├── 3_fill_tables.sql
└── data/
    ├── MOCK_DATA (1).csv
    ├── MOCK_DATA (2).csv
    ├── ...
    ├── MOCK_DATA (9).csv
    └── MOCK_DATA.csv
```

## Модель данных "Снежинка"

### Таблица фактов (Fact Table)
- **fact_sales** - факты продаж
  - `sale_id` - идентификатор продажи
  - `sale_date` - дата продажи
  - `customer_id` - внешний ключ к dim_customer
  - `seller_id` - внешний ключ к dim_seller
  - `product_id` - внешний ключ к dim_product
  - `store_id` - внешний ключ к dim_store
  - `quantity` - количество товара
  - `total_price` - общая стоимость

### Таблицы измерений (Dimension Tables)
1. **dim_customer** - покупатели
2. **dim_seller** - продавцы
3. **dim_product** - товары
4. **dim_store** - магазины
5. **dim_supplier** - поставщики
6. **dim_product_category** - категории товаров (нормализовано)
7. **dim_pet_category** - категории питомцев (нормализовано)

## Требования к системе

- Docker и Docker Compose

## Инструкция по запуску

### 1. Клонирование репозитория

```bash
git clone https://github.com/aldpopov/BDSnowflake.git
```

### 2. Запуск через Docker Compose

```bash
docker-compose up -d
```

### 3. Проверка статуса контейнера

```bash
docker ps
```

### 4. Подключение к базе данных

```bash
docker exec -it snowflake_postgres psql -U admin -d snowflake_db
```

## Выводы

В ходе лабораторной работы была успешно реализована модель данных "Снежинка".
