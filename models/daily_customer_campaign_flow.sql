with shopify_daily as (

    select *
    from {{ ref('int__daily_shopify_customer_orders') }}

), klaviyo_daily as (

    select *
    from {{ ref('int__daily_klaviyo_user_campaign_flow') }}

), combine_histories as (

    select 
        coalesce(shopify_daily.date_day, klaviyo_daily.date_day) as date_day

        {# {{ dbt_utils.star()}} #}
    from shopify_daily
    full outer join klaviyo_daily
        on lower(shopify_daily.email) = lower(klaviyo_daily.email)
        and shopify_daily.date_day = klaviyo_daily.date_day
)

select *
from combine_histories