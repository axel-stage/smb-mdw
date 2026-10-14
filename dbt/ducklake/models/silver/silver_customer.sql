WITH customer_crm AS (
    SELECT
        customer_id,
        TRIM(first_name) || ' ' || TRIM(last_name) AS customer_name,
        email::VARCHAR AS email,
        phone::VARCHAR AS phone,
        city::VARCHAR AS city,
        (CASE country
            WHEN 'USA' THEN 'US'
            WHEN 'UK' THEN 'GB'
            ELSE country
        END)::CHAR(2) AS country_iso,
        tier::VARCHAR AS tier,
        signup_date::DATE AS signup_date,
        _source_system
    FROM {{ ref('bronze_customer_crm') }}
),

customer_sap AS (
    SELECT
        customer_id::VARCHAR AS customer_name,
        full_name::VARCHAR AS full_name,
        email_address::VARCHAR AS email,
        phone_number::VARCHAR AS phone,
        city::VARCHAR AS city,
        country::CHAR(2) AS country_iso,
        customer_tier AS tier,
        signup_date::DATE AS signup_date,
        _source_system
    FROM {{ ref('bronze_customer_sap') }}
),

unioned AS (
    SELECT * FROM customer_crm
    UNION ALL
    SELECT * FROM customer_sap
)

SELECT
    customer_id,
    customer_name,
    email,
    phone,
    city,
    country_iso,
    tier,
    signup_date,
    _source_system,
    CASE
        WHEN country_iso IN ('GB', 'DE', 'IT', 'FR') THEN 'EMEA'
        WHEN country_iso IN ('US') THEN 'AMER'
    END AS region,
    CURRENT_TIMESTAMP AS _insert_at
FROM unioned
