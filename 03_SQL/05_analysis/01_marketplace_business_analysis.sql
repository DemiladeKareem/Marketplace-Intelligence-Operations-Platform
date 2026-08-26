USE MarketplaceIntelligence;
GO

SELECT
    COUNT(*) AS TotalOrders,
    SUM(GrossSales) AS GrossSales,
    SUM(DiscountAmount) AS TotalDiscounts,
    SUM(NetSales) AS NetSales,
    SUM(ProductCost) AS ProductCost,
    SUM(GrossProfit) AS GrossProfit,
    CAST(SUM(GrossProfit) / NULLIF(SUM(NetSales), 0) * 100 AS DECIMAL(10,2)) AS GrossMarginPct,
    CAST(SUM(NetSales) / NULLIF(COUNT(*), 0) AS DECIMAL(18,2)) AS AverageOrderValue
FROM fact.FactOrders;
GO

SELECT
    d.Year,
    d.MonthNumber,
    d.MonthName,
    SUM(f.NetSales) AS NetSales,
    SUM(f.GrossProfit) AS GrossProfit,
    COUNT(DISTINCT f.OrderID) AS Orders
FROM fact.FactOrders f
INNER JOIN dim.DimDate d
    ON f.OrderDateKey = d.DateKey
GROUP BY
    d.Year,
    d.MonthNumber,
    d.MonthName
ORDER BY
    d.Year,
    d.MonthNumber;
GO

SELECT TOP 20
    p.ProductID,
    p.ProductName,
    p.CategoryName,
    SUM(f.NetAmount) AS NetSales,
    SUM(f.GrossProfit) AS GrossProfit,
    CAST(SUM(f.GrossProfit) / NULLIF(SUM(f.NetAmount), 0) * 100 AS DECIMAL(10,2)) AS GrossMarginPct,
    SUM(f.Quantity) AS UnitsSold
FROM fact.FactOrderItems f
INNER JOIN dim.DimProduct p
    ON f.ProductKey = p.ProductKey
GROUP BY
    p.ProductID,
    p.ProductName,
    p.CategoryName
ORDER BY
    NetSales DESC;
GO

SELECT
    p.CategoryName,
    SUM(f.NetAmount) AS NetSales,
    SUM(f.GrossProfit) AS GrossProfit,
    SUM(f.Quantity) AS UnitsSold,
    CAST(SUM(f.GrossProfit) / NULLIF(SUM(f.NetAmount), 0) * 100 AS DECIMAL(10,2)) AS GrossMarginPct
FROM fact.FactOrderItems f
INNER JOIN dim.DimProduct p
    ON f.ProductKey = p.ProductKey
GROUP BY
    p.CategoryName
ORDER BY
    NetSales DESC;
GO

SELECT TOP 20
    s.SellerID,
    s.SellerName,
    s.SellerType,
    SUM(f.NetAmount) AS NetSales,
    SUM(f.GrossProfit) AS GrossProfit,
    SUM(f.Quantity) AS UnitsSold,
    CAST(SUM(f.GrossProfit) / NULLIF(SUM(f.NetAmount), 0) * 100 AS DECIMAL(10,2)) AS GrossMarginPct
FROM fact.FactOrderItems f
INNER JOIN dim.DimSeller s
    ON f.SellerKey = s.SellerKey
GROUP BY
    s.SellerID,
    s.SellerName,
    s.SellerType
ORDER BY
    NetSales DESC;
GO

SELECT
    c.CustomerSegment,
    COUNT(DISTINCT f.CustomerKey) AS Customers,
    SUM(f.NetSales) AS NetSales,
    SUM(f.GrossProfit) AS GrossProfit,
    COUNT(*) AS Orders,
    CAST(SUM(f.NetSales) / NULLIF(COUNT(DISTINCT f.CustomerKey), 0) AS DECIMAL(18,2)) AS RevenuePerCustomer
FROM fact.FactOrders f
INNER JOIN dim.DimCustomer c
    ON f.CustomerKey = c.CustomerKey
GROUP BY
    c.CustomerSegment
ORDER BY
    NetSales DESC;
GO

SELECT TOP 20
    c.CustomerID,
    c.CustomerName,
    c.CustomerSegment,
    SUM(f.NetSales) AS NetSales,
    SUM(f.GrossProfit) AS GrossProfit,
    COUNT(*) AS Orders
FROM fact.FactOrders f
INNER JOIN dim.DimCustomer c
    ON f.CustomerKey = c.CustomerKey
GROUP BY
    c.CustomerID,
    c.CustomerName,
    c.CustomerSegment
ORDER BY
    NetSales DESC;
GO

SELECT
    SUM(GrossSales) AS GrossSales,
    SUM(DiscountAmount) AS DiscountAmount,
    CAST(SUM(DiscountAmount) / NULLIF(SUM(GrossSales), 0) * 100 AS DECIMAL(10,2)) AS DiscountRatePct,
    SUM(NetSales) AS NetSales,
    SUM(GrossProfit) AS GrossProfit
FROM fact.FactOrders;
GO

