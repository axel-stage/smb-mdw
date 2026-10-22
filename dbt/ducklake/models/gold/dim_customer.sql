SELECT
    -1 AS customer_key_1,
    -1 AS customer_key_2,
    'unknown' as customer_id,
    'unknown' as source_system,
    'unknown' as customer_name,
    NULL      as email,
    NULL      as city,
    NULL      as country_iso,
    NULL      as region,
    NULL      as tier,
    NULL      as signup_date,
    '1900-01-01'::date AS effective_from,
    '9999-12-31'::date AS effective_to,
    TRUE AS is_current,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
UNION ALL
select
    {{ dbt_utils.generate_surrogate_key(['_source_system', 'customer_id']) }} AS customer_key_1,
    ROW_NUMBER() OVER (ORDER BY _source_system, customer_id) AS customer_key_2,
    customer_id,
    _source_system,
    customer_name
    email,
    phone,
    city,
    country_iso,
    region,
    tier,
    signup_date,
    '1900-01-01'::date AS effective_from,
    '9999-12-31'::date AS effective_to,
    true AS is_current,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
from {{ ref('silver_customer') }}

