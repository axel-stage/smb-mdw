SELECT
    eco.product_id,
    sap.sap_product_id,
    eco.product_name,
    eco.subcategory,
    eco.category,
    eco.department,
    eco.brand,
    eco.color,
    eco.size,
    eco.unit_price::DECIMAL(10, 2) AS unit_price,
    sap.unit_cost::DECIMAL(10, 2) AS unit_cost,
    eco.launch_date::DATE AS launch_date,
    eco.product_status,
    sap.supplier,
    CURRENT_TIMESTAMP AS _insert_at
FROM {{ ref('bronze_product_ecommerce') }} AS eco
LEFT JOIN {{ ref('bronze_product_sap') }} AS sap
    ON eco.product_name = sap.product_name
