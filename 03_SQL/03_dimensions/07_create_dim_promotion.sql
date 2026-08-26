USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS dim.DimPromotion;
GO

CREATE TABLE dim.DimPromotion
(
    PromotionKey INT IDENTITY(1,1) PRIMARY KEY,
    PromotionID INT NOT NULL,
    PromotionName VARCHAR(150),
    PromotionType VARCHAR(50),
    DiscountRate DECIMAL(5,4),
    StartDate DATE,
    EndDate DATE
);
GO

INSERT INTO dim.DimPromotion
(
    PromotionID,
    PromotionName,
    PromotionType,
    DiscountRate,
    StartDate,
    EndDate
)
SELECT
    PromotionID,
    PromotionName,
    PromotionType,
    DiscountRate,
    StartDate,
    EndDate
FROM stg.promotions;
GO

CREATE UNIQUE INDEX UX_DimPromotion_PromotionID
ON dim.DimPromotion(PromotionID);
GO