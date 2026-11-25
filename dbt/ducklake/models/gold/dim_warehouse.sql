SELECT
    {{ dbt_utils.generate_surrogate_key(['warehouse_code']) }} as warehouse_key,
    warehouse_code,
    warehouse_name,
    city,
    country_iso,
    region,
    opened_date,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
FROM {{ ref('silver_warehouse') }}
