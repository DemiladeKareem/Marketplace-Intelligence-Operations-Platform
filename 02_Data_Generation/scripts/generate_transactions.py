import pandas as pd
import numpy as np
from pathlib import Path

rng = np.random.default_rng(42)

BASE_DIR = Path(__file__).resolve().parents[1]
OUTPUT_DIR = BASE_DIR / "output"

NUM_ORDERS = 250_000

customers = pd.read_csv(OUTPUT_DIR / "customers.csv")
sellers = pd.read_csv(OUTPUT_DIR / "sellers.csv")
products = pd.read_csv(OUTPUT_DIR / "products.csv")
warehouses = pd.read_csv(OUTPUT_DIR / "warehouses.csv")
couriers = pd.read_csv(OUTPUT_DIR / "couriers.csv")
promotions = pd.read_csv(OUTPUT_DIR / "promotions.csv")

products["CostPrice"] = products["CostPrice"].astype(float)
products["ListPrice"] = products["ListPrice"].astype(float)

order_ids = np.arange(1, NUM_ORDERS + 1)

order_dates = pd.Series(
    pd.to_datetime(
        rng.choice(
            pd.date_range("2023-01-01", "2025-12-31"),
            NUM_ORDERS
        )
    )
)

orders = pd.DataFrame({
    "OrderID": order_ids,
    "CustomerID": rng.choice(
        customers["CustomerID"].values,
        NUM_ORDERS
    ),
    "OrderDate": order_dates,
    "PaymentMethod": rng.choice(
        ["Card", "Bank Transfer", "Wallet", "Cash on Delivery"],
        NUM_ORDERS,
        p=[0.38, 0.25, 0.22, 0.15]
    ),
    "OrderStatus": rng.choice(
        ["Completed", "Completed", "Completed", "Cancelled"],
        NUM_ORDERS,
        p=[0.86, 0.07, 0.04, 0.03]
    )
})

item_counts = rng.choice(
    [1, 2, 3, 4, 5],
    NUM_ORDERS,
    p=[0.45, 0.30, 0.15, 0.07, 0.03]
)

order_item_order_ids = np.repeat(order_ids, item_counts)
num_items = len(order_item_order_ids)

order_items = pd.DataFrame({
    "OrderItemID": np.arange(1, num_items + 1),
    "OrderID": order_item_order_ids,
    "ProductID": rng.choice(
        products["ProductID"].values,
        num_items
    ),
    "Quantity": rng.choice(
        [1, 2, 3, 4],
        num_items,
        p=[0.65, 0.22, 0.09, 0.04]
    )
})

product_lookup = products.set_index("ProductID")

order_items["UnitPrice"] = order_items["ProductID"].map(
    product_lookup["ListPrice"]
)

order_items["ProductCost"] = order_items["ProductID"].map(
    product_lookup["CostPrice"]
)

order_items["SellerID"] = order_items["ProductID"].map(
    product_lookup["SellerID"]
)

promotion_ids = rng.choice(
    promotions["PromotionID"].values,
    num_items
)

promotion_flags = rng.random(num_items) < 0.12

order_items["PromotionID"] = np.where(
    promotion_flags,
    promotion_ids,
    np.nan
)

promotion_lookup = promotions.set_index("PromotionID")["DiscountRate"].to_dict()

order_items["DiscountRate"] = order_items["PromotionID"].map(
    promotion_lookup
).fillna(0)

order_items["GrossAmount"] = (
    order_items["Quantity"] * order_items["UnitPrice"]
)

order_items["DiscountAmount"] = (
    order_items["GrossAmount"] * order_items["DiscountRate"]
).round(2)

order_items["NetAmount"] = (
    order_items["GrossAmount"] - order_items["DiscountAmount"]
).round(2)

order_items["ProductCostAmount"] = (
    order_items["Quantity"] * order_items["ProductCost"]
).round(2)

order_items["GrossProfit"] = (
    order_items["NetAmount"] - order_items["ProductCostAmount"]
).round(2)

order_lookup = orders.set_index("OrderID")

order_items["OrderDate"] = order_items["OrderID"].map(
    order_lookup["OrderDate"]
)

order_items["CustomerID"] = order_items["OrderID"].map(
    order_lookup["CustomerID"]
)

order_totals = (
    order_items.groupby("OrderID", as_index=False)
    .agg(
        GrossSales=("GrossAmount", "sum"),
        DiscountAmount=("DiscountAmount", "sum"),
        NetSales=("NetAmount", "sum"),
        ProductCost=("ProductCostAmount", "sum")
    )
)

