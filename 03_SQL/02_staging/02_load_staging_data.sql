USE MarketplaceIntelligence;
GO

BULK INSERT stg.categories
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\categories.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.couriers
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\couriers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.customers
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\customers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.inventory
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\inventory.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.locations
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\locations.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.orders
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\orders.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.order_items
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\order_items.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.payments
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\payments.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.products
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\products.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.promotions
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\promotions.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.returns
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\returns.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.reviews
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\reviews.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.sellers
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\sellers.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.shipments
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\shipments.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO

BULK INSERT stg.warehouses
FROM 'C:\Demilade_Kareem_Projects\Marketplace-Intelligence-Operations-Platform\02_Data_Generation\output\warehouses.csv'
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIELDQUOTE = '"',
    TABLOCK
);
GO