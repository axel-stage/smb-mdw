uv run --env-file $PWD/.env duckdb

INSTALL ducklake;
INSTALL https;
INSTALL postgres;

LOAD ducklake;
LOAD httpfs;
LOAD postgres;

CREATE OR REPLACE SECRET minio_secret (
    type s3,
    key_id getenv('MINIO_ROOT_USER'),
    secret getenv('MINIO_ROOT_PASSWORD'),
    endpoint getenv('LOCAL_MINIO_ENDPOINT'),
    url_style path,
    use_ssl false
);

CREATE OR REPLACE SECRET postgres_secret (
    type postgres,
    host getenv('LOCAL_POSTGRES_HOST'),
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

FROM duckdb_secrets();

ATTACH 'ducklake:lakehouse_secret' AS lakehouse;

USE lakehouse;

CREATE OR REPLACE SCHEMA raw;

CREATE OR REPLACE TABLE raw.customers AS FROM read_csv('jaffle-data/raw_customers.csv');
CREATE OR REPLACE TABLE raw.items AS FROM read_csv('jaffle-data/raw_items.csv');
CREATE OR REPLACE TABLE raw.orders AS FROM read_csv('jaffle-data/raw_orders.csv');
CREATE OR REPLACE TABLE raw.products AS FROM read_csv('jaffle-data/raw_products.csv');
CREATE OR REPLACE TABLE raw.stores AS FROM read_csv('jaffle-data/raw_stores.csv');
CREATE OR REPLACE TABLE raw.supplies AS FROM read_csv('jaffle-data/raw_supplies.csv');
CREATE OR REPLACE TABLE raw.tweets AS FROM read_csv('jaffle-data/raw_tweets.csv');

FROM (SHOW ALL TABLES)
    WHERE database = 'lakehouse';