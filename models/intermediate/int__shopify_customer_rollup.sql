with customers as (

    select *
    from {{ ref('shopify__customers') }}

    where email is not null

), aggregate_customers as (

    select
        email,
        {{ fivetran_utils.string_agg("cast(customer_id as " ~ dbt_utils.type_string() ~ ")", "', '") }} as customer_ids,
        {{ fivetran_utils.string_agg("distinct phone", "', '") }} as phone_numbers,

        max(first_name || ' ' || last_name) as full_name, -- or should this just be the latest? or string agg of names?

        min(created_timestamp) as first_shopify_account_made_at,
        max(created_timestamp) as last_shopify_account_made_at,
        min(first_order_timestamp) as first_order_at,
        max(most_recent_order_timestamp) as last_order_at,
        max(updated_timestamp) as last_updated_at,

        -- sum across accounts
        sum(lifetime_total_spent) as lifetime_total_spent,
        sum(lifetime_total_refunded) as lifetime_total_refunded,
        sum(lifetime_total_amount) as lifetime_total_amount,
        sum(lifetime_count_orders) as lifetime_count_orders,
        case 
            when sum(lifetime_count_orders) = 0 then 0
            else sum(lifetime_total_spent) / sum(lifetime_count_orders) end as average_order_value,

        -- take true if ever given for boolean fields
        {{ fivetran_utils.max_bool("has_accepted_marketing") }} as has_accepted_marketing,
        {{ fivetran_utils.max_bool("is_tax_exempt") }} as is_tax_exempt,
        {{ fivetran_utils.max_bool("is_verified_email") }} as is_verified_email

        {# -- meh? can maybe use window functons to take the latest of these? or agg them?
        default_address_id,
        account_state? -- either enabled, disabled, or invited? can be different

        -- passthrough columns? #}
    from customers 

    group by 1
)

select *
from aggregate_customers