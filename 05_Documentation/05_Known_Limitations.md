# Known Limitations

## Overview

This project is a synthetic marketplace intelligence platform built to demonstrate data engineering, SQL dimensional modeling, analytical reasoning, and Power BI development.

The data and resulting insights should therefore be interpreted within the limitations of a controlled simulation.

---

## Synthetic Data

The dataset is programmatically generated rather than collected from a live marketplace.

As a result:

- Customer behavior is simulated.
- Product demand is simulated.
- Seller performance is simulated.
- Promotion behavior is simulated.
- Delivery outcomes are simulated.
- Inventory movement is simulated.
- Financial relationships are simulated.

The dashboard demonstrates analytical methodology rather than representing the actual performance of a commercial marketplace.

---

## Fixed Fulfillment Probabilities

Shipment outcomes were generated using predefined operational probabilities.

This produces relatively stable proportions of:

- On-time deliveries
- Late deliveries
- Failed deliveries

The resulting monthly fulfillment chart therefore does not contain the degree of seasonal or operational volatility normally expected in a real marketplace.

The visual is primarily useful for demonstrating how delivery health can be monitored through the dimensional model.

---

## Limited Promotion Penetration

Only a subset of order items contains promotions.

The final dataset contains:

- 57,743 populated promotion keys
- 425,759 order items without promotions

Therefore, promotion-level analysis should be interpreted as analysis of promoted transactions rather than the entire order-item population.

---

## Financial Distribution

Because the financial data is synthetically generated, some categories, sellers, and products have relatively similar financial performance.

This can reduce the strength of certain analytical patterns.

For this reason, the dashboard avoids forcing artificial benchmarks or conclusions where the underlying data does not support them.

---

## Inventory Analysis

Inventory snapshots and warehouse capacity represent different business grains.

Inventory is recorded across product, warehouse, and snapshot periods, while warehouse capacity is a relatively static warehouse-level attribute.

Combining these directly can produce misleading utilization ratios.

The project therefore avoids presenting warehouse capacity utilization as a headline dashboard metric.

---

## Product-Level Analysis

Product and category analysis is primarily driven through `FactOrderItems`.

This is important because product attributes relate naturally to individual order items rather than the order-level sales grain.

Measures such as item net sales were therefore created to preserve the correct analytical context.

---

## Promotion-Key Data Quality Issue

A promotion-key issue was identified after the initial dimensional model was created.

The source promotion identifier contained formatting that caused a type mismatch when being converted into an integer key.

The issue was corrected directly in SQL Server using DML and the Power BI model was subsequently refreshed.

This demonstrates the importance of validating relationships after loading and not assuming that successful table creation automatically guarantees analytical correctness.

---

## Power BI Dependency

The dashboard depends on the SQL Server model and its relationships.

Changes to:

- Dimension keys
- Fact keys
- Data types
- Relationships
- Source table names
- Database structure

may require a Power BI model refresh or additional model adjustments.

---

## Intended Use

This project should be viewed as a portfolio demonstration of:

- Synthetic data engineering
- Data validation
- SQL Server
- Staging architecture
- Dimensional modeling
- Star-schema design
- SQL DML
- Analytical SQL
- Power BI
- DAX
- Business intelligence storytelling
- Data-quality troubleshooting

It should not be interpreted as a production marketplace forecasting system or as evidence of real-world marketplace performance.

---

## Future Extensions

A production implementation could extend the platform with:

- Real marketplace data
- Streaming order events
- More granular inventory snapshots
- Dynamic promotion effectiveness measurement
- Customer lifetime value
- Cohort analysis
- Seller health scoring
- Return-rate forecasting
- Demand forecasting
- Inventory replenishment optimization
- Courier SLA monitoring
- Automated data-quality pipelines
- Power BI deployment and scheduled refresh
- Role-level security
- Machine-learning models

These extensions are intentionally outside the scope of the current portfolio build.