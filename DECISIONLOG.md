# Decision Log (notes/draft)

In creating this package, which is meant for a wide range of use cases, we had to take opinionated stances on a few different questions we came across during development. We've consolidated significant choices we made here, and will continue to update as the package evolves. 

## Using the Campaign and Flow IDs From the Klaviyo package's attribution model
We chose to build off of the layer of attribution occurring in the Klaviyo-only dbt package. This means that we refer to `last_touch_campaign_id` and `last_touch_flow_id` (a coalescing of the Klaviyo-provided `campaign_id`/`flow_id` and those attributed by the package itself) when attributing Shopify orders to Klaviyo campaigns and flows.
## Last Touch Attribution
This package performs last-touch attribution only, in line with Klaviyo's internal attribution model. It would've been fairly straightforward to also perform first-touch attribution here, but given the nature of email marketing (ie its place at the bottom of the funnel), this didn't seem very valuable. First-touch (and multi-touch) attribution would make more sense with ad sources.

## Rolling up Customers and Persons
Theoretically, emails should be unique within `shopify.customers` and `klaviyo.person`. However, we have seen cases where this is not true, namely when a bot has created a bunch of accounts under the same email and/or name. Thus, because this package relies on email to join across platforms, we have rolled up these tables to the email-grain. We have also incorporated warnings on the `shopify__customers` and `klaviyo__persons` models so that you are notified if an email is not unique (and that you may have a bot problem!)

## Refund Dates
In the `daily_customer_customer_campaign_flow` model, refund metrics are tied to the day the order was placed, _not_ when it was refunded.