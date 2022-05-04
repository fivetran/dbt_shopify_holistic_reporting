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
