[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=0.20.x&color=orange)
# Shopify Holistic Reporting

This package builds off of the Shopify [dbt package](https://github.com/fivetran/dbt_shopify) to weave together your Shopify e-commerce data with insights from marketing connectors. Currently, this package only supports combining Shopify with email and SMS marketing data from [Klaviyo](https://github.com/fivetran/dbt_klaviyo).

This dbt package enables you to:
- Tie e-commerce revenue to your email and SMS marketing via last-touch attribution
- Consolidate customers, their information, and activity from across platforms.
- Create a rich portrait of how customers are engaging with and responding to specific marketing efforts and easily create personas based on this.

## Models

This package produces three final output models, and is currently designed to work simultaneously with our [Shopify](https://github.com/fivetran/dbt_shopify) and [Klaviyo](https://github.com/fivetran/dbt_klaviyo) dbt packages. Dependencies on these packages are declared in this package's `packages.yml` file, so they will automatically download when you run `dbt deps`. The primary outputs of this package are described below. Intermediate models are used to create these output models, and are not documented here.

| **model**                | **description**                                                                                                                                |
| ------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| [orders_attribution](models/orders_attribution.sql)             | Each record represents a unique Shopify order, enhanced with a customizable last-touch attribution model associating orders with Klaviyo flows and campaigns that customers interacted with. Includes dimensions like whether it is a new or repeat purchase in Shopify. |
| [daily_customer_campaign_flow](models/daily_customer_campaign_flow.sql)             | Each record represent a unique customer's daily activity attributed to a campaign or flow in Klaviyo, setting the grain at the customer-day-flow or customer-day-campaign level. Enriched with both Shopify metrics, like the net revenue, taxes paid, and discounts applied, and Klaviyo metrics, such as the counts of each type of interaction between the user and the campaign/flow. |
| [customer_enhanced](models/customer_enhanced.sql)             | Each record represents a unique individual (based on email) that may exist in Shopify, Klaviyo, or both platforms. Enhanced with information coalesced across platforms, lifetime order metrics, and all-time interactions with email marketing campaigns and flows. |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/shopify_holistic_reporting
    version: [">=0.1.0", "<0.2.0"]
```

## Opinionated Decision Log

put in here? or internal docs

## Contributions

Don't see a model or specific metric you would have liked to be included? Notice any bugs when installing and running the package? If so, we highly encourage and welcome contributions to this package!
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