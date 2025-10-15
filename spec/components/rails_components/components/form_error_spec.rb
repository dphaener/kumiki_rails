require "rails_helper"

RSpec.describe RailsComponents::Components::FormError, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    error = RailsComponents::Components::FormError.new

    expect(error.message).to be_nil
    expect(error.messages).to be_nil
    expect(error.object).to be_nil
    expect(error.attribute).to be_nil
    expect(error.html_options).to eq({})
  end

  it "initialize with message" do
    error = RailsComponents::Components::FormError.new(message: "This field is required")

    expect(error.message).to eq("This field is required")
    expect(error.messages).to be_nil
    expect(error.object).to be_nil
    expect(error.attribute).to be_nil
  end

  it "initialize with messages array" do
    messages = [ "This field is required", "Must be at least 3 characters" ]
    error = RailsComponents::Components::FormError.new(messages: messages)

    expect(error.message).to be_nil
    expect(error.messages).to eq(messages)
    expect(error.object).to be_nil
    expect(error.attribute).to be_nil
  end

  it "initialize with object and attribute" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new(email: [ "can't be blank", "is invalid" ])
      end
    end.new

    html_options = { id: "email-errors", data: { test: "value" } }
    error = RailsComponents::Components::FormError.new(
      object: mock_object,
      attribute: :email,
      html_options: html_options
    )

    expect(error.message).to be_nil
    expect(error.messages).to be_nil
    expect(error.object).to eq(mock_object)
    expect(error.attribute).to eq(:email)
    expect(error.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    error = RailsComponents::Components::FormError.new
    expect(error.css_classes).to eq("text-error text-sm mt-1")
  end

  it "css classes with custom class string" do
    error = RailsComponents::Components::FormError.new(
      html_options: { class: "custom-class another-class" }
    )

    expect(error.css_classes).to eq("text-error text-sm mt-1 custom-class another-class")
  end

  it "css classes with custom class array" do
    error = RailsComponents::Components::FormError.new(
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(error.css_classes).to eq("text-error text-sm mt-1 custom-class another-class")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    error = RailsComponents::Components::FormError.new
    expected = {
      class: "text-error text-sm mt-1"
    }

    expect(error.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "field-errors",
      role: "alert",
      "aria-live": "polite",
      "data-testid": "error-messages"
    }

    error = RailsComponents::Components::FormError.new(html_options: html_options)

    expected = {
      id: "field-errors",
      role: "alert",
      "aria-live": "polite",
      "data-testid": "error-messages",
      class: "text-error text-sm mt-1"
    }

    expect(error.html_attributes).to eq(expected)
  end

  # Test error detection and message extraction
  it "has errors with single message" do
    error = RailsComponents::Components::FormError.new(message: "This field is required")
    expect(error.has_errors?).to eq(true)
  end

  it "has errors with messages array" do
    error = RailsComponents::Components::FormError.new(messages: [ "Error 1", "Error 2" ])
    expect(error.has_errors?).to eq(true)
  end

  it "has errors with object and attribute with errors" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new(email: [ "can't be blank" ])
      end
    end.new

    error = RailsComponents::Components::FormError.new(
      object: mock_object,
      attribute: :email
    )

    expect(error.has_errors?).to eq(true)
  end

  it "has errors with object and attribute without errors" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new({})
      end
    end.new

    error = RailsComponents::Components::FormError.new(
      object: mock_object,
      attribute: :email
    )

    expect(error.has_errors?).to eq(false)
  end

  it "has errors with no errors" do
    error = RailsComponents::Components::FormError.new
    expect(error.has_errors?).to eq(false)
  end

  it "has errors with empty message" do
    error = RailsComponents::Components::FormError.new(message: "")
    expect(error.has_errors?).to eq(false)
  end

  it "has errors with nil message" do
    error = RailsComponents::Components::FormError.new(message: nil)
    expect(error.has_errors?).to eq(false)
  end

  it "has errors with empty messages array" do
    error = RailsComponents::Components::FormError.new(messages: [])
    expect(error.has_errors?).to eq(false)
  end

  it "has errors with nil messages array" do
    error = RailsComponents::Components::FormError.new(messages: nil)
    expect(error.has_errors?).to eq(false)
  end

  # Test error_messages method
  it "error messages with single message" do
    error = RailsComponents::Components::FormError.new(message: "This field is required")
    expect(error.error_messages).to eq([ "This field is required" ])
  end

  it "error messages with messages array" do
    messages = [ "Error 1", "Error 2", "Error 3" ]
    error = RailsComponents::Components::FormError.new(messages: messages)
    expect(error.error_messages).to eq(messages)
  end

  it "error messages from object and attribute" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new(email: [ "can't be blank", "is invalid" ])
      end
    end.new

    error = RailsComponents::Components::FormError.new(
      object: mock_object,
      attribute: :email
    )

    expect(error.error_messages).to eq([ "can't be blank", "is invalid" ])
  end

  it "error messages with no errors" do
    error = RailsComponents::Components::FormError.new
    expect(error.error_messages).to eq([])
  end

  it "error messages with empty message" do
    error = RailsComponents::Components::FormError.new(message: "")
    expect(error.error_messages).to eq([])
  end

  it "error messages with blank message" do
    error = RailsComponents::Components::FormError.new(message: "   ")
    expect(error.error_messages).to eq([])
  end

  it "error messages filters blank messages from array" do
    messages = [ "Valid error", "", "   ", nil, "Another valid error" ]
    error = RailsComponents::Components::FormError.new(messages: messages)
    expect(error.error_messages).to eq([ "Valid error", "Another valid error" ])
  end

  # Test edge cases
  it "error messages with object but no attribute" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new(email: [ "can't be blank" ])
      end
    end.new

    error = RailsComponents::Components::FormError.new(object: mock_object)
    expect(error.error_messages).to eq([])
  end

  it "error messages with attribute but no object" do
    error = RailsComponents::Components::FormError.new(attribute: :email)
    expect(error.error_messages).to eq([])
  end

  it "error messages with object without errors method" do
    mock_object = Struct.new(:email).new

    error = RailsComponents::Components::FormError.new(
      object: mock_object,
      attribute: :email
    )

    expect(error.error_messages).to eq([])
  end

  # Test priority of error sources (message > messages > object+attribute)
  it "message takes priority over messages" do
    error = RailsComponents::Components::FormError.new(
      message: "Priority message",
      messages: [ "Array message 1", "Array message 2" ]
    )

    expect(error.error_messages).to eq([ "Priority message" ])
  end

  it "message takes priority over object" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new(email: [ "Object error" ])
      end
    end.new

    error = RailsComponents::Components::FormError.new(
      message: "Priority message",
      object: mock_object,
      attribute: :email
    )

    expect(error.error_messages).to eq([ "Priority message" ])
  end

  it "messages takes priority over object" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new(email: [ "Object error" ])
      end
    end.new

    error = RailsComponents::Components::FormError.new(
      messages: [ "Array message" ],
      object: mock_object,
      attribute: :email
    )

    expect(error.error_messages).to eq([ "Array message" ])
  end

  # Test complex combination scenario
  it "complex combination scenario" do
    mock_object = Struct.new(:password) do
      def errors
        MockErrors.new(password: [
          "can't be blank",
          "is too short (minimum is 8 characters)",
          "must include at least one uppercase letter",
          "must include at least one number"
        ])
      end
    end.new

    error = RailsComponents::Components::FormError.new(
      object: mock_object,
      attribute: :password,
      html_options: {
        id: "password-errors",
        class: "mt-1 font-medium",
        role: "alert",
        "aria-live": "polite",
        "data-controller": "error-display",
        "data-testid": "password-validation-errors"
      }
    )

    expected_classes = "text-error text-sm mt-1 mt-1 font-medium"
    expect(error.css_classes).to eq(expected_classes)

    expected_attributes = {
      id: "password-errors",
      role: "alert",
      "aria-live": "polite",
      "data-controller": "error-display",
      "data-testid": "password-validation-errors",
      class: expected_classes
    }

    expect(error.html_attributes).to eq(expected_attributes)

    expected_messages = [
      "can't be blank",
      "is too short (minimum is 8 characters)",
      "must include at least one uppercase letter",
      "must include at least one number"
    ]

    expect(error.error_messages).to eq(expected_messages)
    expect(error.has_errors?).to eq(true)
  end

  # Test ARIA attributes for accessibility
  it "default accessibility attributes" do
    error = RailsComponents::Components::FormError.new(message: "Error message")

    # Default attributes should include proper ARIA setup
    expect(error.css_classes).to eq("text-error text-sm mt-1")
  end

  it "custom accessibility attributes" do
    error = RailsComponents::Components::FormError.new(
      message: "Error message",
      html_options: {
        role: "alert",
        "aria-live": "assertive",
        "aria-atomic": "true"
      }
    )

    expected = {
      role: "alert",
      "aria-live": "assertive",
      "aria-atomic": "true",
      class: "text-error text-sm mt-1"
    }

    expect(error.html_attributes).to eq(expected)
  end

  # Test error message sanitization
  it "error messages with html content" do
    html_message = "Field <strong>cannot</strong> be blank"
    error = RailsComponents::Components::FormError.new(message: html_message)

    expect(error.error_messages).to eq([ html_message ])
  end

  it "error messages with special characters" do
    special_message = "Error with \"quotes\" and 'apostrophes' & ampersands"
    error = RailsComponents::Components::FormError.new(message: special_message)

    expect(error.error_messages).to eq([ special_message ])
  end

  # Test multiple error scenarios
  it "multiple field errors" do
    mock_object = Struct.new(:email, :password) do
      def errors
        MockErrors.new(
          email: [ "can't be blank", "is invalid" ],
          password: [ "is too short" ]
        )
      end
    end.new

    email_error = RailsComponents::Components::FormError.new(
      object: mock_object,
      attribute: :email
    )

    password_error = RailsComponents::Components::FormError.new(
      object: mock_object,
      attribute: :password
    )

    expect(email_error.error_messages).to eq([ "can't be blank", "is invalid" ])
    expect(password_error.error_messages).to eq([ "is too short" ])
  end

  private

  # Mock errors class for testing
  class MockErrors
    def initialize(errors = {})
      @errors = errors
    end

    def any?
      @errors.any?
    end

    def [](attribute)
      @errors[attribute] || []
    end

    def include?(attribute)
      @errors.key?(attribute) && @errors[attribute].any?
    end

    def where(attribute)
      (@errors[attribute] || []).map do |msg|
        MockError.new(msg, {})
      end
    end
  end

  # Mock error class for testing ActiveModel::Error-like objects
  class MockError
    attr_reader :message, :options

    def initialize(message, options = {})
      @message = message
      @options = options
    end
  end
end
