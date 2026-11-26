sqlfluff lint .



# bronze layer
##############

# lint
sqlfluff lint dbt/ducklake/models/bronze/bronze_customer_crm.sql --dialect duckdb

sqlfluff lint dbt/ducklake/models/bronze --dialect duckdb
sqlfluff lint dbt/ducklake/models/silver --dialect duckdb
sqlfluff lint dbt/ducklake/models/gold --dialect duckdb

# fix
sqlfluff fix dbt/ducklake/models/bronze/bronze_customer_crm.sql --dialect duckdb
sqlfluff fix dbt/ducklake/models/silver/silver_order.sql --dialect duckdb

sqlfluff fix dbt/ducklake/models/bronze --dialect duckdb
sqlfluff fix dbt/ducklake/models/silver --dialect duckdb
sqlfluff fix dbt/ducklake/models/gold --dialect duckdb
