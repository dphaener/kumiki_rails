require "rails_helper"

RSpec.describe RailsComponents::Components::FormTextarea, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    textarea = RailsComponents::Components::FormTextarea.new

    expect(textarea.name).to be_nil
    expect(textarea.value).to be_nil
    expect(textarea.placeholder).to be_nil
    expect(textarea.rows).to be_nil
    expect(textarea.cols).to be_nil
    expect(textarea.size).to be_nil
    expect(textarea.disabled).to eq(false)
    expect(textarea.readonly).to eq(false)
    expect(textarea.required).to eq(false)
    expect(textarea.object).to be_nil
    expect(textarea.attribute).to be_nil
    expect(textarea.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { id: "custom-textarea", data: { test: "value" } }
    textarea = RailsComponents::Components::FormTextarea.new(
      name: "post[content]",
      value: "Sample content",
      placeholder: "Enter your content here",
      rows: 10,
      cols: 50,
      size: "lg",
      disabled: true,
      readonly: true,
      required: true,
      html_options: html_options
    )

    expect(textarea.name).to eq("post[content]")
    expect(textarea.value).to eq("Sample content")
    expect(textarea.placeholder).to eq("Enter your content here")
    expect(textarea.rows).to eq(10)
    expect(textarea.cols).to eq(50)
    expect(textarea.size).to eq("lg")
    expect(textarea.disabled).to eq(true)
    expect(textarea.readonly).to eq(true)
    expect(textarea.required).to eq(true)
    expect(textarea.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    textarea = RailsComponents::Components::FormTextarea.new
    expect(textarea.css_classes).to eq("textarea textarea-bordered")
  end

  it "css classes with size" do
    textarea = RailsComponents::Components::FormTextarea.new(size: "lg")
    expect(textarea.css_classes).to eq("textarea textarea-bordered textarea-lg")
  end

  it "css classes with error state" do
    textarea = RailsComponents::Components::FormTextarea.new(error: true)
    expect(textarea.css_classes).to eq("textarea textarea-bordered textarea-error")
  end

  it "css classes with size and error" do
    textarea = RailsComponents::Components::FormTextarea.new(size: "sm", error: true)
    expect(textarea.css_classes).to eq("textarea textarea-bordered textarea-sm textarea-error")
  end

  it "css classes with custom class string" do
    textarea = RailsComponents::Components::FormTextarea.new(
      size: "lg",
      html_options: { class: "custom-class another-class" }
    )

    expect(textarea.css_classes).to eq("textarea textarea-bordered textarea-lg custom-class another-class")
  end

  it "css classes with custom class array" do
    textarea = RailsComponents::Components::FormTextarea.new(
      size: "lg",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(textarea.css_classes).to eq("textarea textarea-bordered textarea-lg custom-class another-class")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    textarea = RailsComponents::Components::FormTextarea.new
    expected = {
      class: "textarea textarea-bordered"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "html attributes with basic attributes" do
    textarea = RailsComponents::Components::FormTextarea.new(
      name: "post[content]",
      value: "Sample content",
      placeholder: "Enter content"
    )

    expected = {
      name: "post[content]",
      placeholder: "Enter content",
      class: "textarea textarea-bordered",
      id: "post_content"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "html attributes with rows and cols" do
    textarea = RailsComponents::Components::FormTextarea.new(
      rows: 10,
      cols: 50
    )

    expected = {
      rows: 10,
      cols: 50,
      class: "textarea textarea-bordered"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "html attributes with disabled state" do
    textarea = RailsComponents::Components::FormTextarea.new(disabled: true)
    expected = {
      class: "textarea textarea-bordered",
      disabled: true
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "html attributes with readonly state" do
    textarea = RailsComponents::Components::FormTextarea.new(readonly: true)
    expected = {
      class: "textarea textarea-bordered",
      readonly: true
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "html attributes with required state" do
    textarea = RailsComponents::Components::FormTextarea.new(required: true)
    expected = {
      class: "textarea textarea-bordered",
      required: true,
      "aria-required": true
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "html attributes with error state" do
    textarea = RailsComponents::Components::FormTextarea.new(error: true)
    expected = {
      class: "textarea textarea-bordered textarea-error",
      "aria-invalid": true
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "html attributes with error and required" do
    textarea = RailsComponents::Components::FormTextarea.new(error: true, required: true)
    expected = {
      class: "textarea textarea-bordered textarea-error",
      required: true,
      "aria-required": true,
      "aria-invalid": true
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "content-textarea",
      data: { controller: "textarea", action: "input->textarea#autoResize" },
      "data-testid": "content-field",
      spellcheck: true
    }

    textarea = RailsComponents::Components::FormTextarea.new(
      name: "post[content]",
      size: "lg",
      html_options: html_options
    )

    expected = {
      id: "content-textarea",
      data: { controller: "textarea", action: "input->textarea#autoResize" },
      "data-testid": "content-field",
      spellcheck: true,
      name: "post[content]",
      class: "textarea textarea-bordered textarea-lg"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  # Test error detection from model object
  it "error detection from object with errors" do
    mock_object = Struct.new(:content) do
      def errors
        MockErrors.new(content: [ "can't be blank" ])
      end
    end.new

    textarea = RailsComponents::Components::FormTextarea.new(
      object: mock_object,
      attribute: :content
    )

    expect(textarea.error?).to eq(true)
    expect(textarea.css_classes).to include("textarea-error")
    expect(textarea.html_attributes[:"aria-invalid"]).to eq(true)
  end

  it "error detection from object without errors" do
    mock_object = Struct.new(:content) do
      def errors
        MockErrors.new({})
      end
    end.new

    textarea = RailsComponents::Components::FormTextarea.new(
      object: mock_object,
      attribute: :content
    )

    expect(textarea.error?).to eq(false)
    expect(textarea.css_classes).to eq("textarea textarea-bordered")
    expect(textarea.html_attributes[:"aria-invalid"]).to be_nil
  end

  # Test various size values
  it "various size values" do
    %w[xs sm lg].each do |size|
      textarea = RailsComponents::Components::FormTextarea.new(size: size)
      expect(textarea.css_classes).to eq("textarea textarea-bordered textarea-#{size}")
    end
  end

  # Test edge cases
  it "nil values do not add attributes" do
    textarea = RailsComponents::Components::FormTextarea.new(
      name: nil,
      value: nil,
      placeholder: nil,
      rows: nil,
      cols: nil,
      size: nil
    )

    expected = {
      class: "textarea textarea-bordered"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "empty string values are preserved" do
    textarea = RailsComponents::Components::FormTextarea.new(
      name: "",
      value: "",
      placeholder: ""
    )

    expected = {
      name: "",
      placeholder: "",
      id: "",
      class: "textarea textarea-bordered"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "false boolean states do not add attributes" do
    textarea = RailsComponents::Components::FormTextarea.new(
      disabled: false,
      readonly: false,
      required: false,
      error: false
    )

    expected = {
      class: "textarea textarea-bordered"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  # Test value handling with multiline content
  it "value with multiline content" do
    multiline_content = "Line 1\nLine 2\nLine 3"
    textarea = RailsComponents::Components::FormTextarea.new(value: multiline_content)

    expect(textarea.value).to eq(multiline_content)
  end

  it "value with special characters" do
    special_content = "Content with \"quotes\" and 'apostrophes' & ampersands"
    textarea = RailsComponents::Components::FormTextarea.new(value: special_content)

    expect(textarea.value).to eq(special_content)
  end

  # Test complex combination scenario
  it "complex combination scenario" do
    mock_object = Struct.new(:description) do
      def errors
        MockErrors.new(description: [ "is too short" ])
      end
    end.new

    textarea = RailsComponents::Components::FormTextarea.new(
      name: "product[description]",
      value: "Short desc",
      placeholder: "Enter detailed product description (min 50 chars)",
      rows: 8,
      cols: 60,
      size: "lg",
      disabled: false,
      readonly: false,
      required: true,
      object: mock_object,
      attribute: :description,
      html_options: {
        id: "description-textarea",
        class: "border-2 focus:border-primary resize-y",
        data: {
          controller: "character-counter textarea",
          action: "input->character-counter#update input->textarea#autoResize",
          "character-counter-min-value": "50"
        },
        "data-testid": "description-field",
        maxlength: 1000,
        spellcheck: true
      }
    )

    expected_classes = "textarea textarea-bordered textarea-lg textarea-error border-2 focus:border-primary resize-y"
    expect(textarea.css_classes).to eq(expected_classes)

    html_attrs = textarea.html_attributes

    # Assert individual attributes instead of full hash equality to avoid hash ordering issues
    expect(html_attrs[:id]).to eq("description-textarea")
    expect(html_attrs[:data]).to eq({
      controller: "character-counter textarea",
      action: "input->character-counter#update input->textarea#autoResize",
      "character-counter-min-value": "50"
    })
    expect(html_attrs[:"data-testid"]).to eq("description-field")
    expect(html_attrs[:maxlength]).to eq(1000)
    expect(html_attrs[:spellcheck]).to be_truthy
    expect(html_attrs[:name]).to eq("product[description]")
    expect(html_attrs[:placeholder]).to eq("Enter detailed product description (min 50 chars)")
    expect(html_attrs[:rows]).to eq(8)
    expect(html_attrs[:cols]).to eq(60)
    expect(html_attrs[:required]).to be_truthy
    expect(html_attrs[:"aria-required"]).to be_truthy
    expect(html_attrs[:"aria-invalid"]).to be_truthy
    expect(html_attrs[:"aria-describedby"]).to eq("product_description_errors")
    expect(html_attrs[:class]).to eq(expected_classes)

    expect(textarea.value).to eq("Short desc")
  end

  it "textarea with wrap attribute" do
    textarea = RailsComponents::Components::FormTextarea.new(
      html_options: { wrap: "soft" }
    )

    expected = {
      wrap: "soft",
      class: "textarea textarea-bordered"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "textarea with minlength and maxlength" do
    textarea = RailsComponents::Components::FormTextarea.new(
      html_options: { minlength: 10, maxlength: 500 }
    )

    expected = {
      minlength: 10,
      maxlength: 500,
      class: "textarea textarea-bordered"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "textarea with autofocus" do
    textarea = RailsComponents::Components::FormTextarea.new(
      html_options: { autofocus: true }
    )

    expected = {
      autofocus: true,
      class: "textarea textarea-bordered"
    }

    expect(textarea.html_attributes).to eq(expected)
  end

  it "textarea with resize styles" do
    textarea = RailsComponents::Components::FormTextarea.new(
      html_options: { class: "resize-none" }
    )

    expected_classes = "textarea textarea-bordered resize-none"
    expect(textarea.css_classes).to eq(expected_classes)
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
