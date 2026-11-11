with recursive category_tree as (
    select
        category_id,
        category_name,
        null::text as parent_category_name,
        category_name as root_category_name
    from {{ ref('stg_shop__product_categories') }}
    where parent_category_id is null

    union all

    select
        c.category_id,
        c.category_name,
        p.category_name as parent_category_name,
        p.root_category_name
    from {{ ref('stg_shop__product_categories') }} as c
    join category_tree as p
        on c.parent_category_id = p.category_id
)

select
    p.product_id,
    p.product_name,
    p.brand,
    p.category_name,
    c.parent_category_name,
    c.root_category_name
from {{ ref('stg_shop__products') }} as p
left join category_tree as c
    on p.category_name = c.category_name
