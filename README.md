# Marketplace Intelligence Operations Platform

> **A synthetic, end-to-end marketplace intelligence platform built to
> simulate how a large digital marketplace can turn operational data
> into commercial and operational decisions.**

<figure>
<img src="Images/01_Executive_Overview.png" alt="Executive Overview" />
<figcaption aria-hidden="true">Executive Overview</figcaption>
</figure>

## Overview

Marketplaces do not operate from a single number.

Behind every sale is a customer, seller, product, promotion, payment,
shipment, warehouse, courier, and sometimes a return. When these
processes are disconnected, answering seemingly simple questions becomes
difficult:

- Which categories are actually driving revenue?
- Are higher discounts translating into stronger sales?
- Which sellers contribute the most commercial value?
- Which couriers provide reliable delivery at reasonable cost?
- How healthy is fulfillment performance?
- Where does inventory pressure exist?
- Can management explore these questions from one trusted analytical
  model?

The **Marketplace Intelligence Operations Platform** was built to answer
these questions through a complete data-to-decision workflow.

Rather than starting with a dashboard, the project starts with the
underlying business system: synthetic marketplace data is generated,
validated, staged in SQL Server, transformed into a dimensional model,
analyzed with SQL, and finally exposed through an interactive Power BI
experience.

The result is a compact demonstration of how **data engineering,
dimensional modeling, analytical SQL, DAX, and business intelligence
work together to support marketplace decision-making.**

------------------------------------------------------------------------

## Business Scenario

The platform simulates a growing digital marketplace similar in
operating structure to large multi-seller platforms.

The simulated marketplace manages:

- **50K customers**
- **500 sellers**
- **5K products**
- **250K orders**
- **483K order items**
- **250K shipments**
- **250K payments**
- **225K inventory records**
- **36K+ returns**
- **99K+ reviews**
- **100 promotions**
- **10 couriers**
- **15 warehouses**
- **25 product categories**

Across the platform, more than **1.6 million records** are used to
create an interconnected analytical environment.

The objective is not to reproduce a real company’s confidential data.

Instead, the synthetic environment provides enough scale and relational
complexity to demonstrate how a marketplace intelligence solution could
be designed from the ground up.

------------------------------------------------------------------------

# What This Project Demonstrates

### Data Engineering

Programmatic generation of interconnected marketplace datasets with
controlled business rules, relational dependencies, and validation
checks.

### SQL Server

Raw CSV data is loaded into a staging layer before being transformed
into business dimensions and fact tables.

### Dimensional Modeling

The platform uses a star-schema-oriented analytical architecture
designed around business processes and appropriate fact-table grain.

### Data Quality

Validation was performed before analysis, and an additional
promotion-key issue discovered during modeling was diagnosed and
corrected directly in SQL Server.

### Analytical SQL

Business analysis is performed against the modeled data rather than
relying exclusively on the BI layer.

### Power BI & DAX

The final analytical model provides interactive executive reporting,
drill-down, filtering, KPI monitoring, and diagnostic analysis.

### Business Storytelling

The dashboard is organized around four business perspectives rather than
simply displaying every available metric.

------------------------------------------------------------------------

# Architecture

``` text
┌──────────────────────────────┐
│      Python Data Generation  │
│                              │
│ Customers • Sellers          │
│ Products • Orders            │
│ Payments • Shipments         │
│ Inventory • Promotions       │
│ Returns • Reviews            │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│        CSV Source Layer      │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       SQL Server / stg       │
│                              │
│ Raw marketplace source data  │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Dimensional Model      │
│                              │
│ Dimensions + Fact Tables     │
└──────────────┬───────────────┘
               │
        ┌──────┴──────┐
        ▼             ▼
┌──────────────┐ ┌──────────────┐
│ Analytical   │ │    Power BI  │
│ SQL          │ │    + DAX     │
└──────────────┘ └──────┬───────┘
                        │
                        ▼
               ┌─────────────────┐
               │ Decision Support│
               │   Dashboard     │
               └─────────────────┘
```

------------------------------------------------------------------------

# Data Generation & Validation

The dataset was generated programmatically rather than manually
assembled.

The generation process established relationships between marketplace
entities so that customers, sellers, products, orders, order items,
promotions, shipments, payments, inventory, returns, couriers, and
warehouses could participate in a coherent analytical model.

A dedicated validation process checked:

