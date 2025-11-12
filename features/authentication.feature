Feature: User Authentication
  As a user of Sweet Manager
  I want to be able to register and sign in
  So that I can access the system with different roles

  Scenario: Admin user registration
    Given I am on the registration page
    When I fill in the admin registration form with valid data
    And I submit the registration form
    Then I should receive a successful registration confirmation
    And my admin account should be created in the system

  Scenario: Guest user registration
    Given I am on the registration page
    When I fill in the guest registration form with valid data
    And I submit the registration form
    Then I should receive a successful registration confirmation
    And my guest account should be created in the system

  Scenario: Owner user registration
    Given I am on the registration page
    When I fill in the owner registration form with valid data
    And I submit the registration form
    Then I should receive a successful registration confirmation
    And my owner account should be created in the system

  Scenario: Successful user sign in
    Given I have a registered account
    When I enter my valid credentials
    And I submit the sign in form
    Then I should be successfully authenticated
    And I should be redirected to my dashboard

  Scenario: Failed sign in with invalid credentials
    Given I am on the sign in page
    When I enter invalid credentials
    And I submit the sign in form
    Then I should see an error message
    And I should remain on the sign in page
