-- TODO: make this incremental!
with orders as (

    select *
    from {{ ref('shopify__orders') }}

), events as (

    select 
        *
    from {{ ref('klaviyo__events') }}

    where 
        coalesce(last_touch_campaign_id, last_touch_flow_id) is not null
    {% if var('klaviyo__eligible_attribution_events') != [] %}
        and lower(type) in {{ "('" ~ (var('klaviyo__eligible_attribution_events') | join("', '")) ~ "')" }}
    {% endif %}

), join_orders_w_events as (

    select 
        orders.*,
        events.last_touch_campaign_id,
        events.last_touch_flow_id,

        -- should i prepend the below with last_touch_ or klaviyo_?
        events.variation_id,
        events.campaign_name,
        events.campaign_subject_line,
        events.flow_name,
        events.campaign_type,
        events.event_id,
        events.occurred_at as event_occurred_at,
        events.type as event_type,
        events.integration_name,
        events.integration_category

    from orders 
    left join events on 
        lower(orders.email) = lower(events.person_email)
        and {{ dbt_utils.datediff('events.occurred_at', 'orders.created_timestamp', 'hour') }} <= (
            case when events.type like '%sms%' then {{ var('klaviyo__sms_attribution_lookback') }}
            else {{ var('klaviyo__email_attribution_lookback') }} end)
        and orders.created_timestamp > events.occurred_at

), order_events as (

    select
        *,
        row_number() over (partition by order_id order by event_occurred_at desc) as event_index,

        -- the order was made after X interactions with campaign/flow
        count(event_id) over (partition by order_id, last_touch_campaign_id) as count_interactions_with_campaign,
        count(event_id) over (partition by order_id, last_touch_flow_id) as count_interactions_with_flow


    from join_orders_w_events

), last_touches as (

    select 
        {{ dbt_utils.star(from=ref('shopify__orders')) }},
        last_touch_campaign_id is not null or last_touch_flow_id is not null as is_attributed,
        last_touch_campaign_id,
        last_touch_flow_id,
        variation_id,
        campaign_name,
        campaign_subject_line,
        campaign_type,
        flow_name,
        case when last_touch_campaign_id is not null then count_interactions_with_campaign else null end as count_interactions_with_campaign, -- will be null if it's associated with a flow
        count_interactions_with_flow, -- will be null if it's associated with a campaign
        event_id,
        event_occurred_at,
        event_type,
        integration_name,
        integration_category

    from order_events
    where event_index = 1
)

select *
from last_touches