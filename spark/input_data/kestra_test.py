import requests

from dotenv import load_dotenv

load_dotenv()

# Replace with your Kestra API endpoint and namespace
kestra_api_url = "YOUR_KESTRA_API_URL"
namespace = "YOUR_NAMESPACE"
key = "YOUR_KEY"
# Construct the URL for fetching the key
url = f"{kestra_api_url}/api/v1/namespaces/{namespace}/kv/{key}"

# Send a GET request to fetch the key
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Parse the JSON response to get the value
    value = response.json()
    print(f"Value for key '{key}': {value}")
else:
    print(f"Error fetching key '{key}': {response.status_code}")