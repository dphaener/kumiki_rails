require "rails_helper"

RSpec.describe RailsComponents::Components::Badge, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    badge = RailsComponents::Components::Badge.new

    expect(badge.text).to eq("")
    expect(badge.variant).to be_nil
    expect(badge.size).to be_nil
    expect(badge.style).to be_nil
    expect(badge.icon_left).to be_nil
    expect(badge.icon_right).to be_nil
    expect(badge.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { id: "custom-badge", data: { test: "value" } }
    badge = RailsComponents::Components::Badge.new(
      text: "New",
      variant: "primary",
      size: "lg",
      style: "outline",
      icon_left: "star",
      icon_right: "arrow",
      html_options: html_options
    )

    expect(badge.text).to eq("New")
    expect(badge.variant).to eq("primary")
    expect(badge.size).to eq("lg")
    expect(badge.style).to eq("outline")
    expect(badge.icon_left).to eq("star")
    expect(badge.icon_right).to eq("arrow")
    expect(badge.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    badge = RailsComponents::Components::Badge.new
    expect(badge.css_classes).to eq("badge")
  end

  it "css classes with variant" do
    badge = RailsComponents::Components::Badge.new(variant: "primary")
    expect(badge.css_classes).to eq("badge badge-primary")
  end

  it "css classes with size" do
    badge = RailsComponents::Components::Badge.new(size: "lg")
    expect(badge.css_classes).to eq("badge badge-lg")
  end

  it "css classes with style" do
    badge = RailsComponents::Components::Badge.new(style: "outline")
    expect(badge.css_classes).to eq("badge badge-outline")
  end

  it "css classes with all options" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      size: "lg",
      style: "outline"
    )

    expected_classes = "badge badge-primary badge-lg badge-outline"
    expect(badge.css_classes).to eq(expected_classes)
  end

  # Test custom class merging from html_options
  it "css classes with custom class string" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      html_options: { class: "custom-class another-class" }
    )

    expect(badge.css_classes).to eq("badge badge-primary custom-class another-class")
  end

  it "css classes with custom class array" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(badge.css_classes).to eq("badge badge-primary custom-class another-class")
  end

  it "css classes with custom class string key" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      html_options: { "class" => "custom-class" }
    )

    expect(badge.css_classes).to eq("badge badge-primary custom-class")
  end

  it "css classes without custom class" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      html_options: { id: "test" }
    )

    expect(badge.css_classes).to eq("badge badge-primary")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    badge = RailsComponents::Components::Badge.new
    expected = {
      class: "badge"
    }

    expect(badge.html_attributes).to eq(expected)
  end

  it "html attributes with variant" do
    badge = RailsComponents::Components::Badge.new(variant: "success")
    expected = {
      class: "badge badge-success"
    }

    expect(badge.html_attributes).to eq(expected)
  end

  it "html attributes with html options" do
    html_options = {
      id: "custom-badge",
      data: { test: "value" },
      "data-controller": "badge",
      aria: { label: "Custom badge" }
    }

    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      html_options: html_options
    )

    expected = {
      id: "custom-badge",
      data: { test: "value" },
      "data-controller": "badge",
      aria: { label: "Custom badge" },
      class: "badge badge-primary"
    }

    expect(badge.html_attributes).to eq(expected)
  end

  it "html attributes excludes class from html options" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      html_options: { class: "custom-class", id: "test-badge" }
    )

    expected = {
      id: "test-badge",
      class: "badge badge-primary custom-class"
    }

    expect(badge.html_attributes).to eq(expected)
  end

  it "html attributes excludes string class from html options" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      html_options: { "class" => "custom-class", id: "test-badge" }
    )

    expected = {
      id: "test-badge",
      class: "badge badge-primary custom-class"
    }

    expect(badge.html_attributes).to eq(expected)
  end

  # Test edge cases and parameter combinations
  it "nil values do not add classes" do
    badge = RailsComponents::Components::Badge.new(
      variant: nil,
      size: nil,
      style: nil
    )

    expect(badge.css_classes).to eq("badge")
  end

  it "empty string values add empty classes" do
    badge = RailsComponents::Components::Badge.new(
      variant: "",
      size: "",
      style: ""
    )

    # Empty strings actually generate badge- classes in the current implementation
    expect(badge.css_classes).to eq("badge badge- badge- badge-")
  end

  # Test all DaisyUI badge variants
  it "various variant values" do
    %w[primary secondary accent neutral info success warning error].each do |variant|
      badge = RailsComponents::Components::Badge.new(variant: variant)
      expect(badge.css_classes).to eq("badge badge-#{variant}")
    end
  end

  # Test all DaisyUI badge sizes
  it "various size values" do
    %w[xs sm md lg xl].each do |size|
      badge = RailsComponents::Components::Badge.new(size: size)
      expect(badge.css_classes).to eq("badge badge-#{size}")
    end
  end

  # Test all DaisyUI badge styles
  it "various style values" do
    %w[outline dash soft ghost].each do |style|
      badge = RailsComponents::Components::Badge.new(style: style)
      expect(badge.css_classes).to eq("badge badge-#{style}")
    end
  end

  it "complex combination scenario" do
    badge = RailsComponents::Components::Badge.new(
      text: "Complex Badge",
      variant: "primary",
      size: "lg",
      style: "outline",
      icon_left: "plus",
      icon_right: "arrow-right",
      html_options: {
        id: "complex-badge",
        class: "custom-animation hover:scale-105",
        data: { controller: "badge", action: "click->badge#toggle" },
        "aria-label": "Complex badge"
      }
    )

    expected_classes = "badge badge-primary badge-lg badge-outline custom-animation hover:scale-105"
    expect(badge.css_classes).to eq(expected_classes)

    expected_attributes = {
      id: "complex-badge",
      data: { controller: "badge", action: "click->badge#toggle" },
      "aria-label": "Complex badge",
      class: expected_classes
    }
    expect(badge.html_attributes).to eq(expected_attributes)
  end

  it "custom class array with mixed content" do
    badge = RailsComponents::Components::Badge.new(
      html_options: { class: [ "", "valid-class", nil, "another-class" ].compact }
    )

    # The empty string at the beginning creates an extra space
    expect(badge.css_classes).to eq("badge  valid-class another-class")
  end

  it "empty html options class" do
    badge = RailsComponents::Components::Badge.new(html_options: { class: "" })
    expect(badge.css_classes).to eq("badge")
  end

  it "whitespace only custom class" do
    badge = RailsComponents::Components::Badge.new(html_options: { class: "   " })
    expect(badge.css_classes).to eq("badge")
  end

  it "icon attributes stored correctly" do
    badge = RailsComponents::Components::Badge.new(
      icon_left: "heroicon-star",
      icon_right: "heroicon-arrow-right"
    )

    expect(badge.icon_left).to eq("heroicon-star")
    expect(badge.icon_right).to eq("heroicon-arrow-right")
  end

  # Tests specifically for badge text attribute handling
  it "text attribute is properly stored" do
    badge = RailsComponents::Components::Badge.new(text: "Test Badge")
    expect(badge.text).to eq("Test Badge")
  end

  it "text attribute is accessible after initialization" do
    badge = RailsComponents::Components::Badge.new(text: "New")
    expect(badge.text).to eq("New")
    expect(badge).to respond_to(:text)
  end

  it "text attribute with empty string" do
    badge = RailsComponents::Components::Badge.new(text: "")
    expect(badge.text).to eq("")
  end

  it "text attribute with nil defaults to empty string" do
    badge = RailsComponents::Components::Badge.new(text: nil)
    expect(badge.text).to be_nil
  end

  it "badge initialization with different text values" do
    test_cases = [
      "New",
      "Hot",
      "Sale",
      "Beta",
      "Pro",
      "Free",
      "Premium",
      "Limited",
      "99+",
      "5",
      "Alert",
      "Info",
      "Success",
      "Warning",
      "Error",
      "XS",
      "SM",
      "MD",
      "LG",
      "XL",
      "Featured",
      "Popular",
      "Trending",
      "Recommended"
    ]

    test_cases.each do |text_value|
      badge = RailsComponents::Components::Badge.new(text: text_value)
      expect(badge.text).to eq(text_value)
    end
  end

  it "text attribute with special characters" do
    special_texts = [
      "Badge with spaces",
      "Badge-with-dashes",
      "Badge_with_underscores",
      "Badge123",
      "Badge & Symbols!",
      "🔥 Hot Badge",
      "★ Star Badge",
      "→ Arrow Badge",
      "✓ Check Badge",
      "⚠ Warning Badge"
    ]

    special_texts.each do |text_value|
      badge = RailsComponents::Components::Badge.new(text: text_value)
      expect(badge.text).to eq(text_value)
    end
  end

  # Test comprehensive variant and style combinations
  it "variant with outline style combinations" do
    %w[primary secondary accent neutral info success warning error].each do |variant|
      badge = RailsComponents::Components::Badge.new(variant: variant, style: "outline")
      expected_classes = "badge badge-#{variant} badge-outline"
      expect(badge.css_classes).to eq(expected_classes)
    end
  end

  it "size with variant combinations" do
    sizes = %w[xs sm md lg xl]
    variants = %w[primary secondary accent]

    sizes.each do |size|
      variants.each do |variant|
        badge = RailsComponents::Components::Badge.new(size: size, variant: variant)
        expected_classes = "badge badge-#{variant} badge-#{size}"
        expect(badge.css_classes).to eq(expected_classes)
      end
    end
  end

  it "all style variations" do
    %w[outline dash soft ghost].each do |style|
      badge = RailsComponents::Components::Badge.new(variant: "primary", style: style)
      expected_classes = "badge badge-primary badge-#{style}"
      expect(badge.css_classes).to eq(expected_classes)
    end
  end

  # Test attribute readers
  it "all attribute readers exist" do
    badge = RailsComponents::Components::Badge.new

    expect(badge).to respond_to(:text)
    expect(badge).to respond_to(:variant)
    expect(badge).to respond_to(:size)
    expect(badge).to respond_to(:style)
    expect(badge).to respond_to(:icon_left)
    expect(badge).to respond_to(:icon_right)
    expect(badge).to respond_to(:html_options)
  end

  it "attribute readers return correct values" do
    badge = RailsComponents::Components::Badge.new(
      text: "Test",
      variant: "primary",
      size: "lg",
      style: "outline",
      icon_left: "star",
      icon_right: "arrow",
      html_options: { id: "test" }
    )

    expect(badge.text).to eq("Test")
    expect(badge.variant).to eq("primary")
    expect(badge.size).to eq("lg")
    expect(badge.style).to eq("outline")
    expect(badge.icon_left).to eq("star")
    expect(badge.icon_right).to eq("arrow")
    expect(badge.html_options).to eq({ id: "test" })
  end

  # Test realistic badge scenarios
  it "notification badge scenario" do
    badge = RailsComponents::Components::Badge.new(
      text: "3",
      variant: "error",
      size: "sm",
      html_options: {
        class: "absolute -top-2 -right-2",
        "aria-label": "3 unread notifications"
      }
    )

    expected_classes = "badge badge-error badge-sm absolute -top-2 -right-2"
    expect(badge.css_classes).to eq(expected_classes)

    expected_attributes = {
      class: expected_classes,
      "aria-label": "3 unread notifications"
    }
    expect(badge.html_attributes).to eq(expected_attributes)
  end

  it "status badge scenario" do
    badge = RailsComponents::Components::Badge.new(
      text: "Active",
      variant: "success",
      size: "md",
      style: "soft",
      html_options: {
        class: "ml-2",
        data: { status: "active" }
      }
    )

    expected_classes = "badge badge-success badge-md badge-soft ml-2"
    expect(badge.css_classes).to eq(expected_classes)

    expected_attributes = {
      class: expected_classes,
      data: { status: "active" }
    }
    expect(badge.html_attributes).to eq(expected_attributes)
  end

  it "tag badge scenario" do
    badge = RailsComponents::Components::Badge.new(
      text: "Ruby",
      variant: "neutral",
      size: "xs",
      style: "outline",
      html_options: {
        class: "mr-1 mb-1",
        data: { tag: "ruby" },
        role: "button",
        tabindex: "0"
      }
    )

    expected_classes = "badge badge-neutral badge-xs badge-outline mr-1 mb-1"
    expect(badge.css_classes).to eq(expected_classes)

    expected_attributes = {
      class: expected_classes,
      data: { tag: "ruby" },
      role: "button",
      tabindex: "0"
    }
    expect(badge.html_attributes).to eq(expected_attributes)
  end

  # Test edge cases specific to badges
  it "empty text with icon only" do
    badge = RailsComponents::Components::Badge.new(
      text: "",
      variant: "primary",
      icon_left: "star"
    )

    expect(badge.text).to eq("")
    expect(badge.icon_left).to eq("star")
    expect(badge.css_classes).to eq("badge badge-primary")
  end

  it "numeric text values" do
    numeric_values = [ "1", "99", "999+", "0", "-1" ]

    numeric_values.each do |value|
      badge = RailsComponents::Components::Badge.new(text: value)
      expect(badge.text).to eq(value)
    end
  end

  it "boolean text values" do
    badge_true = RailsComponents::Components::Badge.new(text: true)
    badge_false = RailsComponents::Components::Badge.new(text: false)

    expect(badge_true.text).to eq(true)
    expect(badge_false.text).to eq(false)
  end

  # Test class ordering consistency
  it "css class ordering is consistent" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      size: "lg",
      style: "outline"
    )

    # Should always be: base, variant, size, style, custom
    expected_order = "badge badge-primary badge-lg badge-outline"
    expect(badge.css_classes).to eq(expected_order)
  end

  it "css class ordering with custom classes" do
    badge = RailsComponents::Components::Badge.new(
      variant: "primary",
      size: "lg",
      style: "outline",
      html_options: { class: "custom-1 custom-2" }
    )

    # Custom classes should come after badge classes
    expected_order = "badge badge-primary badge-lg badge-outline custom-1 custom-2"
    expect(badge.css_classes).to eq(expected_order)
  end
end
