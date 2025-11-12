Feature: Hotel Management
  As a hotel owner
  I want to manage hotel information
  So that I can maintain updated hotel data in the system

  Scenario: Create a new hotel
    Given I am authenticated as a hotel owner
    When I submit a new hotel with complete information
    Then the hotel should be created successfully
    And I should see the new hotel in my hotels list

  Scenario: Get all hotels
    Given there are hotels registered in the system
    When I request the list of all hotels
    Then I should receive all registered hotels

  Scenario: Get hotel by ID
    Given a hotel exists with a specific ID
    When I request the hotel information by ID
    Then I should receive the hotel details

  Scenario: Update hotel information
    Given I am the owner of a hotel
    When I update the hotel information
    Then the hotel data should be updated successfully
    And the changes should be reflected in the system

  Scenario: Get hotels by owner
    Given I am authenticated as a hotel owner
    When I request my hotels list
    Then I should see only my hotels
