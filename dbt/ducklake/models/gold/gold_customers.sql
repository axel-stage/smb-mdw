select
    customer_id,
    name

from {{ ref('silver_customers') }}