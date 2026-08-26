USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS dim.DimWarehouse;
GO

CREATE TABLE dim.DimWarehouse
(
    WarehouseKey INT IDENTITY(1,1) PRIMARY KEY,
    WarehouseID INT NOT NULL,
    WarehouseName VARCHAR(150),
    LocationID INT,
    City VARCHAR(100),
    Country VARCHAR(50),
    Region VARCHAR(100),
    CapacityUnits INT
);
GO

INSERT INTO dim.DimWarehouse
(
    WarehouseID,
    WarehouseName,
    LocationID,
    City,
    Country,
    Region,
    CapacityUnits
)
SELECT
    w.WarehouseID,
    w.WarehouseName,
    w.LocationID,
    l.City,
    l.Country,
    l.Region,
    w.CapacityUnits
FROM stg.warehouses w
LEFT JOIN stg.locations l
    ON w.LocationID = l.LocationID;
GO

CREATE UNIQUE INDEX UX_DimWarehouse_WarehouseID
ON dim.DimWarehouse(WarehouseID);
GO