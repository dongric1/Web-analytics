# Web Analytics: Customer Purchase Behavior Analysis

## Overview

This project aims to provide an analysis of customer behavior on the Google Merch Shop. The primary objectives include:

* Building a real-time dashboard to compare web events from the current week to the previous week.
* Measuring the time it takes for users to complete a purchase on the same day after first visiting the website.
* Conducting A/B tests:
  1. Comparing Newsletter conversion rates between two versions (NewYear_V1 vs. NewYear_V2).
  2. Analyzing if there's a significant difference in purchase times between Apple users using Chrome 86.0 vs. 87.0.


This analysis simulates real-world scenarios where businesses aim to improve user experience, optimize marketing efforts, and understand customer purchasing behavior. We assume that data accuracy is high, and web events are consistently captured for the analysis.


## Problems

1. Session duration problems possibly due to latency problems in website. 
2. Newsletter Conversion Effectiveness: stakeholders want to understand which version of NewYear campaign newsletter improves conversions.

### Analysis Process

* **BigQuery** was used to extract session duration, calculating purchase time, validating data.
* **IBM SPSS, Sheets add-on** was used to conduct statistical testing for an A/B testing newsletter, browser impact on purchase time (t-test, Pearson Chi-square test).
* **Looker** was used for data visualization to communicate trends, patterns.


### Data Source
BigQuery sample dataset for Google Analytics ecommerce web implementation was used, [`ga4_obfuscated_sample_ecommerce dataset`](https://console.cloud.google.com/bigquery?p=bigquery-public-data&d=ga4_obfuscated_sample_ecommerce&t=events_20210131&page=table). Full dataset can be found in Bigquery Public dataset link provided. 
For the analysis full dataset from 2020-11-01 to 2021-01-31 was used to analyse full raw dataset. `raw_events` table schema and preview can be found in `data/` folder.

### Data Processing
SQL queries used for the analysis can be found in `AB testing queries/` folder and `Data viz queries/`.


## Findings 


## Solutions 
1. 
2. 
3. 

## Conclusions


## Next Steps

## Limitations

* Purchase duration is calculated within the same day: if user entered page i.e. before midnight 23:50 EET and finished purchase on next day 00:05 EET, average time to purchase for that customer is 5 minutes.
* Calculation focuses on only one purchase per customer per day.
* Purchases that was made via referral mostly 0.00 $, however still included as purchase impacting total # of purchases.
* To reduce impact of long sessions when customers left session running, **median was used for duration to purchase**.
