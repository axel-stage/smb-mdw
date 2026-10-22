with calendar_days as (
    select
        day::date as full_date
    from generate_series(
        '2018-01-01'::date,
        '2030-12-31'::date,
        INTERVAL 1 DAY
    ) as t(day)
) select
    STRFTIME(full_date, '%Y%m%d')::integer as date_key,
    full_date,
    EXTRACT(YEAR FROM full_date) as year,
    EXTRACT(QUARTER FROM full_date) as quarter,
    EXTRACT(MONTH FROM full_date) as month,
    STRFTIME(full_date, '%B') as month_name,
    EXTRACT(WEEK FROM full_date) as week,
    EXTRACT(DAY FROM full_date) as day,
    EXTRACT(ISODOW FROM full_date) as day_of_week,
    STRFTIME(full_date, '%A') as day_name,
    EXTRACT(ISODOW FROM full_date) IN (6,7) as is_weekend,
    CAST(STRFTIME(full_date - INTERVAL 1 YEAR, '%Y%m%d') AS INTEGER) AS prior_year_date_key,
    CURRENT_TIMESTAMP AS _insert_at,
    CURRENT_TIMESTAMP AS _update_at
from calendar_days
