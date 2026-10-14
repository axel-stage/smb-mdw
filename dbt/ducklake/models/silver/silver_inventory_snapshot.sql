SELECT
    snapshot_date::DATE AS snapshot_date,
    warehouse_code::CHAR(5) AS warehouse_code,
    product_id::CHAR(12) AS product_id,
    units_on_hand::INTEGER AS units_on_hand,
    units_reserved::INTEGER AS units_reserved,
    units_sold_that_day::INTEGER AS units_sold_that_day,
    _source_system,
    CURRENT_TIMESTAMP AS _insert_at
FROM {{ ref('bronze_inventory_snapshot_wms') }}
