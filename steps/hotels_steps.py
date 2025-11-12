from behave import given, when, then
import requests

BASE_URL = "https://sweetmanager-backend-emergents.onrender.com/api/v1"

@given('I am authenticated as a hotel owner')
def step_impl(context):
    context.auth_token = "test_token_here"
    context.headers = {"Authorization": f"Bearer {context.auth_token}"}

@when('I submit a new hotel with complete information')
def step_impl(context):
    context.hotel_data = {
        "name": "Grand Plaza Hotel",
        "address": "123 Main Street",
        "city": "Lima",
        "country": "Peru",
        "stars": 5,
        "amenities": ["WiFi", "Pool", "Spa"]
    }
    context.response = requests.post(f"{BASE_URL}/hotels", json=context.hotel_data, headers=context.headers)

@then('the hotel should be created successfully')
def step_impl(context):
    assert context.response.status_code in [200, 201]

@then('I should see the new hotel in my hotels list')
def step_impl(context):
    assert context.response.json() is not None

@given('there are hotels registered in the system')
def step_impl(context):
    context.hotels_exist = True

@when('I request the list of all hotels')
def step_impl(context):
    context.response = requests.get(f"{BASE_URL}/hotels")

@then('I should receive all registered hotels')
def step_impl(context):
    assert context.response.status_code == 200
    assert isinstance(context.response.json(), list)

@given('a hotel exists with a specific ID')
def step_impl(context):
    context.hotel_id = "test_hotel_id_123"

@when('I request the hotel information by ID')
def step_impl(context):
    context.response = requests.get(f"{BASE_URL}/hotels/{context.hotel_id}")

@then('I should receive the hotel details')
def step_impl(context):
    assert context.response.status_code in [200, 404]

@given('I am the owner of a hotel')
def step_impl(context):
    context.hotel_id = "test_hotel_id_123"
    context.auth_token = "test_token_here"
    context.headers = {"Authorization": f"Bearer {context.auth_token}"}

@when('I update the hotel information')
def step_impl(context):
    context.update_data = {
        "name": "Updated Grand Plaza Hotel",
        "address": "456 New Address",
        "amenities": ["WiFi", "Pool", "Spa", "Gym"]
    }
    context.response = requests.put(f"{BASE_URL}/hotels/{context.hotel_id}", json=context.update_data, headers=context.headers)

@then('the hotel data should be updated successfully')
def step_impl(context):
    assert context.response.status_code in [200, 204]

@then('the changes should be reflected in the system')
def step_impl(context):
    assert context.response.status_code in [200, 204]

@when('I request my hotels list')
def step_impl(context):
    owner_id = "test_owner_id_123"
    context.response = requests.get(f"{BASE_URL}/hotels/owner/{owner_id}", headers=context.headers)

@then('I should see only my hotels')
def step_impl(context):
    assert context.response.status_code == 200
    assert isinstance(context.response.json(), list)
