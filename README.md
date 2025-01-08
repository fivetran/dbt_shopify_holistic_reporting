<p align="center">
    <a alt="License"
        href="https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0_<2.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
</p>

# Shopify Holistic Reporting dbt Package ([Docs](https://fivetran.github.io/dbt_shopify_holistic_reporting/))

## What does this dbt package do?
This package builds off of the [Shopify dbt package](https://github.com/fivetran/dbt_shopify) to weave together your Shopify e-commerce data with insights from marketing connections. Currently, this package supports combining Shopify with email and SMS marketing data from Fivetran's [Klaviyo dbt package](https://github.com/fivetran/dbt_klaviyo).
> Wanna see Shopify combined with another connector? Please make create a [Feature Request](https://github.com/fivetran/dbt_shopify_holistic_reporting/issues/new?assignees=&labels=enhancement&template=feature-request.yml&title=%5BFeature%5D+%3Ctitle%3E).

This dbt package enables you to:
- Tie e-commerce revenue to your email and SMS marketing via last-touch attribution.
- Consolidate customers, their information, and activity across platforms.
- Create a rich portrait of customer personas based on how customers are engaging with and responding to specific marketing efforts.

Check out our [blog post](https://www.fivetran.com/blog/gain-faster-insights-from-shopify-and-klaviyo-data) for further discussion on how the package can accelerate your business analysis.

<!--section="shopify_holistic_reporting_transformation_model"-->
The following table provides a detailed list of all tables materialized within this package (see [Shopify](https://github.com/fivetran/dbt_shopify#-what-does-this-dbt-package-do) and [Klaviyo](https://github.com/fivetran/dbt_klaviyo#-what-does-this-dbt-package-do) for the upstream tables these are built off of).
> TIP: See more details about these tables in the package's [dbt docs site](https://fivetran.github.io/dbt_shopify/#!/overview/shopify_holistic_reporting).

| **Table**                | **Description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [shopify_holistic_reporting__orders_attribution](https://fivetran.github.io/dbt_shopify_holistic_reporting/#!/model/model.shopify_holistic_reporting.shopify_holistic_reporting__orders_attribution)             | Each record represents a unique Shopify order, enhanced with a customizable last-touch attribution model associating orders with Klaviyo flows and campaigns that customers interacted with. Includes dimensions like whether it is a new or repeat purchase in Shopify. See available customizations [here](https://github.com/fivetran/dbt_klaviyo#attribution-lookback-window). Materialized incrementally by default. |
| [shopify_holistic_reporting__daily_customer_metrics](https://fivetran.github.io/dbt_shopify_holistic_reporting/#!/model/model.shopify_holistic_reporting.shopify_holistic_reporting__daily_customer_metrics)             | Each record represent a unique customer's daily activity attributed to a campaign or flow in Klaviyo. The grain is set at the customer-day-flow/campaign level. This table is enriched with both Shopify and Klaviyo metrics, such as the net revenue, taxes paid, discounts applied, and the counts of each type of interaction between the user and the campaign/flow. |
| [shopify_holistic_reporting__customer_enhanced](https://fivetran.github.io/dbt_shopify_holistic_reporting/#!/model/model.shopify_holistic_reporting.shopify_holistic_reporting__customer_enhanced)             | Each record represents a unique individual (based on email) that may exist in Shopify, Klaviyo, or both platforms. Enhanced with information coalesced across platforms, lifetime order metrics, and all-time interactions with email marketing campaigns and flows. |
### Materialized Models
Each Quickstart transformation job run materializes 6 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
<!--section-end-->


## How do I use the dbt package?

### Step 1: Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Shopify connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **Databricks**, or **PostgreSQL** destination.

### Step 2: Install the package
Include the following shopify_holistic_reporting package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yml
packages:
  - package: fivetran/shopify_holistic_reporting
    version: [">=0.7.0", "<0.8.0"] # we recommend using ranges to capture non-breaking changes automatically
```

Do **NOT** include the `shopify`, `shopify_source`, `klaviyo`, or `klaviyo_source` packages in this file. The combo package itself has a dependency on these and will install the transformation and source packages as well.

#### Databricks dispatch configuration
If you are using a Databricks destination with this package, you must add the following (or a variation of the following) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Step 3: Define database and schema variables
#### Single Shopify and/or Klaviyo connector
By default, this package runs using your target destination and the `shopify` and `klaviyo` schemas. If this is not where your Shopify and Klaviyo source data is, respectively (for example, they might be `shopify_fivetran` and `klaviyo_fivetran`), add the following configuration to your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
    klaviyo_database: your_database_name
    klaviyo_schema: your_schema_name 
    shopify_database: your_database_name
    shopify_schema: your_schema_name
```
#### Union multiple Shopify and/or Klaviyo connections
If you have multiple Shopify and/or Klaviyo connections in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either the `shopify_union_schemas`/`klaviyo_union_schemas` OR `shopify_union_databases`/`klaviyo_union_databases` variables (cannot do both) in your root `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
    shopify_union_schemas: ['shopify_usa','shopify_canada'] # use this if the data is in different schemas/datasets of the same database/project
    shopify_union_databases: ['shopify_usa','shopify_canada'] # use this if the data is in different databases/projects but uses the same schema name

    klaviyo_union_schemas: ['klaviyo_usa','klaviyo_canada'] # use this if the data is in different schemas/datasets of the same database/project
    klaviyo_union_databases: ['klaviyo_usa','klaviyo_canada'] # use this if the data is in different databases/projects but uses the same schema name
```

### Step 4: Set Shopify- and Klaviyo-specific configurations
See connector-specific configurations in their individual dbt package READMEs:
- [Shopify](https://github.com/fivetran/dbt_shopify)
- [Klaviyo](https://github.com/fivetran/dbt_klaviyo)

### (Optional) Step 5: Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Changing the Build Schema

By default, this package will build the final models within a schema titled (`<target_schema>` + `_shopify_holistic`) and intermediate models in (`<target_schema>` + `_int_shopify_holistic`) in your target database. If this is not where you would like your modeled Shopify Holistic Reporting data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

models:
  shopify_holistic_reporting:
    +schema: my_new_schema_name # leave blank for just the target_schema
    intermediate:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

> Note that if your profile does not have permissions to create schemas in your warehouse, you can set each `+schema` to blank. The package will then write all tables to your pre-existing target schema.

Models from the individual [Shopify](https://github.com/fivetran/dbt_shopify/#changing-the-build-schema) and [Klaviyo](https://github.com/fivetran/dbt_klaviyo/#changing-the-build-schema) packages will be written their respective schemas.
</details>

### (Optional) Step 6: Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>
    
Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt#setupguide).
</details>


## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/shopify
      version: [">=0.11.0", "<0.14.0"]

    - package: fivetran/shopify_source
      version: [">=0.11.0", "<0.13.0"]

    - package: fivetran/klaviyo
      version: [">=0.8.0", "<0.9.0"]

    - package: fivetran/klaviyo_source
      version: [">=0.7.0", "<0.8.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

## How is this package maintained and can I contribute?
### Package Maintenance
The Fivetran team maintaining this package _only_ maintains the latest version of the package. We highly recommend you stay consistent with the [latest version](https://hub.getdbt.com/fivetran/shopify_holistic_reporting/latest/) of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

The Fivetran team also maintains the upstream [Klaviyo](https://hub.getdbt.com/fivetran/klaviyo/latest/) and [Shopify](https://hub.getdbt.com/fivetran/shopify/latest/) packages on which the Shopify Holistic Reporting package is built off of. Refer to the [Klaviyo](https://github.com/fivetran/dbt_klaviyo/blob/main/CHANGELOG.md) and [Shopify](https://github.com/fivetran/dbt_shopify/blob/main/CHANGELOG.md) CHANGELOGs and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Check out [this dbt Discourse article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Are there any resources available?
- If you would like a deeper explanation of the logic used by default in the dbt package you may reference the [DECISIONLOG](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main//DECISIONLOG.md).
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_shopify/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).