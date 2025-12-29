#!/bin/bash

set -euo pipefail

apt-get update
apt-get install libsasl2-dev

python3 -m venv venv
. venv/bin/activate
pip install --upgrade pip setuptools
pip install -r integration_tests/requirements.txt
mkdir -p ~/.dbt
cp integration_tests/ci/sample.profiles.yml ~/.dbt/profiles.yml

db=$1
echo `pwd`
cd integration_tests
dbt deps
dbt seed --target "$db" --full-refresh
dbt source freshness --target "$db" || echo "...Only verifying freshness runs…"
dbt run --target "$db" --full-refresh
dbt run --target "$db"
dbt test --target "$db"
dbt run --vars '{shopify_timezone: "America/New_York", shopify__calendar_start_date: '2020-01-01', shopify_using_fulfillment_event: true, shopify_using_metafield: true, shopify_using_discount_code_app: true, shopify_using_product_variant_media: true}' --target "$db" --full-refresh
dbt run --vars '{shopify_timezone: "America/New_York", shopify__calendar_start_date: '2020-01-01', shopify_using_fulfillment_event: true, shopify_using_metafield: true, shopify_using_discount_code_app: true, shopify_using_product_variant_media: true}' --target "$db"
dbt run --vars '{shopify_api: "graphql", shopify_timezone: "America/New_York", shopify__calendar_start_date: '2020-01-01', shopify_gql_using_collection_rule: true, shopify_gql_using_fulfillment_event: true, shopify_gql_using_discount_code_app: true, shopify_gql_using_fulfillment_tracking_info: true, shopify_gql_using_product_variant_media: true}' --target "$db" --full-refresh
dbt run --vars '{shopify_api: "graphql", shopify_timezone: "America/New_York", shopify__calendar_start_date: '2020-01-01', shopify_gql_using_collection_rule: true, shopify_gql_using_fulfillment_event: true, shopify_gql_using_discount_code_app: true, shopify_gql_using_fulfillment_tracking_info: true, shopify_gql_using_product_variant_media: true}' --target "$db"
dbt test --target "$db"
dbt run-operation fivetran_utils.drop_schemas_automation --target "$db"
