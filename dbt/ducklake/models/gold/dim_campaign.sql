SELECT
    -1                 AS campaign_key,
    'unknown'          AS campaign_id,
    'unknown'          AS campaign_name,
    NULL               AS start_date,
    NULL               AS end_date,
    CURRENT_TIMESTAMP  AS _insert_at,
    CURRENT_TIMESTAMP  AS _update_at
UNION ALL
SELECT
    {{ dbt_utils.generate_surrogate_key(['campaign_id']) }} AS campaign_key,
    campaign_id,
    campaign_name,
    start_date,
    end_date,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
FROM {{ ref('silver_campaign') }}
