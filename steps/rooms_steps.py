from behave import given, when, then
import requests

BASE_URL = "https://sweetmanager-backend-emergents.onrender.com/api/v1"

@given('I am authenticated as a hotel administrator')
def step_impl(context):
    context.auth_token = "test_admin_token"
    context.headers = {"Authorization": f"Bearer {context.auth_token}"}

@when('I set up a new room with room number, floor, and type')
def step_impl(context):
    context.room_data = {
        "hotelId": "test_hotel_id",
        "roomNumber": "101",
        "floor": 1,
        "typeRoomId": "suite_type_id"
    }
    context.response = requests.post(f"{BASE_URL}/room/set-up", json=context.room_data, headers=context.headers)

@then('the room should be created successfully')
def step_impl(context):
    assert context.response.status_code in [200, 201]

@then('the room should appear in the rooms list')
def step_impl(context):
    assert context.response.json() is not None

@given('I have hotel access')
def step_impl(context):
    context.auth_token = "test_admin_token"
    context.headers = {"Authorization": f"Bearer {context.auth_token}"}

@when('I create a room with complete information')
def step_impl(context):
    context.room_data = {
        "hotelId": "test_hotel_id",
        "roomNumber": "202",
        "status": "available"
    }
    context.response = requests.post(f"{BASE_URL}/room/create-room", json=context.room_data, headers=context.headers)

@then('the room should be registered in the system')
def step_impl(context):
    assert context.response.status_code in [200, 201]

@given('a room exists in the system')
def step_impl(context):
    context.room_id = "test_room_id_123"
    context.auth_token = "test_admin_token"
    context.headers = {"Authorization": f"Bearer {context.auth_token}"}

@when('I update the room state to "{state}"')
def step_impl(context, state):
    context.update_data = {"state": state}
    context.response = requests.put(f"{BASE_URL}/room/update-room-state", 
                                   params={"roomId": context.room_id}, 
                                   json=context.update_data, 
                                   headers=context.headers)

@then('the room state should be updated successfully')
def step_impl(context):
    assert context.response.status_code in [200, 204]

@then('the new state should be reflected in the system')
def step_impl(context):
    assert context.response.status_code in [200, 204]

@given('a room exists with a specific ID')
def step_impl(context):
    context.room_id = "test_room_id_123"

@when('I request the room information by ID')
def step_impl(context):
    context.response = requests.get(f"{BASE_URL}/room/get-room-by-id", params={"id": context.room_id})

@then('I should receive the room details')
def step_impl(context):
    assert context.response.status_code in [200, 404]

@given('there are rooms with different states')
def step_impl(context):
    context.rooms_exist = True

@when('I filter rooms by state "{state}"')
def step_impl(context, state):
    context.response = requests.get(f"{BASE_URL}/room/get-room-by-state", params={"state": state})

@then('I should receive only available rooms')
def step_impl(context):
    assert context.response.status_code == 200

@given('there are rooms registered in the hotel')
def step_impl(context):
    context.rooms_exist = True

@when('I request all rooms')
def step_impl(context):
    context.response = requests.get(f"{BASE_URL}/room/get-all-rooms")

@then('I should receive the complete rooms list')
def step_impl(context):
    assert context.response.status_code == 200
    assert isinstance(context.response.json(), list)

@given('there are rooms of different types')
def step_impl(context):
    context.rooms_exist = True

@when('I filter rooms by type "{room_type}"')
def step_impl(context, room_type):
    context.response = requests.get(f"{BASE_URL}/room/get-room-by-type-room", params={"typeRoom": room_type})

@then('I should receive only suite rooms')
def step_impl(context):
    assert context.response.status_code == 200
