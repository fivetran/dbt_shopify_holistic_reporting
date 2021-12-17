with customer_view as (
    select 
        email,
        coalesce(shopify_customer_first_created_at, shopify_customer_first_created_at) as customer_created_at,
        coalesce(shopify_lifetime_total_spent, klaviyo_total_sum_revenue_ordered_product) as total_spend,
        coalesce(shopify_lifetime_total_refunded, klaviyo_total_sum_revenue_refunded_order) as total_refund_amount,
        coalesce(shopify_lifetime_count_orders, klaviyo_total_count_ordered_product) as total_order_count,
        (klaviyo_count_total_campaigns + klaviyo_count_total_flows) as campaign_and_flow_total_count,
        (nullif(klaviyo_total_count_clicked_email,0) / nullif(klaviyo_total_count_received_email,0)) as email_click_rate,
        (nullif(klaviyo_total_count_clicked_sms,0) / nullif(klaviyo_total_count_received_sms,0)) as sms_click_rate
    from {{ ref('shopify_holistic_reporting__customer_enhanced') }}
)
select
    email,
    customer_created_at,
    (total_spend - total_refund_amount) as estimated_total_revenue,
    total_spend,
    total_refund_amount,
    total_order_count,
    campaign_and_flow_total_count,
    email_click_rate,
    sms_click_rate
from customer_view
order by 3 desc