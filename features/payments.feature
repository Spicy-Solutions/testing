Feature: Payment Management
  As a system administrator
  I want to manage customer and owner payments
  So that I can track financial transactions

  Scenario: Create customer payment
    Given I am authenticated as an administrator
    When I register a customer payment with amount and method
    Then the payment should be recorded successfully
    And the payment should appear in the payments list

  Scenario: Get all customer payments
    Given there are customer payments in the system
    When I request all customer payments
    Then I should receive the complete payments list

  Scenario: Get customer payment by ID
    Given a customer payment exists
    When I request the payment by ID
    Then I should receive the payment details

  Scenario: Update customer payment
    Given a customer payment exists
    When I update the payment status
    Then the payment should be updated successfully

  Scenario: Get payments by customer
    Given a customer has made payments
    When I request payments for that customer
    Then I should receive all customer payments

  Scenario: Create owner payment
    Given I am authenticated as an administrator
    When I register an owner payment
    Then the payment should be recorded successfully

  Scenario: Get weekly incomes
    Given there are payments for a hotel
    When I request weekly incomes report
    Then I should receive weekly income statistics

  Scenario: Get monthly incomes
    Given there are payments for a hotel
    When I request monthly incomes report
    Then I should receive monthly income statistics
