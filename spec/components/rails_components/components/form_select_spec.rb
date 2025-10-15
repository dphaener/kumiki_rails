require "rails_helper"

RSpec.describe RailsComponents::Components::FormSelect, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    select = RailsComponents::Components::FormSelect.new

    expect(select.name).to be_nil
    expect(select.value).to be_nil
    expect(select.options).to eq([])
    expect(select.prompt).to be_nil
    expect(select.size).to be_nil
    expect(select.disabled).to eq(false)
    expect(select.required).to eq(false)
    expect(select.object).to be_nil
    expect(select.attribute).to be_nil
    expect(select.html_options).to eq({})
  end

  it "initialize rejects multiple parameter" do
    # Test that passing multiple parameter raises an error since we only support single select
    expect {
      RailsComponents::Components::FormSelect.new(multiple: true)
    }.to raise_error(ArgumentError)

    expect {
      RailsComponents::Components::FormSelect.new(multiple: false)
    }.to raise_error(ArgumentError)
  end

  it "single select only behavior" do
    # Test that component always behaves as single select
    select = RailsComponents::Components::FormSelect.new(
      name: "user[role]",
      options: [ [ "Admin", "admin" ], [ "User", "user" ] ]
    )

    attributes = select.html_attributes

    # Should not have multiple attribute at all
    expect(attributes.keys).not_to include(:multiple)
    expect(attributes.keys).not_to include("multiple")

    # Should have select class for DaisyUI styling
    expect(attributes[:class]).to include("select")
    expect(attributes[:class]).to include("select-bordered")
  end

  it "initialize with custom values" do
    options = [ [ "Option 1", "1" ], [ "Option 2", "2" ] ]
    html_options = { id: "custom-select", data: { test: "value" } }

    select = RailsComponents::Components::FormSelect.new(
      name: "user[role]",
      value: "2",
      options: options,
      prompt: "Choose role",
      size: "lg",
      disabled: true,
      required: true,
      html_options: html_options
    )

    expect(select.name).to eq("user[role]")
    expect(select.value).to eq("2")
    expect(select.options).to eq(options)
    expect(select.prompt).to eq("Choose role")
    expect(select.size).to eq("lg")
    expect(select.disabled).to eq(true)
    expect(select.required).to eq(true)
    expect(select.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    select = RailsComponents::Components::FormSelect.new
    expect(select.css_classes).to eq("select select-bordered")
  end

  it "css classes with size" do
    select = RailsComponents::Components::FormSelect.new(size: "lg")
    expect(select.css_classes).to eq("select select-bordered select-lg")
  end

  it "css classes with error state" do
    select = RailsComponents::Components::FormSelect.new(error: true)
    expect(select.css_classes).to eq("select select-bordered select-error")
  end

  it "css classes with size and error" do
    select = RailsComponents::Components::FormSelect.new(size: "sm", error: true)
    expect(select.css_classes).to eq("select select-bordered select-sm select-error")
  end

  it "css classes with custom class string" do
    select = RailsComponents::Components::FormSelect.new(
      size: "lg",
      html_options: { class: "custom-class another-class" }
    )

    expect(select.css_classes).to eq("select select-bordered select-lg custom-class another-class")
  end

  it "css classes with custom class array" do
    select = RailsComponents::Components::FormSelect.new(
      size: "lg",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(select.css_classes).to eq("select select-bordered select-lg custom-class another-class")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    select = RailsComponents::Components::FormSelect.new
    expected = {
      class: "select select-bordered"
    }

    expect(select.html_attributes).to eq(expected)
  end

  it "html attributes with basic attributes" do
    select = RailsComponents::Components::FormSelect.new(
      name: "user[role]",
      value: "admin"
    )

    expected = {
      name: "user[role]",
      class: "select select-bordered",
      id: "user_role"
    }

    expect(select.html_attributes).to eq(expected)
  end

  it "html attributes with disabled state" do
    select = RailsComponents::Components::FormSelect.new(disabled: true)
    expected = {
      class: "select select-bordered",
      disabled: true
    }

    expect(select.html_attributes).to eq(expected)
  end

  it "html attributes with required state" do
    select = RailsComponents::Components::FormSelect.new(required: true)
    expected = {
      class: "select select-bordered",
      required: true,
      "aria-required": true
    }

    expect(select.html_attributes).to eq(expected)
  end


  it "html attributes with error state" do
    select = RailsComponents::Components::FormSelect.new(error: true)
    expected = {
      class: "select select-bordered select-error",
      "aria-invalid": true
    }

    expect(select.html_attributes).to eq(expected)
  end

  it "html attributes with error and required" do
    select = RailsComponents::Components::FormSelect.new(error: true, required: true)
    expected = {
      class: "select select-bordered select-error",
      required: true,
      "aria-required": true,
      "aria-invalid": true
    }

    expect(select.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "role-select",
      data: { controller: "select", action: "change->select#update" },
      "data-testid": "role-field"
    }

    select = RailsComponents::Components::FormSelect.new(
      name: "user[role]",
      size: "lg",
      html_options: html_options
    )

    expected = {
      id: "role-select",
      data: { controller: "select", action: "change->select#update" },
      "data-testid": "role-field",
      name: "user[role]",
      class: "select select-bordered select-lg"
    }

    expect(select.html_attributes).to eq(expected)
  end

  # Test options handling
  it "options with array of arrays" do
    options = [ [ "First", "1" ], [ "Second", "2" ], [ "Third", "3" ] ]
    select = RailsComponents::Components::FormSelect.new(options: options)
    expect(select.options).to eq(options)
  end

  it "options with array of strings" do
    options = [ "Option 1", "Option 2", "Option 3" ]
    select = RailsComponents::Components::FormSelect.new(options: options)
    expect(select.options).to eq(options)
  end

  it "options with hash" do
    options = { "First" => "1", "Second" => "2", "Third" => "3" }
    select = RailsComponents::Components::FormSelect.new(options: options)
    expect(select.options).to eq(options)
  end

  it "options with empty array" do
    select = RailsComponents::Components::FormSelect.new(options: [])
    expect(select.options).to eq([])
  end

  # Test error detection from model object
  it "error detection from object with errors" do
    mock_object = Struct.new(:role) do
      def errors
        MockErrors.new(role: [ "can't be blank" ])
      end
    end.new

    select = RailsComponents::Components::FormSelect.new(
      object: mock_object,
      attribute: :role
    )

    expect(select.error?).to eq(true)
    expect(select.css_classes).to include("select-error")
    expect(select.html_attributes[:"aria-invalid"]).to eq(true)
  end

  it "error detection from object without errors" do
    mock_object = Struct.new(:role) do
      def errors
        MockErrors.new({})
      end
    end.new

    select = RailsComponents::Components::FormSelect.new(
      object: mock_object,
      attribute: :role
    )

    expect(select.error?).to eq(false)
    expect(select.css_classes).to eq("select select-bordered")
    expect(select.html_attributes[:"aria-invalid"]).to be_nil
  end

  # Test various size values
  it "various size values" do
    %w[xs sm lg].each do |size|
      select = RailsComponents::Components::FormSelect.new(size: size)
      expect(select.css_classes).to eq("select select-bordered select-#{size}")
    end
  end

  # Test edge cases
  it "nil values do not add attributes" do
    select = RailsComponents::Components::FormSelect.new(
      name: nil,
      value: nil,
      prompt: nil,
      size: nil
    )

    expected = {
      class: "select select-bordered"
    }

    expect(select.html_attributes).to eq(expected)
  end

  it "empty string values are preserved" do
    select = RailsComponents::Components::FormSelect.new(
      name: "",
      value: ""
    )

    expected = {
      name: "",
      id: "",
      class: "select select-bordered"
    }

    expect(select.html_attributes).to eq(expected)
  end

  it "false boolean states do not add attributes" do
    select = RailsComponents::Components::FormSelect.new(
      disabled: false,
      required: false,
      error: false
    )

    expected = {
      class: "select select-bordered"
    }

    expect(select.html_attributes).to eq(expected)
  end

  # Test prompt attribute
  it "prompt attribute stored correctly" do
    select = RailsComponents::Components::FormSelect.new(prompt: "Select an option")
    expect(select.prompt).to eq("Select an option")
  end

  it "prompt with nil value" do
    select = RailsComponents::Components::FormSelect.new(prompt: nil)
    expect(select.prompt).to be_nil
  end

  it "prompt with empty string" do
    select = RailsComponents::Components::FormSelect.new(prompt: "")
    expect(select.prompt).to eq("")
  end

  # Test complex combination scenario
  it "complex combination scenario" do
    mock_object = Struct.new(:department) do
      def errors
        MockErrors.new(department: [ "must be selected" ])
      end
    end.new

    options = [
      [ "Engineering", "eng" ],
      [ "Marketing", "mkt" ],
      [ "Sales", "sales" ],
      [ "Support", "support" ]
    ]

    select = RailsComponents::Components::FormSelect.new(
      name: "user[department]",
      value: "",
      options: options,
      prompt: "Choose your department",
      size: "lg",
      disabled: false,
      required: true,
      object: mock_object,
      attribute: :department,
      html_options: {
        id: "department-select",
        class: "border-2 focus:border-primary",
        data: { controller: "department", action: "change->department#update" },
        "data-required": "true"
      }
    )

    expected_classes = "select select-bordered select-lg select-error border-2 focus:border-primary"
    expect(select.css_classes).to eq(expected_classes)

    html_attrs = select.html_attributes

    # Assert individual attributes instead of full hash equality to avoid hash ordering issues
    expect(html_attrs[:id]).to eq("department-select")
    expect(html_attrs[:data]).to eq({ controller: "department", action: "change->department#update" })
    expect(html_attrs[:"data-required"]).to eq("true")
    expect(html_attrs[:name]).to eq("user[department]")
    expect(html_attrs[:required]).to be_truthy
    expect(html_attrs[:"aria-required"]).to be_truthy
    expect(html_attrs[:"aria-invalid"]).to be_truthy
    expect(html_attrs[:"aria-describedby"]).to eq("user_department_errors")
    expect(html_attrs[:class]).to eq(expected_classes)

    expect(select.options).to eq(options)
    expect(select.prompt).to eq("Choose your department")
  end


  it "select with size attribute" do
    select = RailsComponents::Components::FormSelect.new(
      html_options: { size: 5 }
    )

    expected = {
      size: 5,
      class: "select select-bordered"
    }

    expect(select.html_attributes).to eq(expected)
  end

  it "select with autofocus" do
    select = RailsComponents::Components::FormSelect.new(
      html_options: { autofocus: true }
    )

    expected = {
      autofocus: true,
      class: "select select-bordered"
    }

    expect(select.html_attributes).to eq(expected)
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
