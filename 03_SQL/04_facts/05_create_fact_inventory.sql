USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS fact.FactInventory;
GO

CREATE TABLE fact.FactInventory
(
    InventoryKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductKey INT NOT NULL,
    WarehouseKey INT NOT NULL,
    SnapshotDateKey INT NOT NULL,
    OpeningStock INT,
    UnitsReceived INT,
    UnitsSold INT,
    UnitsReturned INT,
    ClosingStock INT,
    ReorderLevel INT
);
GO

INSERT INTO fact.FactInventory
(
    ProductKey,
    WarehouseKey,
    SnapshotDateKey,
    OpeningStock,
    UnitsReceived,
    UnitsSold,
    UnitsReturned,
    ClosingStock,
    ReorderLevel
)
SELECT
    p.ProductKey,
    w.WarehouseKey,
    CONVERT(INT, CONVERT(CHAR(8), i.SnapshotDate, 112)),
    i.OpeningStock,
    i.UnitsReceived,
    i.UnitsSold,
    i.UnitsReturned,
    i.ClosingStock,
    i.ReorderLevel
FROM stg.inventory i
INNER JOIN dim.DimProduct p
    ON i.ProductID = p.ProductID
INNER JOIN dim.DimWarehouse w
    ON i.WarehouseID = w.WarehouseID;
GO