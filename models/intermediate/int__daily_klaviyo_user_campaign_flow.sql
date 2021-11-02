with klaviyo_events as (

    select *
    from {{ ref('klaviyo__events') }}

), pivot_out_events as (
    
    select 
        cast( {{ dbt_utils.date_trunc('month', 'occurred_at') }} as date) as date_day
        person_email,
        person_id,
        last_touch_campaign_id,
        last_touch_flow_id,
        campaign_name,
        flow_name,
        variation_id,
        {# source_relation, #}
        min(occurred_at) as first_event_at,
        max(occurred_at) as last_event_at

    -- sum up the numeric value associated with events (most likely will mean revenue)
    {% for rm in var('klaviyo__sum_revenue_metrics') %}
    , sum(case when lower(type) = '{{ rm | lower }}' then numeric_value else 0 end) 
        as {{ 'sum_revenue_' ~ rm | replace(' ', '_') | replace('(', '') | replace(')', '') | lower }} -- removing special characters that I have seen in different integration events
    {% endfor %}

    -- count up the number of instances of each metric
    {% for cm in var('klaviyo__count_metrics') %}
    , sum(case when lower(type) = '{{ cm | lower }}' then 1 else 0 end) 
        as {{ 'count_' ~ cm | replace(' ', '_') | replace('(', '') | replace(')', '') | lower }} -- removing special characters that I have seen in different integration events
    {% endfor %}

    from events
    {{ dbt_utils.group_by(n=8) }}
)

select *
from pivot_out_events