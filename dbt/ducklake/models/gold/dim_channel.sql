select
    {{ dbt_utils.generate_surrogate_key(['channel_code']) }} as channel_key,
    channel_code,
    channel_name,
    channel_type,
    channel_description,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
from {{ ref('silver_marketing_channel') }}
