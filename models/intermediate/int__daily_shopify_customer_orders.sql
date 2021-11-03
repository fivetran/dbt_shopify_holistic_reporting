with orders as (

    select *
    from {{ ref('orders_attribution') }}

), order_metrics as (

    select
        cast( {{ dbt_utils.date_trunc('day', 'created_timestamp') }} as date) as date_day,
        email,
        last_touch_campaign_id,
        last_touch_flow_id,
        campaign_name,
        flow_name,
        variation_id,
        count(distinct order_id) as total_orders,
        sum(line_item_count) as count_line_items,
        sum(order_adjusted_total) as total_price

        -- make organic vs campaign vs flow

    from orders
    {{ dbt_utils.group_by(n=7)}}
)

select *
from order_metrics