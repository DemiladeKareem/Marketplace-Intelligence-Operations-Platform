USE MarketplaceIntelligence;
GO

DROP TABLE IF EXISTS dim.DimDate;
GO

CREATE TABLE dim.DimDate
(
    DateKey INT PRIMARY KEY,
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    QuarterNumber INT NOT NULL,
    QuarterName VARCHAR(10) NOT NULL,
    MonthNumber INT NOT NULL,
    MonthName VARCHAR(20) NOT NULL,
    YearMonth VARCHAR(7) NOT NULL,
    WeekNumber INT NOT NULL,
    DayOfMonth INT NOT NULL,
    DayName VARCHAR(20) NOT NULL,
    IsWeekend BIT NOT NULL
);
GO

DECLARE @StartDate DATE;
DECLARE @EndDate DATE;

SELECT
    @StartDate = MIN(OrderDate),
    @EndDate = MAX(OrderDate)
FROM stg.orders;

;WITH DateSeries AS
(
    SELECT @StartDate AS FullDate

    UNION ALL

    SELECT DATEADD(DAY, 1, FullDate)
    FROM DateSeries
    WHERE FullDate < @EndDate
)
INSERT INTO dim.DimDate
(
    DateKey,
    FullDate,
    Year,
    QuarterNumber,
    QuarterName,
    MonthNumber,
    MonthName,
    YearMonth,
    WeekNumber,
    DayOfMonth,
    DayName,
    IsWeekend
)
SELECT
    CONVERT(INT, CONVERT(CHAR(8), FullDate, 112)),
    FullDate,
    YEAR(FullDate),
    DATEPART(QUARTER, FullDate),
    'Q' + CAST(DATEPART(QUARTER, FullDate) AS VARCHAR(1)),
    MONTH(FullDate),
    DATENAME(MONTH, FullDate),
    CONVERT(CHAR(7), FullDate, 120),
    DATEPART(WEEK, FullDate),
    DAY(FullDate),
    DATENAME(WEEKDAY, FullDate),
    CASE WHEN DATEPART(WEEKDAY, FullDate) IN (1, 7) THEN 1 ELSE 0 END
FROM DateSeries
OPTION (MAXRECURSION 0);
GO