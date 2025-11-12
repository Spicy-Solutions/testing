from behave import given, when, then
import requests

BASE_URL = "https://sweetmanager-backend-emergents.onrender.com/api/v1"

@given('I am on the registration page')
def step_impl(context):
    context.registration_url = f"{BASE_URL}/authentication/sign-up-admin"

@when('I fill in the admin registration form with valid data')
def step_impl(context):
    context.registration_data = {
        "username": "testadmin",
        "email": "testadmin@sweetmanager.com",
        "password": "SecurePass123!",
        "role": "admin"
    }

@when('I submit the registration form')
def step_impl(context):
    context.response = requests.post(context.registration_url, json=context.registration_data)

@then('I should receive a successful registration confirmation')
def step_impl(context):
    assert context.response.status_code in [200, 201], f"Expected 200 or 201, got {context.response.status_code}"

@then('my admin account should be created in the system')
def step_impl(context):
    assert context.response.json() is not None

@when('I fill in the guest registration form with valid data')
def step_impl(context):
    context.registration_url = f"{BASE_URL}/authentication/sign-up-guest"
    context.registration_data = {
        "username": "testguest",
        "email": "testguest@sweetmanager.com",
        "password": "SecurePass123!",
        "role": "guest"
    }

@then('my guest account should be created in the system')
def step_impl(context):
    assert context.response.json() is not None

@when('I fill in the owner registration form with valid data')
def step_impl(context):
    context.registration_url = f"{BASE_URL}/authentication/sign-up-owner"
    context.registration_data = {
        "username": "testowner",
        "email": "testowner@sweetmanager.com",
        "password": "SecurePass123!",
        "role": "owner"
    }

@then('my owner account should be created in the system')
def step_impl(context):
    assert context.response.json() is not None

@given('I have a registered account')
def step_impl(context):
    context.credentials = {
        "username": "testuser",
        "password": "SecurePass123!"
    }

@when('I enter my valid credentials')
def step_impl(context):
    context.sign_in_url = f"{BASE_URL}/authentication/sign-in"

@when('I submit the sign in form')
def step_impl(context):
    context.response = requests.post(context.sign_in_url, json=context.credentials)

@then('I should be successfully authenticated')
def step_impl(context):
    assert context.response.status_code == 200

@then('I should be redirected to my dashboard')
def step_impl(context):
    assert 'token' in context.response.json() or 'access_token' in context.response.json()

@given('I am on the sign in page')
def step_impl(context):
    context.sign_in_url = f"{BASE_URL}/authentication/sign-in"

@when('I enter invalid credentials')
def step_impl(context):
    context.credentials = {
        "username": "invaliduser",
        "password": "wrongpassword"
    }

@then('I should see an error message')
def step_impl(context):
    assert context.response.status_code in [401, 403, 400]

@then('I should remain on the sign in page')
def step_impl(context):
    assert context.response.status_code != 200
