USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS fact.FactOrders;
GO

CREATE TABLE fact.FactOrders
(
    OrderKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    CustomerKey INT NOT NULL,
    OrderDateKey INT NOT NULL,
    PaymentMethod VARCHAR(50),
    OrderStatus VARCHAR(50),
    GrossSales DECIMAL(18,2),
    DiscountAmount DECIMAL(18,2),
    NetSales DECIMAL(18,2),
    ProductCost DECIMAL(18,2),
    GrossProfit DECIMAL(18,2)
);
GO

INSERT INTO fact.FactOrders
(
    OrderID,
    CustomerKey,
    OrderDateKey,
    PaymentMethod,
    OrderStatus,
    GrossSales,
    DiscountAmount,
    NetSales,
    ProductCost,
    GrossProfit
)
SELECT
    o.OrderID,
    c.CustomerKey,
    CONVERT(INT, CONVERT(CHAR(8), o.OrderDate, 112)),
    o.PaymentMethod,
    o.OrderStatus,
    o.GrossSales,
    o.DiscountAmount,
    o.NetSales,
    o.ProductCost,
    o.GrossProfit
FROM stg.orders o
INNER JOIN dim.DimCustomer c
    ON o.CustomerID = c.CustomerID;
GO

CREATE UNIQUE INDEX UX_FactOrders_OrderID
ON fact.FactOrders(OrderID);
GO