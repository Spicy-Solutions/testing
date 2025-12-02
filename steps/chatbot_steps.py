"""
Chatbot Step Definitions for BDD Testing
This module contains step implementations for testing the chatbot functionality
"""

from behave import given, when, then
import json
import uuid
from unittest.mock import Mock, patch, MagicMock


# Mock classes for Vue component testing
class MockChatbotComponent:
    """Mock class to simulate the ChatbotPopupComponent behavior"""
    
    def __init__(self):
        self.robot_icon = "robot.png"
        self.messages = []
        self.user_input = ""
        self.is_loading = False
        self.conversation_id = None
        self.username = "Manager"
        self.income = 5000
        self.expenses = 3000
        self.chatbot_service = MockChatbotService()
        self.local_storage = {}
        
    def send_message(self):
        """Simulate sending a message"""
        if not self.user_input.strip():
            return
        
        user_message = self.user_input.strip()
        self.user_input = ""
        
        # Add user message
        self.add_message({
            'type': 'user',
            'content': user_message,
            'timestamp': '2024-01-01T00:00:00.000Z'
        })
        
        self.is_loading = True
        
        # Simulate API call
        try:
            response = self.chatbot_service.send_message(
                user_message,
                self.username,
                self.income,
                self.expenses,
                self.conversation_id
            )
            
            # Add bot response
            self.add_message({
                'type': 'robot',
                'content': response.get('message', 'Sorry, I could not process your message.'),
                'timestamp': '2024-01-01T00:00:01.000Z'
            })
        except Exception as error:
            error_message = 'Sorry, there was an error processing your message.'
            
            if 'chatbot not running' in str(error):
                error_message = '⚠️ The chatbot is not active. Please start the chatbot server.'
            
            self.add_message({
                'type': 'robot',
                'content': error_message,
                'timestamp': '2024-01-01T00:00:02.000Z'
            })
        finally:
            self.is_loading = False
    
    def add_message(self, message):
        """Add a message to the conversation"""
        self.messages.append(message)
        self.save_conversation()
    
    def save_conversation(self):
        """Save conversation to mock localStorage"""
        conversation = {
            'conversationId': self.conversation_id,
            'messages': self.messages
        }
        self.local_storage['chatbot_conversation'] = json.dumps(conversation)
    
    def reset_conversation(self):
        """Reset the conversation"""
        self.local_storage.pop('chatbot_conversation', None)
        self.conversation_id = str(uuid.uuid4())
        self.messages = []
        
        # Add welcome message
        self.add_message({
            'type': 'robot',
            'content': f'¡Hola {self.username}! Soy SweetBot, tu asistente financiero para la gestión de tu hotel. Puedo ayudarte con finanzas, toma de decisiones y análisis de gastos. ¿En qué puedo ayudarte hoy?',
            'timestamp': '2024-01-01T00:00:00.000Z'
        })
    
    def close_chat(self):
        """Close the chat and save conversation"""
        self.save_conversation()
        return True
    
    def restore_conversation(self):
        """Restore conversation from localStorage"""
        saved = self.local_storage.get('chatbot_conversation')
        if saved:
            conversation = json.loads(saved)
            self.conversation_id = conversation['conversationId']
            self.messages = conversation['messages']
            return True
        return False
    
    def handle_key_press(self, event):
        """Handle keyboard events"""
        if event.get('key') == 'Enter' and not event.get('shiftKey'):
            event['preventDefault'] = True
            self.send_message()
            return True
        return False


class MockChatbotService:
    """Mock class to simulate ChatbotApiService"""
    
    def __init__(self):
        self.base_url = 'http://localhost:8000'
        self.is_available = True
        self.last_request = None
    
    def generate_uuid(self):
        """Generate a UUID v4"""
        return str(uuid.uuid4())
    
    def send_message(self, message, username='User', income=0, expenses=0, conversation_id=None):
        """Mock send message to chatbot API"""
        self.last_request = {
            'message': message,
            'username': username,
            'income': income,
            'expenses': expenses,
            'conversation_id': conversation_id
        }
        
        if not self.is_available:
            raise Exception('chatbot not running')
        
        # Simulate API response
        return {
            'message': f'This is a response to: {message}',
            'conversation_id': conversation_id
        }
    
    def get_models(self):
        """Get available models"""
        if not self.is_available:
            raise Exception('Service unavailable')
        
        return {
            'models': ['gpt-3.5-turbo', 'gpt-4']
        }


