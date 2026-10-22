select
    campaign_id::varchar as campaign_id,
    ANY_VALUE(campaign_name::varchar) as campaign_name,
    MIN(event_date::date) as start_date,
    MAX(event_date::date) as end_date,
    CURRENT_TIMESTAMP AS _insert_at
from {{ ref('bronze_marketing_event') }}
group by campaign_id
