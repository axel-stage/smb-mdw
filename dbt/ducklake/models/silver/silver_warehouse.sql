SELECT
    warehouse_code::CHAR(5) AS warehouse_code,
    warehouse_name::VARCHAR AS warehouse_name,
    city::VARCHAR AS city,
    region::VARCHAR AS region,
    opened_date::DATE AS opened_date,
    _source_system,
    (CASE country
        WHEN 'Italy' THEN 'IT'
        WHEN 'Germany' THEN 'DE'
        WHEN 'USA' THEN 'US'
    END)::CHAR(2) AS country_iso,
    CURRENT_TIMESTAMP AS _insert_at
FROM {{ ref('bronze_warehouse_wms') }}
