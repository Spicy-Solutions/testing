Feature: Room Management
  As a hotel administrator
  I want to manage room information and states
  So that I can keep track of room availability and status

  Scenario: Set up a new room
    Given I am authenticated as a hotel administrator
    When I set up a new room with room number, floor, and type
    Then the room should be created successfully
    And the room should appear in the rooms list

  Scenario: Create a room
    Given I have hotel access
    When I create a room with complete information
    Then the room should be registered in the system

  Scenario: Update room state
    Given a room exists in the system
    When I update the room state to "occupied"
    Then the room state should be updated successfully
    And the new state should be reflected in the system

  Scenario: Get room by ID
    Given a room exists with a specific ID
    When I request the room information by ID
    Then I should receive the room details

  Scenario: Get room by state
    Given there are rooms with different states
    When I filter rooms by state "available"
    Then I should receive only available rooms

  Scenario: Get all rooms
    Given there are rooms registered in the hotel
    When I request all rooms
    Then I should receive the complete rooms list

  Scenario: Get rooms by type
    Given there are rooms of different types
    When I filter rooms by type "suite"
    Then I should receive only suite rooms
