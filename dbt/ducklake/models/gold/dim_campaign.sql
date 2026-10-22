select
    {{ dbt_utils.generate_surrogate_key(['campaign_id']) }} as campaign_key,
    campaign_id,
    campaign_name,
    start_date,
    end_date,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
from {{ ref('silver_campaign') }}
