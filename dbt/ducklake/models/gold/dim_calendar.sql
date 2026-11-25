WITH calendar_days AS (
    SELECT day::DATE AS full_date
    FROM GENERATE_SERIES(
        '2018-01-01'::DATE,
        '2030-12-31'::DATE,
        INTERVAL 1 DAY
    ) AS t (day)
)

SELECT
    full_date,
    STRFTIME(full_date, '%Y%m%d')::INTEGER AS date_key,
    EXTRACT(YEAR FROM full_date) AS year,
    EXTRACT(QUARTER FROM full_date) AS quarter,
    EXTRACT(MONTH FROM full_date) AS month,
    STRFTIME(full_date, '%B') AS month_name,
    EXTRACT(WEEK FROM full_date) AS week,
    EXTRACT(DAY FROM full_date) AS day,
    EXTRACT(ISODOW FROM full_date) AS day_of_week,
    STRFTIME(full_date, '%A') AS day_name,
    EXTRACT(ISODOW FROM full_date) IN (6, 7) AS is_weekend,
    (STRFTIME(full_date - INTERVAL 1 YEAR, '%Y%m%d'))::INTEGER
        AS prior_year_date_key,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
FROM calendar_days
