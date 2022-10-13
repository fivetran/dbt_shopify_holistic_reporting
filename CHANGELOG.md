# dbt_shopify_holistic_reporting v0.2.0
## Bug Fixes
- Adjusts the incremental logic in the `shopify_holistic_reporting__orders_attribution` model. Previously, on incremental runs, this model transformed only newly-_created_ orders, comparing each order's `created_timestamp` to the `max(created_timestamp)` in the model. Now, the model will also transform newly-_updated_ orders and use `updated_timestamp` instead of `created_timestamp` to determine if an order should be included in an incremental run ([#9](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/9)).

This is a 🚨 Breaking Change 🚨 as **you will need to run a full refresh**.

## Under the Hood
- Ensures that the incremental strategy used by postgres adapters in the `shopify_holistic_reporting__orders_attribution` model is `delete+insert` ([#9](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/9)). Newer versions of dbt-postgres introduced an error message if the provided incremental strategy is not `append` or `delete+insert`.

# dbt_shopify_holistic_reporting v0.1.1
## Bug Fixes
Incorporate the try_cast macro from fivetran_utils to ensure that the numeric_value field in int__daily_klaviyo_user_metrics is the same data type as '0'. ([#6](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/6))

## Contributors
- [@MisterClean](https://github.com/MisterClean) ([#6](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/6))


# dbt_shopify_holistic_reporting v0.1.0

The original release! This package currently models Shopify and Klaviyo data to achieve the following:
- Tie e-commerce revenue to your email and SMS marketing via last-touch attribution.
- Consolidate customers, their information, and activity across platforms.
- Create a rich portrait of customer personas based on how customers are engaging with and responding to specific marketing efforts.

This package works off of dependencies on Fivetran's individual [Shopify](https://github.com/fivetran/dbt_shopify) and [Klaviyo](https://github.com/fivetran/dbt_klaviyo) dbt packages.
