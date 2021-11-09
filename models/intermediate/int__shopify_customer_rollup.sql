with customers as (

    select 
        *,
        row_number() over(partition by email order by created_timestamp desc) as customer_index

    from {{ ref('shopify__customers') }}

    where email is not null -- nonsensical to include any null emails in  this package

), aggregate_customers as (

    select
        email,
        source_relation,
        {{ fivetran_utils.string_agg("cast(customer_id as " ~ dbt_utils.type_string() ~ ")", "', '") }} as customer_ids,
        {{ fivetran_utils.string_agg("distinct phone", "', '") }} as phone_numbers,

        max(case when customer_index = 1 then first_name || ' ' || last_name else null end) as full_name,

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
        max(case when customer_index = 1 then is_tax_exempt else null end) as is_tax_exempt, -- since this changes every yeat
        {{ fivetran_utils.max_bool("is_verified_email") }} as is_verified_email,

        -- other stuff
        max(case when customer_index = 1 then default_address_id else null end) as default_address_id,
        max(case when customer_index = 1 then account_state else null end) as account_state

        -- passthrough columns?? maybe do max case when -> figure out if we wanna keep this first

    from customers 

    group by 1,2

)

select *
from aggregate_customers