require "rails_helper"

RSpec.describe RailsComponents::Components::FormDatePicker, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    date_picker = RailsComponents::Components::FormDatePicker.new

    expect(date_picker.type).to eq("date")
    expect(date_picker.name).to be_nil
    expect(date_picker.value).to be_nil
    expect(date_picker.min).to be_nil
    expect(date_picker.max).to be_nil
    expect(date_picker.step).to be_nil
    expect(date_picker.size).to be_nil
    expect(date_picker.disabled).to eq(false)
    expect(date_picker.readonly).to eq(false)
    expect(date_picker.required).to eq(false)
    expect(date_picker.object).to be_nil
    expect(date_picker.attribute).to be_nil
    expect(date_picker.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { id: "custom-date", data: { test: "value" } }
    date_picker = RailsComponents::Components::FormDatePicker.new(
      type: "datetime-local",
      name: "event[start_date]",
      value: "2024-12-25T14:00",
      min: "2024-01-01",
      max: "2024-12-31",
      step: "900",
      size: "lg",
      disabled: true,
      readonly: true,
      required: true,
      html_options: html_options
    )

    expect(date_picker.type).to eq("datetime-local")
    expect(date_picker.name).to eq("event[start_date]")
    expect(date_picker.value).to eq("2024-12-25T14:00")
    expect(date_picker.min).to eq("2024-01-01")
    expect(date_picker.max).to eq("2024-12-31")
    expect(date_picker.step).to eq("900")
    expect(date_picker.size).to eq("lg")
    expect(date_picker.disabled).to eq(true)
    expect(date_picker.readonly).to eq(true)
    expect(date_picker.required).to eq(true)
    expect(date_picker.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    date_picker = RailsComponents::Components::FormDatePicker.new
    expect(date_picker.css_classes).to eq("input input-bordered")
  end

  it "css classes with size" do
    date_picker = RailsComponents::Components::FormDatePicker.new(size: "lg")
    expect(date_picker.css_classes).to eq("input input-bordered input-lg")
  end

  it "css classes with error state" do
    date_picker = RailsComponents::Components::FormDatePicker.new(error: true)
    expect(date_picker.css_classes).to eq("input input-bordered input-error")
  end

  it "css classes with size and error" do
    date_picker = RailsComponents::Components::FormDatePicker.new(size: "sm", error: true)
    expect(date_picker.css_classes).to eq("input input-bordered input-sm input-error")
  end

  it "css classes with custom class string" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      size: "lg",
      html_options: { class: "custom-class another-class" }
    )

    expect(date_picker.css_classes).to eq("input input-bordered input-lg custom-class another-class")
  end

  it "css classes with custom class array" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      size: "lg",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(date_picker.css_classes).to eq("input input-bordered input-lg custom-class another-class")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    date_picker = RailsComponents::Components::FormDatePicker.new
    expected = {
      type: "date",
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "html attributes with basic attributes" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      name: "user[birth_date]",
      value: "1990-05-15"
    )

    expected = {
      type: "date",
      class: "input input-bordered",
      name: "user[birth_date]",
      value: "1990-05-15",
      id: "user_birth_date"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "html attributes with min max step" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      type: "datetime-local",
      min: "2024-01-01T00:00",
      max: "2024-12-31T23:59",
      step: "900"
    )

    expected = {
      type: "datetime-local",
      min: "2024-01-01T00:00",
      max: "2024-12-31T23:59",
      step: "900",
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "html attributes with disabled state" do
    date_picker = RailsComponents::Components::FormDatePicker.new(disabled: true)
    expected = {
      type: "date",
      class: "input input-bordered",
      disabled: true
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "html attributes with readonly state" do
    date_picker = RailsComponents::Components::FormDatePicker.new(readonly: true)
    expected = {
      type: "date",
      class: "input input-bordered",
      readonly: true
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "html attributes with required state" do
    date_picker = RailsComponents::Components::FormDatePicker.new(required: true)
    expected = {
      type: "date",
      class: "input input-bordered",
      required: true,
      "aria-required": true
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "html attributes with error state" do
    date_picker = RailsComponents::Components::FormDatePicker.new(error: true)
    expected = {
      type: "date",
      class: "input input-bordered input-error",
      "aria-invalid": true
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "html attributes with error and required" do
    date_picker = RailsComponents::Components::FormDatePicker.new(error: true, required: true)
    expected = {
      type: "date",
      class: "input input-bordered input-error",
      required: true,
      "aria-required": true,
      "aria-invalid": true
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "start-date",
      data: { controller: "datepicker", action: "change->datepicker#validate" },
      "data-testid": "start-date-field",
      autocomplete: "bday"
    }

    date_picker = RailsComponents::Components::FormDatePicker.new(
      type: "date",
      size: "lg",
      html_options: html_options
    )

    expected = {
      id: "start-date",
      data: { controller: "datepicker", action: "change->datepicker#validate" },
      "data-testid": "start-date-field",
      autocomplete: "bday",
      type: "date",
      class: "input input-bordered input-lg"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  # Test error detection from model object
  it "error detection from object with errors" do
    mock_object = Struct.new(:birth_date) do
      def errors
        MockErrors.new(birth_date: [ "can't be blank" ])
      end
    end.new

    date_picker = RailsComponents::Components::FormDatePicker.new(
      object: mock_object,
      attribute: :birth_date
    )

    expect(date_picker.error?).to eq(true)
    expect(date_picker.css_classes).to include("input-error")
    expect(date_picker.html_attributes[:"aria-invalid"]).to eq(true)
  end

  it "error detection from object without errors" do
    mock_object = Struct.new(:birth_date) do
      def errors
        MockErrors.new({})
      end
    end.new

    date_picker = RailsComponents::Components::FormDatePicker.new(
      object: mock_object,
      attribute: :birth_date
    )

    expect(date_picker.error?).to eq(false)
    expect(date_picker.css_classes).to eq("input input-bordered")
    expect(date_picker.html_attributes[:"aria-invalid"]).to be_nil
  end

  # Test various date/time input types
  it "various date input types" do
    %w[date time datetime-local month week].each do |input_type|
      date_picker = RailsComponents::Components::FormDatePicker.new(type: input_type)
      expect(date_picker.html_attributes[:type]).to eq(input_type)
    end
  end

  it "various size values" do
    %w[xs sm lg].each do |size|
      date_picker = RailsComponents::Components::FormDatePicker.new(size: size)
      expect(date_picker.css_classes).to eq("input input-bordered input-#{size}")
    end
  end

  # Test edge cases
  it "nil values do not add attributes" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      name: nil,
      value: nil,
      min: nil,
      max: nil,
      step: nil,
      size: nil
    )

    expected = {
      type: "date",
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "empty string values are preserved" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      name: "",
      value: "",
      min: "",
      max: "",
      step: ""
    )

    expected = {
      type: "date",
      name: "",
      value: "",
      min: "",
      max: "",
      step: "",
      id: "",
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "false boolean states do not add attributes" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      disabled: false,
      readonly: false,
      required: false,
      error: false
    )

    expected = {
      type: "date",
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  # Test date format handling
  it "date value formats" do
    test_cases = [
      { type: "date", value: "2024-12-25" },
      { type: "time", value: "14:30" },
      { type: "datetime-local", value: "2024-12-25T14:30" },
      { type: "month", value: "2024-12" },
      { type: "week", value: "2024-W52" }
    ]

    test_cases.each do |test_case|
      date_picker = RailsComponents::Components::FormDatePicker.new(
        type: test_case[:type],
        value: test_case[:value]
      )

      expect(date_picker.html_attributes[:value]).to eq(test_case[:value])
      expect(date_picker.html_attributes[:type]).to eq(test_case[:type])
    end
  end

  # Test step values for different types
  it "step values for time inputs" do
    test_cases = [
      { type: "time", step: "1" },        # 1 second
      { type: "time", step: "60" },       # 1 minute
      { type: "time", step: "900" },      # 15 minutes
      { type: "datetime-local", step: "1" }, # 1 second
      { type: "datetime-local", step: "any" } # any precision
    ]

    test_cases.each do |test_case|
      date_picker = RailsComponents::Components::FormDatePicker.new(
        type: test_case[:type],
        step: test_case[:step]
      )

      expect(date_picker.html_attributes[:step]).to eq(test_case[:step])
    end
  end

  # Test complex combination scenario
  it "complex combination scenario" do
    mock_object = Struct.new(:appointment_date) do
      def errors
        MockErrors.new(appointment_date: [ "must be in the future" ])
      end
    end.new

    date_picker = RailsComponents::Components::FormDatePicker.new(
      type: "datetime-local",
      name: "appointment[date_time]",
      value: "2024-12-25T14:30",
      min: Time.current.strftime("%Y-%m-%dT%H:%M"),
      max: (Time.current + 1.year).strftime("%Y-%m-%dT%H:%M"),
      step: "900",
      size: "lg",
      disabled: false,
      readonly: false,
      required: true,
      object: mock_object,
      attribute: :appointment_date,
      html_options: {
        id: "appointment-datetime",
        class: "border-2 focus:border-primary",
        data: {
          controller: "datepicker availability",
          action: "change->datepicker#validate change->availability#check",
          "datepicker-min-date": Time.current.strftime("%Y-%m-%d"),
          "availability-timezone": "UTC"
        },
        "data-testid": "appointment-field",
        autocomplete: "off"
      }
    )

    expected_classes = "input input-bordered input-lg input-error border-2 focus:border-primary"
    expect(date_picker.css_classes).to eq(expected_classes)

    html_attrs = date_picker.html_attributes

    # Assert individual attributes instead of full hash equality to avoid hash ordering issues
    expect(html_attrs[:id]).to eq("appointment-datetime")
    expect(html_attrs[:data]).to eq({
      controller: "datepicker availability",
      action: "change->datepicker#validate change->availability#check",
      "datepicker-min-date": Time.current.strftime("%Y-%m-%d"),
      "availability-timezone": "UTC"
    })
    expect(html_attrs[:"data-testid"]).to eq("appointment-field")
    expect(html_attrs[:autocomplete]).to eq("off")
    expect(html_attrs[:type]).to eq("datetime-local")
    expect(html_attrs[:name]).to eq("appointment[date_time]")
    expect(html_attrs[:value]).to eq("2024-12-25T14:30")
    expect(html_attrs[:min]).to eq(Time.current.strftime("%Y-%m-%dT%H:%M"))
    expect(html_attrs[:max]).to eq((Time.current + 1.year).strftime("%Y-%m-%dT%H:%M"))
    expect(html_attrs[:step]).to eq("900")
    expect(html_attrs[:required]).to be_truthy
    expect(html_attrs[:"aria-required"]).to be_truthy
    expect(html_attrs[:"aria-invalid"]).to be_truthy
    expect(html_attrs[:"aria-describedby"]).to eq("appointment_date_time_errors")
    expect(html_attrs[:class]).to eq(expected_classes)
  end

  it "date picker with pattern attribute" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      type: "text",
      html_options: { pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}" }
    )

    expected = {
      type: "text",
      pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}",
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "date picker with placeholder" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      html_options: { placeholder: "YYYY-MM-DD" }
    )

    expected = {
      type: "date",
      placeholder: "YYYY-MM-DD",
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "date picker with list attribute" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      html_options: { list: "date-suggestions" }
    )

    expected = {
      type: "date",
      list: "date-suggestions",
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
  end

  it "date picker with autofocus" do
    date_picker = RailsComponents::Components::FormDatePicker.new(
      html_options: { autofocus: true }
    )

    expected = {
      type: "date",
      autofocus: true,
      class: "input input-bordered"
    }

    expect(date_picker.html_attributes).to eq(expected)
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