- Row counts
- Null values
- Referential integrity
- Invalid references
- Required fields
- Numeric consistency
- Financial values
- Cross-table relationships

The initial validation identified data-quality issues involving shipment
values, promotion references, and gross-profit calculations.

These issues were corrected before the final dataset was approved.

**Final validation result:**

> No validation issues detected.

Detailed methodology is documented in:

`05_Documentation/02_Data_Generation_and_Validation.md`

------------------------------------------------------------------------

# SQL Data Model

The SQL database is organized into four logical schemas:

| Schema      | Purpose                             |
|-------------|-------------------------------------|
| `stg`       | Raw source data                     |
| `dim`       | Analytical dimensions               |
| `fact`      | Transactional and operational facts |
| `analytics` | Business analysis                   |

### Dimensions

- `DimCustomer`
- `DimSeller`
- `DimProduct`
- `DimCourier`
- `DimWarehouse`
- `DimDate`
- `DimPromotion`

### Facts

- `FactOrders`
- `FactOrderItems`
- `FactShipments`
- `FactPayments`
- `FactInventory`
- `FactReturns`

The model was deliberately designed around business-process grain.

For example, product, category, seller, and promotion analysis is driven
through the **order-item grain**, while shipment analysis is driven
through the shipment grain.

This distinction became particularly important when building the Power
BI measures.

<figure>
<img src="Images/05_Star_Schema.png" alt="Star Schema" />
<figcaption aria-hidden="true">Star Schema</figcaption>
</figure>

Detailed modeling decisions are documented in:

`05_Documentation/03_SQL_Data_Model.md`

------------------------------------------------------------------------

# A Real Data-Quality Lesson

One of the most valuable parts of the project happened after the initial
model had already been built.

Promotion analysis in Power BI was not behaving as expected.

Investigation showed that the promotion key in the order-item fact table
was blank for a large portion of the records.

The underlying issue was traced back to the source promotion identifier
and its formatting/type compatibility.

Instead of rebuilding the model, the issue was corrected at the SQL
Server layer using **DML with** **`UPDATE ... SET`** **and a joined
source**.

After the correction:

- **57,743** order items had populated promotion keys.
- **425,759** order items remained without promotions.
- Promotion keys correctly mapped to the available promotion records.
- Power BI was refreshed.
- Promotion Name and Promotion Type could subsequently filter item-level
  sales correctly.

This became an important architectural lesson:

``` text
SQL Server correction
        ↓
Existing connected model
        ↓
Power BI refresh
        ↓
Corrected analysis
```

No new Power BI table was required.

The project therefore demonstrates not only how to build a BI solution,
but also how to **debug one when the numbers do not behave as
expected.**

------------------------------------------------------------------------

# Power BI Executive Experience

The final Power BI solution contains four analytical pages.

------------------------------------------------------------------------

## 01 — Executive Overview

The executive page answers:

> **How is the marketplace performing overall?**

It combines:

- Net Sales
- Gross Profit
- Gross Margin
- Orders
- Customers
- Average Order Value

with analysis of:

- Monthly commercial performance
- Category scale and profitability
- Fulfillment outcomes
- Customer segment contribution
- Courier cost and delivery reliability

<figure>
<img src="Images/01_Executive_Overview.png" alt="Executive Overview" />
<figcaption aria-hidden="true">Executive Overview</figcaption>
</figure>

------------------------------------------------------------------------

## 02 — Commercial Performance

The commercial page answers:

> **What is driving marketplace revenue and customer demand?**

It examines:

- Sales and order activity
- Category revenue contribution
- Top promotions
- Discount intensity
- Customer segment order behavior
- Average order value

<figure>
<img src="Images/02_Commercial_Performance.png"
alt="Commercial Performance" />
<figcaption aria-hidden="true">Commercial Performance</figcaption>
</figure>

------------------------------------------------------------------------

## 03 — Operations & Fulfillment

The operations page answers:

> **How efficiently is the marketplace fulfilling customer orders?**

It focuses on:

- Shipment volume
- On-time delivery
- Late delivery
- Failed delivery
- Shipping cost
- Courier performance
- Delivery reliability
- Fulfillment distribution

<figure>
<img src="Images/03_Operations_Fulfillment.png"
alt="Operations &amp; Fulfillment" />
<figcaption aria-hidden="true">Operations &amp; Fulfillment</figcaption>
</figure>

------------------------------------------------------------------------

