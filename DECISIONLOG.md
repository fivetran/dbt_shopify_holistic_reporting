# Decision Log

In creating this package, which is meant for a wide range of use cases, we had to take opinionated stances on a few different questions we came across during development. We've consolidated significant choices we made here, and will continue to update as the package evolves.

You can also refer to the package-specific `DECISIONLOG`s:
- [Shopify-specific decisions](https://github.com/fivetran/dbt_shopify/blob/main/DECISIONLOG.md)
- [Klaviyo-specific decisions](https://github.com/fivetran/dbt_klaviyo/blob/main/DECISIONLOG.md)

## Using the Campaign and Flow IDs From the Klaviyo package's attribution model
We chose to build off of the layer of attribution occurring in the Klaviyo-only dbt package. This means that we refer to `last_touch_campaign_id` and `last_touch_flow_id` (a coalescing of the Klaviyo-provided `campaign_id`/`flow_id` and those attributed by the package itself) when attributing Shopify orders to Klaviyo campaigns and flows.

## Rolling up Customers and Persons
Theoretically, emails should be unique within `shopify.customers` and `klaviyo.person`. However, we have seen cases where this is not true, namely when a bot has created a bunch of accounts under the same email and/or name. Thus, because this package relies on email to join across platforms, we have rolled up these tables to the email-grain. We have also incorporated warnings on the `shopify__customers` and `klaviyo__persons` models so that you are notified if an email is not unique (and that you may have a bot problem!)

## Partitioning by source_relation in Window Functions
Window functions in `shopify_holistic_reporting__orders_attribution` partition by both `order_id` and `source_relation`. This prevents orders from different Shopify instances from being incorrectly grouped together when a multi-source union is configured, since `order_id` alone is not guaranteed to be unique across sources.

The one exception is `int__klaviyo_person_rollup`, where the deduplication window (`row_number() over (partition by email ...)`) intentionally omits `source_relation`. This makes emails globally unique across all Klaviyo sources, which is required for correct cross-platform joins in the final models. If we partitioned by `source_relation` here, the same email could produce multiple output rows — one per Klaviyo source — breaking the email-grain assumption downstream.

## Refund Dates
In the `daily_customer_customer_campaign_flow` model, refund metrics are tied to the day the order was placed, _not_ when it was refunded. More details can be found [here](https://github.com/fivetran/dbt_shopify/blob/main/DECISIONLOG.md#refundreturn-timestamp-mismatch).