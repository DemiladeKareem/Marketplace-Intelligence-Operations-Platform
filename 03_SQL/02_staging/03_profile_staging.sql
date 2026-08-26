USE MarketplaceIntelligence;
GO

SELECT
    'customers' AS TableName,
    COUNT(*) AS Row_Count,
    COUNT(DISTINCT CustomerID) AS DistinctCustomerIDs,
    COUNT(*) - COUNT(DISTINCT CustomerID) AS DuplicateCustomerIDs
FROM stg.customers
UNION ALL
SELECT
    'sellers',
    COUNT(*),
    COUNT(DISTINCT SellerID),
    COUNT(*) - COUNT(DISTINCT SellerID)
FROM stg.sellers
UNION ALL
SELECT
    'products',
    COUNT(*),
    COUNT(DISTINCT ProductID),
    COUNT(*) - COUNT(DISTINCT ProductID)
FROM stg.products
UNION ALL
SELECT
    'orders',
    COUNT(*),
    COUNT(DISTINCT OrderID),
    COUNT(*) - COUNT(DISTINCT OrderID)
FROM stg.orders
UNION ALL
SELECT
    'order_items',
    COUNT(*),
    COUNT(DISTINCT OrderItemID),
    COUNT(*) - COUNT(DISTINCT OrderItemID)
FROM stg.order_items
UNION ALL
SELECT
    'payments',
    COUNT(*),
    COUNT(DISTINCT PaymentID),
    COUNT(*) - COUNT(DISTINCT PaymentID)
FROM stg.payments
UNION ALL
SELECT
    'shipments',
    COUNT(*),
    COUNT(DISTINCT ShipmentID),
    COUNT(*) - COUNT(DISTINCT ShipmentID)
FROM stg.shipments
UNION ALL
SELECT
    'returns',
    COUNT(*),
    COUNT(DISTINCT ReturnID),
    COUNT(*) - COUNT(DISTINCT ReturnID)
FROM stg.returns
UNION ALL
SELECT
    'reviews',
    COUNT(*),
    COUNT(DISTINCT ReviewID),
    COUNT(*) - COUNT(DISTINCT ReviewID)
FROM stg.reviews;
GO

SELECT COUNT(*) AS InvalidOrderCustomers
FROM stg.orders o
LEFT JOIN stg.customers c
    ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;
GO

SELECT COUNT(*) AS InvalidOrderItemsOrders
FROM stg.order_items oi
LEFT JOIN stg.orders o
    ON oi.OrderID = o.OrderID
WHERE o.OrderID IS NULL;
GO

SELECT COUNT(*) AS InvalidOrderItemsProducts
FROM stg.order_items oi
LEFT JOIN stg.products p
    ON oi.ProductID = p.ProductID
WHERE p.ProductID IS NULL;
GO

SELECT COUNT(*) AS InvalidOrderItemsSellers
FROM stg.order_items oi
LEFT JOIN stg.sellers s
    ON oi.SellerID = s.SellerID
WHERE s.SellerID IS NULL;
GO

SELECT COUNT(*) AS InvalidPaymentsOrders
FROM stg.payments p
LEFT JOIN stg.orders o
    ON p.OrderID = o.OrderID
WHERE o.OrderID IS NULL;
GO

SELECT COUNT(*) AS InvalidShipmentsOrders
FROM stg.shipments s
LEFT JOIN stg.orders o
    ON s.OrderID = o.OrderID
WHERE o.OrderID IS NULL;
GO

SELECT COUNT(*) AS InvalidInventoryProducts
FROM stg.inventory i
LEFT JOIN stg.products p
    ON i.ProductID = p.ProductID
WHERE p.ProductID IS NULL;
GO

SELECT COUNT(*) AS InvalidInventoryWarehouses
FROM stg.inventory i
LEFT JOIN stg.warehouses w
    ON i.WarehouseID = w.WarehouseID
WHERE w.WarehouseID IS NULL;
GO