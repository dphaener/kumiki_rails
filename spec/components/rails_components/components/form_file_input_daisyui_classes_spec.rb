require "rails_helper"

RSpec.describe "FormFileInput DaisyUI Classes", type: :model do
  # These tests expose the missing DaisyUI bordered class issue

  it "default file input includes bordered class" do
    file_input = RailsComponents::Components::FormFileInput.new

    # FAILING TEST: This should include file-input-bordered for proper DaisyUI styling
    expected_classes = "file-input file-input-bordered"
    expect(file_input.css_classes).to eq(expected_classes)
  end

  it "file input with size includes bordered class" do
    file_input = RailsComponents::Components::FormFileInput.new(size: "lg")

    # FAILING TEST: Should include bordered class with size
    expected_classes = "file-input file-input-bordered file-input-lg"
    expect(file_input.css_classes).to eq(expected_classes)
  end

  it "file input with error includes bordered class" do
    file_input = RailsComponents::Components::FormFileInput.new(error: true)

    # FAILING TEST: Should include bordered class with error state
    expected_classes = "file-input file-input-bordered file-input-error"
    expect(file_input.css_classes).to eq(expected_classes)
  end

  it "file input html attributes include bordered class" do
    file_input = RailsComponents::Components::FormFileInput.new

    # FAILING TEST: HTML attributes should include bordered class
    expected_class = "file-input file-input-bordered"
    expect(file_input.html_attributes[:class]).to eq(expected_class)
  end

  it "file input bordered class not duplicated with custom classes" do
    file_input = RailsComponents::Components::FormFileInput.new(
      html_options: { class: "custom-class file-input-bordered" }
    )

    # FAILING TEST: Should not duplicate file-input-bordered if already present
    classes = file_input.css_classes.split
    bordered_count = classes.count("file-input-bordered")
    expect(bordered_count).to eq(1)
  end

  it "file input preserves daisyui component structure" do
    file_input = RailsComponents::Components::FormFileInput.new(size: "sm", error: true)

    # FAILING TEST: Should maintain proper DaisyUI class order
    expected_classes = "file-input file-input-bordered file-input-sm file-input-error"
    expect(file_input.css_classes).to eq(expected_classes)

    # Verify individual classes are present
    classes = file_input.css_classes.split
    expect(classes).to include("file-input")
    expect(classes).to include("file-input-bordered")
    expect(classes).to include("file-input-sm")
    expect(classes).to include("file-input-error")
  end

  it "file input daisyui theming compatibility" do
    # Test various DaisyUI theme-compatible classes
    theme_classes = [ "file-input-primary", "file-input-secondary", "file-input-accent" ]

    theme_classes.each do |theme_class|
      file_input = RailsComponents::Components::FormFileInput.new(
        html_options: { class: theme_class }
      )

      # FAILING TEST: Should include both bordered and theme classes
      classes = file_input.css_classes.split
      expect(classes).to include("file-input")
      expect(classes).to include("file-input-bordered")
      expect(classes).to include(theme_class)
    end
  end

  it "file input ghost variant excludes bordered" do
    # Ghost variant should NOT have bordered class
    file_input = RailsComponents::Components::FormFileInput.new(
      html_options: { class: "file-input-ghost" }
    )

    # This test should PASS - ghost variant shouldn't have bordered
    classes = file_input.css_classes.split
    expect(classes).to include("file-input")
    expect(classes).to include("file-input-ghost")
    expect(classes).not_to include("file-input-bordered", "Ghost variant should not have bordered class")
  end

  it "file input responsive classes with bordered" do
    responsive_sizes = [ "file-input-xs", "file-input-sm", "file-input-md", "file-input-lg" ]

    responsive_sizes.each do |responsive_size|
      size = responsive_size.gsub("file-input-", "")
      file_input = RailsComponents::Components::FormFileInput.new(size: size)

      # FAILING TEST: Should include bordered with responsive sizing
      classes = file_input.css_classes.split
      expect(classes).to include("file-input")
      expect(classes).to include("file-input-bordered")
      expect(classes).to include(responsive_size)
    end
  end
end
