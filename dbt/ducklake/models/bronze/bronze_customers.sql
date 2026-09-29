select
    id as customer_id,
    trim(name) as name
from {{ source('raw', 'customers') }}