Feature: Chatbot Functionality
  As a hotel manager
  I want to interact with the chatbot assistant
  So that I can get help with financial management and decision making

  Background:
    Given the chatbot service is available
    And the user is logged in as "Manager"
    And the conversation is initialized with a new UUID

  Scenario: User sends a message and receives a response
    Given the chatbot popup is open
    When the user types "Hello, how can you help me?"
    And the user clicks the send button
    Then the user message should appear in the chat
    And the chatbot should show a loading indicator
    And the chatbot should respond with a message
    And the loading indicator should disappear

  Scenario: User sends a message using Enter key
    Given the chatbot popup is open
    When the user types "What are my expenses?"
    And the user presses the Enter key
    Then the user message should appear in the chat
    And the chatbot should respond with a message

  Scenario: User cannot send empty messages
    Given the chatbot popup is open
    When the user tries to send an empty message
    Then the send button should be disabled
    And no message should be sent to the chatbot

  Scenario: Chatbot displays welcome message on initialization
    When the chatbot popup is opened for the first time
    Then the chatbot should display a welcome message
    And the welcome message should include the user's name
    And the welcome message should mention financial assistance

  Scenario: User resets the conversation
    Given the chatbot popup is open
    And there are messages in the conversation history
    When the user clicks the reset conversation button
    Then the conversation history should be cleared
    And a new conversation ID should be generated
    And a new welcome message should be displayed

  Scenario: User closes the chatbot
    Given the chatbot popup is open
    When the user clicks the close button
    Then the chatbot popup should close
    And the conversation should be saved to localStorage

  Scenario: Conversation persistence across sessions
    Given the user had a previous conversation
    And the conversation is saved in localStorage
    When the chatbot popup is opened
    Then the previous conversation should be restored
    And the conversation ID should match the saved one
    And all previous messages should be displayed

  Scenario: Chatbot handles API errors gracefully
    Given the chatbot service is unavailable
    And the chatbot popup is open
    When the user sends a message "Test error handling"
    Then an error message should be displayed
    And the error message should suggest starting the chatbot server

  Scenario: Chatbot sends context with messages
    Given the chatbot popup is open
    And the user has income of 5000 and expenses of 3000
    When the user sends a message "Analyze my finances"
    Then the message should be sent with the user's context
    And the context should include username "Manager"
    And the context should include income 5000
    And the context should include expenses 3000
    And the context should include the conversation ID

  Scenario: Multiple messages maintain conversation flow
    Given the chatbot popup is open
    When the user sends the message "Hello"
    And the chatbot responds
    And the user sends the message "What's my balance?"
    And the chatbot responds
    Then there should be 5 messages in the conversation
    And the messages should be displayed in chronological order
    And all messages should use the same conversation ID

  Scenario: Chatbot handles long messages properly
    Given the chatbot popup is open
    When the user sends a very long message
    Then the message should be displayed with proper word wrapping
    And the message should not overflow the chat container

  Scenario: Loading indicator appears during API call
    Given the chatbot popup is open
    When the user sends a message
    Then the loading indicator should appear immediately
    And the send button should be disabled during loading
    And the input field should be disabled during loading
    And the loading indicator should show typing animation

  Scenario: User input is cleared after sending
    Given the chatbot popup is open
    When the user types "Test message"
    And the user sends the message
    Then the input field should be empty
    And the user should be able to type a new message

  Scenario: Conversation auto-scrolls to latest message
    Given the chatbot popup is open
    And there are multiple messages in the conversation
    When a new message is sent or received
    Then the chat should automatically scroll to the bottom
    And the latest message should be visible

  Scenario: Shift+Enter creates new line without sending
    Given the chatbot popup is open
    When the user types "First line"
    And the user presses Shift+Enter
    And the user types "Second line"
    Then the message should contain multiple lines
    And the message should not be sent yet
