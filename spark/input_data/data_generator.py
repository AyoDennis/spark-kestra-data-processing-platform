import pandas as pd
import logging
import awswrangler as wr
import os
import boto3
from faker import Faker
from datetime import datetime, timedelta
import random
from dotenv import load_dotenv

logging.basicConfig(format='%(asctime)s %(levelname)s:%(name)s:%(message)s')
logging.getLogger().setLevel(20)

load_dotenv()

# Initialize Faker for fake data
fake = Faker()
logging.info("faker instantiated")
#Initialize aws session
def aws_session():
    session = boto3.Session(
                    aws_access_key_id = os.getenv("AWS_ACCESS_KEY"),
                    aws_secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY"),
                    region_name= os.getenv("REGION_NAME")
    )
    return session

logging.info("aws session instantiated")

def boto3_client(aws_service):

    client = boto3.client(
        aws_service,
        aws_access_key_id = os.getenv("AWS_ACCESS_KEY"),
        aws_secret_access_key = os.getenv("AWS_SECRET_ACCESS_KEY"),
         region_name= os.getenv("REGION_NAME"))

    return client

logging.info("boto3 session instantiated")

# Configuration
NUM_RECORDS = 1000  # Adjust as needed
WAREHOUSES = ["NY_Warehouse", "TX_Warehouse", "CA_Warehouse", "IL_Warehouse"]
CITIES = ["Los Angeles", "Chicago", "Miami", "Seattle", "Boston", "Denver", "Atlanta", "Houston"]
CARRIERS = ["FedEx", "UPS", "DHL", "USPS"]

logging.info("configurations done")

# Route distances (simulated in km)
ROUTE_DISTANCES = {
    ("NY_Warehouse", "Los Angeles"): 3940,
    ("TX_Warehouse", "Chicago"): 1770,
    ("CA_Warehouse", "Miami"): 4800,
    ("IL_Warehouse", "Seattle"): 3300,
    ("NY_Warehouse", "Boston"): 310,
    ("TX_Warehouse", "Denver"): 1030,
    ("CA_Warehouse", "Atlanta"): 3500,
    ("IL_Warehouse", "Houston"): 1370,
}

logging.info("routes simulated")

# Generate fake shipments
def generate_shipments(n):
    shipments = []
    for _ in range(n):
        origin = random.choice(WAREHOUSES)
        destination = random.choice(CITIES)
        carrier = random.choice(CARRIERS)
        
        # Simulate shipping details
        weight = round(random.uniform(1.0, 50.0), 1)
        volume = round(random.uniform(0.1, 1.0), 2)
        route_distance = ROUTE_DISTANCES.get((origin, destination), random.randint(500, 5000))
        
        # Shipping cost formula (base + weight/distance factors)
        base_cost = random.uniform(10, 30)
        cost = round(base_cost + (weight * 0.5) + (route_distance * 0.01), 2)
        
        # Shipment and delivery dates (1-7 days transit, random delays)
        ship_date = fake.date_between(start_date="-30d", end_date="today")
        transit_days = random.randint(1, 7)
        delay = random.choices([0, 1, 2, 3], weights=[0.7, 0.15, 0.1, 0.05])[0]
        delivery_date = ship_date + timedelta(days=transit_days + delay)
        
        # Delivery status
        status = "Delivered" if delay == 0 else "Delayed"
        
        shipments.append({
            "shipment_id": f"SH{random.randint(1000, 9999)}",
            "origin_warehouse": origin,
            "destination_city": destination,
            "carrier": carrier,
            "shipment_weight_kg": weight,
            "shipment_volume_m3": volume,
            "shipment_date": ship_date.strftime("%Y-%m-%d"),
            "delivery_date": delivery_date.strftime("%Y-%m-%d"),
            "shipping_cost": cost,
            "delivery_status": status,
            "delay_days": delay,
            "route_distance_km": route_distance,
        })
    return shipments

# Generate and save data
df = pd.DataFrame(generate_shipments(NUM_RECORDS))
# df.to_csv("shipping_data.csv", index=False)
# print(f"Generated {NUM_RECORDS} shipping records in 'shipping_data.csv'.")



def s3_load():
    """
    Converts a DataFrame to Parquet and loads it to S3.
    """
    s3_path = os.getenv("S3_PATH")
    logging.info("s3 object initiated")
    wr.s3.to_csv(
        df=df,
        path=s3_path,
        mode="overwrite",
        boto3_session=aws_session(),
        dataset=True
    )
    logging.info("csv conversion successful")
    return "Data successfully written to S3"
