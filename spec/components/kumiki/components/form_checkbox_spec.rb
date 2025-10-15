require "rails_helper"

RSpec.describe Kumiki::Components::FormCheckbox, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    checkbox = Kumiki::Components::FormCheckbox.new

    expect(checkbox.name).to be_nil
    expect(checkbox.value).to be_nil
    expect(checkbox.label).to be_nil
    expect(checkbox.checked).to eq(false)
    expect(checkbox.disabled).to eq(false)
    expect(checkbox.required).to eq(false)
    expect(checkbox.size).to be_nil
    expect(checkbox.object).to be_nil
    expect(checkbox.attribute).to be_nil
    expect(checkbox.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { id: "custom-checkbox", data: { test: "value" } }
    checkbox = Kumiki::Components::FormCheckbox.new(
      name: "user[terms]",
      value: "1",
      label: "Accept terms and conditions",
      checked: true,
      disabled: true,
      required: true,
      size: "lg",
      html_options: html_options
    )

    expect(checkbox.name).to eq("user[terms]")
    expect(checkbox.value).to eq("1")
    expect(checkbox.label).to eq("Accept terms and conditions")
    expect(checkbox.checked).to eq(true)
    expect(checkbox.disabled).to eq(true)
    expect(checkbox.required).to eq(true)
    expect(checkbox.size).to eq("lg")
    expect(checkbox.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    checkbox = Kumiki::Components::FormCheckbox.new
    expect(checkbox.css_classes).to eq("checkbox")
  end

  it "css classes with size" do
    checkbox = Kumiki::Components::FormCheckbox.new(size: "lg")
    expect(checkbox.css_classes).to eq("checkbox checkbox-lg")
  end

  it "css classes with error state" do
    checkbox = Kumiki::Components::FormCheckbox.new(error: true)
    expect(checkbox.css_classes).to eq("checkbox checkbox-error")
  end

  it "css classes with size and error" do
    checkbox = Kumiki::Components::FormCheckbox.new(size: "sm", error: true)
    expect(checkbox.css_classes).to eq("checkbox checkbox-sm checkbox-error")
  end

  it "css classes with custom class string" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      size: "lg",
      html_options: { class: "custom-class another-class" }
    )

    expect(checkbox.css_classes).to eq("checkbox checkbox-lg custom-class another-class")
  end

  it "css classes with custom class array" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      size: "lg",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(checkbox.css_classes).to eq("checkbox checkbox-lg custom-class another-class")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    checkbox = Kumiki::Components::FormCheckbox.new
    expected = {
      type: "checkbox",
      class: "checkbox"
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "html attributes with basic attributes" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      name: "user[newsletter]",
      value: "1"
    )

    expected = {
      type: "checkbox",
      name: "user[newsletter]",
      value: "1",
      id: "user_newsletter",
      class: "checkbox"
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "html attributes with checked state" do
    checkbox = Kumiki::Components::FormCheckbox.new(checked: true)
    expected = {
      type: "checkbox",
      class: "checkbox",
      checked: true
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "html attributes with disabled state" do
    checkbox = Kumiki::Components::FormCheckbox.new(disabled: true)
    expected = {
      type: "checkbox",
      class: "checkbox",
      disabled: true
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "html attributes with required state" do
    checkbox = Kumiki::Components::FormCheckbox.new(required: true)
    expected = {
      type: "checkbox",
      class: "checkbox",
      required: true,
      "aria-required": true
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "html attributes with error state" do
    checkbox = Kumiki::Components::FormCheckbox.new(error: true)
    expected = {
      type: "checkbox",
      class: "checkbox checkbox-error",
      "aria-invalid": true
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "html attributes with error and required" do
    checkbox = Kumiki::Components::FormCheckbox.new(error: true, required: true)
    expected = {
      type: "checkbox",
      class: "checkbox checkbox-error",
      required: true,
      "aria-required": true,
      "aria-invalid": true
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "terms-checkbox",
      data: { controller: "checkbox", action: "change->checkbox#toggle" },
      "data-testid": "terms-field",
      "aria-describedby": "terms-help"
    }

    checkbox = Kumiki::Components::FormCheckbox.new(
      name: "user[terms]",
      size: "lg",
      html_options: html_options
    )

    expected = {
      id: "terms-checkbox",
      data: { controller: "checkbox", action: "change->checkbox#toggle" },
      "data-testid": "terms-field",
      "aria-describedby": "terms-help",
      type: "checkbox",
      name: "user[terms]",
      class: "checkbox checkbox-lg"
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  # Test error detection from model object
  it "error detection from object with errors" do
    mock_object = Struct.new(:terms) do
      def errors
        MockErrors.new(terms: [ "must be accepted" ])
      end
    end.new

    checkbox = Kumiki::Components::FormCheckbox.new(
      object: mock_object,
      attribute: :terms
    )

    expect(checkbox.error?).to eq(true)
    expect(checkbox.css_classes).to include("checkbox-error")
    expect(checkbox.html_attributes[:"aria-invalid"]).to eq(true)
  end

  it "error detection from object without errors" do
    mock_object = Struct.new(:terms) do
      def errors
        MockErrors.new({})
      end
    end.new

    checkbox = Kumiki::Components::FormCheckbox.new(
      object: mock_object,
      attribute: :terms
    )

    expect(checkbox.error?).to eq(false)
    expect(checkbox.css_classes).to eq("checkbox")
    expect(checkbox.html_attributes[:"aria-invalid"]).to be_nil
  end

  # Test various size values
  it "various size values" do
    %w[xs sm lg].each do |size|
      checkbox = Kumiki::Components::FormCheckbox.new(size: size)
      expect(checkbox.css_classes).to eq("checkbox checkbox-#{size}")
    end
  end

  # Test edge cases
  it "nil values do not add attributes" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      name: nil,
      value: nil,
      label: nil,
      size: nil
    )

    expected = {
      type: "checkbox",
      class: "checkbox"
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "empty string values are preserved" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      name: "",
      value: "",
      label: ""
    )

    expected = {
      type: "checkbox",
      name: "",
      value: "",
      id: "",
      class: "checkbox"
    }

    expect(checkbox.html_attributes).to eq(expected)
    expect(checkbox.label).to eq("")
  end

  it "false boolean states do not add attributes" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      checked: false,
      disabled: false,
      required: false,
      error: false
    )

    expected = {
      type: "checkbox",
      class: "checkbox"
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  # Test label attribute
  it "label attribute stored correctly" do
    checkbox = Kumiki::Components::FormCheckbox.new(label: "Subscribe to newsletter")
    expect(checkbox.label).to eq("Subscribe to newsletter")
  end

  it "label with html content" do
    html_label = "I agree to the <a href='/terms'>Terms of Service</a>"
    checkbox = Kumiki::Components::FormCheckbox.new(label: html_label)
    expect(checkbox.label).to eq(html_label)
  end

  # Test value handling
  it "default value when not specified" do
    checkbox = Kumiki::Components::FormCheckbox.new(name: "user[newsletter]")
    # Default value should be nil when not specified
    expect(checkbox.value).to be_nil
  end

  it "custom value" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      name: "user[role]",
      value: "admin"
    )
    expect(checkbox.value).to eq("admin")
  end

  # Test complex combination scenario
  it "complex combination scenario" do
    mock_object = Struct.new(:privacy_policy) do
      def errors
        MockErrors.new(privacy_policy: [ "must be accepted" ])
      end
    end.new

    checkbox = Kumiki::Components::FormCheckbox.new(
      name: "user[privacy_policy]",
      value: "1",
      label: "I have read and agree to the Privacy Policy",
      checked: false,
      disabled: false,
      required: true,
      size: "lg",
      object: mock_object,
      attribute: :privacy_policy,
      html_options: {
        id: "privacy-checkbox",
        class: "border-2 focus:border-primary",
        data: {
          controller: "checkbox validation",
          action: "change->checkbox#toggle change->validation#check",
          "validation-required": "true"
        },
        "data-testid": "privacy-field",
        "aria-describedby": "privacy-help"
      }
    )

    expected_classes = "checkbox checkbox-lg checkbox-error border-2 focus:border-primary"
    expect(checkbox.css_classes).to eq(expected_classes)

    expected_attributes = {
      id: "privacy-checkbox",
      data: {
        controller: "checkbox validation",
        action: "change->checkbox#toggle change->validation#check",
        "validation-required": "true"
      },
      "data-testid": "privacy-field",
      "aria-describedby": "privacy-help",
      type: "checkbox",
      name: "user[privacy_policy]",
      value: "1",
      required: true,
      "aria-required": true,
      "aria-invalid": true,
      class: expected_classes
    }

    expect(checkbox.html_attributes).to eq(expected_attributes)
    expect(checkbox.label).to eq("I have read and agree to the Privacy Policy")
  end

  it "checkbox with indeterminate state" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      html_options: { "data-indeterminate": true }
    )

    expected = {
      type: "checkbox",
      "data-indeterminate": true,
      class: "checkbox"
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "checkbox with form attribute" do
    checkbox = Kumiki::Components::FormCheckbox.new(
      html_options: { form: "my-form" }
    )

    expected = {
      type: "checkbox",
      form: "my-form",
      class: "checkbox"
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "checkbox with multiple values array" do
    # For cases where multiple checkboxes share the same name
    checkbox = Kumiki::Components::FormCheckbox.new(
      name: "user[interests][]",
      value: "sports"
    )

    expected = {
      type: "checkbox",
      name: "user[interests][]",
      value: "sports",
      id: "user_interests",
      class: "checkbox"
    }

    expect(checkbox.html_attributes).to eq(expected)
  end

  it "checked state with truthy values" do
    truthy_values = [ true, "1", 1, "true", "on", "yes" ]

    truthy_values.each do |value|
      checkbox = Kumiki::Components::FormCheckbox.new(checked: value)
      expect(checkbox.html_attributes[:checked]).to eq(true)
    end
  end

  it "checked state with falsy values" do
    falsy_values = [ false, "0", 0, "false", "off", "no", nil, "" ]

    falsy_values.each do |value|
      checkbox = Kumiki::Components::FormCheckbox.new(checked: value)
      expect(checkbox.html_attributes[:checked]).to be_nil
    end
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
  end
end
