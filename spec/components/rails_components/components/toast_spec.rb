require "rails_helper"

RSpec.describe RailsComponents::Components::Toast, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    toast = RailsComponents::Components::Toast.new

    expect(toast.type).to eq("notice")
    expect(toast.message).to eq("")
    expect(toast.dismissible).to eq(true)
    expect(toast.auto_dismiss_delay).to eq(5000)
    expect(toast.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { id: "custom-flash", data: { test: "value" } }
    toast = RailsComponents::Components::Toast.new(
      type: "error",
      message: "Something went wrong!",
      dismissible: false,
      auto_dismiss_delay: 3000,
      html_options: html_options
    )

    expect(toast.type).to eq("error")
    expect(toast.message).to eq("Something went wrong!")
    expect(toast.dismissible).to eq(false)
    expect(toast.auto_dismiss_delay).to eq(3000)
    expect(toast.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    toast = RailsComponents::Components::Toast.new
    expected_classes = "alert bg-white shadow-lg border-l-4 border-l-green-500 slide-in-right fixed top-4 right-4 z-50 max-w-sm rounded-lg"
    expect(toast.css_classes).to eq(expected_classes)
  end

  it "css classes with notice type" do
    toast = RailsComponents::Components::Toast.new(type: "notice")
    expect(toast.css_classes).to include("border-l-green-500")
    expect(toast.css_classes).not_to include("border-l-red-500")
  end

  it "css classes with error type" do
    toast = RailsComponents::Components::Toast.new(type: "error")
    expect(toast.css_classes).to include("border-l-red-500")
    expect(toast.css_classes).not_to include("border-l-green-500")
  end

  it "css classes with invalid type" do
    toast = RailsComponents::Components::Toast.new(type: "invalid")
    expect(toast.css_classes).not_to include("border-l-green-500")
    expect(toast.css_classes).not_to include("border-l-red-500")
    expect(toast.css_classes).to include("border-l-blue-500")
  end

  it "css classes always includes base classes" do
    toast = RailsComponents::Components::Toast.new
    base_classes = [ "alert", "bg-white", "shadow-lg", "border-l-4", "fixed", "top-4", "right-4", "z-50", "slide-in-right", "max-w-sm", "rounded-lg" ]

    base_classes.each do |base_class|
      expect(toast.css_classes).to include(base_class)
    end
  end

  # Test custom class merging from html_options
  it "css classes with custom class string" do
    toast = RailsComponents::Components::Toast.new(
      type: "notice",
      html_options: { class: "custom-class another-class" }
    )

    expect(toast.css_classes).to include("custom-class")
    expect(toast.css_classes).to include("another-class")
    expect(toast.css_classes).to include("border-l-green-500")
  end

  it "css classes with custom class array" do
    toast = RailsComponents::Components::Toast.new(
      type: "error",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(toast.css_classes).to include("custom-class")
    expect(toast.css_classes).to include("another-class")
    expect(toast.css_classes).to include("border-l-red-500")
  end

  it "css classes with custom class string key" do
    toast = RailsComponents::Components::Toast.new(
      type: "notice",
      html_options: { "class" => "custom-class" }
    )

    expect(toast.css_classes).to include("custom-class")
    expect(toast.css_classes).to include("border-l-green-500")
  end

  it "css classes without custom class" do
    toast = RailsComponents::Components::Toast.new(
      type: "error",
      html_options: { id: "test" }
    )

    expect(toast.css_classes).to include("border-l-red-500")
    expect(toast.css_classes).not_to include("custom")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    toast = RailsComponents::Components::Toast.new
    attributes = toast.html_attributes

    expect(attributes[:role]).to eq("alert")
    expect(attributes[:class]).to include("border-l-green-500")
    expect(attributes["data-auto-dismiss-delay"]).to eq(5000)
    expect(attributes["data-dismissible"]).to eq("true")
  end

  it "html attributes with dismissible false" do
    toast = RailsComponents::Components::Toast.new(dismissible: false)
    attributes = toast.html_attributes

    expect(attributes["data-auto-dismiss-delay"]).to eq(5000)
    expect(attributes["data-dismissible"]).to be_nil
  end

  it "html attributes with custom auto dismiss delay" do
    toast = RailsComponents::Components::Toast.new(auto_dismiss_delay: 3000)
    attributes = toast.html_attributes

    expect(attributes["data-auto-dismiss-delay"]).to eq(3000)
    expect(attributes["data-dismissible"]).to eq("true")
  end

  it "html attributes with html options" do
    html_options = {
      id: "custom-flash",
      data: { test: "value" },
      "data-controller" => "flash",
      aria: { label: "Custom flash message" }
    }

    toast = RailsComponents::Components::Toast.new(
      type: "error",
      html_options: html_options
    )

    attributes = toast.html_attributes

    expect(attributes[:id]).to eq("custom-flash")
    expect(attributes[:data]).to eq({ test: "value" })
    expect(attributes["data-controller"]).to eq("flash")
    expect(attributes[:aria]).to eq({ label: "Custom flash message" })
    expect(attributes[:role]).to eq("alert")
    expect(attributes[:class]).to include("border-l-red-500")
  end

  it "html attributes excludes class from html options" do
    toast = RailsComponents::Components::Toast.new(
      type: "notice",
      html_options: { class: "custom-class", id: "test-flash" }
    )

    attributes = toast.html_attributes

    expect(attributes[:id]).to eq("test-flash")
    expect(attributes[:role]).to eq("alert")
    expect(attributes[:class]).to include("border-l-green-500")
    expect(attributes[:class]).to include("custom-class")
  end

  it "html attributes excludes string class from html options" do
    toast = RailsComponents::Components::Toast.new(
      type: "error",
      html_options: { "class" => "custom-class", id: "test-flash" }
    )

    attributes = toast.html_attributes

    expect(attributes[:id]).to eq("test-flash")
    expect(attributes[:role]).to eq("alert")
    expect(attributes[:class]).to include("border-l-red-500")
    expect(attributes[:class]).to include("custom-class")
  end

  # Test icon method
  it "icon for notice type" do
    toast = RailsComponents::Components::Toast.new(type: "notice")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-green-500")
    expect(icon).to include("fill-rule=\"evenodd\"")
  end

  it "icon for success type" do
    toast = RailsComponents::Components::Toast.new(type: "success")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-green-500")
    expect(icon).to include("fill-rule=\"evenodd\"")
  end

  it "icon for error type" do
    toast = RailsComponents::Components::Toast.new(type: "error")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-red-500")
    expect(icon).to include("fill-rule=\"evenodd\"")
  end

  it "icon for danger type" do
    toast = RailsComponents::Components::Toast.new(type: "danger")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-red-500")
    expect(icon).to include("fill-rule=\"evenodd\"")
  end

  it "icon for info type" do
    toast = RailsComponents::Components::Toast.new(type: "info")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-blue-500")
    expect(icon).to include("fill-rule=\"evenodd\"")
  end

  it "icon for warning type" do
    toast = RailsComponents::Components::Toast.new(type: "warning")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-yellow-500")
    expect(icon).to include("fill-rule=\"evenodd\"")
  end

  it "icon for invalid type" do
    toast = RailsComponents::Components::Toast.new(type: "invalid")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-blue-500")
    expect(icon).to include("fill-rule=\"evenodd\"")
  end

  it "icon for nil type" do
    toast = RailsComponents::Components::Toast.new(type: nil)
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-blue-500")
    expect(icon).to include("fill-rule=\"evenodd\"")
  end

  # Test edge cases and parameter combinations
  it "nil values handled gracefully" do
    toast = RailsComponents::Components::Toast.new(
      type: nil,
      message: nil,
      dismissible: nil,
      auto_dismiss_delay: nil
    )

    # Should not crash and should handle nil values appropriately
    expect(toast.css_classes).not_to be_nil
    expect(toast.html_attributes).not_to be_nil
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-blue-500")
  end

  it "empty string values" do
    toast = RailsComponents::Components::Toast.new(
      type: "",
      message: "",
      dismissible: false
    )

    # Empty type should use default info styling
    expect(toast.css_classes).not_to include("border-l-green-500")
    expect(toast.css_classes).not_to include("border-l-red-500")
    expect(toast.css_classes).to include("border-l-blue-500")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-blue-500")
  end

  it "various type values" do
    %w[notice error warning info].each do |type|
      toast = RailsComponents::Components::Toast.new(type: type)
      icon = toast.icon
      case type
      when "notice"
        expect(toast.css_classes).to include("border-l-green-500")
        expect(icon).to include("text-green-500")
      when "error"
        expect(toast.css_classes).to include("border-l-red-500")
        expect(icon).to include("text-red-500")
      when "warning"
        expect(toast.css_classes).to include("border-l-yellow-500")
        expect(icon).to include("text-yellow-500")
      else
        # Types not explicitly handled should use info styling
        expect(toast.css_classes).not_to include("border-l-green-500")
        expect(toast.css_classes).not_to include("border-l-red-500")
        expect(toast.css_classes).to include("border-l-blue-500")
        expect(icon).to include("text-blue-500")
      end
    end
  end

  it "various auto dismiss delay values" do
    [ 1000, 3000, 5000, 10000 ].each do |delay|
      toast = RailsComponents::Components::Toast.new(auto_dismiss_delay: delay)
      attributes = toast.html_attributes
      expect(attributes["data-auto-dismiss-delay"]).to eq(delay)
    end
  end

  it "auto dismiss delay zero does not add attribute" do
    toast = RailsComponents::Components::Toast.new(auto_dismiss_delay: 0)
    attributes = toast.html_attributes
    expect(attributes["data-auto-dismiss-delay"]).to be_nil
  end

  it "auto dismiss delay negative does not add attribute" do
    toast = RailsComponents::Components::Toast.new(auto_dismiss_delay: -100)
    attributes = toast.html_attributes
    expect(attributes["data-auto-dismiss-delay"]).to be_nil
  end

  it "auto dismiss delay nil does not add attribute" do
    toast = RailsComponents::Components::Toast.new(auto_dismiss_delay: nil)
    attributes = toast.html_attributes
    expect(attributes["data-auto-dismiss-delay"]).to be_nil
  end

  it "complex combination scenario" do
    toast = RailsComponents::Components::Toast.new(
      type: "error",
      message: "Complex error message with details",
      dismissible: true,
      auto_dismiss_delay: 7500,
      html_options: {
        id: "complex-flash",
        class: "custom-animation fade-in-up",
        data: { controller: "flash", action: "click->flash#dismiss" },
        "aria-live" => "assertive",
        "aria-atomic" => "true"
      }
    )

    # Test CSS classes
    css_classes = toast.css_classes
    expect(css_classes).to include("border-l-red-500")
    expect(css_classes).to include("custom-animation")
    expect(css_classes).to include("fade-in-up")

    # Base classes should still be present
    base_classes = [ "alert", "bg-white", "shadow-lg", "border-l-4" ]
    base_classes.each do |base_class|
      expect(css_classes).to include(base_class)
    end

    # Test HTML attributes
    attributes = toast.html_attributes
    expect(attributes[:id]).to eq("complex-flash")
    expect(attributes["data-auto-dismiss-delay"]).to eq(7500)
    expect(attributes["data-dismissible"]).to eq("true")
    expect(attributes["aria-live"]).to eq("assertive")
    expect(attributes["aria-atomic"]).to eq("true")
    expect(attributes[:data]).to eq({ controller: "flash", action: "click->flash#dismiss" })
    expect(attributes[:role]).to eq("alert")

    # Test other methods
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-red-500")
    expect(toast.message).to eq("Complex error message with details")
  end

  it "dismissible false with auto dismiss delay" do
    toast = RailsComponents::Components::Toast.new(
      dismissible: false,
      auto_dismiss_delay: 3000
    )

    attributes = toast.html_attributes

    # Should still include auto-dismiss delay but not dismissible
    expect(attributes["data-auto-dismiss-delay"]).to eq(3000)
    expect(attributes["data-dismissible"]).to be_nil
  end

  it "message attribute is properly stored" do
    toast = RailsComponents::Components::Toast.new(message: "Test message")
    expect(toast.message).to eq("Test message")
  end

  it "message attribute is accessible after initialization" do
    toast = RailsComponents::Components::Toast.new(message: "Success message")
    expect(toast.message).to eq("Success message")
    expect(toast).to respond_to(:message)
  end

  it "message attribute with empty string" do
    toast = RailsComponents::Components::Toast.new(message: "")
    expect(toast.message).to eq("")
  end

  it "message attribute with nil" do
    toast = RailsComponents::Components::Toast.new(message: nil)
    expect(toast.message).to be_nil
  end

  it "toast initialization with different message values" do
    test_cases = [
      "Operation successful",
      "Error occurred",
      "Warning: Check your input",
      "Information updated",
      "File uploaded successfully",
      "Access denied",
      "Session expired",
      "Data saved",
      "Processing complete",
      "Validation failed"
    ]

    test_cases.each do |message_value|
      toast = RailsComponents::Components::Toast.new(message: message_value)
      expect(toast.message).to eq(message_value)
    end
  end

  it "message attribute with special characters" do
    special_messages = [
      "Message with spaces",
      "Message-with-dashes",
      "Message_with_underscores",
      "Message123",
      "Message & Symbols!",
      "Success with emoji",
      "Multi\nLine\nMessage",
      "Message with \"quotes\"",
      "Message with 'apostrophes'"
    ]

    special_messages.each do |message_value|
      toast = RailsComponents::Components::Toast.new(message: message_value)
      expect(toast.message).to eq(message_value)
    end
  end

  it "custom class array with mixed content" do
    toast = RailsComponents::Components::Toast.new(
      html_options: { class: [ "", "valid-class", nil, "another-class" ].compact }
    )

    css_classes = toast.css_classes
    expect(css_classes).to include("valid-class")
    expect(css_classes).to include("another-class")
  end

  it "empty html options class" do
    toast = RailsComponents::Components::Toast.new(html_options: { class: "" })
    expect(toast.css_classes).to include("alert")
  end

  it "whitespace only custom class" do
    toast = RailsComponents::Components::Toast.new(html_options: { class: "   " })
    # Should still include base classes
    expect(toast.css_classes).to include("alert")
  end

  it "role attribute always present" do
    toast = RailsComponents::Components::Toast.new
    attributes = toast.html_attributes
    expect(attributes[:role]).to eq("alert")
  end

  it "role attribute not overridden by html options" do
    toast = RailsComponents::Components::Toast.new(
      html_options: { role: "status" }
    )

    attributes = toast.html_attributes
    # Our role should take precedence
    expect(attributes[:role]).to eq("alert")
  end

  # Test type conversion and symbol handling
  it "type with symbol input" do
    toast = RailsComponents::Components::Toast.new(type: :error)
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-red-500")
    expect(toast.css_classes).to include("border-l-red-500")
  end

  it "type with string input" do
    toast = RailsComponents::Components::Toast.new(type: "success")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-green-500")
    expect(toast.css_classes).to include("border-l-green-500")
  end

  # Test success and danger type aliases
  it "success type maps to success styling" do
    toast = RailsComponents::Components::Toast.new(type: "success")
    expect(toast.css_classes).to include("border-l-green-500")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-green-500")
  end

  it "danger type maps to error styling" do
    toast = RailsComponents::Components::Toast.new(type: "danger")
    expect(toast.css_classes).to include("border-l-red-500")
    icon = toast.icon
    expect(icon).to include("svg")
    expect(icon).to include("text-red-500")
  end

  # Test comprehensive CSS class order
  it "css classes order is consistent" do
    toast = RailsComponents::Components::Toast.new(type: "error")
    classes = toast.css_classes.split(" ")

    # Check that base classes come first in expected order
    expect(classes[0]).to eq("alert")
    expect(classes[1]).to eq("bg-white")
    expect(classes[2]).to eq("shadow-lg")
    expect(classes[3]).to eq("border-l-4")
    expect(classes[4]).to eq("border-l-red-500")
    expect(classes[5]).to eq("slide-in-right")
    expect(classes[6]).to eq("fixed")
    expect(classes[7]).to eq("top-4")
    expect(classes[8]).to eq("right-4")
    expect(classes[9]).to eq("z-50")
  end

  # Test HTML attribute exclusion
  it "html attributes excludes class but merges others" do
    toast = RailsComponents::Components::Toast.new(
      html_options: {
        class: "should-not-appear-directly",
        id: "test-id",
        "data-test" => "value"
      }
    )

    attributes = toast.html_attributes
    expect(attributes[:id]).to eq("test-id")
    expect(attributes["data-test"]).to eq("value")
    expect(attributes[:class]).to include("should-not-appear-directly")
    # Class should be merged, not excluded entirely
  end

  # Test boolean conversion for data attributes
  it "dismissible boolean converted to string" do
    toast = RailsComponents::Components::Toast.new(dismissible: true)
    attributes = toast.html_attributes
    expect(attributes["data-dismissible"]).to eq("true")
    expect(attributes["data-dismissible"]).to be_an_instance_of(String)
  end

  # Test title attribute
  it "title attribute is properly stored" do
    toast = RailsComponents::Components::Toast.new(title: "Success")
    expect(toast.title).to eq("Success")
  end

  it "title attribute with nil" do
    toast = RailsComponents::Components::Toast.new(title: nil)
    expect(toast.title).to be_nil
  end

  it "title attribute is accessible after initialization" do
    toast = RailsComponents::Components::Toast.new(title: "Alert")
    expect(toast.title).to eq("Alert")
    expect(toast).to respond_to(:title)
  end
end
