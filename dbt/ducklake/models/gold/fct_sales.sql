SELECT
    -- degenerate dimension
    so.order_number,
    so.line_number,
    -- foreign key
    COALESCE(dc.customer_key, '-1') AS customer_key,
    COALESCE(dp.product_key, '-1') AS product_key,
    COALESCE(dw.warehouse_key, '-1') AS warehouse_key,
    COALESCE(dch.channel_key, '-1') AS channel_key,
    CAST(STRFTIME(so.order_date, '%Y%m%d') AS INT) AS order_date_key,
    CAST(STRFTIME(so.ship_date, '%Y%m%d') AS INT) AS ship_date_key,
    -- degenerate dimension
    so.payment_method,
    so.is_gift,
    so.is_promo,
    so.is_guest_checkout,
    -- measure
    so.quantity,
    so.unit_price AS unit_price_eur,
    CAST(so.quantity * so.unit_price AS DECIMAL(14, 2)) AS gross_revenue_eur,
    so.discount_amount AS discount_amount_eur,
    CAST(so.quantity * so.unit_price - so.discount_amount AS DECIMAL(14, 2))
        AS net_revenue_eur,
    sp.unit_cost AS unit_cost_at_sale_eur,
    CAST(so.quantity * sp.unit_cost AS DECIMAL(14, 2)) AS cogs_eur,
    CAST(
        so.quantity * so.unit_price - so.discount_amount
        - so.quantity * sp.unit_cost AS DECIMAL(14, 2)
    ) AS gross_margin_eur,

    -- audit
    CURRENT_TIMESTAMP AS _insert_at,
    'silver_order' AS _source_table

FROM {{ ref('silver_order') }} AS so

-- SCD2 customer lookup at order_date
LEFT OUTER JOIN {{ ref('dim_customer') }} AS dc
    ON
        so.customer_id = dc.customer_id
        AND so._source_system = dc._source_system
        AND so.order_date BETWEEN dc.effective_from AND dc.effective_to

-- SCD2 product lookup at order_date
LEFT OUTER JOIN {{ ref('dim_product') }} AS dp
    ON
        so.product_id = dp.product_id
        AND so.order_date BETWEEN dp.effective_from AND dp.effective_to

-- SCD1 warehouse lookup
LEFT OUTER JOIN {{ ref('dim_warehouse') }} AS dw
    ON so.fulfilling_warehouse_code = dw.warehouse_code

-- SCD1 channel lookup
LEFT OUTER JOIN {{ ref('dim_channel') }} AS dch
    ON so.channel = dch.channel_code

-- enrichment for cost stamping at load time
LEFT OUTER JOIN {{ ref('silver_product') }} AS sp
    ON so.product_id = sp.product_id