order_totals["GrossProfit"] = (
    order_totals["NetSales"] - order_totals["ProductCost"]
).round(2)

orders = orders.merge(order_totals, on="OrderID", how="left")

courier_performance = pd.DataFrame({
    "CourierID": couriers["CourierID"],
    "AverageDeliveryDays": [2.5, 3.2, 4.8, 2.8, 5.2, 2.2, 3.5, 6.0, 3.0, 4.0],
    "LateRate": [0.08, 0.12, 0.24, 0.10, 0.28, 0.06, 0.14, 0.32, 0.09, 0.18],
    "FailedRate": [0.02, 0.03, 0.07, 0.03, 0.08, 0.015, 0.04, 0.09, 0.025, 0.05],
    "BaseShippingCost": [180, 220, 260, 200, 280, 240, 210, 300, 190, 250]
})

shipments = pd.DataFrame({
    "ShipmentID": np.arange(1, NUM_ORDERS + 1),
    "OrderID": order_ids,
    "CourierID": rng.choice(
        courier_performance["CourierID"].values,
        NUM_ORDERS
    ),
    "WarehouseID": rng.choice(
        warehouses["WarehouseID"].values,
        NUM_ORDERS
    )
})

shipment_lookup = courier_performance.set_index("CourierID")

shipments["ExpectedDeliveryDays"] = shipments["CourierID"].map(
    shipment_lookup["AverageDeliveryDays"]
)

shipments["LateProbability"] = shipments["CourierID"].map(
    shipment_lookup["LateRate"]
)

shipments["FailedProbability"] = shipments["CourierID"].map(
    shipment_lookup["FailedRate"]
)

shipments["BaseShippingCost"] = shipments["CourierID"].map(
    shipment_lookup["BaseShippingCost"]
)

shipments["ShippingCost"] = (
    shipments["BaseShippingCost"] *
    rng.uniform(0.85, 1.25, NUM_ORDERS)
).round(2)

shipments["OrderDate"] = shipments["OrderID"].map(
    order_lookup["OrderDate"]
)

shipments["ExpectedDeliveryDate"] = (
    shipments["OrderDate"] +
    pd.to_timedelta(
        np.ceil(shipments["ExpectedDeliveryDays"]),
        unit="D"
    )
)

late_flags = rng.random(NUM_ORDERS) < shipments["LateProbability"].values
failed_flags = rng.random(NUM_ORDERS) < shipments["FailedProbability"].values

actual_delivery_days = (
    np.ceil(shipments["ExpectedDeliveryDays"].values) +
    rng.integers(0, 3, NUM_ORDERS)
)

actual_delivery_days[late_flags] += rng.integers(2, 7, late_flags.sum())

shipments["DeliveryDate"] = (
    shipments["OrderDate"] +
    pd.to_timedelta(actual_delivery_days, unit="D")
)

shipments["DeliveryStatus"] = np.where(
    failed_flags,
    "Failed",
    np.where(late_flags, "Late", "On Time")
)

shipments.loc[
    shipments["DeliveryStatus"] == "Failed",
    "DeliveryDate"
] = pd.NaT

inventory_dates = pd.date_range(
    "2025-09-30",
    "2025-12-31",
    freq="MS"
) + pd.offsets.MonthEnd(0)

inventory_base = pd.MultiIndex.from_product(
    [
        products["ProductID"].values,
        warehouses["WarehouseID"].values,
        inventory_dates
    ],
    names=["ProductID", "WarehouseID", "SnapshotDate"]
).to_frame(index=False)

inventory_base["AverageDailyDemand"] = rng.gamma(
    shape=2.0,
    scale=4.0,
    size=len(inventory_base)
)

inventory_base["OpeningStock"] = rng.integers(
    20,
    800,
    len(inventory_base)
)

inventory_base["UnitsReceived"] = rng.integers(
    0,
    500,
    len(inventory_base)
)

inventory_base["UnitsSold"] = np.minimum(
    rng.poisson(
        inventory_base["AverageDailyDemand"] * 30
    ),
    inventory_base["OpeningStock"] + inventory_base["UnitsReceived"]
)

inventory_base["UnitsReturned"] = rng.binomial(
    inventory_base["UnitsSold"],
    0.08
)

inventory_base["ClosingStock"] = (
    inventory_base["OpeningStock"]
    + inventory_base["UnitsReceived"]
    - inventory_base["UnitsSold"]
    + inventory_base["UnitsReturned"]
)

inventory_base["ReorderLevel"] = rng.integers(
    30,
    180,
    len(inventory_base)
)