## 04 — Product & Seller Performance

The product and seller page answers:

> **Which products and sellers are contributing commercial value?**

It provides:

- Product revenue contribution
- Category-to-product drill-down
- Top seller performance
- Product portfolio status
- Average order value by seller type
- Detailed seller performance

<figure>
<img src="Images/04_Product_Seller_Performance.png"
alt="Product &amp; Seller Performance" />
<figcaption aria-hidden="true">Product &amp; Seller
Performance</figcaption>
</figure>

------------------------------------------------------------------------

# Dashboard Design Principles

The dashboard was intentionally designed around **decision usefulness
rather than visual quantity**.

Each visual was selected to answer a distinct business question.

The model uses:

- KPI cards
- Slicers
- Cross-filtering
- Drill-down
- Scatter analysis
- Treemaps
- Donut analysis
- Matrices
- Conditional formatting
- In-cell data bars
- Combo charts
- Reset interactions

Where the synthetic data did not support a meaningful benchmark or
pattern, the dashboard avoided manufacturing one.

For example, no artificial average/reference line was added to the
category profitability scatter because the categories were relatively
close together and such a line could imply a stronger business
distinction than the data justified.

That principle guided the dashboard throughout:

> **Do not make the visualization more confident than the data.**

------------------------------------------------------------------------

# Key Analytical Measures

The Power BI model includes measures for areas such as:

- Total Net Sales
- Item Net Sales
- Gross Profit
- Gross Margin %
- Total Orders
- Total Products Sold
- Average Order Value
- Discount Rate
- On-Time Delivery %
- Late Delivery %
- Failed Delivery %
- Average Shipping Cost

Measures were created according to the grain of the underlying facts.

This was especially important for product, seller, category, and
promotion analysis, where **item-level measures** were required to
correctly respond to dimensional filters.

------------------------------------------------------------------------

# Synthetic Data: Important Context

This is a controlled simulation rather than production marketplace data.

Some patterns are therefore intentionally stable.

For example, shipment statuses were generated using fixed operational
probabilities. As a result, monthly fulfillment percentages remain
relatively normalized.

This means the dashboard should be interpreted as:

**a demonstration of analytical design and decision-support capability**

rather than:

**a forecast of actual marketplace performance.**

The project intentionally documents these limitations rather than
presenting synthetic patterns as real-world discoveries.

Full details are available in:

`05_Documentation/05_Known_Limitations.md`

------------------------------------------------------------------------

# Why No Large Collection of SQL Views?

The project deliberately keeps the analytical architecture focused.

The dimensional model and fact tables already provide the required
analytical foundation for Power BI.

Rather than creating views that simply duplicate the existing model, the
project retains a focused analytical SQL layer.

Future users can create purpose-specific views when extending the
platform.

This keeps the current implementation simpler while leaving room for
future development.

------------------------------------------------------------------------

# Technology Stack

| Technology           | Role                                           |
|----------------------|------------------------------------------------|
| Python               | Synthetic data generation and validation       |
| CSV                  | Source data interchange                        |
| Microsoft SQL Server | Database, staging, transformation and modeling |
| SQL                  | Data transformation and business analysis      |
| DML                  | Data-quality correction                        |
| Power BI             | Interactive BI and visualization               |
| DAX                  | Analytical measures                            |
| Git                  | Version control                                |
| GitHub               | Project repository and documentation           |

------------------------------------------------------------------------

# Repository Structure

``` text
Marketplace-Intelligence-Operations-Platform/
│
├── 01_Business_Requirements/
│   └── 01_Business_Requirements.docx
│
├── 02_Data_Generation/
│   └── scripts/
│       ├── generate_marketplace_data.py
│       ├── generate_transactions.py
│       └── validate_marketplace_data.py
│
├── 03_SQL/
│   ├── 01_database/
│   ├── 02_staging/
│   ├── 03_dimensions/
│   ├── 04_facts/
│   ├── 05_views/
│   └── 06_analysis/
│
├── 04_PowerBI/
│   └── Marketplace_Intelligence_Model_Backup.pbix
│
├── 05_Documentation/
│   ├── 01_Business_Requirements/
│   ├── 02_Data_Generation_and_Validation.md
│   ├── 03_SQL_Data_Model.md
│   ├── 04_PowerBI_Dashboard.md
│   ├── 05_Known_Limitations.md
│   └── Project_Build_Log
│
├── Images/
│   ├── 01_Executive_Overview.png
│   ├── 02_Commercial_Performance.png
│   ├── 03_Operations_Fulfillment.png
│   ├── 04_Product_Seller_Performance.png
│   └── 05_Star_Schema.png
│
└── README.md
```

