USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS stg.categories;
DROP TABLE IF EXISTS stg.couriers;
DROP TABLE IF EXISTS stg.customers;
DROP TABLE IF EXISTS stg.inventory;
DROP TABLE IF EXISTS stg.locations;
DROP TABLE IF EXISTS stg.orders;
DROP TABLE IF EXISTS stg.order_items;
DROP TABLE IF EXISTS stg.payments;
DROP TABLE IF EXISTS stg.products;
DROP TABLE IF EXISTS stg.promotions;
DROP TABLE IF EXISTS stg.returns;
DROP TABLE IF EXISTS stg.reviews;
DROP TABLE IF EXISTS stg.sellers;
DROP TABLE IF EXISTS stg.shipments;
DROP TABLE IF EXISTS stg.warehouses;
GO

CREATE TABLE stg.categories
(
    CategoryID INT,
    CategoryName VARCHAR(100)
);
GO

CREATE TABLE stg.couriers
(
    CourierID INT,
    CourierName VARCHAR(100),
    ServiceLevel VARCHAR(50)
);
GO

CREATE TABLE stg.customers
(
    CustomerID INT,
    CustomerName VARCHAR(100),
    Email VARCHAR(150),
    City VARCHAR(100),
    Country VARCHAR(50),
    CustomerSegment VARCHAR(50),
    RegistrationDate DATE
);
GO

CREATE TABLE stg.inventory
(
    ProductID INT,
    WarehouseID INT,
    SnapshotDate DATE,
    OpeningStock INT,
    UnitsReceived INT,
    UnitsSold INT,
    UnitsReturned INT,
    ClosingStock INT,
    ReorderLevel INT
);
GO

CREATE TABLE stg.locations
(
    LocationID INT,
    City VARCHAR(100),
    Country VARCHAR(50),
    Region VARCHAR(100)
);
GO

CREATE TABLE stg.orders
(
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    PaymentMethod VARCHAR(50),
    OrderStatus VARCHAR(50),
    GrossSales DECIMAL(18,2),
    DiscountAmount DECIMAL(18,2),
    NetSales DECIMAL(18,2),
    ProductCost DECIMAL(18,2),
    GrossProfit DECIMAL(18,2)
);
GO

CREATE TABLE stg.order_items
(
    OrderItemID INT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(18,2),
    ProductCost DECIMAL(18,2),
    SellerID INT,
    PromotionID VARCHAR(20),
    DiscountRate DECIMAL(5,4),
    GrossAmount DECIMAL(18,2),
    DiscountAmount DECIMAL(18,2),
    NetAmount DECIMAL(18,2),
    ProductCostAmount DECIMAL(18,2),
    GrossProfit DECIMAL(18,2),
    OrderDate DATE,
    CustomerID INT
);
GO
CREATE TABLE stg.payments
(
    PaymentID INT,
    OrderID INT,
    CustomerID INT,
    PaymentMethod VARCHAR(50),
    NetSales DECIMAL(18,2),
    PaymentStatus VARCHAR(50),
    PaymentAmount DECIMAL(18,2)
);
GO

CREATE TABLE stg.products
(
    ProductID INT,
    ProductName VARCHAR(200),
    CategoryID INT,
    SellerID INT,
    CostPrice DECIMAL(18,2),
    ListPrice DECIMAL(18,2),
    ProductStatus VARCHAR(50)
);
GO

CREATE TABLE stg.promotions
(
    PromotionID INT,
    PromotionName VARCHAR(150),
    PromotionType VARCHAR(50),
    DiscountRate DECIMAL(5,4),
    StartDate DATE,
    EndDate DATE
);
GO

CREATE TABLE stg.returns
(
    ReturnID INT,
    OrderItemID INT,
    OrderID INT,
    ProductID INT,
    SellerID INT,
    ReturnedQuantity INT,
    ReturnReason VARCHAR(100),
    ReturnDate DATE,
    ReturnCost DECIMAL(18,2)
);
GO

CREATE TABLE stg.reviews
(
    ReviewID INT,
    OrderID INT,
    CustomerID INT,
    Rating INT,
    ReviewDate DATE,
    ReviewText VARCHAR(1000)
);
GO

CREATE TABLE stg.sellers
(
    SellerID INT,
    SellerName VARCHAR(100),
    City VARCHAR(100),
    Country VARCHAR(50),
    SellerType VARCHAR(50),
    JoinDate DATE
);
GO

CREATE TABLE stg.shipments
(
    ShipmentID INT,
    OrderID INT,
    CourierID INT,
    WarehouseID INT,
    ExpectedDeliveryDays VARCHAR(20),
    LateProbability DECIMAL(5,4),
    FailedProbability DECIMAL(5,4),
    BaseShippingCost DECIMAL(18,2),
    ShippingCost DECIMAL(18,2),
    OrderDate DATE,
    ExpectedDeliveryDate DATE,
    DeliveryDate DATE,
    DeliveryStatus VARCHAR(50)
);
GO
CREATE TABLE stg.warehouses
(
    WarehouseID INT,
    WarehouseName VARCHAR(150),
    LocationID INT,
    CapacityUnits INT
);
GO