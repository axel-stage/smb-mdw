select
    sku as product_id,
    name as product_name,
    lower(type) as product_type,
    description as product_description,
    cast(price * 0.01 as decimal(18, 2)) as product_price,
from {{ source('raw', 'products') }}
