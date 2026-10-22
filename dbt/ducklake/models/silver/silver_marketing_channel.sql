select
    channel_code::varchar as channel_code,
    channel_name::varchar as channel_name,
    channel_type::varchar as channel_type,
    channel_description::varchar as channel_description,
    _source_system::varchar as _source_system,
    CURRENT_TIMESTAMP AS _insert_at
from {{ ref('bronze_marketing_channel') }}
