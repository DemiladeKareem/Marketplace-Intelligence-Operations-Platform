import pandas as pd
import numpy as np
from faker import Faker
from pathlib import Path

fake = Faker()
rng = np.random.default_rng(42)

BASE_DIR = Path(__file__).resolve().parents[1]
OUTPUT_DIR = BASE_DIR / "output"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

NUM_CUSTOMERS = 50_000
NUM_SELLERS = 500
NUM_PRODUCTS = 5_000
NUM_LOCATIONS = 50
NUM_WAREHOUSES = 15
NUM_COURIERS = 10
NUM_PROMOTIONS = 100

categories = [
    "Phones & Tablets",
    "Computing",
    "Electronics",
    "Home & Kitchen",
    "Fashion",
    "Beauty",
    "Health",
    "Groceries",
    "Baby Products",
    "Sports & Fitness",
    "Automotive",
    "Books",
    "Gaming",
    "Appliances",
    "Furniture",
    "Office Supplies",
    "Jewelry",
    "Shoes",
    "Tools",
    "Pet Supplies",
    "Travel",
    "Garden",
    "Toys",
    "Musical Instruments",
    "Accessories"
]

nigerian_cities = [
    "Lagos",
    "Abuja",
    "Ibadan",
    "Kano",
    "Port Harcourt",
    "Benin City",
    "Enugu",
    "Kaduna",
    "Jos",
    "Ilorin",
    "Abeokuta",
    "Akure",
    "Owerri",
    "Uyo",
    "Calabar",
    "Warri",
    "Sokoto",
    "Onitsha",
    "Ado-Ekiti",
    "Osogbo"
]

customer_segments = [
    "New",
    "Occasional",
    "Regular",
    "High Value",
    "Discount Sensitive"
]

seller_types = [
    "High Volume",
    "High Margin",
    "Discount Heavy",
    "Premium",
    "Standard"
]

customers = pd.DataFrame({
    "CustomerID": np.arange(1, NUM_CUSTOMERS + 1),
    "CustomerName": [fake.name() for _ in range(NUM_CUSTOMERS)],
    "Email": [fake.email() for _ in range(NUM_CUSTOMERS)],
    "City": rng.choice(nigerian_cities, NUM_CUSTOMERS),
    "Country": "Nigeria",
    "CustomerSegment": rng.choice(
        customer_segments,
        NUM_CUSTOMERS,
        p=[0.18, 0.25, 0.30, 0.12, 0.15]
    ),
    "RegistrationDate": pd.to_datetime(
        rng.choice(
            pd.date_range("2022-01-01", "2025-12-31"),
            NUM_CUSTOMERS
        )
    )
})

sellers = pd.DataFrame({
    "SellerID": np.arange(1, NUM_SELLERS + 1),
    "SellerName": [fake.company() for _ in range(NUM_SELLERS)],
    "City": rng.choice(nigerian_cities, NUM_SELLERS),
    "Country": "Nigeria",
    "SellerType": rng.choice(
        seller_types,
        NUM_SELLERS,
        p=[0.25, 0.15, 0.15, 0.15, 0.30]
    ),
    "JoinDate": pd.to_datetime(
        rng.choice(
            pd.date_range("2021-01-01", "2025-06-30"),
            NUM_SELLERS
        )
    )
})

category_df = pd.DataFrame({
    "CategoryID": np.arange(1, len(categories) + 1),
    "CategoryName": categories
})

locations = pd.DataFrame({
    "LocationID": np.arange(1, NUM_LOCATIONS + 1),
    "City": rng.choice(nigerian_cities, NUM_LOCATIONS),
    "Country": "Nigeria",
    "Region": rng.choice(
        ["South West", "South South", "South East", "North Central", "North West"],
        NUM_LOCATIONS
    )
})

warehouses = pd.DataFrame({
    "WarehouseID": np.arange(1, NUM_WAREHOUSES + 1),
    "WarehouseName": [
        f"Warehouse {i:03d}" for i in range(1, NUM_WAREHOUSES + 1)
    ],
    "LocationID": rng.choice(
        locations["LocationID"],
        NUM_WAREHOUSES
    ),
    "CapacityUnits": rng.integers(
        50_000,
        250_000,
        NUM_WAREHOUSES
    )
})

courier_names = [
    "Swift Logistics",
    "Prime Express",
    "RapidRoute",
    "Metro Delivery",
    "Nationwide Couriers",
    "FastTrack",
    "BlueLine Logistics",
    "UrbanShip",
    "DirectDrop",
    "Apex Delivery"
]

couriers = pd.DataFrame({
    "CourierID": np.arange(1, NUM_COURIERS + 1),
    "CourierName": courier_names,
    "ServiceLevel": rng.choice(
        ["Standard", "Express", "Premium"],
        NUM_COURIERS,
        p=[0.55, 0.35, 0.10]
    )
})

product_names = [
    f"{fake.word().title()} {fake.word().title()} {rng.integers(100, 9999)}"
    for _ in range(NUM_PRODUCTS)
]

products = pd.DataFrame({
    "ProductID": np.arange(1, NUM_PRODUCTS + 1),
    "ProductName": product_names,
    "CategoryID": rng.choice(
        category_df["CategoryID"],
        NUM_PRODUCTS
    ),
    "SellerID": rng.choice(
        sellers["SellerID"],
        NUM_PRODUCTS
    ),
    "CostPrice": np.round(
        rng.lognormal(mean=8.0, sigma=0.8, size=NUM_PRODUCTS),
        2
    ),
    "ListPrice": np.zeros(NUM_PRODUCTS),
    "ProductStatus": rng.choice(
        ["Active", "Active", "Active", "Inactive"],
        NUM_PRODUCTS
    )
})

products["ListPrice"] = np.round(
    products["CostPrice"] * rng.uniform(1.15, 2.20, NUM_PRODUCTS),
    2
)

promotion_types = [
    "Percentage Discount",
    "Fixed Amount",
    "Category Promotion",
    "Flash Sale",
    "Seasonal Campaign"
]

promotions = pd.DataFrame({
    "PromotionID": np.arange(1, NUM_PROMOTIONS + 1),
    "PromotionName": [
        f"{fake.word().title()} {fake.word().title()} Campaign"
        for _ in range(NUM_PROMOTIONS)
    ],
    "PromotionType": rng.choice(
        promotion_types,
        NUM_PROMOTIONS
    ),
    "DiscountRate": np.round(
        rng.choice(
            [0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.40],
            NUM_PROMOTIONS
        ),
        2
    ),
    "StartDate": pd.to_datetime(
        rng.choice(
            pd.date_range("2023-01-01", "2025-06-01"),
            NUM_PROMOTIONS
        )
    )
})

promotions["EndDate"] = promotions["StartDate"] + pd.to_timedelta(
    rng.integers(7, 60, NUM_PROMOTIONS),
    unit="D"
)

datasets = {
    "customers": customers,
    "sellers": sellers,
    "categories": category_df,
    "products": products,
    "locations": locations,
    "warehouses": warehouses,
    "couriers": couriers,
    "promotions": promotions
}

for name, dataframe in datasets.items():
    dataframe.to_csv(
        OUTPUT_DIR / f"{name}.csv",
        index=False
    )
    print(f"{name}: {len(dataframe):,} rows")

print(f"\nData generated successfully in: {OUTPUT_DIR}")