with ranked_orders as (
    select
        customer_id,
        order_id,
        ordered_at,
        order_amount,
        row_number() over (
            partition by customer_id
            order by ordered_at, order_id
        ) as order_number
    from {{ ref('int_orders_with_items') }}
    where is_confirmed
)

select
    c.customer_id,
    c.registered_at,
    c.registration_date,
    c.city,
    c.acquisition_channel,
    max(case when o.order_number = 1 then o.order_id end) as first_confirmed_order_id,
    max(case when o.order_number = 1 then o.ordered_at end) as first_confirmed_at,
    count(o.order_id) as confirmed_orders_count,
    coalesce(sum(o.order_amount), 0) as confirmed_revenue,
    count(o.order_id) > 0 as is_buyer
from {{ ref('stg_shop__customers') }} as c
left join ranked_orders as o
    on c.customer_id = o.customer_id
group by
    c.customer_id,
    c.registered_at,
    c.registration_date,
    c.city,
    c.acquisition_channel
