import pandas as pd
from pathlib import Path

OUTPUT_DIR = Path(__file__).resolve().parents[1] / "output"

files = {
    "customers": "customers.csv",
    "sellers": "sellers.csv",
    "categories": "categories.csv",
    "products": "products.csv",
    "locations": "locations.csv",
    "warehouses": "warehouses.csv",
    "couriers": "couriers.csv",
    "promotions": "promotions.csv",
    "orders": "orders.csv",
    "order_items": "order_items.csv",
    "payments": "payments.csv",
    "shipments": "shipments.csv",
    "inventory": "inventory.csv",
    "returns": "returns.csv",
    "reviews": "reviews.csv"
}

df = {
    name: pd.read_csv(OUTPUT_DIR / filename)
    for name, filename in files.items()
}

errors = []

def check_unique(table, column):
    duplicates = table[column].duplicated().sum()
    if duplicates > 0:
        errors.append(f"{table.name}.{column}: {duplicates:,} duplicate values")

def check_fk(child, child_column, parent, parent_column, allow_null=False):
    values = df[child][child_column]

    if allow_null:
        values = values.dropna()

    invalid = ~values.isin(df[parent][parent_column])
    count = invalid.sum()

    if count > 0:
        errors.append(
            f"{child}.{child_column}: {count:,} invalid references to {parent}.{parent_column}"
        )

for name, table in df.items():
    table.name = name

check_unique(df["customers"], "CustomerID")
check_unique(df["sellers"], "SellerID")
check_unique(df["categories"], "CategoryID")
check_unique(df["products"], "ProductID")
check_unique(df["locations"], "LocationID")
check_unique(df["warehouses"], "WarehouseID")
check_unique(df["couriers"], "CourierID")
check_unique(df["promotions"], "PromotionID")
check_unique(df["orders"], "OrderID")
check_unique(df["order_items"], "OrderItemID")
check_unique(df["payments"], "PaymentID")
check_unique(df["shipments"], "ShipmentID")
check_unique(df["returns"], "ReturnID")
check_unique(df["reviews"], "ReviewID")

check_fk("orders", "CustomerID", "customers", "CustomerID")
check_fk("order_items", "OrderID", "orders", "OrderID")
check_fk("order_items", "ProductID", "products", "ProductID")
check_fk("order_items", "SellerID", "sellers", "SellerID")
check_fk("order_items", "PromotionID", "promotions", "PromotionID", allow_null=True)
check_fk("products", "SellerID", "sellers", "SellerID")
check_fk("products", "CategoryID", "categories", "CategoryID")
check_fk("payments", "OrderID", "orders", "OrderID")
check_fk("payments", "CustomerID", "customers", "CustomerID")
check_fk("shipments", "OrderID", "orders", "OrderID")
check_fk("shipments", "CourierID", "couriers", "CourierID")
check_fk("shipments", "WarehouseID", "warehouses", "WarehouseID")
check_fk("inventory", "ProductID", "products", "ProductID")
check_fk("inventory", "WarehouseID", "warehouses", "WarehouseID")
check_fk("returns", "OrderItemID", "order_items", "OrderItemID")
check_fk("returns", "OrderID", "orders", "OrderID")
check_fk("returns", "ProductID", "products", "ProductID")
check_fk("returns", "SellerID", "sellers", "SellerID")
check_fk("reviews", "OrderID", "orders", "OrderID")
check_fk("reviews", "CustomerID", "customers", "CustomerID")

if (df["products"]["CostPrice"] < 0).any():
    errors.append("products.CostPrice: negative values detected")

if (df["products"]["ListPrice"] < 0).any():
    errors.append("products.ListPrice: negative values detected")

if (df["products"]["ListPrice"] < df["products"]["CostPrice"]).any():
    errors.append("products: ListPrice below CostPrice detected")

if (df["order_items"]["Quantity"] <= 0).any():
    errors.append("order_items.Quantity: zero or negative quantities detected")

