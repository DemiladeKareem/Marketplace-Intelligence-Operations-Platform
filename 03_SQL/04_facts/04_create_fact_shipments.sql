USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS fact.FactShipments;
GO

CREATE TABLE fact.FactShipments
(
    ShipmentKey INT IDENTITY(1,1) PRIMARY KEY,
    ShipmentID INT NOT NULL,
    OrderID INT NOT NULL,
    CourierKey INT NOT NULL,
    WarehouseKey INT NOT NULL,
    OrderDateKey INT NOT NULL,
    ExpectedDeliveryDays INT NULL,
    LateProbability DECIMAL(5,4),
    FailedProbability DECIMAL(5,4),
    BaseShippingCost DECIMAL(18,2),
    ShippingCost DECIMAL(18,2),
    ExpectedDeliveryDate DATE,
    DeliveryDate DATE,
    DeliveryStatus VARCHAR(50)
);
GO

INSERT INTO fact.FactShipments
(
    ShipmentID,
    OrderID,
    CourierKey,
    WarehouseKey,
    OrderDateKey,
    ExpectedDeliveryDays,
    LateProbability,
    FailedProbability,
    BaseShippingCost,
    ShippingCost,
    ExpectedDeliveryDate,
    DeliveryDate,
    DeliveryStatus
)
SELECT
    sh.ShipmentID,
    sh.OrderID,
    c.CourierKey,
    w.WarehouseKey,
    CONVERT(INT, CONVERT(CHAR(8), sh.OrderDate, 112)),
    TRY_CONVERT(INT, NULLIF(sh.ExpectedDeliveryDays, '')),
    sh.LateProbability,
    sh.FailedProbability,
    sh.BaseShippingCost,
    sh.ShippingCost,
    sh.ExpectedDeliveryDate,
    sh.DeliveryDate,
    sh.DeliveryStatus
FROM stg.shipments sh
INNER JOIN dim.DimCourier c
    ON sh.CourierID = c.CourierID
INNER JOIN dim.DimWarehouse w
    ON sh.WarehouseID = w.WarehouseID;
GO

CREATE UNIQUE INDEX UX_FactShipments_ShipmentID
ON fact.FactShipments(ShipmentID);
GO