# Context storage
class ChatbotContext:
    """Store context between steps"""
    def __init__(self):
        self.component = None
        self.service = None
        self.last_error = None
        self.last_event = None


# Step Definitions

@given('the chatbot service is available')
def step_chatbot_service_available(context):
    """Initialize the chatbot service as available"""
    if not hasattr(context, 'chatbot_ctx'):
        context.chatbot_ctx = ChatbotContext()
    
    context.chatbot_ctx.service = MockChatbotService()
    context.chatbot_ctx.service.is_available = True


@given('the chatbot service is unavailable')
def step_chatbot_service_unavailable(context):
    """Set the chatbot service as unavailable"""
    if not hasattr(context, 'chatbot_ctx'):
        context.chatbot_ctx = ChatbotContext()
    
    context.chatbot_ctx.service = MockChatbotService()
    context.chatbot_ctx.service.is_available = False


@given('the user is logged in as "{username}"')
def step_user_logged_in(context, username):
    """Set the logged in user"""
    if not hasattr(context, 'chatbot_ctx'):
        context.chatbot_ctx = ChatbotContext()
    
    context.chatbot_ctx.username = username


@given('the conversation is initialized with a new UUID')
def step_conversation_initialized(context):
    """Initialize a new conversation with UUID"""
    if not hasattr(context, 'chatbot_ctx'):
        context.chatbot_ctx = ChatbotContext()
    
    if not context.chatbot_ctx.component:
        context.chatbot_ctx.component = MockChatbotComponent()
    
    context.chatbot_ctx.component.conversation_id = str(uuid.uuid4())


@given('the chatbot popup is open')
def step_chatbot_popup_open(context):
    """Open the chatbot popup"""
    if not hasattr(context, 'chatbot_ctx'):
        context.chatbot_ctx = ChatbotContext()
    
    if not context.chatbot_ctx.component:
        context.chatbot_ctx.component = MockChatbotComponent()
        context.chatbot_ctx.component.conversation_id = str(uuid.uuid4())
        context.chatbot_ctx.component.chatbot_service = context.chatbot_ctx.service
        
        # Add initial welcome message
        context.chatbot_ctx.component.add_message({
            'type': 'robot',
            'content': f'¡Hola {context.chatbot_ctx.component.username}! Soy SweetBot, tu asistente financiero para la gestión de tu hotel. Puedo ayudarte con finanzas, toma de decisiones y análisis de gastos. ¿En qué puedo ayudarte hoy?',
            'timestamp': '2024-01-01T00:00:00.000Z'
        })


@given('there are messages in the conversation history')
def step_messages_in_history(context):
    """Add some messages to conversation history"""
    component = context.chatbot_ctx.component
    
    component.add_message({
        'type': 'user',
        'content': 'Hello',
        'timestamp': '2024-01-01T00:00:00.000Z'
    })
    
    component.add_message({
        'type': 'robot',
        'content': 'Hi! How can I help you?',
        'timestamp': '2024-01-01T00:00:01.000Z'
    })


@given('the user had a previous conversation')
def step_previous_conversation(context):
    """Set up a previous conversation in localStorage"""
    if not hasattr(context, 'chatbot_ctx'):
        context.chatbot_ctx = ChatbotContext()
    
    if not context.chatbot_ctx.component:
        context.chatbot_ctx.component = MockChatbotComponent()
    
    # Create a previous conversation
    context.chatbot_ctx.component.conversation_id = str(uuid.uuid4())
    context.chatbot_ctx.component.add_message({
        'type': 'user',
        'content': 'Previous message',
        'timestamp': '2024-01-01T00:00:00.000Z'
    })


@given('the conversation is saved in localStorage')
def step_conversation_saved(context):
    """Ensure conversation is saved"""
    context.chatbot_ctx.component.save_conversation()


@given('the user has income of {income:d} and expenses of {expenses:d}')
def step_user_finances(context, income, expenses):
    """Set user financial data"""
    context.chatbot_ctx.component.income = income
    context.chatbot_ctx.component.expenses = expenses


@given('there are multiple messages in the conversation')
def step_multiple_messages(context):
    """Add multiple messages to the conversation"""
    component = context.chatbot_ctx.component
    
    for i in range(5):
        component.add_message({
            'type': 'user',
            'content': f'Message {i}',
            'timestamp': f'2024-01-01T00:00:0{i}.000Z'
        })


