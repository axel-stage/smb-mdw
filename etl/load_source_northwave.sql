INSTALL ducklake;

LOAD ducklake;

CREATE OR REPLACE SECRET minio_secret (
    type s3,
    key_id getenv('MINIO_ROOT_USER'),
    secret getenv('MINIO_ROOT_PASSWORD'),
    endpoint getenv('MINIO_ENDPOINT'),
    url_style path,
    use_ssl false
);

CREATE OR REPLACE SECRET postgres_secret (
    type postgres,
    host getenv('POSTGRES_HOST'),
    port getenv('POSTGRES_PORT'),
    database getenv('POSTGRES_DB'),
    user getenv('POSTGRES_USER'),
    password getenv('POSTGRES_PASSWORD')
);

CREATE OR REPLACE SECRET lakehouse_secret (
    TYPE ducklake,
    METADATA_PATH '',
    DATA_PATH 's3://smb-mdw/lakehouse/',
    METADATA_PARAMETERS MAP {
        'TYPE': 'postgres',
        'SECRET': 'postgres_secret',
        'SCHEMA': 'metadata'
    }
);

-- FROM duckdb_secrets();

ATTACH 'ducklake:lakehouse_secret' AS lakehouse;

USE lakehouse;

CREATE SCHEMA IF NOT EXISTS source_data;

CREATE OR REPLACE TABLE source_data.customer_crm AS
  SELECT
    *
  FROM read_csv(
    '../data/northwave/customers_crm.csv',
    header=true,
    encoding='utf-8',
    delim=',',
    quote='"',
    escape='"',
    nullstr=['NULL', 'NA', '-', ''],
    auto_detect=true
  );

CREATE OR REPLACE TABLE source_data.customer_sap AS
  SELECT
    *
  FROM read_csv(
    '../data/northwave/customers_sap.csv',
    header=true,
    encoding='utf-8',
    delim=',',
    quote='"',
    escape='"',
    nullstr=['NULL', 'NA', '-', ''],
    auto_detect=true
  );

CREATE OR REPLACE TABLE source_data.inventory_snapshot AS
  SELECT
    *
  FROM read_csv(
    '../data/northwave/inventory_snapshots.csv',
    header=true,
    encoding='utf-8',
    delim=',',
    quote='"',
    escape='"',
    nullstr=['NULL', 'NA', '-', ''],
    auto_detect=true
  );

CREATE OR REPLACE TABLE source_data.marketing_event AS
  SELECT
    *
  FROM read_csv(
    '../data/northwave/marketing_events.csv',
    header=true,
    encoding='utf-8',
    delim=',',
    quote='"',
    escape='"',
    nullstr=['NULL', 'NA', '-', ''],
    auto_detect=true
  );

CREATE OR REPLACE TABLE source_data.order AS
  SELECT
    *
  FROM read_csv(
    '../data/northwave/orders_ecommerce.csv',
    header=true,
    encoding='utf-8',
    delim=',',
    quote='"',
    escape='"',
    nullstr=['NULL', 'NA', '-', ''],
    auto_detect=true
  );

CREATE OR REPLACE TABLE source_data.product_ecommerce AS
  SELECT
    *
  FROM read_csv(
    '../data/northwave/products_ecommerce.csv',
    header=true,
    encoding='utf-8',
    delim=',',
    quote='"',
    escape='"',
    nullstr=['NULL', 'NA', '-', ''],
    auto_detect=true
  );

CREATE OR REPLACE TABLE source_data.product_sap AS
  SELECT
    *
  FROM read_csv(
    '../data/northwave/products_sap.csv',
    header=true,
    encoding='utf-8',
    delim=',',
    quote='"',
    escape='"',
    nullstr=['NULL', 'NA', '-', ''],
    auto_detect=true
  );

CREATE OR REPLACE TABLE source_data.warehouse AS
  SELECT
    *
  FROM read_csv(
    '../data/northwave/warehouses.csv',
    header=true,
    encoding='utf-8',
    delim=',',
    quote='"',
    escape='"',
    nullstr=['NULL', 'NA', '-', ''],
    auto_detect=true
  );

FROM (SHOW ALL TABLES)
    WHERE database = 'lakehouse';