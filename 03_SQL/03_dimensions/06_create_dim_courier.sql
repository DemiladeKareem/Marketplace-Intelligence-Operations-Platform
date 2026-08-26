USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS dim.DimCourier;
GO

CREATE TABLE dim.DimCourier
(
    CourierKey INT IDENTITY(1,1) PRIMARY KEY,
    CourierID INT NOT NULL,
    CourierName VARCHAR(100),
    ServiceLevel VARCHAR(50)
);
GO

INSERT INTO dim.DimCourier
(
    CourierID,
    CourierName,
    ServiceLevel
)
SELECT
    CourierID,
    CourierName,
    ServiceLevel
FROM stg.couriers;
GO

CREATE UNIQUE INDEX UX_DimCourier_CourierID
ON dim.DimCourier(CourierID);
GO