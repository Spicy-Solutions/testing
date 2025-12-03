Feature: Mobile Subscription Plans
  As a hotel owner
  I want to view and select subscription plans
  So that I can choose the best plan for my hotel management needs

  Background:
    Given I am logged in as a hotel owner
    And I navigate to the subscription plans screen

  Scenario: Display all available subscription plans
    Then I should see the "BÁSICO" plan card
    And I should see the "REGULAR" plan card
    And I should see the "PREMIUM" plan card
    And each plan should display an icon
    And each plan should display a price

  Scenario: View Basic plan details
    When I view the "BÁSICO" plan
    Then I should see the price "$29.99 al mes"
    And I should see the icon for bed/rooms
    And I should see the feature "Access to room management with IoT technology"
    And I should see the feature "Collaborative administration for up to two people"
    And I should see exactly 2 features for this plan

  Scenario: View Regular plan details
    When I view the "REGULAR" plan
    Then I should see the price "$58.99 al mes"
    And I should see the icon for apartments
    And I should see the feature "Access to room management with IoT technology"
    And I should see the feature "Collaborative administration for up to two people"
    And I should see the feature "Access to interactive business management dashboards"
    And I should see exactly 3 features for this plan

  Scenario: View Premium plan details
    When I view the "PREMIUM" plan
    Then I should see the price "$110.69 al mes"
    And I should see the icon for business
    And I should see the feature "Access to room management with IoT technology"
    And I should see the feature "Collaborative administration for up to two people"
    And I should see the feature "Access to interactive business management dashboards"
    And I should see the feature "24/7 support and maintenance"
    And I should see exactly 4 features for this plan

  Scenario: Select Basic plan
    When I click on the "BÁSICO" plan card
    Then I should be navigated to the payment screen
    And the payment screen should have card identifier 1
    And the selected plan should be Basic

  Scenario: Select Regular plan
    When I click on the "REGULAR" plan card
    Then I should be navigated to the payment screen
    And the payment screen should have card identifier 2
    And the selected plan should be Regular

  Scenario: Select Premium plan
    When I click on the "PREMIUM" plan card
    Then I should be navigated to the payment screen
    And the payment screen should have card identifier 3
    And the selected plan should be Premium

  Scenario: Scroll through plans on small screens
    Given I am viewing the plans on a mobile device
    When I scroll down the screen
    Then all three plans should be accessible
    And the scroll should be smooth
    And proper spacing should be maintained between plans

  Scenario: Plan cards display consistent styling
    Then all plan cards should have consistent width
    And all plan cards should have proper padding
    And all plan cards should be visually separated
    And feature lists should be properly formatted

  Scenario: Navigate back from subscription plans
    When I press the back button
    Then I should return to the previous screen
    And no plan should be selected

  Scenario: Plan comparison by price
    Then the "BÁSICO" plan should be the cheapest option
    And the "REGULAR" plan should be mid-tier pricing
    And the "PREMIUM" plan should be the most expensive option

  Scenario: Feature progression across plans
    Then the "BÁSICO" plan should have the base features
    And the "REGULAR" plan should include all Basic features plus additional features
    And the "PREMIUM" plan should include all Regular features plus premium features

  Scenario: UI responsiveness on different screen sizes
    Given I am viewing the plans on different screen sizes
    Then the layout should adapt appropriately
    And text should remain readable
    And buttons should remain accessible

  Scenario: Plan card interaction feedback
    When I tap on a plan card
    Then there should be visual feedback
    And the navigation should occur smoothly
    And loading state should be minimal
