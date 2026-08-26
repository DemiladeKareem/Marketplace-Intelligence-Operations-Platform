USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS dim.DimCustomer;
GO

CREATE TABLE dim.DimCustomer
(
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    CustomerName VARCHAR(100),
    Email VARCHAR(150),
    City VARCHAR(100),
    Country VARCHAR(50),
    CustomerSegment VARCHAR(50),
    RegistrationDate DATE
);
GO

INSERT INTO dim.DimCustomer
(
    CustomerID,
    CustomerName,
    Email,
    City,
    Country,
    CustomerSegment,
    RegistrationDate
)
SELECT
    CustomerID,
    CustomerName,
    Email,
    City,
    Country,
    CustomerSegment,
    RegistrationDate
FROM stg.customers;
GO

CREATE UNIQUE INDEX UX_DimCustomer_CustomerID
ON dim.DimCustomer(CustomerID);
GO