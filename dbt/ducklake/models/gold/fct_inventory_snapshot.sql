SELECT
    -- foreign keys
    STRFTIME(sis.snapshot_date, '%Y%m%d')::INTEGER AS snapshot_date_key,
    COALESCE(dp.product_key, -1) AS product_key,
    COALESCE(dp.warehouse_key, -1) AS warehouse_key,
    -- measures
    sis.units_on_hand,
    sis.units_reserved,
    (sis.units_on_hand - sis.units_reserved) AS units_available,
    sis.units_sold_that_day,
    -- audit
    CURRENT_TIMESTAMP AS _insert_at,
    'silver_inventory_snapshot' AS _source_table
FROM {{ ref('silver_inventory_snapshot') }} AS sis

-- SCD2 product lookup at snapshot_date
LEFT OUTER JOIN {{ ref('dim_product') }} AS dp
    ON
        sis.product_id = dp.product_id
        AND sis.snapshot_date BETWEEN dp.effective_from AND dp.effective_to

-- SCD1 warehouse lookup
LEFT OUTER JOIN {{ ref('dim_warehouse') }} AS dw
    ON sis.warehouse_code = dw.warehouse_code
