select
    customer_id,
    name

from {{ ref('bronze_customers') }}