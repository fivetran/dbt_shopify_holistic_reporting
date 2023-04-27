# dbt_shopify_holistic_reporting v0.3.1

## Bug Fixes:
PR #something includes the following changes:
- Adds flow, campaign, and variation to the join between shopify and klaviyo data in `shopify_holistic_reporting__daily_customer_metrics`. These fields are part of the grain of this model and could cause fanout if not included as arguments in the `full outer join`.

## Contributors
- [@jmussitsch](https://github.com/jmussitsch) ([#14](https://github.com/fivetran/dbt_shopify_holistic_reporting/issues/14))

# dbt_shopify_holistic_reporting v0.3.0

## 🚨 Breaking Changes 🚨:
[PR #11](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/11/) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- `dbt_utils.surrogate_key` has also been updated to `dbt_utils.generate_surrogate_key`. Since the method for creating surrogate keys differ, we suggest all users do a `full-refresh` for the most accurate data. For more information, please refer to dbt-utils [release notes](https://github.com/dbt-labs/dbt-utils/releases) for this update.
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

# dbt_shopify_holistic_reporting v0.2.0
## Bug Fixes
- Adjusts the incremental logic in the `shopify_holistic_reporting__orders_attribution` model. Previously, on incremental runs, this model transformed only newly-_created_ orders, comparing each order's `created_timestamp` to the `max(created_timestamp)` in the model. Now, the model will also transform newly-_updated_ orders and use `updated_timestamp` instead of `created_timestamp` to determine if an order should be included in an incremental run ([#9](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/9)).

This is a 🚨 Breaking Change 🚨 as **you will need to run a full refresh**.

## Under the Hood
- Ensures that the incremental strategy used by Postgres and Redshift adapters in the `shopify_holistic_reporting__orders_attribution` model is `delete+insert` ([#9](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/9)). Newer versions of dbt introduced an error message if the provided incremental strategy is not `append` or `delete+insert` for these adapters.

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
