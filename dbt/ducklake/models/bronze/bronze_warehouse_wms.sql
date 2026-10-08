SELECT
    *,
    'Warehouse management system' AS _source_system,
    CURRENT_TIMESTAMP AS _loaded_at
FROM {{ source('source_data', 'warehouse_wms') }}
