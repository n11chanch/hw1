with source_totals as (
    select
        count(*) as orders_count,
        coalesce(sum(o.total_amount), 0) as revenue
    from {{ source('shop', 'orders') }} as o
    where o.status = 'paid'
      and exists (
          select 1
          from {{ source('shop', 'payments') }} as p
          where p.order_id = o.order_id
            and p.payment_status = 'success'
            and p.amount >= 0
      )
),

mart_totals as (
    select
        count(*) as orders_count,
        coalesce(sum(order_amount), 0) as revenue
    from {{ ref('fct_orders') }}
    where is_confirmed
)

select
    s.orders_count as source_orders_count,
    m.orders_count as mart_orders_count,
    s.revenue as source_revenue,
    m.revenue as mart_revenue
from source_totals as s
cross join mart_totals as m
where s.orders_count <> m.orders_count
   or s.revenue <> m.revenue
