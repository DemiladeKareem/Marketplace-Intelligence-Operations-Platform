USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS fact.FactPayments;
GO

CREATE TABLE fact.FactPayments
(
    PaymentKey INT IDENTITY(1,1) PRIMARY KEY,
    PaymentID INT NOT NULL,
    OrderID INT NOT NULL,
    CustomerKey INT NOT NULL,
    PaymentDateKey INT NOT NULL,
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(50),
    NetSales DECIMAL(18,2),
    PaymentAmount DECIMAL(18,2)
);
GO

INSERT INTO fact.FactPayments
(
    PaymentID,
    OrderID,
    CustomerKey,
    PaymentDateKey,
    PaymentMethod,
    PaymentStatus,
    NetSales,
    PaymentAmount
)
SELECT
    p.PaymentID,
    p.OrderID,
    c.CustomerKey,
    o.OrderDateKey,
    p.PaymentMethod,
    p.PaymentStatus,
    p.NetSales,
    p.PaymentAmount
FROM stg.payments p
INNER JOIN dim.DimCustomer c
    ON p.CustomerID = c.CustomerID
INNER JOIN fact.FactOrders o
    ON p.OrderID = o.OrderID;
GO

CREATE UNIQUE INDEX UX_FactPayments_PaymentID
ON fact.FactPayments(PaymentID);
GO