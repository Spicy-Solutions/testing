Feature: Mobile Authentication
  As a hotel manager or guest
  I want to authenticate in the mobile application
  So that I can access the Sweet Manager features

  Background:
    Given the mobile app is launched
    And I am on the authentication screen

  Scenario: Display welcome screen with proper branding
    Then I should see the text "Welcome to Sweet Manager"
    And I should see the login tab selected by default
    And I should see both "Login" and "Sign Up" tabs

  Scenario: Successful login as hotel owner
    Given I am on the login tab
    When I enter valid email "owner@hotel.com"
    And I enter valid password "password123"
    And I select role "Owner"
    And I click the login button
    Then the app should show a loading indicator
    And the login should be successful
    And I should be redirected to the home screen
    And my authentication token should be stored

  Scenario: Successful login as guest
    Given I am on the login tab
    When I enter valid email "guest@hotel.com"
    And I enter valid password "password123"
    And I select role "Guest"
    And I click the login button
    Then the login should be successful
    And I should be redirected to the appropriate screen for guest

  Scenario: Failed login with invalid credentials
    Given I am on the login tab
    When I enter email "invalid@email.com"
    And I enter password "wrongpassword"
    And I select role "Owner"
    And I click the login button
    Then the app should show a loading indicator
    And an error message should be displayed
    And I should remain on the login screen

  Scenario: Login with remember me option
    Given I am on the login tab
    When I enter valid email "owner@hotel.com"
    And I enter valid password "password123"
    And I check the "Remember Me" checkbox
    And I select role "Owner"
    And I click the login button
    Then my credentials should be saved for future sessions

  Scenario: Toggle password visibility on login
    Given I am on the login tab
    When I enter password "mypassword"
    Then the password should be obscured by default
    When I click the password visibility toggle
    Then the password should be visible
    When I click the password visibility toggle again
    Then the password should be obscured

  Scenario: Switch to sign up tab
    Given I am on the login tab
    When I click the "Sign Up" tab
    Then I should see the sign up form
    And I should see fields for full name, email, DNI, phone, and password

  Scenario: Successful user registration
    Given I am on the sign up tab
    When I enter full name "John Doe"
    And I enter signup email "john.doe@email.com"
    And I enter DNI "12345678"
    And I enter phone number "987654321"
    And I enter signup password "SecurePass123"
    And I enter confirm password "SecurePass123"
    And I accept the terms and conditions
    And I click the sign up button
    Then the registration should be successful
    And I should be redirected to account type selection

  Scenario: Registration fails when passwords don't match
    Given I am on the sign up tab
    When I enter full name "Jane Smith"
    And I enter signup email "jane@email.com"
    And I enter DNI "87654321"
    And I enter phone number "912345678"
    And I enter signup password "Password123"
    And I enter confirm password "DifferentPass123"
    And I accept the terms and conditions
    And I click the sign up button
    Then an error message should be displayed
    And the error should indicate password mismatch

  Scenario: Registration fails without accepting terms
    Given I am on the sign up tab
    When I enter full name "Test User"
    And I enter signup email "test@email.com"
    And I enter DNI "11223344"
    And I enter phone number "999888777"
    And I enter signup password "TestPass123"
    And I enter confirm password "TestPass123"
    And I do not accept the terms and conditions
    And I click the sign up button
    Then the sign up button should be disabled
    And the registration should not proceed

  Scenario: View terms and conditions
    Given I am on the sign up tab
    When I click on the terms and conditions link
    Then I should be redirected to the terms and conditions screen
    And I should see the complete terms and conditions text

  Scenario: Toggle password visibility during sign up
    Given I am on the sign up tab
    When I enter signup password "MySecretPass"
    And I enter confirm password "MySecretPass"
    Then both passwords should be obscured by default
    When I click the signup password visibility toggle
    Then the signup password should be visible
    When I click the confirm password visibility toggle
    Then the confirm password should be visible

  Scenario: Form validation on login
    Given I am on the login tab
    When I leave email field empty
    And I leave password field empty
    And I try to click the login button
    Then the form should show validation errors
    And the login should not proceed

  Scenario: Form validation on sign up
    Given I am on the sign up tab
    When I leave required fields empty
    And I try to click the sign up button
    Then the form should show validation errors for each empty field
    And the registration should not proceed

  Scenario: Email format validation
    Given I am on the login tab
    When I enter an invalid email format "notanemail"
    And I enter password "password123"
    Then the email field should show a validation error

  Scenario: Scroll behavior in long forms
    Given I am on the sign up tab
    When the keyboard appears
    Then the form should scroll to keep the focused field visible
    And all form fields should remain accessible

  Scenario: Account type selection after registration
    Given I have successfully registered
    When I am redirected to account type selection
    Then I should see options to select account type
    And I should be able to proceed with account setup

  Scenario: Navigate back from sign up to login
    Given I am on the sign up tab
    When I click the "Login" tab
    Then I should see the login form
    And any entered sign up data should be preserved in the background

  Scenario: Loading state prevents multiple submissions
    Given I am on the login tab
    When I enter valid credentials
    And I click the login button
    Then the login button should be disabled
    And multiple submissions should be prevented
    And a loading indicator should be visible
