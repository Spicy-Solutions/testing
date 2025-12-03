Feature: Mobile User Profile Management
  As a hotel owner or guest
  I want to manage my user profile
  So that I can keep my personal information up to date

  Background:
    Given I am logged in to the mobile app
    And I navigate to the account page

  Scenario: Display account page loading state
    When the account page loads
    Then a loading indicator should be displayed
    And the profile content should be hidden
    When the profile data is loaded
    Then the loading indicator should disappear
    And the profile content should be visible

  Scenario: Display user profile for hotel owner
    Given I am logged in as a hotel owner
    When the account page loads
    Then I should see my profile photo or default avatar
    And I should see my full name
    And I should see my role displayed as "Owner"
    And I should see navigation options for profile sections

  Scenario: Display user profile for guest
    Given I am logged in as a guest
    When the account page loads
    Then I should see my profile photo or default avatar
    And I should see my full name
    And I should see my role displayed as "Guest"
    And I should see navigation options for profile sections

  Scenario: Display default avatar when photo URL is not available
    Given I have no profile photo uploaded
    When I view my account page
    Then I should see a default avatar icon
    And the default avatar should be a social media user icon
    And the avatar should be displayed in a circular format

  Scenario: Display custom avatar when photo URL is available
    Given I have uploaded a profile photo
    When I view my account page
    Then I should see my custom profile photo
    And the photo should be loaded from the correct URL
    And the photo should be displayed in a circular format

  Scenario: Navigate to profile information section
    Given I am on the account page
    When I click on "Profile Information" option
    Then I should be navigated to the user profile info page
    And I should see my detailed profile information

  Scenario: Navigate to profile preferences section
    Given I am on the account page
    When I click on "Profile Preferences" option
    Then I should be navigated to the user profile preferences page
    And I should see my preference settings

  Scenario: Error handling when profile fetch fails
    Given the user service is unavailable
    When I try to load the account page
    Then an error state should be displayed
    And an error message should explain what went wrong
    And I should see an option to retry

  Scenario: Error message display
    When a profile loading error occurs
    Then the error message should be clearly visible
    And the error should indicate the specific problem
    And I should be able to dismiss the error

  Scenario: Retry loading profile after error
    Given I have encountered a profile loading error
    When I click the retry button
    Then the profile should attempt to load again
    And a loading indicator should appear
    And the error message should disappear

  Scenario: Role ID extraction from token
    Given I have a valid authentication token
    When the account page initializes
    Then the app should extract the role ID from the token
    And the role ID should be used to determine user type
    And appropriate profile data should be fetched based on role

  Scenario: Guest profile data retrieval
    Given I am logged in as a guest
    When my profile is loaded
    Then the app should call UserService.getGuestProfile()
    And the guest profile data should be populated
    And guest-specific information should be displayed

  Scenario: Owner profile data retrieval
    Given I am logged in as a hotel owner
    When my profile is loaded
    Then the app should call UserService.getOwnerProfile()
    And the owner profile data should be populated
    And owner-specific information should be displayed

  Scenario: Profile data initialization sequence
    When I open the account page
    Then the role ID should be fetched first
    Then the user profile should be fetched
    Then the loading state should be updated
    And all data should be ready before display

  Scenario: Handle missing user name gracefully
    Given my profile has no name set
    When the account page loads
    Then I should see "Unknown User" as the display name
    And the app should not crash
    And I should be able to update my name

  Scenario: Secure storage integration
    When profile data is loaded
    Then authentication tokens should be retrieved from secure storage
    And tokens should be used for API calls
    And sensitive data should be handled securely

  Scenario: Token helper usage
    When the account page needs authentication data
    Then the TokenHelper should be used to access tokens
    And the token should be validated before use
    And expired tokens should be handled appropriately

  Scenario: Base layout integration
    Then the account page should use BaseLayout widget
    And the role should be passed to BaseLayout
    And navigation should be properly integrated
    And the layout should be consistent with other screens

  Scenario: Profile photo URL handling for owner
    Given I am a hotel owner with a photo URL
    When my profile loads
    Then the owner's photoURL should be used
    And the image should be loaded asynchronously
    And a placeholder should show while loading

  Scenario: Profile photo URL handling for guest
    Given I am a guest with a photo URL
    When my profile loads
    Then the guest's photoURL should be used
    And the image should be loaded asynchronously
    And a placeholder should show while loading

  Scenario: Profile information page content
    Given I navigate to profile information
    Then I should see fields for personal details
    And I should be able to edit my information
    And changes should be saved properly
    And I should receive confirmation of updates

  Scenario: Profile preferences page content
    Given I navigate to profile preferences
    Then I should see my preference settings
    And I should be able to modify preferences
    And preferences should be saved locally
    And I should receive confirmation of changes

  Scenario: Refresh profile data
    Given I am viewing my profile
    When I pull to refresh
    Then the profile data should be refetched
    And a loading indicator should appear briefly
    And updated data should be displayed
    And the refresh indicator should disappear

  Scenario: Profile consistency across app
    Given I update my profile information
    When I navigate to different screens
    Then my updated profile data should be reflected everywhere
    And the user name should be consistent
    And the profile photo should be consistent

  Scenario: Loading state prevents interaction
    When the profile is loading
    Then interactive elements should be disabled
    And the user should not be able to navigate away prematurely
    And data should not be partially displayed

  Scenario: Successful profile load clears previous errors
    Given I previously had a profile loading error
    When I successfully load my profile
    Then the error state should be cleared
    And the error message should not be visible
    And the profile should display normally

  Scenario: Account page navigation options layout
    Then navigation options should be clearly visible
    And options should be organized logically
    And each option should have an appropriate icon
    And tap targets should be adequately sized

  Scenario: Profile state management
    When profile data changes
    Then the UI should update reactively
    And setState should be called appropriately
    And the widget tree should rebuild efficiently
    And no unnecessary rebuilds should occur

  Scenario: Owner and guest profile differentiation
    Then owner profiles should have owner-specific features
    And guest profiles should have guest-specific features
    And role-based access should be enforced
    And unauthorized features should not be accessible
