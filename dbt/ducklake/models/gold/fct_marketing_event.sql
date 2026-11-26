SELECT
    -- foreign keys
    STRFTIME(sme.event_date, '%Y%m%d')::INTEGER AS event_date_key,
    COALESCE(dc.customer_key, -1) AS customer_key,
    COALESCE(dca.campaign_key, -1) AS campaign_key,
    COALESCE(dch.channel_key, -1) AS channel_key,
    -- degenerate dimension
    sme.event_id,
    -- factless measure
    1 AS event_count,
    -- audit
    CURRENT_TIMESTAMP AS _insert_at,
    'silver_marketing_event' AS _source_table
FROM {{ ref('silver_marketing_event') }} AS sme

-- SCD2 product lookup at snapshot_date
LEFT OUTER JOIN {{ ref('dim_customer') }} AS dc
    ON
        sme.customer_id = dc.customer_id
        AND sme.event_date BETWEEN dc.effective_from AND dc.effective_to

-- SCD1 campaign lookup
LEFT OUTER JOIN {{ ref('dim_campaign') }} AS dca
    ON sme.campaign_id = dca.campaign_id

-- SCD1 channel lookup
LEFT OUTER JOIN {{ ref('dim_channel') }} AS dch
    ON sme.channel = dca.channel_code
