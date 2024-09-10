# dbt_shopify_holistic_reporting v0.7.0

[PR #26](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/26) includes the following changes:

## Upstream Klaviyo Breaking Changes (Full refresh required after upgrading)
- Upstream incremental models within the dbt_klaviyo package running on BigQuery have had the `partition_by` logic removed from incremental models running on BigQuery. This change affects only BigQuery warehouses and resolves the `too many partitions` error that some users encountered. The partitioning was also deemed unnecessary for the mentioned models and their downstream references, offering no performance benefit. By removing it, we eliminate both the error risk and an unneeded configuration. Refer to the [v0.8.0 dbt_klaviyo release notes](https://github.com/fivetran/dbt_klaviyo/releases/tag/v0.7.2) for more details. This change applies to the following models:
  - `int_klaviyo__event_attribution`
  - `klaviyo__events`

## Under the Hood
- Added consistency and integrity validation tests for the following models:
  - `shopify_holistic_reporting__customer_enhanced`
  - `shopify_holistic_reporting__daily_customer_metrics`
  - `shopify_holistic_reporting__orders_attribution`
- Cleaned up unnecessary variable configuration within the `integration_tests/dbt_project.yml` file.

# dbt_shopify_holistic_reporting v0.6.0
[PR #21](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/21) includes the following changes:

## Dependency Updates
Updates the underlying Shopify package version range from [">=0.10.0", "<0.11.0"] to [">=0.11.0", "<0.14.0"] to account for breaking changes introduced to the Shopify package up to v0.14.0. This wider range will accommodate previous versions while support an upcoming release to Shopify, which will not have breaking changes for this package.
   - Additionally, please note that the wider range for the Shopify dbt package also updates the underlying Shopify Source dependency range from versions [">=0.10.0", "<0.11.0"] to  [">=0.11.0", "<0.13.0"].
  
## Under The Hood
- Included auto-releaser GitHub Actions workflow to automate future releases.
   
# dbt_shopify_holistic_reporting v0.5.0
[PR #18](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/18) includes the following changes:

## 🚨 Breaking Changes 🚨:

- This package now points to the following ranges of the upstream packages. We recommend a `dbt run --full-refresh` to capture all the latest data within incremental models.

```
- package: fivetran/shopify
  version: [">=0.10.0", "<0.11.0"]
- package: fivetran/klaviyo
  version: [">=0.7.0", "<0.8.0"]
```

For more information on the changes in the underlying upstream pacakges, refer to the changelogs for [Shopify](https://github.com/fivetran/dbt_shopify/compare/v0.8.1...v0.10.0) and [Klaviyo](https://github.com/fivetran/dbt_klaviyo/compare/v0.5.0...v0.7.1). 

## Additions
- Adds field `last_touch_integration_id` to `shopify_holistic_reporting__orders_attribution`

## Under the Hood:
- Replace seed files with the new ones from the respective upstream packages.
- Renamed all Klaviyo seed files so that they start with prefix `klaviyo` in order to differentiate which seed files come from Shopify versus Klaviyo.
- Removed the flow_snowflake seed file now that `trigger` has been removed from the Klaviyo flow object and as such will not cause run errors in Snowflake.
- Populate the order_line_refund seed file as it was empty previously.
 
# dbt_shopify_holistic_reporting v0.4.0

[PR #16](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/16) includes the following changes:

## 🚨 Breaking Changes 🚨:
- The package now points [to v0.8.1 of the `shopify` package](https://github.com/fivetran/dbt_shopify/releases/tag/v0.8.1). 
  - See Shopify's [CHANGELOG](https://github.com/fivetran/dbt_shopify/blob/main/CHANGELOG.md) notes for details, as many fields, tables, and features were introduced (or deprecated) in [v0.8.0](https://github.com/fivetran/dbt_shopify/blob/main/CHANGELOG.md#dbt_shopify-v080) of Shopify.

## Bug Fixes:
- Adds flow, campaign, and variation to the join between shopify and klaviyo data in `shopify_holistic_reporting__daily_customer_metrics`. These fields are part of the grain of this model and could cause fanout if not included as arguments in the `full outer join`.

## Under the Hood:
- [Updates our README](https://github.com/fivetran/dbt_shopify/blob/main/README.md) for easier navigation and consistency with other packages.
- Incorporates the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([#15](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/15))
- Updates the pull request [templates](/.github). ([#15](https://github.com/fivetran/dbt_shopify_holistic_reporting/pull/15))

## Contributors
- [@jmussitsch](https://github.com/jmussitsch) ([#14](https://github.com/fivetran/dbt_shopify_holistic_reporting/issues/14))

## Related-Package Releases
- [dbt_shopify v0.8.0](https://github.com/fivetran/dbt_shopify/releases/tag/v0.8.0)
- [dbt_shopify v0.8.1](https://github.com/fivetran/dbt_shopify/releases/tag/v0.8.1)

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
