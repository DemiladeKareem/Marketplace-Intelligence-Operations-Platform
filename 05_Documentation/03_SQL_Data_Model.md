# SQL Data Model

## Overview

The SQL layer transforms the generated marketplace CSV files into a structured analytical database designed for reporting and business intelligence.

The database was implemented in Microsoft SQL Server using a staged dimensional modeling approach.

The final model follows a star-schema-oriented architecture in which descriptive dimensions provide business context for transactional fact tables.

---

## Database

**Database:** `MarketplaceIntelligence`

### Schemas

| Schema | Purpose |
|---|---|
| `stg` | Raw source data loaded from generated CSV files |
| `dim` | Business dimensions used for descriptive analysis |
| `fact` | Transactional and operational measures |
| `analytics` | Analytical layer for reusable analysis |

---

## Data Flow

The project follows this general flow:

```text
Python Data Generation
        ↓
CSV Source Files
        ↓
SQL Server Staging
        ↓
Dimensional Transformation
        ↓
Dimension Tables
        ↓
Fact Tables
        ↓
Analytical Queries
        ↓
Power BI
The staging layer preserves the source structure before dimensional transformation.

Surrogate keys are introduced during dimensional modeling to support stable relationships between dimensions and facts.

Dimension Tables

The analytical model contains the following major dimensions:

dim.DimCustomer
dim.DimSeller
dim.DimProduct
dim.DimCourier
dim.DimWarehouse
dim.DimDate
dim.DimPromotion

The dimensions provide descriptive attributes such as:

Customer segment
Customer geography
Seller type
Product category
Product status
Courier service level
Warehouse location
Calendar attributes
Promotion type
Promotion name
Discount rate
Fact Tables

The model contains the following major fact tables:

fact.FactOrders
fact.FactOrderItems
fact.FactShipments
fact.FactPayments
fact.FactInventory
fact.FactReturns

These tables represent different business processes and grains.

FactOrders

Order-level transactional information including:

Order
Customer
Order date
Gross sales
Discount amount
Net sales
Gross profit
Order status
FactOrderItems

Line-item level information including:

Order item
Product
Customer
Promotion
Gross amount
Discount
Net amount
Gross profit
Product cost
Product sales

This table is particularly important for product, category, seller, and promotion analysis because product-level dimensions naturally operate at the order-item grain.

FactShipments

Shipment-level operational information including:

Shipment
Order
Courier
Warehouse
Delivery date
Delivery status
Expected delivery date
Shipping cost
Late probability
Failed probability
FactPayments

Payment-level information including:

Payment
Order
Customer
Payment date
Payment amount
Payment method
Payment status
FactInventory

Inventory snapshot information including:

Inventory snapshot
Product
Warehouse
Opening stock
Closing stock
Units sold
Units received
Units returned
Reorder level
FactReturns

Return-level information including:

Return
Order
Order item
Product
Return date
Returned quantity
Return cost
Return reason
Date Modeling

A dedicated dim.DimDate table supports time-based analysis.

Calendar attributes include:

Date key
Full date
Day
Month
Month number
Quarter
Quarter number
Year
Weekend indicator

This enables consistent time intelligence across the Power BI model.

Relationship Design

The Power BI model uses one-to-many relationships from dimensions into fact tables wherever the business grain supports it.

Examples include:

DimCustomer  → FactOrders
DimCustomer  → FactOrderItems
DimProduct   → FactOrderItems
DimProduct   → FactInventory
DimProduct   → FactReturns
DimSeller    → DimProduct
DimCourier   → FactShipments
DimWarehouse → FactShipments
DimWarehouse → FactInventory
DimDate      → FactOrders
DimDate      → FactShipments
DimDate      → FactPayments
DimDate      → FactInventory
DimDate      → FactReturns
DimPromotion → FactOrderItems

The model was reviewed in Power BI to ensure the required relationships were active and usable for dashboard analysis.


## Modeling Decisions

A major modeling principle was maintaining the correct analytical grain.

For example, product and category analysis uses FactOrderItems rather than forcing product attributes through the order-level sales table.

This distinction was important when creating measures such as item-level net sales and gross margin.

Similarly, inventory analysis was treated separately from warehouse capacity because inventory snapshots and static warehouse capacity represent different grains.

Views

The project deliberately does not depend on a large collection of SQL views.

The dimensional model and fact tables provide the analytical foundation required by Power BI.

Reusable analytical views could be created by future users depending on their reporting requirements, but creating views solely for this project would add unnecessary duplication to the architecture.

The analytical SQL layer therefore remains focused on business analysis rather than duplicating the dimensional model.

Database Correction as Part of the Build

The project also demonstrates that the database remains an active part of the BI workflow.

A promotion-key data-quality issue was corrected directly in SQL Server using DML.

After the update, Power BI was refreshed and the corrected promotion relationships became available to the dashboard without creating a separate Power BI table.

This illustrates the connected nature of the architecture:

SQL Server Data
      ↓
Relationship Model
      ↓
Power BI Refresh
      ↓
Updated Analysis