if (df["order_items"]["UnitPrice"] < 0).any():
    errors.append("order_items.UnitPrice: negative values detected")

if (df["order_items"]["GrossAmount"] < 0).any():
    errors.append("order_items.GrossAmount: negative values detected")

if (df["order_items"]["DiscountAmount"] < 0).any():
    errors.append("order_items.DiscountAmount: negative values detected")

if (df["order_items"]["DiscountAmount"] > df["order_items"]["GrossAmount"]).any():
    errors.append("order_items: discount exceeds gross amount")

if (df["order_items"]["NetAmount"] < 0).any():
    errors.append("order_items.NetAmount: negative values detected")

if (df["inventory"]["ClosingStock"] < 0).any():
    errors.append("inventory.ClosingStock: negative values detected")

if (df["inventory"]["UnitsSold"] < 0).any():
    errors.append("inventory.UnitsSold: negative values detected")

if (df["inventory"]["UnitsReceived"] < 0).any():
    errors.append("inventory.UnitsReceived: negative values detected")

if (df["returns"]["ReturnedQuantity"] <= 0).any():
    errors.append("returns.ReturnedQuantity: zero or negative quantities detected")

if (df["returns"]["ReturnCost"] < 0).any():
    errors.append("returns.ReturnCost: negative values detected")

order_item_quantity_lookup = df["order_items"].set_index("OrderItemID")["Quantity"]

return_quantities = df["returns"]["OrderItemID"].map(
    order_item_quantity_lookup
)

if (
    df["returns"]["ReturnedQuantity"] > return_quantities
).any():
    errors.append(
        "returns: returned quantity exceeds purchased quantity"
    )

order_item_orders = set(df["order_items"]["OrderID"])
orders_without_items = set(df["orders"]["OrderID"]) - order_item_orders

if orders_without_items:
    errors.append(
        f"orders: {len(orders_without_items):,} orders without order items"
    )

shipment_dates = df["shipments"][
    ["OrderID", "OrderDate", "DeliveryDate", "DeliveryStatus"]
].copy()

shipment_dates["OrderDate"] = pd.to_datetime(
    shipment_dates["OrderDate"]
)

shipment_dates["DeliveryDate"] = pd.to_datetime(
    shipment_dates["DeliveryDate"]
)

invalid_delivery_dates = (
    shipment_dates["DeliveryDate"].notna()
    & (
        shipment_dates["DeliveryDate"]
        < shipment_dates["OrderDate"]
    )
).sum()

if invalid_delivery_dates > 0:
    errors.append(
        f"shipments: {invalid_delivery_dates:,} delivery dates before order dates"
    )

unexpected_delivery_nulls = (
    shipment_dates["DeliveryStatus"].ne("Failed")
    & shipment_dates["DeliveryDate"].isna()
).sum()

if unexpected_delivery_nulls > 0:
    errors.append(
        f"shipments: {unexpected_delivery_nulls:,} missing delivery dates for non-failed shipments"
    )

return_dates = df["returns"][
    ["OrderID", "ReturnDate"]
].copy()

return_dates["ReturnDate"] = pd.to_datetime(
    return_dates["ReturnDate"]
)

return_dates["OrderDate"] = return_dates["OrderID"].map(
    df["orders"].set_index("OrderID")["OrderDate"]
)

return_dates["OrderDate"] = pd.to_datetime(
    return_dates["OrderDate"]
)

invalid_return_dates = (
    return_dates["ReturnDate"]
    < return_dates["OrderDate"]
).sum()

if invalid_return_dates > 0:
    errors.append(
        f"returns: {invalid_return_dates:,} return dates before order dates"
    )

print("=" * 60)
print("MARKETPLACE DATA VALIDATION")
print("=" * 60)

for name, table in df.items():
    print(f"{name:<15} {len(table):>10,} rows")

print("\nValidation Results")

if errors:
    print(f"\nFAILED: {len(errors)} issue(s) detected\n")
    for error in errors:
        print(f"- {error}")
else:
    print("\nPASSED: No validation issues detected.")

print("=" * 60)