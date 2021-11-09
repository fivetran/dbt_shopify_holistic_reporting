with shopify_customers as (

    select *
    from {{ ref('int__shopify_customer_rollup') }}

), klaviyo_persons as (

    select *
    from {{ ref('klaviyo__persons') }}

), combine_customer_info as (

    select
        coalesce(shopify_customers.email, klaviyo_persons.email) as email,
        coalesce(klaviyo_persons.full_name, shopify_customers.full_name) as full_name,
        shopify_customers.customer_ids as shopify_customer_ids, -- do some case when's to determine where they came from / if they're in both ?
        klaviyo_persons.person_id as klaviyo_person_id,
        coalesce(shopify_customers.phone_numbers, cast(klaviyo_persons.phone_number as {{ dbt_utils.type_string() }})) as phone_number,
        shopify_customers.first_shopify_account_made_at as shopify_customer_first_created_at,
        shopify_customers.last_shopify_account_made_at as shopify_customer_last_created_at,
        klaviyo_persons.created_at as klaviyo_person_created_at,
        shopify_customers.last_updated_at as shopify_customer_last_updated_at,
        klaviyo_persons.updated_at as klaviyo_person_updated_at,
        shopify_customers.is_verified_email as is_shopify_email_verified,

        -- maybe rewrite this macro to be able to prefix with shopify_ and klaviyo_ ?
        {{ dbt_utils.star(from=ref('int__shopify_customer_rollup'), relation_alias='shopify_customers', prefix='shopify_',
                                except=['email', 'full_name', 'customer_ids', 'phone_numbers', 'first_shopify_account_made_at','last_shopify_account_made_at', 
                                        'last_updated_at', 'is_verified_email'] ) 
        }},

        {{ dbt_utils.star(from=ref('klaviyo__persons'), relation_alias='klaviyo_persons', prefix='klaviyo_',
                                except=['email', 'full_name', 'created_at', 'person_id', 'phone_number', 'updated_at'] ) 
        }}

    from shopify_customers
    full outer join klaviyo_persons 
        on lower(shopify_customers.email) = lower(klaviyo_persons.email)

)

select *
from combine_customer_info