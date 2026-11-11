{{ config(distributed_replicated=true) }}

select
    date_day,
    extract(year from date_day)::integer as year_number,
    extract(quarter from date_day)::integer as quarter_number,
    extract(month from date_day)::integer as month_number,
    extract(isodow from date_day)::integer as day_of_week,
    extract(isodow from date_day) in (6, 7) as is_weekend
from {{ ref('int_dates') }}
