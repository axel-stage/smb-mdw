WITH customer_crm AS (
    SELECT
        customer_id,
        TRIM(first_name) || ' ' || TRIM(last_name) AS customer_name,
        email,
        phone,
        city,
        CAST(CASE country
            WHEN 'USA' THEN 'US'
            WHEN 'UK' THEN 'GB'
            ELSE country
        END AS CHAR(2)) AS country_iso,
        tier,
        CAST(signup_date AS DATE) AS signup_date,
        _source_system
    FROM {{ ref('bronze_customer_crm') }}
),

customer_sap AS (
    SELECT
        customer_id,
        full_name,
        email_address AS email,
        phone_number AS phone,
        city,
        CAST(country AS CHAR(2)) AS country_iso,
        customer_tier AS tier,
        CAST(signup_date AS DATE) AS signup_date,
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
    CASE
        WHEN country_iso IN ('GB', 'DE', 'IT', 'FR') THEN 'EMEA'
        WHEN country_iso IN ('US') THEN 'AMER'
    END AS region,
    tier,
    signup_date,
    _source_system,
    CURRENT_TIMESTAMP AS _insert_at
FROM unioned
