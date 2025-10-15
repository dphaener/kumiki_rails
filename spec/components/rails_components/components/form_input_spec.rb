require "rails_helper"

RSpec.describe RailsComponents::Components::FormInput, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    input = RailsComponents::Components::FormInput.new

    expect(input.type).to eq("text")
    expect(input.name).to be_nil
    expect(input.value).to be_nil
    expect(input.placeholder).to be_nil
    expect(input.size).to be_nil
    expect(input.disabled).to eq(false)
    expect(input.readonly).to eq(false)
    expect(input.required).to eq(false)
    expect(input.object).to be_nil
    expect(input.attribute).to be_nil
    expect(input.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { id: "custom-input", data: { test: "value" } }
    input = RailsComponents::Components::FormInput.new(
      type: "email",
      name: "user[email]",
      value: "test@example.com",
      placeholder: "Enter your email",
      size: "lg",
      disabled: true,
      readonly: true,
      required: true,
      html_options: html_options
    )

    expect(input.type).to eq("email")
    expect(input.name).to eq("user[email]")
    expect(input.value).to eq("test@example.com")
    expect(input.placeholder).to eq("Enter your email")
    expect(input.size).to eq("lg")
    expect(input.disabled).to eq(true)
    expect(input.readonly).to eq(true)
    expect(input.required).to eq(true)
    expect(input.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    input = RailsComponents::Components::FormInput.new
    expect(input.css_classes).to eq("input input-bordered")
  end

  it "css classes with size" do
    input = RailsComponents::Components::FormInput.new(size: "lg")
    expect(input.css_classes).to eq("input input-bordered input-lg")
  end

  it "css classes with error state" do
    input = RailsComponents::Components::FormInput.new(error: true)
    expect(input.css_classes).to eq("input input-bordered input-error")
  end

  it "css classes with size and error" do
    input = RailsComponents::Components::FormInput.new(size: "sm", error: true)
    expect(input.css_classes).to eq("input input-bordered input-sm input-error")
  end

  it "css classes with custom class string" do
    input = RailsComponents::Components::FormInput.new(
      size: "lg",
      html_options: { class: "custom-class another-class" }
    )

    expect(input.css_classes).to eq("input input-bordered input-lg custom-class another-class")
  end

  it "css classes with custom class array" do
    input = RailsComponents::Components::FormInput.new(
      size: "lg",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(input.css_classes).to eq("input input-bordered input-lg custom-class another-class")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    input = RailsComponents::Components::FormInput.new
    expected = {
      type: "text",
      class: "input input-bordered"
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "html attributes with all basic attributes" do
    input = RailsComponents::Components::FormInput.new(
      type: "email",
      name: "user[email]",
      value: "test@example.com",
      placeholder: "Enter email"
    )

    expected = {
      type: "email",
      class: "input input-bordered",
      name: "user[email]",
      value: "test@example.com",
      placeholder: "Enter email",
      id: "user_email"
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "html attributes with disabled state" do
    input = RailsComponents::Components::FormInput.new(disabled: true)
    expected = {
      type: "text",
      class: "input input-bordered input-disabled",
      disabled: true
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "html attributes with readonly state" do
    input = RailsComponents::Components::FormInput.new(readonly: true)
    expected = {
      type: "text",
      class: "input input-bordered",
      readonly: true
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "html attributes with required state" do
    input = RailsComponents::Components::FormInput.new(required: true)
    expected = {
      type: "text",
      class: "input input-bordered",
      required: true,
      "aria-required": true
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "html attributes with error state" do
    input = RailsComponents::Components::FormInput.new(error: true)
    expected = {
      type: "text",
      class: "input input-bordered input-error",
      "aria-invalid": true
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "html attributes with error and required" do
    input = RailsComponents::Components::FormInput.new(error: true, required: true)
    expected = {
      type: "text",
      class: "input input-bordered input-error",
      required: true,
      "aria-required": true,
      "aria-invalid": true
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "custom-input",
      data: { controller: "input", action: "input->input#validate" },
      "data-testid": "email-field",
      autocomplete: "email"
    }

    input = RailsComponents::Components::FormInput.new(
      type: "email",
      size: "lg",
      html_options: html_options
    )

    expected = {
      id: "custom-input",
      data: { controller: "input", action: "input->input#validate" },
      "data-testid": "email-field",
      autocomplete: "email",
      type: "email",
      class: "input input-bordered input-lg"
    }

    expect(input.html_attributes).to eq(expected)
  end

  # Test error detection from model object
  it "error detection from object with errors" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new(email: [ "can't be blank" ])
      end
    end.new

    input = RailsComponents::Components::FormInput.new(
      object: mock_object,
      attribute: :email
    )

    expect(input.error?).to eq(true)
    expect(input.css_classes).to include("input-error")
    expect(input.html_attributes[:"aria-invalid"]).to eq(true)
  end

  it "error detection from object without errors" do
    mock_object = Struct.new(:email) do
      def errors
        MockErrors.new({})
      end
    end.new

    input = RailsComponents::Components::FormInput.new(
      object: mock_object,
      attribute: :email
    )

    expect(input.error?).to eq(false)
    expect(input.css_classes).to eq("input input-bordered")
    expect(input.html_attributes[:"aria-invalid"]).to be_nil
  end

  # Test various input types
  it "various input types" do
    %w[text email password number tel url search].each do |input_type|
      input = RailsComponents::Components::FormInput.new(type: input_type)
      expect(input.html_attributes[:type]).to eq(input_type)
    end
  end

  it "various size values" do
    %w[xs sm lg].each do |size|
      input = RailsComponents::Components::FormInput.new(size: size)
      expect(input.css_classes).to eq("input input-bordered input-#{size}")
    end
  end

  # Test edge cases
  it "nil values do not add classes or attributes" do
    input = RailsComponents::Components::FormInput.new(
      name: nil,
      value: nil,
      placeholder: nil,
      size: nil
    )

    expected = {
      type: "text",
      class: "input input-bordered"
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "empty string values are preserved" do
    input = RailsComponents::Components::FormInput.new(
      name: "",
      value: "",
      placeholder: ""
    )

    expected = {
      type: "text",
      name: "",
      value: "",
      placeholder: "",
      id: "",
      class: "input input-bordered"
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "false boolean states do not add attributes" do
    input = RailsComponents::Components::FormInput.new(
      disabled: false,
      readonly: false,
      required: false,
      error: false
    )

    expected = {
      type: "text",
      class: "input input-bordered"
    }

    expect(input.html_attributes).to eq(expected)
  end

  # Test complex combination scenario
  it "complex combination scenario" do
    mock_object = Struct.new(:username) do
      def errors
        MockErrors.new(username: [ "is too short" ])
      end
    end.new

    input = RailsComponents::Components::FormInput.new(
      type: "text",
      name: "user[username]",
      value: "jo",
      placeholder: "Enter username (min 3 chars)",
      size: "lg",
      disabled: false,
      readonly: false,
      required: true,
      object: mock_object,
      attribute: :username,
      html_options: {
        id: "username-field",
        class: "border-2 hover:border-primary",
        data: { controller: "validation", action: "blur->validation#check" },
        "data-min-length": "3",
        autocomplete: "username"
      }
    )

    expected_classes = "input input-bordered input-lg input-error border-2 hover:border-primary"
    expect(input.css_classes).to eq(expected_classes)

    html_attrs = input.html_attributes

    # Assert individual attributes instead of full hash equality to avoid hash ordering issues
    expect(html_attrs[:id]).to eq("username-field")
    expect(html_attrs[:data]).to eq({ controller: "validation", action: "blur->validation#check" })
    expect(html_attrs[:"data-min-length"]).to eq("3")
    expect(html_attrs[:autocomplete]).to eq("username")
    expect(html_attrs[:type]).to eq("text")
    expect(html_attrs[:name]).to eq("user[username]")
    expect(html_attrs[:value]).to eq("jo")
    expect(html_attrs[:placeholder]).to eq("Enter username (min 3 chars)")
    expect(html_attrs[:required]).to be_truthy
    expect(html_attrs[:"aria-required"]).to be_truthy
    expect(html_attrs[:"aria-invalid"]).to be_truthy
    expect(html_attrs[:"aria-describedby"]).to eq("user_username_errors")
    expect(html_attrs[:class]).to eq(expected_classes)
  end

  it "input with min max attributes" do
    input = RailsComponents::Components::FormInput.new(
      type: "number",
      html_options: { min: 1, max: 100, step: 5 }
    )

    expected = {
      type: "number",
      min: 1,
      max: 100,
      step: 5,
      class: "input input-bordered"
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "input with pattern attribute" do
    input = RailsComponents::Components::FormInput.new(
      type: "tel",
      html_options: { pattern: "[0-9]{3}-[0-9]{3}-[0-9]{4}" }
    )

    expected = {
      type: "tel",
      pattern: "[0-9]{3}-[0-9]{3}-[0-9]{4}",
      class: "input input-bordered"
    }

    expect(input.html_attributes).to eq(expected)
  end

  it "input with maxlength attribute" do
    input = RailsComponents::Components::FormInput.new(
      type: "text",
      html_options: { maxlength: 50 }
    )

    expected = {
      type: "text",
      maxlength: 50,
      class: "input input-bordered"
    }

    expect(input.html_attributes).to eq(expected)
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
