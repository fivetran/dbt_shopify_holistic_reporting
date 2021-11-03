with shopify_customers as (

    select *
    from {{ ref('shopify__customers') }}

), klaviyo_persons as (

    select *
    from {{ ref('klaviyo__persons') }}

), combine_customer_info as (

    select
        coalesce(shopify_customers.email, klaviyo_persons.email) as email,
        coalesce(klaviyo_persons.full_name, (shopify_customers.first_name || ' ' || shopify_customers.last_name)) as full_name,
        shopify_customers.customer_id as shopify_customer_id, -- do some case when's to determine where they came from / if they're in both ?
        klaviyo_persons.person_id as klaviyo_person_id,
        coalesce(shopify_customers.phone, klaviyo_persons.phone_number) as phone_number,
        shopify_customers.account_state as shopify_account_state,

        shopify_customers.created_timestamp as shopify_customer_created_at,
        klaviyo_persons.created_at as klaviyo_person_created_at,
        shopify_customers.updated_timestamp as shopify_customer_updated_at,
        klaviyo_persons.updated_at as klaviyo_person_updated_at,
        shopify_customers.is_verified_email as is_shopify_email_verified,

        {# shopify_customers.has_accepted_marketing, #}

        -- maybe rewrite this macro to be able to prefix with shopify_ and klaviyo_ ?
        {{ dbt_utils.star(from=ref('shopify__customers'), relation_alias='shopify_customers', except=['email', 'first_name', 'last_name', 'customer_id', 'phone', 
                                                                                            'account_state', 'created_timestamp', 'updated_timestamp', 'is_verified_email'] ) }},

        {{ dbt_utils.star(from=ref('klaviyo__persons'), relation_alias='klaviyo_persons', except=['email', 'full_name', 'created_at', 'person_id', 'phone_number', 'updated_at'] ) }}

    from shopify_customers
    full outer join klaviyo_persons 
        on lower(shopify_customers.email) = lower(klaviyo_persons.email)

{# ), surrogate_key as (
    select 
        *,
        {{ dbt_utils.surrogate_key(['shopify_customer_id','klaviyo_person_id']) }} as unique_customer_key

    from combine_customer_info #}

)
select *
from combine_customer_info