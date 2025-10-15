require "rails_helper"

RSpec.describe Kumiki::Components::FormFileInput, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    file_input = Kumiki::Components::FormFileInput.new

    expect(file_input.name).to be_nil
    expect(file_input.accept).to be_nil
    expect(file_input.multiple).to eq(false)
    expect(file_input.disabled).to eq(false)
    expect(file_input.required).to eq(false)
    expect(file_input.size).to be_nil
    expect(file_input.object).to be_nil
    expect(file_input.attribute).to be_nil
    expect(file_input.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { id: "custom-file", data: { test: "value" } }
    file_input = Kumiki::Components::FormFileInput.new(
      name: "user[avatar]",
      accept: "image/*",
      multiple: true,
      disabled: true,
      required: true,
      size: "lg",
      html_options: html_options
    )

    expect(file_input.name).to eq("user[avatar]")
    expect(file_input.accept).to eq("image/*")
    expect(file_input.multiple).to eq(true)
    expect(file_input.disabled).to eq(true)
    expect(file_input.required).to eq(true)
    expect(file_input.size).to eq("lg")
    expect(file_input.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    file_input = Kumiki::Components::FormFileInput.new
    expect(file_input.css_classes).to eq("file-input file-input-bordered")
  end

  it "css classes with size" do
    file_input = Kumiki::Components::FormFileInput.new(size: "lg")
    expect(file_input.css_classes).to eq("file-input file-input-bordered file-input-lg")
  end

  it "css classes with error state" do
    file_input = Kumiki::Components::FormFileInput.new(error: true)
    expect(file_input.css_classes).to eq("file-input file-input-bordered file-input-error")
  end

  it "css classes with size and error" do
    file_input = Kumiki::Components::FormFileInput.new(size: "sm", error: true)
    expect(file_input.css_classes).to eq("file-input file-input-bordered file-input-sm file-input-error")
  end

  it "css classes with custom class string" do
    file_input = Kumiki::Components::FormFileInput.new(
      size: "lg",
      html_options: { class: "custom-class another-class" }
    )

    expect(file_input.css_classes).to eq("file-input file-input-bordered file-input-lg custom-class another-class")
  end

  it "css classes with custom class array" do
    file_input = Kumiki::Components::FormFileInput.new(
      size: "lg",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(file_input.css_classes).to eq("file-input file-input-bordered file-input-lg custom-class another-class")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    file_input = Kumiki::Components::FormFileInput.new
    expected = {
      type: "file",
      class: "file-input file-input-bordered"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "html attributes with basic attributes" do
    file_input = Kumiki::Components::FormFileInput.new(
      name: "user[document]",
      accept: ".pdf,.doc,.docx"
    )

    expected = {
      type: "file",
      class: "file-input file-input-bordered",
      name: "user[document]",
      accept: ".pdf,.doc,.docx",
      id: "user_document"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "html attributes with multiple state" do
    file_input = Kumiki::Components::FormFileInput.new(multiple: true)
    expected = {
      type: "file",
      class: "file-input file-input-bordered",
      multiple: true
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "html attributes with disabled state" do
    file_input = Kumiki::Components::FormFileInput.new(disabled: true)
    expected = {
      type: "file",
      class: "file-input file-input-bordered",
      disabled: true
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "html attributes with required state" do
    file_input = Kumiki::Components::FormFileInput.new(required: true)
    expected = {
      type: "file",
      class: "file-input file-input-bordered",
      required: true,
      "aria-required": true
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "html attributes with error state" do
    file_input = Kumiki::Components::FormFileInput.new(error: true)
    expected = {
      type: "file",
      class: "file-input file-input-bordered file-input-error",
      "aria-invalid": true
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "html attributes with error and required" do
    file_input = Kumiki::Components::FormFileInput.new(error: true, required: true)
    expected = {
      type: "file",
      class: "file-input file-input-bordered file-input-error",
      required: true,
      "aria-required": true,
      "aria-invalid": true
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "avatar-upload",
      data: { controller: "file-upload", action: "change->file-upload#preview" },
      "data-testid": "avatar-field",
      "data-max-size": "5242880"
    }

    file_input = Kumiki::Components::FormFileInput.new(
      name: "user[avatar]",
      accept: "image/*",
      size: "lg",
      html_options: html_options
    )

    expected = {
      id: "avatar-upload",
      data: { controller: "file-upload", action: "change->file-upload#preview" },
      "data-testid": "avatar-field",
      "data-max-size": "5242880",
      type: "file",
      name: "user[avatar]",
      accept: "image/*",
      class: "file-input file-input-bordered file-input-lg"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  # Test error detection from model object
  it "error detection from object with errors" do
    mock_object = Struct.new(:avatar) do
      def errors
        MockErrors.new(avatar: [ "can't be blank" ])
      end
    end.new

    file_input = Kumiki::Components::FormFileInput.new(
      object: mock_object,
      attribute: :avatar
    )

    expect(file_input.error?).to eq(true)
    expect(file_input.css_classes).to include("file-input-error")
    expect(file_input.html_attributes[:"aria-invalid"]).to eq(true)
  end

  it "error detection from object without errors" do
    mock_object = Struct.new(:avatar) do
      def errors
        MockErrors.new({})
      end
    end.new

    file_input = Kumiki::Components::FormFileInput.new(
      object: mock_object,
      attribute: :avatar
    )

    expect(file_input.error?).to eq(false)
    expect(file_input.css_classes).to eq("file-input file-input-bordered")
    expect(file_input.html_attributes[:"aria-invalid"]).to be_nil
  end

  # Test various accept attribute values
  it "various accept values" do
    test_cases = [
      "image/*",
      "image/jpeg,image/png,image/gif",
      ".pdf",
      ".pdf,.doc,.docx",
      "audio/*",
      "video/*",
      "text/plain",
      "application/json"
    ]

    test_cases.each do |accept_value|
      file_input = Kumiki::Components::FormFileInput.new(accept: accept_value)
      expect(file_input.html_attributes[:accept]).to eq(accept_value)
    end
  end

  it "various size values" do
    %w[xs sm lg].each do |size|
      file_input = Kumiki::Components::FormFileInput.new(size: size)
      expect(file_input.css_classes).to eq("file-input file-input-bordered file-input-#{size}")
    end
  end

  # Test edge cases
  it "nil values do not add attributes" do
    file_input = Kumiki::Components::FormFileInput.new(
      name: nil,
      accept: nil,
      size: nil
    )

    expected = {
      type: "file",
      class: "file-input file-input-bordered"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "empty string values are preserved" do
    file_input = Kumiki::Components::FormFileInput.new(
      name: "",
      accept: ""
    )

    expected = {
      type: "file",
      name: "",
      accept: "",
      id: "",
      class: "file-input file-input-bordered"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "false boolean states do not add attributes" do
    file_input = Kumiki::Components::FormFileInput.new(
      multiple: false,
      disabled: false,
      required: false,
      error: false
    )

    expected = {
      type: "file",
      class: "file-input file-input-bordered"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  # Test file upload scenarios
  it "single file upload" do
    file_input = Kumiki::Components::FormFileInput.new(
      name: "user[avatar]",
      accept: "image/jpeg,image/png"
    )

    expected = {
      type: "file",
      class: "file-input file-input-bordered",
      name: "user[avatar]",
      accept: "image/jpeg,image/png",
      id: "user_avatar"
    }

    expect(file_input.html_attributes).to eq(expected)
    expect(file_input.multiple).to eq(false)
  end

  it "multiple file upload" do
    file_input = Kumiki::Components::FormFileInput.new(
      name: "post[attachments][]",
      accept: ".pdf,.doc,.docx,.txt",
      multiple: true
    )

    expected = {
      type: "file",
      class: "file-input file-input-bordered",
      name: "post[attachments][]",
      accept: ".pdf,.doc,.docx,.txt",
      multiple: true,
      id: "post_attachments"
    }

    expect(file_input.html_attributes).to eq(expected)
    expect(file_input.multiple).to eq(true)
  end

  # Test complex combination scenario
  it "complex combination scenario" do
    mock_object = Struct.new(:resume) do
      def errors
        MockErrors.new(resume: [ "file size too large" ])
      end
    end.new

    file_input = Kumiki::Components::FormFileInput.new(
      name: "application[resume]",
      accept: ".pdf,.doc,.docx",
      multiple: false,
      disabled: false,
      required: true,
      size: "lg",
      object: mock_object,
      attribute: :resume,
      html_options: {
        id: "resume-upload",
        class: "border-2 border-dashed hover:border-primary",
        data: {
          controller: "file-upload validation",
          action: "change->file-upload#validateSize change->validation#check",
          "file-upload-max-size": "10485760",
          "file-upload-allowed-types": "pdf,doc,docx"
        },
        "data-testid": "resume-field",
        "aria-describedby": "resume-help"
      }
    )

    expected_classes = "file-input file-input-bordered file-input-lg file-input-error border-2 border-dashed hover:border-primary"
    expect(file_input.css_classes).to eq(expected_classes)

    expected_attributes = {
      id: "resume-upload",
      data: {
        controller: "file-upload validation",
        action: "change->file-upload#validateSize change->validation#check",
        "file-upload-max-size": "10485760",
        "file-upload-allowed-types": "pdf,doc,docx"
      },
      "data-testid": "resume-field",
      "aria-describedby": "resume-help",
      type: "file",
      name: "application[resume]",
      accept: ".pdf,.doc,.docx",
      required: true,
      "aria-required": true,
      "aria-invalid": true,
      class: expected_classes
    }

    expect(file_input.html_attributes).to eq(expected_attributes)
  end

  it "file input with capture attribute" do
    # For mobile devices to access camera/microphone
    file_input = Kumiki::Components::FormFileInput.new(
      accept: "image/*",
      html_options: { capture: "environment" }
    )

    expected = {
      type: "file",
      accept: "image/*",
      capture: "environment",
      class: "file-input file-input-bordered"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "file input with webkitdirectory" do
    # For directory uploads
    file_input = Kumiki::Components::FormFileInput.new(
      multiple: true,
      html_options: { webkitdirectory: true }
    )

    expected = {
      type: "file",
      multiple: true,
      webkitdirectory: true,
      class: "file-input file-input-bordered"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "file input with form attribute" do
    file_input = Kumiki::Components::FormFileInput.new(
      html_options: { form: "upload-form" }
    )

    expected = {
      type: "file",
      form: "upload-form",
      class: "file-input file-input-bordered"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  it "file input with autofocus" do
    file_input = Kumiki::Components::FormFileInput.new(
      html_options: { autofocus: true }
    )

    expected = {
      type: "file",
      autofocus: true,
      class: "file-input file-input-bordered"
    }

    expect(file_input.html_attributes).to eq(expected)
  end

  # Test image-specific scenarios
  it "image file upload" do
    file_input = Kumiki::Components::FormFileInput.new(
      name: "product[images][]",
      accept: "image/jpeg,image/png,image/webp",
      multiple: true
    )

    expect(file_input.accept).to eq("image/jpeg,image/png,image/webp")
    expect(file_input.multiple).to eq(true)
    expect(file_input.name).to eq("product[images][]")
  end

  it "document file upload" do
    file_input = Kumiki::Components::FormFileInput.new(
      name: "contract[document]",
      accept: ".pdf,.docx"
    )

    expect(file_input.accept).to eq(".pdf,.docx")
    expect(file_input.multiple).to eq(false)
    expect(file_input.name).to eq("contract[document]")
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
