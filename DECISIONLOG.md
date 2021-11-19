# Decision Log

In creating this package, which is meant for a wide range of use cases, we had to take opinionated stances on a few different questions we came across during development. We've consolidated significant choices we made here, and will continue to update as the package evolves. 

## Using the Campaign and Flow IDs From the Klaviyo package's attribution model.
Choosing to attribute orders to Klaviyo campaigns/flows using the Klaviyo package’s layer of attribution (so last_touch_campaign_id instead of campaign_id)
Pro: More generous attribution! And fuller attribution

## Last Touch Attribution
Choosing to only do a last touch attribution model 
First touch is more appropriate for farther up the funnel, not email marketing 

## Not adding a date spine
Not adding a date spine to the daily models 

## Shopify metrics?
The choice of metrics we extract for daily shopify activity 

## Rolling up customers and persons
Rolling up customers from Shopify
It is potentially possible for multiple shopify accounts to be associated with the same email. This may point to Bot behavior or something, so we have a warning test on this, and we de-dupe if needed. 
Also we need it to be email-based to connect across platforms 

## Refund Dates
Refunded orders are reported for the day the order was placed.
