<!--section="shopify-holistic-reporting_transformation_model"-->
# Shopify Holistic Reporting dbt Package

<p align="left">
    <a alt="License"
        href="https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/LICENSE">
        <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" /></a>
    <a alt="dbt-core">
        <img src="https://img.shields.io/badge/dbt_Core™_version->=1.3.0,_<3.0.0-orange.svg" /></a>
    <a alt="Maintained?">
        <img src="https://img.shields.io/badge/Maintained%3F-yes-green.svg" /></a>
    <a alt="PRs">
        <img src="https://img.shields.io/badge/Contributions-welcome-blueviolet" /></a>
    <a alt="Fivetran Quickstart Compatible"
        href="https://fivetran.com/docs/transformations/data-models/quickstart-management#quickstartmanagement">
        <img src="https://img.shields.io/badge/Fivetran_Quickstart_Compatible%3F-yes-green.svg" /></a>
</p>

This dbt package transforms data from Fivetran's Shopify Holistic Reporting connector into analytics-ready tables.

## Resources

- Number of materialized models¹: 113
- Connector documentation
  - [Shopify Holistic Reporting connector documentation](https://fivetran.com/docs/connectors/applications/shopify-holistic-reporting)
  - [Shopify Holistic Reporting ERD](https://fivetran.com/docs/connectors/applications/shopify-holistic-reporting#schemainformation)
- dbt package documentation
  - [GitHub repository](https://github.com/fivetran/dbt_shopify_holistic_reporting)
  - [dbt Docs](https://fivetran.github.io/dbt_shopify_holistic_reporting/#!/overview)
  - [DAG](https://fivetran.github.io/dbt_shopify_holistic_reporting/#!/overview?g_v=1)
  - [Changelog](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/CHANGELOG.md)

## What does this dbt package do?
This package enables you to tie e-commerce revenue to your email and SMS marketing via last-touch attribution, consolidate customers and their activity across platforms, and create rich customer personas based on marketing engagement. It creates enriched models with metrics focused on order attribution, daily customer activity, and enhanced customer profiles.

> Wanna see Shopify combined with another connector? Please make create a [Feature Request](https://github.com/fivetran/dbt_shopify_holistic_reporting/issues/new?assignees=&labels=enhancement&template=feature-request.yml&title=%5BFeature%5D+%3Ctitle%3E).

Check out our [blog post](https://www.fivetran.com/blog/gain-faster-insights-from-shopify-and-klaviyo-data) for further discussion on how the package can accelerate your business analysis.

### Output schema
Final output tables are generated in the following target schema:

```
<your_database>.<connector/schema_name>_shopify_holistic_reporting
```

### Final output tables

By default, this package materializes the following final tables:

| Table | Description |
| :---- | :---- |
| [shopify_holistic_reporting__orders_attribution](https://fivetran.github.io/dbt_shopify_holistic_reporting/#!/model/model.shopify_holistic_reporting.shopify_holistic_reporting__orders_attribution) | Connects Shopify orders to the Klaviyo email campaigns and flows that influenced purchases using a customizable last-touch attribution model (see [attribution lookback window options](https://github.com/fivetran/dbt_klaviyo#attribution-lookback-window)) to measure marketing effectiveness and understand which emails drive revenue for new versus repeat customers. <br></br>**Example Analytics Questions:**<ul><li>Which Klaviyo campaigns or flows generate the most attributed revenue?</li><li>What is the conversion rate from email interactions to completed purchases?</li><li>How do new customer orders compare to repeat purchases in terms of revenue attribution?</li></ul>|
| [shopify_holistic_reporting__daily_customer_metrics](https://fivetran.github.io/dbt_shopify_holistic_reporting/#!/model/model.shopify_holistic_reporting.shopify_holistic_reporting__daily_customer_metrics) | Tracks daily customer engagement with Klaviyo email campaigns alongside their Shopify purchase behavior including revenue, taxes, discounts, and interaction counts to connect marketing touches with revenue outcomes at the customer level. <br></br>**Example Analytics Questions:**<ul><li>How much daily net revenue is driven by each campaign or flow?</li><li>Which customers generate the highest revenue and have the most email interactions?</li><li>What is the average discount rate and order value for customers engaged with specific campaigns?</li></ul>|
| [shopify_holistic_reporting__customer_enhanced](https://fivetran.github.io/dbt_shopify_holistic_reporting/#!/model/model.shopify_holistic_reporting.shopify_holistic_reporting__customer_enhanced) | Unifies customer profiles across Shopify and Klaviyo to provide a complete view of purchase history, lifetime order metrics, and all-time email campaign engagement for every customer based on email address. <br></br>**Example Analytics Questions:**<ul><li>What is the lifetime value and total order count for each customer across platforms?</li><li>Which customers are most engaged with email marketing campaigns and flows?</li><li>How do customer segments differ in purchasing behavior and email responsiveness?</li></ul>|

¹ Each Quickstart transformation job run materializes these models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`.
---

### Materialized Models
Each Quickstart transformation job run materializes 113 models if all components of this data model are enabled. This count includes all staging, intermediate, and final models materialized as `view`, `table`, or `incremental`:
| **Connector** | **Model Count** |
| ------------- | --------------- |
| Shopify Holistic Reporting | 6 |
| [Shopify](https://github.com/fivetran/dbt_shopify) | 89 |
| [klaviyo](https://github.com/fivetran/dbt_klaviyo) | 18 |

## Prerequisites
To use this dbt package, you must have the following:

- At least one Fivetran Shopify Holistic Reporting connection syncing data into your destination.
- A **BigQuery**, **Snowflake**, **Redshift**, **Databricks**, or **PostgreSQL** destination.

## How do I use the dbt package?
You can either add this dbt package in the Fivetran dashboard or import it into your dbt project:

- To add the package in the Fivetran dashboard, follow our [Quickstart guide](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore).
- To add the package to your dbt project, follow the setup instructions in the dbt package's [README file](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/README.md#how-do-i-use-the-dbt-package) to use this package.

<!--section-end-->

### Install the package
Include the following shopify_holistic_reporting package version in your `packages.yml` file:
> TIP: Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.
```yml
packages:
  - package: fivetran/shopify_holistic_reporting
    version: [">=1.1.0", "<1.2.0"] # we recommend using ranges to capture non-breaking changes automatically
```

Do **NOT** include the `shopify` or `klaviyo` packages in this file. The combo package itself has a dependency on these and will install upstream packages as well.

#### Databricks dispatch configuration
If you are using a Databricks destination with this package, you must add the following (or a variation of the following) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Define database and schema variables
#### Single Shopify and/or Klaviyo connection
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

### Set Shopify- and Klaviyo-specific configurations
See connector-specific configurations in their individual dbt package READMEs:
- [Shopify](https://github.com/fivetran/dbt_shopify)
- [Klaviyo](https://github.com/fivetran/dbt_klaviyo)

### (Optional) Additional configurations
<details open><summary>Expand/Collapse details</summary>

#### Changing the Build Schema

By default, this package will build the final models within a schema titled (`<target_schema>` + `_shopify_holistic`) and intermediate models in (`<target_schema>` + `_int_shopify_holistic`) in your target database. Additionally, the Shopify staging models will be built within a schema titled (`<target_schema>` + `_stg_shopify`) and the Shopify final models within a schema titled (`<target_schema>` + `_shopify`); similarly, the Klaviyo final models will be built within a schema titled (`<target_schema>` + `_klaviyo`), intermediate models in (`<target_schema>` + `_int_klaviyo`), and staging models within a schema titled (`<target_schema>` + `_stg_klaviyo`) in your target database. If this is not where you would like your modeled Shopify Holistic Reporting, Shopify, or Klaviyo data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

models:
  shopify_holistic_reporting:
    +schema: my_new_schema_name # leave blank for just the target_schema
    intermediate:
      +schema: my_new_schema_name # leave blank for just the target_schema
  shopify:
    +schema: my_new_schema_name # leave blank for just the target_schema
  shopify_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
  klaviyo:
    +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
    staging:
      +schema: my_new_schema_name # Leave +schema: blank to use the default target_schema.
```

> Note that if your profile does not have permissions to create schemas in your warehouse, you can set each `+schema` to blank. The package will then write all tables to your pre-existing target schema.

Models from the individual [Shopify](https://github.com/fivetran/dbt_shopify/#changing-the-build-schema) and [Klaviyo](https://github.com/fivetran/dbt_klaviyo/#changing-the-build-schema) packages will be written their respective schemas.
</details>

### (Optional) Orchestrate your models with Fivetran Transformations for dbt Core™
<details><summary>Expand for details</summary>
<br>

Fivetran offers the ability for you to orchestrate your dbt project through [Fivetran Transformations for dbt Core™](https://fivetran.com/docs/transformations/dbt#transformationsfordbtcore). Learn how to set up your project for orchestration through Fivetran in our [Transformations for dbt Core setup guides](https://fivetran.com/docs/transformations/dbt/setup-guide#transformationsfordbtcoresetupguide).
</details>

## Does this package have dependencies?
This dbt package is dependent on the following dbt packages. These dependencies are installed by default within this package. For more information on the following packages, refer to the [dbt hub](https://hub.getdbt.com/) site.
> IMPORTANT: If you have any of these dependent packages in your own `packages.yml` file, we highly recommend that you remove them from your root `packages.yml` to avoid package version conflicts.
```yml
packages:
    - package: fivetran/shopify
      version: [">=1.4.0", "<1.5.0"]

    - package: fivetran/klaviyo
      version: [">=1.2.0", "<1.3.0"]

    - package: fivetran/fivetran_utils
      version: [">=0.4.0", "<0.5.0"]

    - package: dbt-labs/dbt_utils
      version: [">=1.0.0", "<2.0.0"]

    - package: dbt-labs/spark_utils
      version: [">=0.3.0", "<0.4.0"]
```

<!--section="shopify-holistic-reporting_maintenance"-->
## How is this package maintained and can I contribute?

### Package Maintenance
The Fivetran team maintaining this package only maintains the [latest version](https://hub.getdbt.com/fivetran/shopify_holistic_reporting/latest/) of the package. We highly recommend you stay consistent with the latest version of the package and refer to the [CHANGELOG](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/CHANGELOG.md) and release notes for more information on changes across versions.

The Fivetran team also maintains the upstream [Klaviyo](https://hub.getdbt.com/fivetran/klaviyo/latest/) and [Shopify](https://hub.getdbt.com/fivetran/shopify/latest/) packages on which the Shopify Holistic Reporting package is built off of. Refer to the [Klaviyo](https://github.com/fivetran/dbt_klaviyo/blob/main/CHANGELOG.md) and [Shopify](https://github.com/fivetran/dbt_shopify/blob/main/CHANGELOG.md) CHANGELOGs and release notes for more information on changes across versions.

### Contributions
A small team of analytics engineers at Fivetran develops these dbt packages. However, the packages are made better by community contributions.

We highly encourage and welcome contributions to this package. Learn how to contribute to a package in dbt's [Contributing to an external dbt package article](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657).

<!--section-end-->

## Are there any resources available?
- If you would like a deeper explanation of the logic used by default in the dbt package you may reference the [DECISIONLOG](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main//DECISIONLOG.md).
- If you have questions or want to reach out for help, see the [GitHub Issue](https://github.com/fivetran/dbt_shopify_holistic_reporting/issues/new/choose) section to find the right avenue of support for you.
- If you would like to provide feedback to the dbt package team at Fivetran or would like to request a new dbt package, fill out our [Feedback Form](https://www.surveymonkey.com/r/DQ7K7WW).