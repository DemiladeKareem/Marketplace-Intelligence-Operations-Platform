USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS dim.DimProduct;
GO

CREATE TABLE dim.DimProduct
(
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT NOT NULL,
    ProductName VARCHAR(200),
    CategoryID INT,
    CategoryName VARCHAR(100),
    SellerID INT,
    CostPrice DECIMAL(18,2),
    ListPrice DECIMAL(18,2),
    ProductStatus VARCHAR(50)
);
GO

INSERT INTO dim.DimProduct
(
    ProductID,
    ProductName,
    CategoryID,
    CategoryName,
    SellerID,
    CostPrice,
    ListPrice,
    ProductStatus
)
SELECT
    p.ProductID,
    p.ProductName,
    p.CategoryID,
    c.CategoryName,
    p.SellerID,
    p.CostPrice,
    p.ListPrice,
    p.ProductStatus
FROM stg.products p
LEFT JOIN stg.categories c
    ON p.CategoryID = c.CategoryID;
GO

CREATE UNIQUE INDEX UX_DimProduct_ProductID
ON dim.DimProduct(ProductID);
GO