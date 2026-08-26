USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS fact.FactReturns;
GO

CREATE TABLE fact.FactReturns
(
    ReturnKey INT IDENTITY(1,1) PRIMARY KEY,
    ReturnID INT NOT NULL,
    OrderItemID INT NOT NULL,
    OrderID INT NOT NULL,
    ProductKey INT NOT NULL,
    SellerKey INT NOT NULL,
    ReturnDateKey INT NOT NULL,
    ReturnedQuantity INT,
    ReturnReason VARCHAR(100),
    ReturnCost DECIMAL(18,2)
);
GO

INSERT INTO fact.FactReturns
(
    ReturnID,
    OrderItemID,
    OrderID,
    ProductKey,
    SellerKey,
    ReturnDateKey,
    ReturnedQuantity,
    ReturnReason,
    ReturnCost
)
SELECT
    r.ReturnID,
    r.OrderItemID,
    r.OrderID,
    p.ProductKey,
    s.SellerKey,
    CONVERT(INT, CONVERT(CHAR(8), r.ReturnDate, 112)),
    r.ReturnedQuantity,
    r.ReturnReason,
    r.ReturnCost
FROM stg.returns r
INNER JOIN dim.DimProduct p
    ON r.ProductID = p.ProductID
INNER JOIN dim.DimSeller s
    ON r.SellerID = s.SellerID;
GO

CREATE UNIQUE INDEX UX_FactReturns_ReturnID
ON fact.FactReturns(ReturnID);
GO