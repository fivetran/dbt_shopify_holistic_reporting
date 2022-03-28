[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
# Shopify Holistic Reporting

This package builds off of the [Shopify dbt package](https://github.com/fivetran/dbt_shopify) to weave together your Shopify e-commerce data with insights from marketing connectors. Currently, this package supports combining Shopify with email and SMS marketing data from Fivetran's [Klaviyo dbt package](https://github.com/fivetran/dbt_klaviyo).

This dbt package enables you to:
- Tie e-commerce revenue to your email and SMS marketing via last-touch attribution.
- Consolidate customers, their information, and activity across platforms.
- Create a rich portrait of customer personas based on how customers are engaging with and responding to specific marketing efforts.

Check out our [blog post](https://www.fivetran.com/blog/gain-faster-insights-from-shopify-and-klaviyo-data) for further discussion on how the package can accelerate your business analysis. 

## Models

This package produces three final output models, and is currently designed to work simultaneously with our [Shopify](https://github.com/fivetran/dbt_shopify) and [Klaviyo](https://github.com/fivetran/dbt_klaviyo) dbt packages. Dependencies on these packages are declared in this package's `packages.yml` file, so they will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models, and are not documented here.

| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [shopify_holistic_reporting__orders_attribution](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/models/shopify_holistic_reporting__orders_attribution.sql)             | Each record represents a unique Shopify order, enhanced with a customizable last-touch attribution model associating orders with Klaviyo flows and campaigns that customers interacted with. Includes dimensions like whether it is a new or repeat purchase in Shopify. See available customizations [here](https://github.com/fivetran/dbt_klaviyo#attribution-lookback-window). |
| [shopify_holistic_reporting__daily_customer_metrics](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/models/shopify_holistic_reporting__daily_customer_metrics.sql)             | Each record represent a unique customer's daily activity attributed to a campaign or flow in Klaviyo. The grain is set at the customer-day-flow/campaign level. This model is enriched with both Shopify and Klaviyo metrics, such as the net revenue, taxes paid, discounts applied, and the counts of each type of interaction between the user and the campaign/flow. |
| [shopify_holistic_reporting__customer_enhanced](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main/models/shopify_holistic_reporting__customer_enhanced.sql)             | Each record represents a unique individual (based on email) that may exist in Shopify, Klaviyo, or both platforms. Enhanced with information coalesced across platforms, lifetime order metrics, and all-time interactions with email marketing campaigns and flows. |

### Opinionated Modelling Decisions
If you would like a deeper explanation of the logic used by default in the dbt package you may reference the [DECISIONLOG](https://github.com/fivetran/dbt_shopify_holistic_reporting/blob/main//DECISIONLOG.md).

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/shopify_holistic_reporting
    version: [">=0.1.0", "<0.2.0"]
```

## Configurations

See connector-specific configurations in their individual dbt package READMEs:
- [Shopify](https://github.com/fivetran/dbt_shopify)
- [Klaviyo](https://github.com/fivetran/dbt_klaviyo)

### Unioning Multiple Shopify or Klaviyo Connectors
If you have multiple Shopify and/or Klaviyo connectors in Fivetran and would like to use this package on all of them simultaneously, we have provided functionality to do so. The package will union all of the data together and pass the unioned table into the transformations. You will be able to see which source it came from in the `source_relation` column of each model. To use this functionality, you will need to set either (**note that you cannot use both**) the `union_schemas` or `union_databases` variables for each type of connector. Note that Shopify and Klaviyo refer the same names for the variables, so you will need to properly namespace them within the `klaviyo_source` and `shopify_source` packages to use this functionality for both sources:

```yml
# dbt_project.yml
...
config-version: 2
vars:
  klaviyo_source:
    union_schemas: ['klaviyo_usa','klaviyo_canada'] # use this if the data is in different schemas/datasets of the same database/project
    union_databases: ['klaviyo_usa','klaviyo_canada'] # use this if the data is in different databases/projects but uses the same schema name

  shopify_source:
    union_schemas: ['shopify_usa','shopify_canada'] # use this if the data is in different schemas/datasets of the same database/project
    union_databases: ['shopify_usa','shopify_canada'] # use this if the data is in different databases/projects but uses the same schema name
```

### Changing the Build Schema

By default, this package will build the final models within a schema titled (`<target_schema>` + `_shopify_holistic`) and intermediate models in (`<target_schema>` + `_int_shopify_holistic`) in your target database. If this is not where you would like your modeled Shopify Holistic Reporting data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  shopify_holistic_reporting:
    +schema: my_new_schema_name # leave blank for just the target_schema
    intermediate:
      +schema: my_new_schema_name # leave blank for just the target_schema
```

> Note that if your profile does not have permissions to create schemas in your warehouse, you can set each `+schema` to blank. The package will then write all tables to your pre-existing target schema.

Models from the individual [Shopify](https://github.com/fivetran/dbt_shopify/#changing-the-build-schema) and [Klaviyo](https://github.com/fivetran/dbt_klaviyo/#changing-the-build-schema) packages will be written their respective schemas. 


## Contributions

Don't see a model or specific metric you want to be included? Notice any bugs when installing and running the package? If so, we highly encourage and welcome contributions to this package!
Please create issues or open PRs against `main`. Check out [this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) on the best workflow for contributing to a package.

## Database Support

This package has been tested on BigQuery, Snowflake, Redshift, Postgres, and Databricks.

### Databricks Dispatch Configuration
dbt `v0.20.0` introduced a new project-level dispatch configuration that enables an "override" setting for all dispatched macros. If you are using a Databricks destination with this package you will need to add the below (or a variation of the below) dispatch configuration within your `dbt_project.yml`. This is required in order for the package to accurately search for macros within the `dbt-labs/spark_utils` then the `dbt-labs/dbt_utils` packages respectively.
```yml
# dbt_project.yml

dispatch:
  - macro_namespace: dbt_utils
    search_order: ['spark_utils', 'dbt_utils']
```

### Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
