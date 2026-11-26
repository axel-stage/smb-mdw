SELECT
    channel_code::VARCHAR AS channel_code,
    channel_name::VARCHAR AS channel_name,
    channel_type::VARCHAR AS channel_type,
    channel_description::VARCHAR AS channel_description,
    _source_system::VARCHAR AS _source_system,
    CURRENT_TIMESTAMP AS _insert_at
FROM {{ ref('bronze_marketing_channel') }}
