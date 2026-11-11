-- Задание 2. Staging позиций заказа: одна строка — один товар в заказе.
with source as (
    select * from {{ source('shop', 'order_items') }}
)

select
    -- Ключ позиции из номера заказа и товара.
    {{ dbt_utils.generate_surrogate_key(['order_id', 'product_id']) }} as order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,
    discount_amount,
    quantity * unit_price           as gross_amount,   -- сумма до скидки
    quantity * unit_price - discount_amount as line_amount     -- сумма после скидки
from source
