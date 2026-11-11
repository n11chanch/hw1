with date_bounds as (
    select
        min(order_date)::timestamp as first_date,
        max(order_date)::timestamp as last_date
    from {{ ref('stg_shop__orders') }}
)

select
    d.date_day::date as date_day
from date_bounds as b
cross join lateral generate_series(
    b.first_date,
    b.last_date,
    interval '1 day'
) as d(date_day)
