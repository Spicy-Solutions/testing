Feature: Mobile Payment Processing
  As a hotel owner
  I want to process payment for my selected subscription plan
  So that I can activate my subscription and use the service

  Background:
    Given I am logged in as a hotel owner
    And I have selected a subscription plan
    And I am on the payment checkout screen

  Scenario: Display payment checkout screen elements
    Then I should see the heading "Payment and checkout"
    And I should see the subheading "Complete the form"
    And I should see a payment form card
    And I should see a card number input field
    And I should see an expiration date input field
    And I should see a CVV input field
    And I should see a submit payment button

  Scenario: Card number field formatting
    When I enter card number "4532015112830366"
    Then the card number should be formatted with spaces
    And the card number should display as "4532 0151 1283 0366"
    And the field should accept only numeric input

  Scenario: Card number field validation
    When I enter an invalid card number "1234"
    And I try to submit the payment
    Then I should see a validation error for card number
    And the payment should not be processed

  Scenario: Expiration date field formatting
    When I enter expiration date "1225"
    Then the expiration date should be formatted as "12/25"
    And the field should accept only numeric input
    And the format should be MM/YY

  Scenario: Expiration date validation
    When I enter an expired date "0120"
    And I try to submit the payment
    Then I should see a validation error for expiration date
    And the error should indicate the card is expired

  Scenario: CVV field validation
    When I enter CVV "12"
    And I try to submit the payment
    Then I should see a validation error for CVV
    And the error should indicate CVV must be 3 or 4 digits

  Scenario: CVV field security
    When I enter CVV "123"
    Then the CVV should be obscured or protected
    And the field should accept only numeric input
    And the maximum length should be 4 digits

  Scenario: Successful payment processing for Basic plan
    Given I selected the Basic plan with card identifier 1
    When I enter valid card number "4532015112830366"
    And I enter valid expiration date "1225"
    And I enter valid CVV "123"
    And I click the submit payment button
    Then the payment processing should start
    And a loading indicator should be displayed
    And the form fields should be disabled during processing
    And the payment should be processed successfully
    And I should receive a confirmation message

  Scenario: Successful payment processing for Regular plan
    Given I selected the Regular plan with card identifier 2
    When I enter valid payment information
    And I submit the payment
    Then the payment should be processed for Regular plan
    And the contract should be created with Regular plan details

  Scenario: Successful payment processing for Premium plan
    Given I selected the Premium plan with card identifier 3
    When I enter valid payment information
    And I submit the payment
    Then the payment should be processed for Premium plan
    And the contract should be created with Premium plan details

  Scenario: Payment processing failure
    When I enter valid card number "4532015112830366"
    And I enter valid expiration date "1225"
    And I enter valid CVV "123"
    And I click the submit payment button
    But the payment service returns an error
    Then I should see an error message
    And the error message should explain the failure reason
    And the form should remain editable
    And I should be able to retry the payment

  Scenario: Loading state during payment processing
    When I submit a valid payment
    Then the submit button should be disabled
    And a loading indicator should be visible
    And I should not be able to edit the form fields
    And multiple submissions should be prevented

  Scenario: Form field focus management
    When I tap on the card number field
    Then the card number field should be focused
    And the keyboard should appear
    When I complete the card number
    And I press next on the keyboard
    Then the focus should move to the expiration date field

  Scenario: Form field focus navigation
    When the expiration date field is focused
    And I complete the expiration date
    And I press next on the keyboard
    Then the focus should move to the CVV field

  Scenario: Empty form validation
    When I leave all fields empty
    And I try to submit the payment
    Then I should see validation errors for all required fields
    And the payment should not be processed
    And each field should display its specific error message

  Scenario: Payment card styling and UX
    Then the payment form should have a white background
    And the form should have rounded corners
    And the form should have a subtle shadow
    And the layout should be centered and constrained
    And the maximum width should be appropriate for mobile

  Scenario: Keyboard behavior on mobile
    When I tap on any input field
    Then the numeric keyboard should appear for card number
    And the numeric keyboard should appear for expiration date
    And the numeric keyboard should appear for CVV
    And the keyboard should not obscure the submit button

  Scenario: Contract creation after successful payment
    Given I complete a successful payment
    Then a contract should be created via ContractOwnerService
    And the contract should include the selected plan identifier
    And the contract should be associated with the logged-in user
    And the payment should be recorded via PaymentService

  Scenario: Navigate back from payment screen
    When I press the back button
    Then I should return to the subscription plans screen
    And no payment should be processed
    And the form data should be cleared

  Scenario: Form data persistence during errors
    When I enter card number "4532015112830366"
    And I enter expiration date "1225"
    And I enter CVV "123"
    And the payment fails
    Then the entered data should remain in the form
    And I should be able to edit and resubmit

  Scenario: Security considerations
    Then the payment form should use secure input fields
    And sensitive data should not be logged
    And the CVV should never be displayed in plain text
    And the connection should be secure

  Scenario: Responsive layout on different devices
    Given I am viewing the payment screen on different device sizes
    Then the form should adapt to the screen size
    And all fields should remain accessible
    And the submit button should always be visible
    And proper spacing should be maintained
