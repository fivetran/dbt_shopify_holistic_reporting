with shopify_customers as (

    select *
    from {{ ref('shopify__customer_emails') }}

), klaviyo_persons as (

    select *
    from {{ ref('int__klaviyo_person_rollup') }}

), combine_customer_info as (

    select
        coalesce(shopify_customers.email, klaviyo_persons.email) as email,
        coalesce(klaviyo_persons.full_name, shopify_customers.first_name || ' ' || shopify_customers.last_name) as full_name,
        shopify_customers.customer_ids as shopify_customer_ids,
        klaviyo_persons.person_ids as klaviyo_person_ids,
        coalesce(shopify_customers.phone_numbers, klaviyo_persons.phone_numbers) as phone_number,
        shopify_customers.first_account_created_at as shopify_customer_first_created_at,
        shopify_customers.last_account_created_at as shopify_customer_last_created_at,
        klaviyo_persons.first_klaviyo_account_made_at as klaviyo_person_first_created_at,
        klaviyo_persons.last_klaviyo_account_made_at as klaviyo_person_last_created_at,
        shopify_customers.updated_timestamp as shopify_customer_last_updated_at,
        klaviyo_persons.last_updated_at as klaviyo_person_last_updated_at,
        shopify_customers.is_verified_email as is_shopify_email_verified,
        shopify_customers.first_order_timestamp as first_order_at,
        shopify_customers.most_recent_order_timestamp as last_order_at,

        {{ dbt_utils.star(from=ref('shopify__customer_emails'), relation_alias='shopify_customers', prefix='shopify_', quote_identifiers=false,
                                except=['source_relation', 'email', 'full_name', 'customer_ids', 'phone_numbers', 'first_account_created_at','last_account_created_at', 
                                        'updated_timestamp', 'is_verified_email'] ) 
        }},
        shopify_customers.source_relation as shopify_source_relation,

        {{ dbt_utils.star(from=ref('int__klaviyo_person_rollup'), relation_alias='klaviyo_persons', prefix='klaviyo_', quote_identifiers=false,
                                except=['source_relation', 'email', 'full_name', 'first_klaviyo_account_made_at', 'last_klaviyo_account_made_at', 'person_ids', 'phone_numbers', 'last_updated_at'] ) 
        }}
        klaviyo_persons.source_relation as klaviyo_source_relation

    from shopify_customers
    full outer join klaviyo_persons 
        on shopify_customers.email = lower(klaviyo_persons.email) -- redshift doesn't like doing 2 lowers here. we lowercase shopify.email in an intermediate model

)

select *
from combine_customer_info