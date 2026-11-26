SELECT
    campaign_id::VARCHAR AS campaign_id,
    ANY_VALUE(campaign_name::VARCHAR) AS campaign_name,
    MIN(event_date::DATE) AS start_date,
    MAX(event_date::DATE) AS end_date,
    CURRENT_TIMESTAMP AS _insert_at
FROM {{ ref('bronze_marketing_event') }}
GROUP BY campaign_id
