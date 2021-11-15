with customers as (

    select 
        *,
        row_number() over(partition by email order by created_timestamp desc) as customer_index

    from {{ ref('shopify__customers') }}

    where email is not null -- nonsensical to include any null emails in  this package

), aggregate_customers as (

    select
        lower(email) as email,
        source_relation,
        {{ fivetran_utils.string_agg("cast(customer_id as " ~ dbt_utils.type_string() ~ ")", "', '") }} as customer_ids,
        {{ fivetran_utils.string_agg("distinct cast(phone as " ~ dbt_utils.type_string() ~ ")", "', '") }} as phone_numbers,

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
        {{ fivetran_utils.max_bool("case when customer_index = 1 then is_tax_exempt else null end") }} as is_tax_exempt, -- since this changes every year
        {{ fivetran_utils.max_bool("is_verified_email") }} as is_verified_email,

        -- other stuff
        max(case when customer_index = 1 then default_address_id else null end) as default_address_id,
        max(case when customer_index = 1 then account_state else null end) as account_state

        -- ok let's get any custom passthrough columns! might want to put all max(Case when)'s in here....
        {% set cols = adapter.get_columns_in_relation(ref('shopify__customers')) %}
        {% set except_cols = ['_fivetran_synced', 'email', 'source_relation', 'customer_id', 'phone', 'first_name', 'last_name', 'created_timestamp', 'first_order_timestamp', 'most_recent_order_timestamp',
                                'updated_timestamp', 'lifetime_total_spent', 'lifetime_total_refunded', 'lifetime_total_amount', 'lifetime_count_orders', 'average_order_value', 'has_accepted_marketing',
                                'is_tax_exempt', 'is_verified_email', 'default_address_id', 'account_state'] %}
        {% for col in cols %}
            {% if col.column|lower not in except_cols %}
            , max(case when customer_index = 1 then {{ col.column }} else null end) as {{ col.column }}
            {% endif %}
        {% endfor %}

    from customers 

    group by 1,2

)

select *
from aggregate_customers