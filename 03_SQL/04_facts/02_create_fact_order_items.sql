USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS fact.FactOrderItems;
GO

CREATE TABLE fact.FactOrderItems
(
    OrderItemKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderItemID INT NOT NULL,
    OrderID INT NOT NULL,
    ProductKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    SellerKey INT NOT NULL,
    PromotionKey INT NULL,
    OrderDateKey INT NOT NULL,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    ProductCost DECIMAL(18,2),
    DiscountRate DECIMAL(5,4),
    GrossAmount DECIMAL(18,2),
    DiscountAmount DECIMAL(18,2),
    NetAmount DECIMAL(18,2),
    ProductCostAmount DECIMAL(18,2),
    GrossProfit DECIMAL(18,2)
);
GO

INSERT INTO fact.FactOrderItems
(
    OrderItemID,
    OrderID,
    ProductKey,
    CustomerKey,
    SellerKey,
    PromotionKey,
    OrderDateKey,
    Quantity,
    UnitPrice,
    ProductCost,
    DiscountRate,
    GrossAmount,
    DiscountAmount,
    NetAmount,
    ProductCostAmount,
    GrossProfit
)
SELECT
    oi.OrderItemID,
    oi.OrderID,
    p.ProductKey,
    c.CustomerKey,
    s.SellerKey,
    pr.PromotionKey,
    CONVERT(INT, CONVERT(CHAR(8), oi.OrderDate, 112)),
    oi.Quantity,
    oi.UnitPrice,
    oi.ProductCost,
    oi.DiscountRate,
    oi.GrossAmount,
    oi.DiscountAmount,
    oi.NetAmount,
    oi.ProductCostAmount,
    oi.GrossProfit
FROM stg.order_items oi
INNER JOIN dim.DimProduct p
    ON oi.ProductID = p.ProductID
INNER JOIN dim.DimCustomer c
    ON oi.CustomerID = c.CustomerID
INNER JOIN dim.DimSeller s
    ON oi.SellerID = s.SellerID
LEFT JOIN dim.DimPromotion pr
    ON TRY_CONVERT(INT, NULLIF(oi.PromotionID, '')) = pr.PromotionID;
GO

CREATE UNIQUE INDEX UX_FactOrderItems_OrderItemID
ON fact.FactOrderItems(OrderItemID);
GO