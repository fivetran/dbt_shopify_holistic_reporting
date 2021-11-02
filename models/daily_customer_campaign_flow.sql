{{ config(enabled=false) }}

with orders as (

    select *
    from {{ ref('orders_attribution') }}

), daily_klaviyo_events as (

    select *
    from {{ ref('int__daily_klaviyo_user_campaign_flow') }}

)


-- spine stuff ?

