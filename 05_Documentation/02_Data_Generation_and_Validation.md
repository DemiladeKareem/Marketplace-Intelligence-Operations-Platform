# Data Generation and Validation

## Overview

The Marketplace Intelligence Operations Platform uses a synthetic but business-oriented marketplace dataset designed to simulate the operational environment of a large digital marketplace.

The dataset was generated programmatically to create realistic relationships across customers, sellers, products, orders, payments, shipments, inventory, promotions, returns, reviews, couriers, warehouses, and locations.

The objective was not simply to create large volumes of data, but to create a dataset capable of supporting commercial, operational, customer, inventory, seller, and fulfillment analysis.

---

## Dataset Scale

| Dataset | Rows |
|---|---:|
| Customers | 50,000 |
| Sellers | 500 |
| Products | 5,000 |
| Categories | 25 |
| Orders | 250,000 |
| Order Items | 483,502 |
| Payments | 250,000 |
| Shipments | 250,000 |
| Inventory | 225,000 |
| Returns | 36,365 |
| Reviews | 99,390 |
| Promotions | 100 |
| Couriers | 10 |
| Warehouses | 15 |
| Locations | 50 |

The resulting dataset contains more than 1.6 million records across the major marketplace entities and transactional tables.

---

## Generation Approach

The data-generation process was designed around marketplace business rules rather than independent random tables.

The generation process established:

- Customer and seller populations
- Product and category hierarchies
- Marketplace orders
- Multi-item orders
- Payments associated with orders
- Shipment and fulfillment outcomes
- Inventory snapshots
- Promotional campaigns
- Product returns
- Customer reviews
- Courier assignments
- Warehouse relationships
- Geographic locations

This allowed the resulting data to behave like an interconnected operational system rather than a collection of unrelated CSV files.

---

## Validation

A dedicated validation script was used to verify the generated datasets before loading them into SQL Server.

Validation checks included:

- Expected row counts
- Required fields
- Null values
- Referential integrity
- Invalid foreign-key references
- Numeric consistency
- Negative financial values
- Relationship compatibility between datasets

The initial validation identified several issues involving shipment values, promotion references, and gross profit calculations.

These issues were corrected before the final dataset was approved.

The final validation run returned:

**No validation issues detected.**

---

## Promotion Data Correction

During the SQL and Power BI modeling stage, an additional data-quality issue was discovered involving promotion keys in the order-item fact table.

The source staging data contained promotion identifiers represented in a format that did not align cleanly with the destination integer key.

The issue was resolved through a SQL Server DML correction using `UPDATE ... SET`, joining the affected staging data to the appropriate promotion records.

After correction:

- 57,743 order items contained populated promotion keys.
- 425,759 order items remained without a promotion.
- The populated records represented promoted items.
- Promotion keys were correctly available from 1–100.
- Power BI was refreshed after the database correction.
- Promotion-level analysis subsequently worked correctly.

This correction demonstrated an important principle of the project: data quality problems can be resolved at the database layer without rebuilding the Power BI model when the BI layer is connected directly to the SQL Server source.

---

## Synthetic Data Considerations

Some operational distributions are intentionally normalized because the dataset is synthetic.

For example, shipment outcomes were generated using fixed operational probabilities. This produces relatively stable monthly proportions of:

- On-time deliveries
- Late deliveries
- Failed deliveries

Consequently, some dashboard patterns should be interpreted as demonstrations of analytical capability rather than forecasts of real-world marketplace behavior.

The dataset is therefore best viewed as a controlled business simulation designed to demonstrate data engineering, SQL modeling, analytical reasoning, and BI development.