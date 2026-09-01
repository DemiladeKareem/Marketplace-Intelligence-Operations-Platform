
# 04 — Power BI Dashboard

```markdown
# Power BI Dashboard

## Overview

The Power BI dashboard translates the marketplace dimensional model into an executive-facing analytical experience.

The dashboard is organized around four business perspectives:

1. Executive Overview
2. Commercial Performance
3. Operations & Fulfillment
4. Product & Seller Performance

The design intentionally combines executive KPIs with diagnostic visuals so that users can move from overall performance to the underlying commercial and operational drivers.

---

# Page 1 — Executive Overview

### Purpose

Provides an enterprise-level view of marketplace performance, customer value, and fulfillment health.

### KPI Cards

- Net Sales
- Gross Profit
- Gross Margin %
- Orders
- Customers
- Average Order Value

### Filters

- Year
- Customer Segment
- Category Name

### Visuals

**Monthly Sales & Profitability**

Tracks monthly net sales and gross margin to show commercial performance over time.

**Category Performance: Scale vs Profitability**

A bubble scatter plot comparing category-level item net sales against gross margin, with bubble size representing units sold.

Item-level measures were used because product and category analysis operates through `FactOrderItems`.

No average/reference line was added because the synthetic categories cluster relatively closely around the same performance range. Adding an artificial benchmark could imply an unsupported distinction between above-average and below-average categories.

**Fulfillment Outcomes**

Shows the distribution of on-time, late, and failed shipments.

**Customer Segment Contribution**

Compares net sales contribution across customer segments.

**Courier Cost vs Delivery Reliability**

Compares average shipping cost against delivery reliability across courier partners.

---

# Page 2 — Commercial Performance

### Purpose

Examines sales drivers, order activity, customer demand, promotions, and discount behavior.

### KPI Cards

- Net Sales
- Orders
- Units Sold
- Discount Rate
- Average Order Value

### Filters

- Promotion Type
- Customer Segment
- Category Name

### Visuals

**Monthly Sales & Order Activity**

Combines monthly net sales with order activity to examine changes in sales and transaction volume.

**Category Revenue Contribution**

Ranks categories by revenue contribution.

**Top 10 Promotions by Net Sales**

Highlights the highest-performing promotions based on item-level net sales.

Promotion analysis uses the corrected promotion relationship in `FactOrderItems`.

**Discount Intensity vs Net Sales**

Examines the relationship between discount rate and net sales across categories.

**Customer Segment: Orders vs Order Value**

Compares order volume with average order value across customer segments.

---

# Page 3 — Operations & Fulfillment

### Purpose

Focuses on delivery reliability, courier performance, fulfillment risk, and shipping economics.

### KPI Cards

- Total Shipments
- On-Time Delivery %
- Late Delivery %
- Failed Delivery %
- Total Shipping Cost

### Filters

- Year
- Courier Name
- Warehouse Name
- Delivery Status

### Visuals

**Monthly Delivery Reliability**

Tracks on-time, late, and failed delivery rates over time.

The relatively stable distribution reflects the fixed operational probabilities used during synthetic shipment generation.

**Courier Performance & Cost**

A matrix comparing:

- On-Time Delivery %
- Late Delivery %
- Failed Delivery %
- Total Shipments
- Average Shipping Cost

Conditional formatting and in-cell data bars provide rapid comparison without requiring multiple additional charts.

**Courier Cost vs Delivery Reliability**

Identifies the relationship between shipping cost and delivery performance across couriers.

**Fulfillment Status Distribution**

Provides an executive view of total shipment outcomes using a donut chart with the overall shipment volume displayed centrally.

---

# Page 4 — Product & Seller Performance

### Purpose

Examines product portfolio performance, seller contribution, seller economics, and marketplace product distribution.

### KPI Cards

- Total Products Sold
- Net Sales
- Gross Margin %
- Gross Profit

### Filters

- Year
- Category Name
- Product Status

### Visuals

**Product Revenue Contribution**

A treemap showing category and product-level revenue contribution.

Category-to-product drill-down allows users to move from portfolio-level performance into individual products without overcrowding the initial view.

**Top Sellers by Net Sales**

Ranks the highest-performing sellers by net sales.

**Product Portfolio Status**

Shows the distribution of active and inactive products.

**Average Order Value by Seller Type**

Compares average order value across seller types.

**Seller Performance Detail**

A compact analytical matrix containing:

- Seller Name
- Products Sold
- Net Sales
- Item Gross Profit
- Gross Margin %

This provides detailed seller-level information without requiring another large visual.

---

## Interactive Design

The dashboard uses:

- Slicers
- Cross-filtering
- Drill-down
- Tooltips
- Reset buttons
- Active dimension relationships
- Conditional formatting
- Data bars
- KPI cards
- Analytical matrices

The interaction design allows users to move between executive summaries and detailed business segments without requiring separate dashboards for every question.

---

## Measure Design

Measures were created according to the grain of the underlying fact table.

Examples include:

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

Item-level measures were used where product, seller, category, or promotion dimensions depend on `FactOrderItems`.

This prevented inappropriate filter behavior caused by attempting to analyze item-level attributes through the order-level sales fact.

---

## Data Refresh

The Power BI model is connected to the SQL Server analytical database.

Consequently, corrections made to the underlying SQL tables become available to Power BI after a model refresh.

This was demonstrated during the promotion-key correction, where the database was corrected through SQL Server DML and the updated promotion relationships became available in Power BI after refresh.

---

## Dashboard Design Philosophy

The dashboard prioritizes:

- Business questions over visual quantity
- Correct analytical grain
- Clear executive hierarchy
- Minimal visual redundancy
- Appropriate visual selection
- Interactive exploration
- Operational usefulness
- Honest interpretation of synthetic data

The objective is not to maximize the number of charts, but to make each visual answer a distinct business question.