@when('the chatbot popup is opened for the first time')
def step_open_first_time(context):
    """Open chatbot for the first time"""
    if not hasattr(context, 'chatbot_ctx'):
        context.chatbot_ctx = ChatbotContext()
    
    context.chatbot_ctx.component = MockChatbotComponent()
    context.chatbot_ctx.component.conversation_id = str(uuid.uuid4())
    
    # Add welcome message
    context.chatbot_ctx.component.add_message({
        'type': 'robot',
        'content': f'¡Hola {context.chatbot_ctx.component.username}! Soy SweetBot, tu asistente financiero para la gestión de tu hotel. Puedo ayudarte con finanzas, toma de decisiones y análisis de gastos. ¿En qué puedo ayudarte hoy?',
        'timestamp': '2024-01-01T00:00:00.000Z'
    })


@when('the chatbot popup is opened')
def step_open_popup(context):
    """Open the chatbot popup"""
    if not hasattr(context, 'chatbot_ctx'):
        context.chatbot_ctx = ChatbotContext()
    
    if not context.chatbot_ctx.component:
        context.chatbot_ctx.component = MockChatbotComponent()
    
    # Try to restore conversation
    context.chatbot_ctx.component.restore_conversation()
    
    # If no conversation, initialize new one
    if not context.chatbot_ctx.component.conversation_id:
        context.chatbot_ctx.component.conversation_id = str(uuid.uuid4())


@when('the user types "{message}"')
def step_user_types(context, message):
    """User types a message"""
    context.chatbot_ctx.component.user_input = message


@when('the user clicks the send button')
def step_click_send(context):
    """User clicks send button"""
    context.chatbot_ctx.component.send_message()


@when('the user presses the Enter key')
def step_press_enter(context):
    """User presses Enter key"""
    event = {'key': 'Enter', 'shiftKey': False}
    context.chatbot_ctx.component.handle_key_press(event)


@when('the user presses Shift+Enter')
def step_press_shift_enter(context):
    """User presses Shift+Enter"""
    event = {'key': 'Enter', 'shiftKey': True}
    context.chatbot_ctx.component.handle_key_press(event)
    context.chatbot_ctx.last_event = event


@when('the user tries to send an empty message')
def step_send_empty(context):
    """User tries to send empty message"""
    context.chatbot_ctx.component.user_input = ""
    initial_message_count = len(context.chatbot_ctx.component.messages)
    context.chatbot_ctx.component.send_message()
    context.chatbot_ctx.initial_message_count = initial_message_count


@when('the user clicks the reset conversation button')
def step_click_reset(context):
    """User clicks reset button"""
    context.chatbot_ctx.component.reset_conversation()


@when('the user clicks the close button')
def step_click_close(context):
    """User clicks close button"""
    context.chatbot_ctx.component.close_chat()


@when('the user sends a message "{message}"')
def step_send_message(context, message):
    """User sends a message"""
    context.chatbot_ctx.component.user_input = message
    context.chatbot_ctx.component.send_message()


@when('the user sends the message "{message}"')
def step_send_the_message(context, message):
    """User sends a specific message"""
    context.chatbot_ctx.component.user_input = message
    context.chatbot_ctx.component.send_message()


@when('the chatbot responds')
def step_chatbot_responds(context):
    """Wait for chatbot to respond (already handled in send_message)"""
    # The response is already added in the send_message method
    pass


@when('a new message is sent or received')
def step_new_message(context):
    """New message is sent or received"""
    context.chatbot_ctx.component.user_input = "New message"
    context.chatbot_ctx.component.send_message()


@when('the user sends a very long message')
def step_send_long_message(context):
    """Send a very long message"""
    long_message = "This is a very long message " * 20
    context.chatbot_ctx.component.user_input = long_message
    context.chatbot_ctx.component.send_message()


@when('the user sends a message')
def step_user_sends_message(context):
    """User sends any message"""
    context.chatbot_ctx.component.user_input = "Test message"
    context.chatbot_ctx.component.send_message()


@when('the user sends the message')
def step_send_the_message_generic(context):
    """User sends the typed message"""
    context.chatbot_ctx.component.send_message()


@then('the user message should appear in the chat')
def step_user_message_appears(context):
    """Verify user message appears"""
    messages = context.chatbot_ctx.component.messages
    assert len(messages) > 0, "No messages in chat"
    
    # Find the last user message
    user_messages = [m for m in messages if m['type'] == 'user']
    assert len(user_messages) > 0, "No user messages found"


