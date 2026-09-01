# Marketplace Intelligence Operations Platform
## Project Build Log

## 1. Project Purpose

The Marketplace Intelligence Operations Platform is a synthetic enterprise marketplace analytics project designed to simulate the data environment and operational challenges of a large e-commerce marketplace.

The project is intentionally built from generated data rather than downloaded from an existing dataset.

The objective is to demonstrate practical capability across:

- Python-based data generation
- SQL Server data engineering and transformation
- relational data modeling
- dimensional modeling
- business analysis
- Power BI semantic modeling
- executive and operational analytics

The project should resemble a realistic marketplace environment with enough scale, relationships, financial metrics, operational data, and business problems to demonstrate enterprise-level analytical thinking.

The primary objective is not to demonstrate every available technology. Each technology must serve the business requirements.

---

## 2. Source of Truth

The Business Requirements Document is the primary source of truth for the project.

All database structures, analytical questions, KPIs, and Power BI outputs must remain aligned with the BRD.

New ideas should not be added simply because they are technically interesting.

Any additional feature must either:

1. Directly support an existing business requirement, or
2. Clearly strengthen the original business objective without creating unnecessary scope.

The project should not drift from the BRD.

---

## 3. Technology Stack

Primary tools:

- Python
- SQL Server / SSMS
- Power BI
- Git / GitHub

Python is used primarily for synthetic marketplace data generation.

SQL Server is used for:

- staging
- data validation
- transformation
- dimensional modeling
- fact table construction
- business analysis

Power BI is used for:

- semantic modeling
- relationships
- DAX measures where required
- interactive dashboards
- executive and operational reporting

GitHub is used for version control and project presentation.

---

## 4. Architecture

Current architecture:

Python
↓
CSV Source Files
↓
SQL Server Staging Layer
↓
Data Validation
↓
Dimension Tables
↓
Fact Tables
↓
SQL Business Analysis
↓
Power BI Semantic Model
↓
Power BI Dashboards
↓
Documentation

The project intentionally avoids unnecessary transformation layers.

---

## 5. Repository Structure

Current project structure:

Marketplace-Intelligence-Operations-Platform/
├── .idea/
├── .venv/
├── 01_Business_Requirements/
├── 02_Data_Generation/
├── 03_SQL/
│   ├── 01_database/
│   ├── 02_staging/
│   ├── 03_dimensions/
│   ├── 04_facts/
│   └── 05_analysis/
├── 04_PowerBI/
├── 05_Documentation/
├── images/
├── LICENSE
└── README.md

The Python virtual environment and PyCharm configuration are excluded through Git ignore rules.

---

## 6. Business Scope

The simulated marketplace contains:

- Customers
- Sellers
- Products
- Categories
- Orders
- Order items
- Payments
- Promotions
- Shipments
- Couriers
- Warehouses
- Locations
- Inventory
- Returns
- Reviews

The project is not courier-centric.

Courier performance is one operational component of the wider marketplace intelligence problem.

Courier analysis is included because logistics performance can affect:

- delivery outcomes
- shipping costs
- late deliveries
- failed deliveries
- customer experience
- operational profitability

---

## 7. Generated Dataset

Final validated dataset:

| Table | Rows |
|---|---:|
| customers | 50,000 |
| sellers | 500 |
| categories | 25 |
| products | 5,000 |
| locations | 50 |
| warehouses | 15 |
| couriers | 10 |
| promotions | 100 |
| orders | 250,000 |
| order_items | 483,502 |
| payments | 250,000 |
| shipments | 250,000 |
| inventory | 225,000 |
| returns | 36,365 |
| reviews | 99,390 |

The data was generated synthetically using Python.

---

## 8. Python Data Generation

Python generation was separated into two main scripts:

- generate_marketplace_data.py
- generate_transactions.py

The first script establishes marketplace master/reference data.

The transaction generator creates large-scale transactional and operational data.

The generated files are stored under:

02_Data_Generation/output/

---

## 9. Python Data Validation

The generated dataset was validated before being loaded into SQL Server.

An initial validation identified:

- missing shipment values
- invalid promotion references
- negative gross profit values

The generation logic was corrected.

A subsequent validation passed with:

PASSED: No validation issues detected.

This validation step is important because SQL Server should receive a controlled source dataset rather than unverified generated data.

---

## 10. SQL Server Database

Database:

MarketplaceIntelligence

Schemas:

- stg
- dim
- fact
- analytics

The analytics schema was created for potential analytical objects, while the primary analysis deliverable will currently be maintained as SQL scripts rather than unnecessary view layers.

---

## 11. Staging Architecture

The staging layer represents the raw CSV source data loaded into SQL Server.

Principle:

Staging should preserve the source data as closely as practical.

Business transformations and dimensional modeling occur downstream.

The staging layer contains:

- stg.categories
- stg.couriers
- stg.customers
- stg.inventory
- stg.locations
- stg.orders
- stg.order_items
- stg.payments
- stg.products
- stg.promotions
- stg.returns
- stg.reviews
- stg.sellers
- stg.shipments
- stg.warehouses

All 15 staging tables were successfully loaded.

---

## 12. Staging Load Exception

Two source columns contain legitimate blank values:

- order_items.PromotionID
- shipments.ExpectedDeliveryDays

These fields were represented as VARCHAR in staging rather than forcing the raw CSV values into integer fields.

