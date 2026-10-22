SELECT
    *,
    'Seed' AS _source_system,
    CURRENT_TIMESTAMP AS _loaded_at
FROM {{ ref('marketing_channel') }}
