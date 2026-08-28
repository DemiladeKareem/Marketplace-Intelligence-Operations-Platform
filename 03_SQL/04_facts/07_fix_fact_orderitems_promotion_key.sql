USE MarketplaceIntelligence;
GO

UPDATE f
SET f.PromotionKey = p.PromotionKey
FROM fact.FactOrderItems f
INNER JOIN stg.order_items s
    ON f.OrderItemID = s.OrderItemID
INNER JOIN dim.DimPromotion p
    ON TRY_CONVERT(INT, TRY_CONVERT(DECIMAL(10,1), s.PromotionID)) = p.PromotionID
WHERE s.PromotionID IS NOT NULL;
GO

SELECT
    COUNT(*) AS TotalOrderItems,
    COUNT(PromotionKey) AS PopulatedPromotionKeys,
    COUNT(*) - COUNT(PromotionKey) AS BlankPromotionKeys
FROM fact.FactOrderItems;
GO