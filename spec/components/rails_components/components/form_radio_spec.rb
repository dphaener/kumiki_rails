require "rails_helper"

RSpec.describe RailsComponents::Components::FormRadio, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    radio = RailsComponents::Components::FormRadio.new

    expect(radio.name).to be_nil
    expect(radio.value).to be_nil
    expect(radio.label).to be_nil
    expect(radio.checked).to eq(false)
    expect(radio.disabled).to eq(false)
    expect(radio.required).to eq(false)
    expect(radio.size).to be_nil
    expect(radio.object).to be_nil
    expect(radio.attribute).to be_nil
    expect(radio.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { id: "custom-radio", data: { test: "value" } }
    radio = RailsComponents::Components::FormRadio.new(
      name: "user[role]",
      value: "admin",
      label: "Administrator",
      checked: true,
      disabled: true,
      required: true,
      size: "lg",
      html_options: html_options
    )

    expect(radio.name).to eq("user[role]")
    expect(radio.value).to eq("admin")
    expect(radio.label).to eq("Administrator")
    expect(radio.checked).to eq(true)
    expect(radio.disabled).to eq(true)
    expect(radio.required).to eq(true)
    expect(radio.size).to eq("lg")
    expect(radio.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    radio = RailsComponents::Components::FormRadio.new
    expect(radio.css_classes).to eq("radio")
  end

  it "css classes with size" do
    radio = RailsComponents::Components::FormRadio.new(size: "lg")
    expect(radio.css_classes).to eq("radio radio-lg")
  end

  it "css classes with error state" do
    radio = RailsComponents::Components::FormRadio.new(error: true)
    expect(radio.css_classes).to eq("radio radio-error")
  end

  it "css classes with size and error" do
    radio = RailsComponents::Components::FormRadio.new(size: "sm", error: true)
    expect(radio.css_classes).to eq("radio radio-sm radio-error")
  end

  it "css classes with custom class string" do
    radio = RailsComponents::Components::FormRadio.new(
      size: "lg",
      html_options: { class: "custom-class another-class" }
    )

    expect(radio.css_classes).to eq("radio radio-lg custom-class another-class")
  end

  it "css classes with custom class array" do
    radio = RailsComponents::Components::FormRadio.new(
      size: "lg",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(radio.css_classes).to eq("radio radio-lg custom-class another-class")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    radio = RailsComponents::Components::FormRadio.new
    expected = {
      type: "radio",
      class: "radio"
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "html attributes with basic attributes" do
    radio = RailsComponents::Components::FormRadio.new(
      name: "user[role]",
      value: "editor"
    )

    expected = {
      type: "radio",
      name: "user[role]",
      value: "editor",
      id: "user_role_editor",
      class: "radio"
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "html attributes with checked state" do
    radio = RailsComponents::Components::FormRadio.new(checked: true)
    expected = {
      type: "radio",
      class: "radio",
      checked: true
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "html attributes with disabled state" do
    radio = RailsComponents::Components::FormRadio.new(disabled: true)
    expected = {
      type: "radio",
      class: "radio",
      disabled: true
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "html attributes with required state" do
    radio = RailsComponents::Components::FormRadio.new(required: true)
    expected = {
      type: "radio",
      class: "radio",
      required: true,
      "aria-required": true
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "html attributes with error state" do
    radio = RailsComponents::Components::FormRadio.new(error: true)
    expected = {
      type: "radio",
      class: "radio radio-error",
      "aria-invalid": true
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "html attributes with error and required" do
    radio = RailsComponents::Components::FormRadio.new(error: true, required: true)
    expected = {
      type: "radio",
      class: "radio radio-error",
      required: true,
      "aria-required": true,
      "aria-invalid": true
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "role-admin",
      data: { controller: "radio", action: "change->radio#select" },
      "data-testid": "role-field",
      "aria-describedby": "role-help"
    }

    radio = RailsComponents::Components::FormRadio.new(
      name: "user[role]",
      value: "admin",
      size: "lg",
      html_options: html_options
    )

    expected = {
      id: "role-admin",
      data: { controller: "radio", action: "change->radio#select" },
      "data-testid": "role-field",
      "aria-describedby": "role-help",
      type: "radio",
      name: "user[role]",
      value: "admin",
      class: "radio radio-lg"
    }

    expect(radio.html_attributes).to eq(expected)
  end

  # Test error detection from model object
  it "error detection from object with errors" do
    mock_object = Struct.new(:role) do
      def errors
        MockErrors.new(role: [ "can't be blank" ])
      end
    end.new

    radio = RailsComponents::Components::FormRadio.new(
      object: mock_object,
      attribute: :role
    )

    expect(radio.error?).to eq(true)
    expect(radio.css_classes).to include("radio-error")
    expect(radio.html_attributes[:"aria-invalid"]).to eq(true)
  end

  it "error detection from object without errors" do
    mock_object = Struct.new(:role) do
      def errors
        MockErrors.new({})
      end
    end.new

    radio = RailsComponents::Components::FormRadio.new(
      object: mock_object,
      attribute: :role
    )

    expect(radio.error?).to eq(false)
    expect(radio.css_classes).to eq("radio")
    expect(radio.html_attributes[:"aria-invalid"]).to be_nil
  end

  # Test various size values
  it "various size values" do
    %w[xs sm lg].each do |size|
      radio = RailsComponents::Components::FormRadio.new(size: size)
      expect(radio.css_classes).to eq("radio radio-#{size}")
    end
  end

  # Test edge cases
  it "nil values do not add attributes" do
    radio = RailsComponents::Components::FormRadio.new(
      name: nil,
      value: nil,
      label: nil,
      size: nil
    )

    expected = {
      type: "radio",
      class: "radio"
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "empty string values are preserved" do
    radio = RailsComponents::Components::FormRadio.new(
      name: "",
      value: "",
      label: ""
    )

    expected = {
      type: "radio",
      name: "",
      value: "",
      id: "_",
      class: "radio"
    }

    expect(radio.html_attributes).to eq(expected)
    expect(radio.label).to eq("")
  end

  it "false boolean states do not add attributes" do
    radio = RailsComponents::Components::FormRadio.new(
      checked: false,
      disabled: false,
      required: false,
      error: false
    )

    expected = {
      type: "radio",
      class: "radio"
    }

    expect(radio.html_attributes).to eq(expected)
  end

  # Test label attribute
  it "label attribute stored correctly" do
    radio = RailsComponents::Components::FormRadio.new(label: "Administrator Role")
    expect(radio.label).to eq("Administrator Role")
  end

  it "label with html content" do
    html_label = "Manager <span class='text-sm text-gray-500'>(Team Lead)</span>"
    radio = RailsComponents::Components::FormRadio.new(label: html_label)
    expect(radio.label).to eq(html_label)
  end

  # Test radio button groups (same name, different values)
  it "radio group same name different values" do
    roles = [ "admin", "editor", "viewer" ]

    roles.each do |role|
      radio = RailsComponents::Components::FormRadio.new(
        name: "user[role]",
        value: role,
        label: role.capitalize
      )

      expect(radio.name).to eq("user[role]")
      expect(radio.value).to eq(role)
      expect(radio.label).to eq(role.capitalize)
    end
  end

  it "radio group with checked state" do
    admin_radio = RailsComponents::Components::FormRadio.new(
      name: "user[role]",
      value: "admin",
      checked: true
    )

    editor_radio = RailsComponents::Components::FormRadio.new(
      name: "user[role]",
      value: "editor",
      checked: false
    )

    expect(admin_radio.html_attributes[:checked]).to eq(true)
    expect(editor_radio.html_attributes[:checked]).to be_nil
  end

  # Test complex combination scenario
  it "complex combination scenario" do
    mock_object = Struct.new(:subscription_plan) do
      def errors
        MockErrors.new(subscription_plan: [ "must be selected" ])
      end
    end.new

    radio = RailsComponents::Components::FormRadio.new(
      name: "user[subscription_plan]",
      value: "premium",
      label: "Premium Plan - $29/month",
      checked: false,
      disabled: false,
      required: true,
      size: "lg",
      object: mock_object,
      attribute: :subscription_plan,
      html_options: {
        id: "plan-premium",
        class: "border-2 focus:border-primary",
        data: {
          controller: "radio subscription",
          action: "change->radio#select change->subscription#updatePrice",
          "subscription-price": "29",
          "subscription-features": "unlimited"
        },
        "data-testid": "plan-field",
        "aria-describedby": "plan-help"
      }
    )

    expected_classes = "radio radio-lg radio-error border-2 focus:border-primary"
    expect(radio.css_classes).to eq(expected_classes)

    expected_attributes = {
      id: "plan-premium",
      data: {
        controller: "radio subscription",
        action: "change->radio#select change->subscription#updatePrice",
        "subscription-price": "29",
        "subscription-features": "unlimited"
      },
      "data-testid": "plan-field",
      "aria-describedby": "plan-help",
      type: "radio",
      name: "user[subscription_plan]",
      value: "premium",
      required: true,
      "aria-required": true,
      "aria-invalid": true,
      class: expected_classes
    }

    expect(radio.html_attributes).to eq(expected_attributes)
    expect(radio.label).to eq("Premium Plan - $29/month")
  end

  it "radio with form attribute" do
    radio = RailsComponents::Components::FormRadio.new(
      html_options: { form: "my-form" }
    )

    expected = {
      type: "radio",
      form: "my-form",
      class: "radio"
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "radio with tabindex" do
    radio = RailsComponents::Components::FormRadio.new(
      html_options: { tabindex: 0 }
    )

    expected = {
      type: "radio",
      tabindex: 0,
      class: "radio"
    }

    expect(radio.html_attributes).to eq(expected)
  end

  it "checked state with value matching" do
    # Test when the radio value matches the current selected value
    current_value = "admin"

    admin_radio = RailsComponents::Components::FormRadio.new(
      name: "user[role]",
      value: "admin",
      checked: (current_value == "admin")
    )

    editor_radio = RailsComponents::Components::FormRadio.new(
      name: "user[role]",
      value: "editor",
      checked: (current_value == "editor")
    )

    expect(admin_radio.html_attributes[:checked]).to eq(true)
    expect(editor_radio.html_attributes[:checked]).to be_nil
  end

  it "checked state with truthy values" do
    truthy_values = [ true, "1", 1, "true", "on", "yes" ]

    truthy_values.each do |value|
      radio = RailsComponents::Components::FormRadio.new(checked: value)
      expect(radio.html_attributes[:checked]).to eq(true)
    end
  end

  it "checked state with falsy values" do
    falsy_values = [ false, "0", 0, "false", "off", "no", nil, "" ]

    falsy_values.each do |value|
      radio = RailsComponents::Components::FormRadio.new(checked: value)
      expect(radio.html_attributes[:checked]).to be_nil
    end
  end

  it "radio group accessibility attributes" do
    radio = RailsComponents::Components::FormRadio.new(
      name: "user[role]",
      value: "admin",
      html_options: {
        "aria-labelledby": "role-legend",
        "aria-describedby": "role-description"
      }
    )

    expected = {
      type: "radio",
      name: "user[role]",
      value: "admin",
      id: "user_role_admin",
      "aria-labelledby": "role-legend",
      "aria-describedby": "role-description",
      class: "radio"
    }

    expect(radio.html_attributes).to eq(expected)
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