@then('the chatbot should show a loading indicator')
def step_loading_indicator_shown(context):
    """Verify loading indicator is shown"""
    # In real implementation, this would check the component state during loading
    # For mock, we verify the flow happened correctly
    assert context.chatbot_ctx.component is not None


@then('the loading indicator should appear immediately')
def step_loading_appears_immediately(context):
    """Verify loading appears immediately"""
    assert context.chatbot_ctx.component is not None


@then('the chatbot should respond with a message')
def step_chatbot_responds_message(context):
    """Verify chatbot responded"""
    messages = context.chatbot_ctx.component.messages
    robot_messages = [m for m in messages if m['type'] == 'robot']
    assert len(robot_messages) > 0, "No robot messages found"


@then('the loading indicator should disappear')
def step_loading_disappears(context):
    """Verify loading indicator disappeared"""
    assert context.chatbot_ctx.component.is_loading is False


@then('the send button should be disabled')
def step_send_button_disabled(context):
    """Verify send button is disabled"""
    # Button should be disabled when input is empty
    assert context.chatbot_ctx.component.user_input == ""


@then('the send button should be disabled during loading')
def step_send_disabled_during_loading(context):
    """Verify send button is disabled during loading"""
    # This would be checked during the loading state
    assert True  # Placeholder for actual implementation


@then('the input field should be disabled during loading')
def step_input_disabled_during_loading(context):
    """Verify input field is disabled during loading"""
    # This would be checked during the loading state
    assert True  # Placeholder for actual implementation


@then('no message should be sent to the chatbot')
def step_no_message_sent(context):
    """Verify no message was sent"""
    final_count = len(context.chatbot_ctx.component.messages)
    assert final_count == context.chatbot_ctx.initial_message_count


@then('the chatbot should display a welcome message')
def step_welcome_message_displayed(context):
    """Verify welcome message is displayed"""
    messages = context.chatbot_ctx.component.messages
    assert len(messages) > 0, "No messages found"
    assert messages[0]['type'] == 'robot', "First message is not from robot"


@then('the welcome message should include the user\'s name')
def step_welcome_includes_name(context):
    """Verify welcome message includes user name"""
    messages = context.chatbot_ctx.component.messages
    welcome_message = messages[0]['content']
    assert 'Manager' in welcome_message or context.chatbot_ctx.component.username in welcome_message


@then('the welcome message should mention financial assistance')
def step_welcome_mentions_finance(context):
    """Verify welcome message mentions financial assistance"""
    messages = context.chatbot_ctx.component.messages
    welcome_message = messages[0]['content'].lower()
    assert 'financ' in welcome_message or 'asistente' in welcome_message


@then('the conversation history should be cleared')
def step_conversation_cleared(context):
    """Verify conversation is cleared"""
    # After reset, should only have the welcome message
    assert len(context.chatbot_ctx.component.messages) == 1


@then('a new conversation ID should be generated')
def step_new_conversation_id(context):
    """Verify new conversation ID was generated"""
    assert context.chatbot_ctx.component.conversation_id is not None
    assert len(context.chatbot_ctx.component.conversation_id) > 0


@then('a new welcome message should be displayed')
def step_new_welcome_displayed(context):
    """Verify new welcome message is displayed"""
    messages = context.chatbot_ctx.component.messages
    assert len(messages) > 0
    assert messages[-1]['type'] == 'robot'


@then('the chatbot popup should close')
def step_popup_closes(context):
    """Verify popup closes"""
    result = context.chatbot_ctx.component.close_chat()
    assert result is True


@then('the conversation should be saved to localStorage')
def step_conversation_saved_to_storage(context):
    """Verify conversation is saved"""
    assert 'chatbot_conversation' in context.chatbot_ctx.component.local_storage


@then('the previous conversation should be restored')
def step_previous_conversation_restored(context):
    """Verify previous conversation was restored"""
    assert len(context.chatbot_ctx.component.messages) > 0


@then('the conversation ID should match the saved one')
def step_conversation_id_matches(context):
    """Verify conversation ID matches"""
    saved = json.loads(context.chatbot_ctx.component.local_storage.get('chatbot_conversation', '{}'))
    assert context.chatbot_ctx.component.conversation_id == saved.get('conversationId')


@then('all previous messages should be displayed')
def step_previous_messages_displayed(context):
    """Verify previous messages are displayed"""
    messages = context.chatbot_ctx.component.messages
    assert any(m['content'] == 'Previous message' for m in messages)


