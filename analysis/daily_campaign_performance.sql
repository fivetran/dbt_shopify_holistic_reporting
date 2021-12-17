select 
    coalesce(last_touch_campaign_id,last_touch_flow_id) as campaign_or_flow_id,
    coalesce(last_touch_campaign_name, last_touch_flow_name) as campaign_or_flow_name,
    shopify_source_relation,
    klaviyo_source_relation,
    date_trunc(created_timestamp, day) as order_created_date,
    count(order_id) as total_order_count,
    sum(order_adjusted_total) as total_order_value,
    avg(order_adjusted_total) as average_order_value,
    avg(line_item_count) as average_line_item_count,
    sum(case when new_vs_repeat = 'new' then 1 else 0 end) as total_new_customers,
    sum(case when new_vs_repeat = 'repeat' then 1 else 0 end) as total_repeat_customers
from {{ ref('shopify_holistic_reporting__orders_attribution') }}
where not is_test_order and coalesce(last_touch_campaign_id,last_touch_flow_id) is not null
group by 1, 2, 3, 4, 5
order by 1, 2