------------------------------------------------------------------------

# Business Questions the Platform Can Answer

### Commercial

- What is driving total marketplace revenue?
- Which categories contribute the most sales?
- Which customer segments generate the greatest value?
- How does order volume relate to order value?
- Which promotions generate the most item-level sales?
- Does higher discount intensity correspond to stronger sales?

### Product & Seller

- Which categories and products contribute the most revenue?
- Which sellers generate the highest sales?
- How does seller type relate to average order value?
- Which sellers combine strong sales with healthy gross profit?
- What does the active/inactive product portfolio look like?

### Operations

- What proportion of shipments arrive on time?
- Which couriers provide the strongest delivery reliability?
- Which couriers are more expensive?
- Is higher shipping cost associated with better delivery performance?
- How does fulfillment performance change over time?

### Data & Architecture

- Can raw marketplace data be transformed into a reusable analytical
  model?
- Are fact and dimension grains correctly separated?
- Can data-quality problems be diagnosed at the database layer?
- Can corrected SQL data flow into an existing Power BI model?
- Can business analysis be performed without relying entirely on the
  visualization layer?

------------------------------------------------------------------------

# Project Build Journey

This project was intentionally built as a progression rather than a
dashboard-first exercise.

``` text
Business Requirements
        ↓
Synthetic Data Design
        ↓
Data Generation
        ↓
Validation
        ↓
SQL Server Staging
        ↓
Dimensional Modeling
        ↓
Fact Construction
        ↓
Relationship Validation
        ↓
Analytical SQL
        ↓
Power BI Modeling
        ↓
DAX Measures
        ↓
Dashboard Development
        ↓
Data-Quality Debugging
        ↓
Final Documentation
```

The build log records the major implementation decisions, corrections,
and lessons learned throughout the project.

------------------------------------------------------------------------

# What I Would Build Next

The current platform establishes the analytical foundation.

A production-grade evolution could introduce:

- Real marketplace data
- Automated ETL pipelines
- Incremental loading
- Streaming order events
- Automated data-quality monitoring
- Customer lifetime value
- Cohort analysis
- Seller health scoring
- Return-rate forecasting
- Demand forecasting
- Inventory replenishment optimization
- Courier SLA monitoring
- Automated Power BI refresh
- Row-level security
- Machine-learning models
- Cloud data warehousing

The architecture is intentionally designed so that these capabilities
can be added without discarding the analytical foundation.

------------------------------------------------------------------------

# Final Perspective

The most important outcome of this project is not the dashboard itself.

It is the chain connecting **business requirements → data → validation →
database design → analytical logic → visualization → decision-making.**

The project started with the question of how a marketplace could
understand its commercial and operational performance.

It ended with a working analytical platform capable of connecting those
questions to structured data and interactive decision support.

Along the way, the build also exposed a realistic lesson from analytics
work:

**data does not always behave the way you expect it to.**

When the promotion analysis failed, the solution was not to force Power
BI to produce the desired result. The underlying relationship was
investigated, the database issue was corrected, the model was refreshed,
and the analysis was revalidated.

That is the mindset this project is intended to demonstrate:

> **Build the model correctly. Validate the data. Question the numbers.
> Fix the root cause. Then tell the story.**

------------------------------------------------------------------------

## Project Documentation

- [Business
  Requirements](01_Business_Requirements/01_Business_Requirements.docx)
- [Data Generation &
  Validation](05_Documentation/02_Data_Generation_and_Validation.md)
- [SQL Data Model](05_Documentation/03_SQL_Data_Model.md)
- [Power BI Dashboard](05_Documentation/04_PowerBI_Dashboard.md)
- [Known Limitations](05_Documentation/05_Known_Limitations.md)

------------------------------------------------------------------------

## Project Status

**Status:** Completed

**Scope:** End-to-end marketplace intelligence simulation

**Primary focus:** Data engineering • SQL • Dimensional modeling • DAX •
Power BI • Business intelligence

**Final deliverable:** Integrated marketplace analytical platform with
four interactive Power BI dashboard pages, SQL analytical foundation,
validated synthetic datasets, and supporting technical documentation.