SELECT
    CASE
        WHEN PromotionKey IS NULL THEN 'No Promotion'
        ELSE 'Promotion Applied'
    END AS PromotionStatus,
    COUNT(*) AS OrderItems,
    SUM(NetAmount) AS NetSales,
    SUM(DiscountAmount) AS DiscountAmount,
    SUM(GrossProfit) AS GrossProfit,
    CAST(SUM(GrossProfit) / NULLIF(SUM(NetAmount), 0) * 100 AS DECIMAL(10,2)) AS GrossMarginPct
FROM fact.FactOrderItems
GROUP BY
    CASE
        WHEN PromotionKey IS NULL THEN 'No Promotion'
        ELSE 'Promotion Applied'
    END;
GO

SELECT
    pr.PromotionID,
    pr.PromotionName,
    pr.PromotionType,
    COUNT(f.OrderItemKey) AS OrderItems,
    SUM(f.NetAmount) AS NetSales,
    SUM(f.DiscountAmount) AS DiscountAmount,
    SUM(f.GrossProfit) AS GrossProfit
FROM fact.FactOrderItems f
INNER JOIN dim.DimPromotion pr
    ON f.PromotionKey = pr.PromotionKey
GROUP BY
    pr.PromotionID,
    pr.PromotionName,
    pr.PromotionType
ORDER BY
    NetSales DESC;
GO

SELECT
    p.CategoryName,
    SUM(i.ClosingStock) AS ClosingStock,
    SUM(i.UnitsReceived) AS UnitsReceived,
    SUM(i.UnitsSold) AS UnitsSold,
    SUM(i.UnitsReturned) AS UnitsReturned,
    SUM(i.ReorderLevel) AS ReorderLevel,
    SUM(CASE WHEN i.ClosingStock <= i.ReorderLevel THEN 1 ELSE 0 END) AS ReorderRiskRecords
FROM fact.FactInventory i
INNER JOIN dim.DimProduct p
    ON i.ProductKey = p.ProductKey
GROUP BY
    p.CategoryName
ORDER BY
    ClosingStock DESC;
GO

SELECT TOP 30
    p.ProductID,
    p.ProductName,
    p.CategoryName,
    w.WarehouseName,
    i.SnapshotDateKey,
    i.ClosingStock,
    i.ReorderLevel,
    i.UnitsSold
FROM fact.FactInventory i
INNER JOIN dim.DimProduct p
    ON i.ProductKey = p.ProductKey
INNER JOIN dim.DimWarehouse w
    ON i.WarehouseKey = w.WarehouseKey
WHERE i.ClosingStock <= i.ReorderLevel
ORDER BY
    i.ClosingStock ASC;
GO

SELECT
    r.ReturnReason,
    COUNT(*) AS ReturnCount,
    SUM(r.ReturnedQuantity) AS ReturnedUnits,
    SUM(r.ReturnCost) AS ReturnCost
FROM fact.FactReturns r
GROUP BY
    r.ReturnReason
ORDER BY
    ReturnCost DESC;
GO

SELECT
    p.CategoryName,
    SUM(r.ReturnedQuantity) AS ReturnedUnits,
    SUM(r.ReturnCost) AS ReturnCost
FROM fact.FactReturns r
INNER JOIN dim.DimProduct p
    ON r.ProductKey = p.ProductKey
GROUP BY
    p.CategoryName
ORDER BY
    ReturnCost DESC;
GO

SELECT
    c.CourierName,
    c.ServiceLevel,
    COUNT(*) AS Shipments,
    SUM(f.ShippingCost) AS ShippingCost,
    SUM(f.BaseShippingCost) AS BaseShippingCost,
    SUM(f.ShippingCost - f.BaseShippingCost) AS ShippingVariance,
    SUM(CASE WHEN f.DeliveryStatus = 'Late' THEN 1 ELSE 0 END) AS LateShipments,
    SUM(CASE WHEN f.DeliveryStatus = 'Failed' THEN 1 ELSE 0 END) AS FailedShipments
FROM fact.FactShipments f
INNER JOIN dim.DimCourier c
    ON f.CourierKey = c.CourierKey
GROUP BY
    c.CourierName,
    c.ServiceLevel
ORDER BY
    ShippingCost DESC;
GO

SELECT
    f.DeliveryStatus,
    COUNT(*) AS Shipments,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(10,2)) AS ShipmentPct,
    SUM(f.ShippingCost) AS ShippingCost
FROM fact.FactShipments f
GROUP BY
    f.DeliveryStatus
ORDER BY
    Shipments DESC;
GO

SELECT
    w.WarehouseName,
    COUNT(*) AS InventoryRecords,
    SUM(i.ClosingStock) AS ClosingStock,
    SUM(i.UnitsReceived) AS UnitsReceived,
    SUM(i.UnitsSold) AS UnitsSold,
    SUM(CASE WHEN i.ClosingStock <= i.ReorderLevel THEN 1 ELSE 0 END) AS ReorderRiskRecords
FROM fact.FactInventory i
INNER JOIN dim.DimWarehouse w
    ON i.WarehouseKey = w.WarehouseKey
GROUP BY
    w.WarehouseName
ORDER BY
    ReorderRiskRecords DESC;
GO

SELECT
    PaymentStatus,
    COUNT(*) AS Payments,
    SUM(PaymentAmount) AS PaymentAmount,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(10,2)) AS PaymentPct
FROM fact.FactPayments
GROUP BY
    PaymentStatus
ORDER BY
    Payments DESC;
GO