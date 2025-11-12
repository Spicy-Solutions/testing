Feature: IoT Smoke Sensor Management
  As a hotel administrator
  I want to manage smoke sensors
  So that I can monitor room safety

  Scenario: Create a new smoke sensor
    Given I am authenticated as a hotel administrator
    When I register a new smoke sensor for a room
    Then the sensor should be created successfully
    And the sensor should be active

  Scenario: Update smoke sensor state
    Given a smoke sensor exists
    When I update the sensor state and temperature
    Then the sensor state should be updated successfully

  Scenario: Get smoke sensor by ID
    Given a smoke sensor exists with a specific ID
    When I request the sensor information
    Then I should receive the sensor details

  Scenario: Get all smoke sensors
    Given there are smoke sensors in the system
    When I request all sensors
    Then I should receive the complete sensors list

  Scenario: Update sensor temperature
    Given a smoke sensor exists
    When I update only the temperature value
    Then the temperature should be updated successfully
    And an alert should be triggered if temperature is critical

  Scenario: Update smoke sensor configuration
    Given a smoke sensor exists
    When I update the sensor configuration
    Then the sensor should be reconfigured successfully