inventory = inventory_base[
    [
        "ProductID",
        "WarehouseID",
        "SnapshotDate",
        "OpeningStock",
        "UnitsReceived",
        "UnitsSold",
        "UnitsReturned",
        "ClosingStock",
        "ReorderLevel"
    ]
]

return_probability = order_items["ProductID"].map(
    products.set_index("ProductID")["CategoryID"]
).map(
    lambda x: 0.12 if x in [1, 2, 3, 5, 18] else 0.06
)

seller_type_lookup = sellers.set_index("SellerID")["SellerType"]

seller_type_effect = order_items["SellerID"].map(
    seller_type_lookup
).map({
    "High Volume": 0.02,
    "High Margin": -0.01,
    "Discount Heavy": 0.025,
    "Premium": -0.015,
    "Standard": 0
}).fillna(0)

return_probability = (
    return_probability + seller_type_effect
).clip(0.02, 0.25)

return_flags = (
    rng.random(num_items) < return_probability.values
)

returned_items = order_items.loc[
    return_flags,
    [
        "OrderItemID",
        "OrderID",
        "ProductID",
        "SellerID",
        "Quantity",
        "NetAmount"
    ]
].copy()

returned_items["ReturnID"] = np.arange(
    1,
    len(returned_items) + 1
)

returned_items["ReturnedQuantity"] = np.maximum(
    1,
    np.floor(
        returned_items["Quantity"] *
        rng.uniform(0.5, 1.0, len(returned_items))
    ).astype(int)
)

returned_items["ReturnReason"] = rng.choice(
    [
        "Damaged",
        "Wrong Item",
        "Poor Quality",
        "Not as Described",
        "Changed Mind",
        "Late Delivery"
    ],
    len(returned_items),
    p=[0.15, 0.14, 0.22, 0.18, 0.16, 0.15]
)

returned_items["ReturnDate"] = (
    returned_items["OrderID"].map(order_lookup["OrderDate"]) +
    pd.to_timedelta(
        rng.integers(3, 30, len(returned_items)),
        unit="D"
    )
)

returned_items["ReturnCost"] = (
    returned_items["ReturnedQuantity"] *
    rng.uniform(80, 350, len(returned_items))
).round(2)

returns = returned_items[
    [
        "ReturnID",
        "OrderItemID",
        "OrderID",
        "ProductID",
        "SellerID",
        "ReturnedQuantity",
        "ReturnReason",
        "ReturnDate",
        "ReturnCost"
    ]
]

review_flags = rng.random(NUM_ORDERS) < 0.40

review_orders = orders.loc[
    review_flags,
    ["OrderID", "CustomerID"]
].copy()

review_orders["ReviewID"] = np.arange(
    1,
    len(review_orders) + 1
)

review_orders["Rating"] = rng.choice(
    [1, 2, 3, 4, 5],
    len(review_orders),
    p=[0.04, 0.07, 0.14, 0.30, 0.45]
)

review_orders["ReviewDate"] = (
    review_orders["OrderID"].map(order_lookup["OrderDate"]) +
    pd.to_timedelta(
        rng.integers(5, 45, len(review_orders)),
        unit="D"
    )
)

review_orders["ReviewText"] = np.where(
    review_orders["Rating"] <= 2,
    "Customer reported an issue with the order.",
    np.where(
        review_orders["Rating"] == 3,
        "Customer reported an average experience.",
        "Customer reported a positive experience."
    )
)

reviews = review_orders[
    [
        "ReviewID",
        "OrderID",
        "CustomerID",
        "Rating",
        "ReviewDate",
        "ReviewText"
    ]
]

payments = orders[
    [
        "OrderID",
        "CustomerID",
        "PaymentMethod",
        "NetSales"
    ]
].copy()

payments.insert(
    0,
    "PaymentID",
    np.arange(1, len(payments) + 1)
)

payments["PaymentStatus"] = np.where(
    payments["PaymentMethod"].eq("Cash on Delivery"),
    "Pending Settlement",
    np.where(
        orders["OrderStatus"].eq("Cancelled"),
        "Refunded",
        "Completed"
    )
)

payments["PaymentAmount"] = payments["NetSales"]

datasets = {
    "orders": orders,
    "order_items": order_items,
    "payments": payments,
    "shipments": shipments,
    "inventory": inventory,
    "returns": returns,
    "reviews": reviews
}

for name, dataframe in datasets.items():
    dataframe.to_csv(
        OUTPUT_DIR / f"{name}.csv",
        index=False
    )
    print(f"{name}: {len(dataframe):,} rows")

print("\nTransaction data generated successfully.")