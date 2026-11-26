SELECT
    -1 AS warehouse_key,
    'unknown' AS warehouse_code,
    'unknown' AS warehouse_name,
    NULL AS city,
    NULL AS country_iso,
    NULL AS region,
    NULL AS opened_date,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
UNION ALL
SELECT
    {{ dbt_utils.generate_surrogate_key(['warehouse_code']) }} AS warehouse_key,
    warehouse_code,
    warehouse_name,
    city,
    country_iso,
    region,
    opened_date,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
FROM {{ ref('silver_warehouse') }}
