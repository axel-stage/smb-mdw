SELECT
    event_id::CHAR(15) AS event_id,
    campaign_id::VARCHAR AS campaign_id,
    campaign_name::VARCHAR AS campaign_name,
    customer_id::VARCHAR AS customer_id,
    channel::VARCHAR AS channel,
    event_date::DATE AS event_date,
    _source_system,
    (CASE customer_country
        WHEN 'USA' THEN 'US'
        WHEN 'UK' THEN 'GB'
        ELSE customer_country
    END)::CHAR(2) AS customer_country_iso,
    CURRENT_TIMESTAMP AS _insert_at
FROM {{ ref('bronze_marketing_event') }}
