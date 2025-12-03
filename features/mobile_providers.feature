Feature: Mobile Providers Management
  As a hotel owner
  I want to manage my hotel providers
  So that I can maintain an updated list of suppliers for my hotel

  Background:
    Given I am logged in as a hotel owner
    And I have a valid hotel ID from my authentication token
    And I navigate to the providers view screen

  Scenario: Display providers list on load
    When the providers view loads
    Then the app should fetch providers for my hotel
    And a loading indicator should be displayed
    And the providers list should be loaded
    And only active providers should be displayed

  Scenario: Display empty providers list
    Given I have no providers in my hotel
    When the providers view loads
    Then I should see an empty state message
    And I should see an option to add a new provider

  Scenario: Display providers list with multiple providers
    Given I have multiple active providers
    When the providers view loads
    Then I should see all active providers in a list
    And each provider card should display provider information
    And each provider card should be tappable

  Scenario: View provider details
    Given I have providers in my list
    When I tap on a provider card
    Then a dialog should open with provider details
    And I should see the provider's avatar or default icon
    And I should see the provider's name
    And I should see the provider's email
    And I should see the provider's phone number
    And I should see the provider's status
    And I should see options to close or edit the provider

  Scenario: Provider avatar display
    When I view a provider's details
    Then I should see either the provider's photo or a default person icon
    And the avatar should be displayed in a circular format
    And the avatar size should be consistent

  Scenario: Close provider details dialog
    Given I am viewing a provider's details
    When I click the "Cerrar" button
    Then the dialog should close
    And I should return to the providers list

  Scenario: Open edit provider form from details
    Given I am viewing a provider's details
    When I click the "Editar" button
    Then the details dialog should close
    And the provider edit form should open
    And the form should be pre-filled with the provider's current data

  Scenario: Add new provider
    Given I am on the providers list
    When I click the add provider button
    Then a provider form dialog should open
    And the form should be empty for new provider
    And I should see fields for name, email, phone, address, and RUC

  Scenario: Fill new provider form
    Given I am adding a new provider
    When I enter provider name "ABC Supplies"
    And I enter provider email "contact@abcsupplies.com"
    And I enter provider phone "987654321"
    And I enter provider address "123 Main St"
    And I enter provider RUC "20123456789"
    And I submit the form
    Then the provider should be created
    And the new provider should appear in the list
    And a success message should be displayed

  Scenario: Edit existing provider
    Given I am editing a provider
    When I update the provider name to "Updated Supplies"
    And I update the provider phone to "912345678"
    And I submit the form
    Then the provider should be updated
    And the changes should be reflected in the list
    And a success message should be displayed

  Scenario: Form validation for required fields
    Given I am adding a new provider
    When I leave the name field empty
    And I try to submit the form
    Then I should see a validation error for the name field
    And the form should not be submitted

  Scenario: Email format validation
    Given I am adding a new provider
    When I enter an invalid email format "notanemail"
    And I try to submit the form
    Then I should see an email format validation error
    And the form should not be submitted

  Scenario: Phone number validation
    Given I am adding a new provider
    When I enter an invalid phone number "123"
    And I try to submit the form
    Then I should see a phone number validation error
    And the form should not be submitted

  Scenario: RUC validation
    Given I am adding a new provider
    When I enter an invalid RUC format "123"
    And I try to submit the form
    Then I should see a RUC validation error
    And the form should not be submitted

  Scenario: Cancel adding new provider
    Given I am adding a new provider
    And I have entered some data in the form
    When I click the cancel button
    Then the form should close
    And the data should not be saved
    And no new provider should be added to the list

  Scenario: Cancel editing provider
    Given I am editing a provider
    And I have made changes to the form
    When I click the cancel button
    Then the form should close
    And the changes should not be saved
    And the provider should retain its original data

  Scenario: Delete provider
    Given I am editing a provider
    When I click the delete button
    Then a confirmation dialog should appear
    When I confirm the deletion
    Then the provider should be deleted
    And the provider should be removed from the list
    And a success message should be displayed

  Scenario: Cancel provider deletion
    Given I am deleting a provider
    And a confirmation dialog is displayed
    When I cancel the deletion
    Then the provider should not be deleted
    And the dialog should close
    And the provider should remain in the list

  Scenario: Filter active providers only
    Given I have both active and inactive providers in the database
    When the providers list loads
    Then only providers with status "active" should be displayed
    And inactive providers should be hidden from the view

  Scenario: Loading state during provider fetch
    When I navigate to the providers view
    Then a loading indicator should be visible
    And the providers list should be hidden
    When the providers are loaded
    Then the loading indicator should disappear
    And the providers list should be displayed

  Scenario: Error handling when fetching providers fails
    Given the provider service is unavailable
    When I try to load the providers view
    Then an error message should be displayed
    And the error should explain what went wrong
    And I should see an option to retry

  Scenario: Error handling when hotel ID is missing
    Given I don't have a valid hotel ID in my token
    When I try to load the providers view
    Then an error snackbar should be displayed
    And the error should say "No se pudo obtener el hotelId del token"
    And the loading should stop

  Scenario: Success message after creating provider
    When I successfully create a new provider
    Then a snackbar should appear with a success message
    And the message should confirm the provider was created
    And the snackbar should auto-dismiss after a few seconds

  Scenario: Success message after updating provider
    When I successfully update a provider
    Then a snackbar should appear with a success message
    And the message should confirm the provider was updated

  Scenario: Success message after deleting provider
    When I successfully delete a provider
    Then a snackbar should appear with a success message
    And the message should confirm the provider was deleted

  Scenario: Provider card UI consistency
    Given I have multiple providers in the list
    Then all provider cards should have consistent styling
    And proper spacing should be maintained between cards
    And each card should be easily distinguishable

  Scenario: Scroll behavior with many providers
    Given I have more than 10 providers
    When I scroll through the providers list
    Then the scroll should be smooth
    And all providers should be accessible through scrolling
    And the list should maintain performance

  Scenario: Refresh providers list
    Given I am viewing the providers list
    When I perform a pull-to-refresh gesture
    Then the providers should be fetched again
    And the list should be updated with the latest data
    And any new providers should appear

  Scenario: Provider service integration
    When I perform any provider operation
    Then the app should use the ProviderService
    And API calls should include the hotel ID
    And proper authentication should be included
    And errors should be handled gracefully

  Scenario: Token helper integration
    When the providers view loads
    Then the app should use TokenHelper to get the hotel ID
    And the hotel ID should be extracted from the JWT token
    And the hotel ID should be used for all provider operations
