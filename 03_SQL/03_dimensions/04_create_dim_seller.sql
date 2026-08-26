USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS dim.DimSeller;
GO

CREATE TABLE dim.DimSeller
(
    SellerKey INT IDENTITY(1,1) PRIMARY KEY,
    SellerID INT NOT NULL,
    SellerName VARCHAR(100),
    City VARCHAR(100),
    Country VARCHAR(50),
    SellerType VARCHAR(50),
    JoinDate DATE
);
GO

INSERT INTO dim.DimSeller
(
    SellerID,
    SellerName,
    City,
    Country,
    SellerType,
    JoinDate
)
SELECT
    SellerID,
    SellerName,
    City,
    Country,
    SellerType,
    JoinDate
FROM stg.sellers;
GO

CREATE UNIQUE INDEX UX_DimSeller_SellerID
ON dim.DimSeller(SellerID);
GO