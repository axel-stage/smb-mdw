SELECT
    *,
    'SAP platform' AS _source_system,
    CURRENT_TIMESTAMP AS _loaded_at
FROM {{ source('source_data', 'product_sap') }}