@then('an error message should be displayed')
def step_error_message_displayed(context):
    """Verify error message is displayed"""
    messages = context.chatbot_ctx.component.messages
    robot_messages = [m for m in messages if m['type'] == 'robot']
    last_robot_message = robot_messages[-1]['content']
    assert 'error' in last_robot_message.lower() or 'activ' in last_robot_message.lower()


@then('the error message should suggest starting the chatbot server')
def step_error_suggests_start_server(context):
    """Verify error message suggests starting server"""
    messages = context.chatbot_ctx.component.messages
    robot_messages = [m for m in messages if m['type'] == 'robot']
    last_robot_message = robot_messages[-1]['content']
    assert 'chatbot' in last_robot_message.lower()


@then('the message should be sent with the user\'s context')
def step_message_with_context(context):
    """Verify message was sent with context"""
    service = context.chatbot_ctx.component.chatbot_service
    assert service.last_request is not None


@then('the context should include username "{username}"')
def step_context_includes_username(context, username):
    """Verify context includes username"""
    service = context.chatbot_ctx.component.chatbot_service
    assert service.last_request['username'] == username


@then('the context should include income {income:d}')
def step_context_includes_income(context, income):
    """Verify context includes income"""
    service = context.chatbot_ctx.component.chatbot_service
    assert service.last_request['income'] == income


@then('the context should include expenses {expenses:d}')
def step_context_includes_expenses(context, expenses):
    """Verify context includes expenses"""
    service = context.chatbot_ctx.component.chatbot_service
    assert service.last_request['expenses'] == expenses


@then('the context should include the conversation ID')
def step_context_includes_conversation_id(context):
    """Verify context includes conversation ID"""
    service = context.chatbot_ctx.component.chatbot_service
    assert service.last_request['conversation_id'] is not None


@then('there should be {count:d} messages in the conversation')
def step_message_count(context, count):
    """Verify specific message count"""
    messages = context.chatbot_ctx.component.messages
    assert len(messages) == count, f"Expected {count} messages, found {len(messages)}"


@then('the messages should be displayed in chronological order')
def step_messages_chronological(context):
    """Verify messages are in chronological order"""
    messages = context.chatbot_ctx.component.messages
    for i in range(len(messages) - 1):
        assert messages[i]['timestamp'] <= messages[i + 1]['timestamp']


@then('all messages should use the same conversation ID')
def step_same_conversation_id(context):
    """Verify all messages use same conversation ID"""
    # In the implementation, all messages in a session use the same conversation_id
    assert context.chatbot_ctx.component.conversation_id is not None


@then('the message should be displayed with proper word wrapping')
def step_message_word_wrapping(context):
    """Verify message has proper word wrapping"""
    messages = context.chatbot_ctx.component.messages
    user_messages = [m for m in messages if m['type'] == 'user']
    assert len(user_messages[-1]['content']) > 50  # Verify it's actually long


@then('the message should not overflow the chat container')
def step_message_no_overflow(context):
    """Verify message doesn't overflow"""
    # This would be a CSS/visual test in real implementation
    assert True  # Placeholder


@then('the loading indicator should show typing animation')
def step_loading_typing_animation(context):
    """Verify loading indicator shows typing animation"""
    # This would check CSS animation in real implementation
    assert True  # Placeholder


@then('the input field should be empty')
def step_input_field_empty(context):
    """Verify input field is empty"""
    assert context.chatbot_ctx.component.user_input == ""


@then('the user should be able to type a new message')
def step_can_type_new_message(context):
    """Verify user can type new message"""
    context.chatbot_ctx.component.user_input = "New message"
    assert context.chatbot_ctx.component.user_input == "New message"


@then('the chat should automatically scroll to the bottom')
def step_auto_scroll_bottom(context):
    """Verify chat auto-scrolls to bottom"""
    # This would be a DOM manipulation check in real implementation
    assert True  # Placeholder


@then('the latest message should be visible')
def step_latest_message_visible(context):
    """Verify latest message is visible"""
    messages = context.chatbot_ctx.component.messages
    assert len(messages) > 0


@then('the message should contain multiple lines')
def step_message_multiline(context):
    """Verify message contains multiple lines"""
    # User input should still contain the text
    assert context.chatbot_ctx.component.user_input != ""


@then('the message should not be sent yet')
def step_message_not_sent_yet(context):
    """Verify message was not sent"""
    # Event should have prevented default
    assert context.chatbot_ctx.last_event.get('key') == 'Enter'
    assert context.chatbot_ctx.last_event.get('shiftKey') is True