Conversion will occur downstream using safe conversion logic.

This preserves the raw source representation while allowing the dimensional model to use appropriate analytical data types.

This was a deliberate staging design decision.

---

## 13. SQL Staging Validation

The SQL staging layer was profiled after loading.

Primary keys and relational references were checked.

The objective was to verify:

- row counts
- uniqueness
- referential integrity
- valid source relationships

The staging layer passed the required validation checks.

---

## 14. Dimensional Modeling Decision

The project uses a dimensional model designed for Power BI.

The model uses multiple fact tables rather than forcing all business processes into one fact table.

The architecture is effectively a constellation/multi-fact model with shared dimensions.

---

## 15. Dimension Tables

Planned dimensions:

- DimDate
- DimCustomer
- DimProduct
- DimSeller
- DimWarehouse
- DimCourier
- DimPromotion

Surrogate keys are used in the dimensional model.

Source business identifiers such as CustomerID and ProductID are retained as attributes for traceability.

---

## 16. DimProduct Design

Category information is incorporated into DimProduct rather than creating an unnecessary snowflake relationship.

DimProduct therefore contains:

- ProductID
- ProductName
- CategoryID
- CategoryName
- SellerID
- CostPrice
- ListPrice
- ProductStatus

This keeps the Power BI model simpler and more suitable for analytical use.

---

## 17. Fact Tables

Core fact tables:

- FactOrders
- FactOrderItems
- FactPayments
- FactShipments
- FactInventory
- FactReturns

Reviews remain part of the source dataset but are not currently a core fact table.

They can support future customer-experience analysis if required by the business scope.

---

## 18. Fact Table Grain

FactOrders:

One row represents one customer order.

FactOrderItems:

One row represents one individual product line within an order.

FactPayments:

One row represents one customer payment transaction.

FactShipments:

One row represents one shipment.

FactInventory:

One row represents one product/warehouse inventory snapshot.

FactReturns:

One row represents one product return transaction.

Grain must remain explicit because incorrect grain is one of the biggest risks in analytical data modeling.

---

## 19. Views Decision

A dedicated SQL views layer was originally considered.

It was removed from the final architecture because it would provide an unnecessary additional abstraction layer for this project.

The curated dimensions and facts will be consumed directly by Power BI.

Business analysis will be maintained as SQL analysis scripts.

Views can be added by future users of the repository if they require another presentation layer.

The project prioritizes useful architecture over adding technical components for appearance.

---

## 20. SQL Analysis

The analysis layer will contain one primary comprehensive business analysis script.

It will answer business questions derived from the BRD.

Expected analytical areas include:

- marketplace sales
- revenue
- gross profit
- customer performance
- product performance
- category performance
- seller performance
- promotions and discount impact
- inventory performance
- stock/reorder risk
- returns
- shipment performance
- courier performance
- payment performance
- operational cost and leakage

Analysis must remain connected to actual business questions.

---

## 21. Power BI

Power BI will consume the curated dimensional model.

Power BI responsibilities:

- establish the semantic model
- define relationships
- create business measures
- provide executive KPIs
- provide operational analysis
- provide drill-down capability
- communicate actionable marketplace insights

The Power BI dashboard must align with the BRD.

Dashboard requirements will not be invented independently after the model is completed.

---

## 22. Git Strategy

Git is used continuously throughout development.

The project should be committed at meaningful milestones rather than only at the end.

Initial project milestone:

Initialize marketplace intelligence platform

Database milestone:

Build database and schemas

Staging milestone:

Build SQL staging layer

Dimensional-model milestone:

Build dimensional model and fact tables

Future milestones:

- Complete business analysis
- Build Power BI semantic model
- Complete Power BI dashboards
- Complete project documentation

The repository should remain clean and reproducible.

---

## 23. Current Progress

Completed:

- Business Requirements Document
- Repository creation
- MIT License
- Python environment
- Python marketplace data generation
- Python transaction generation
- Python dataset validation
- CSV generation
- SQL Server database
- SQL schemas
- SQL staging tables
- CSV bulk loading
- SQL staging validation
- dimensional model design

Current task:

Build and validate dimension and fact tables.

Remaining:

1. Complete dimensions
2. Complete fact tables
3. Validate dimensional model
4. Build comprehensive SQL business analysis
5. Build Power BI semantic model
6. Build Power BI dashboards
7. Document final architecture, methodology, KPIs, findings and limitations
8. Update README
9. Final GitHub cleanup and presentation

---

## 24. Project Rules

The following rules govern development:

1. The BRD is the source of truth.
2. Do not add features merely because they are technically interesting.
3. Do not create unnecessary architecture layers.
4. Validate before transforming.
5. Preserve source data in staging.
6. Define fact table grain explicitly.
7. Use surrogate keys in analytical dimensions.
8. Maintain traceability to source business IDs.
9. Business questions must drive analysis.
10. Power BI must align with the documented requirements.
11. Git commits should represent meaningful milestones.
12. The final project should demonstrate business impact, not just technical complexity.

---

## 25. Current Checkpoint

At this checkpoint:

Python data generation is complete.

Python validation passed.

SQL staging is complete.

SQL staging validation passed.

The next major milestone is dimensional modeling.

The immediate sequence is:

Dimensions
→ Facts
→ Dimensional model validation
→ Business analysis
→ Power BI
→ Final documentation

No additional Python development is currently required unless a genuine source-data defect is discovered.