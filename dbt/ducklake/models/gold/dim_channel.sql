SELECT
    -1 AS channel_key,
    'unknown' AS channel_code,
    'unknown' AS channel_name,
    NULL AS channel_type,
    NULL AS channel_description,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
UNION ALL
SELECT
    {{ dbt_utils.generate_surrogate_key(['channel_code']) }} AS channel_key,
    channel_code,
    channel_name,
    channel_type,
    channel_description,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
FROM {{ ref('silver_marketing_channel') }}
