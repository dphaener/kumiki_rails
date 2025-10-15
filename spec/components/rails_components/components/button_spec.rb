require "rails_helper"

RSpec.describe RailsComponents::Components::Button, type: :model do
  # Test initialization with default values
  describe "#initialize" do
    context "with default values" do
      let(:button) { described_class.new }

      it "initializes with empty text" do
        expect(button.text).to eq("")
      end

      it "initializes with button type" do
        expect(button.type).to eq("button")
      end

      it "initializes with nil variant" do
        expect(button.variant).to be_nil
      end

      it "initializes with nil size" do
        expect(button.size).to be_nil
      end

      it "initializes with nil style" do
        expect(button.style).to be_nil
      end

      it "initializes with nil shape" do
        expect(button.shape).to be_nil
      end

      it "initializes with nil icon_left" do
        expect(button.icon_left).to be_nil
      end

      it "initializes with nil icon_right" do
        expect(button.icon_right).to be_nil
      end

      it "initializes with loading false" do
        expect(button.loading).to eq(false)
      end

      it "initializes with disabled false" do
        expect(button.disabled).to eq(false)
      end

      it "initializes with active false" do
        expect(button.active).to eq(false)
      end

      it "initializes with empty html_options" do
        expect(button.html_options).to eq({})
      end
    end

    context "with custom values" do
      let(:html_options) { { id: "custom-button", data: { test: "value" } } }
      let(:button) do
        described_class.new(
          text: "Click me",
          type: "submit",
          variant: "primary",
          size: "lg",
          style: "outline",
          shape: "circle",
          icon_left: "star",
          icon_right: "arrow",
          loading: true,
          disabled: true,
          active: true,
          html_options: html_options
        )
      end

      it "sets text correctly" do
        expect(button.text).to eq("Click me")
      end

      it "sets type correctly" do
        expect(button.type).to eq("submit")
      end

      it "sets variant correctly" do
        expect(button.variant).to eq("primary")
      end

      it "sets size correctly" do
        expect(button.size).to eq("lg")
      end

      it "sets style correctly" do
        expect(button.style).to eq("outline")
      end

      it "sets shape correctly" do
        expect(button.shape).to eq("circle")
      end

      it "sets icon_left correctly" do
        expect(button.icon_left).to eq("star")
      end

      it "sets icon_right correctly" do
        expect(button.icon_right).to eq("arrow")
      end

      it "sets loading correctly" do
        expect(button.loading).to eq(true)
      end

      it "sets disabled correctly" do
        expect(button.disabled).to eq(true)
      end

      it "sets active correctly" do
        expect(button.active).to eq(true)
      end

      it "sets html_options correctly" do
        expect(button.html_options).to eq(html_options)
      end
    end
  end

  # Test CSS class generation
  describe "#css_classes" do
    it "generates base btn class by default" do
      button = described_class.new
      expect(button.css_classes).to eq("btn")
    end

    it "includes variant class" do
      button = described_class.new(variant: "primary")
      expect(button.css_classes).to eq("btn btn-primary")
    end

    it "includes size class" do
      button = described_class.new(size: "lg")
      expect(button.css_classes).to eq("btn btn-lg")
    end

    it "includes style class" do
      button = described_class.new(style: "outline")
      expect(button.css_classes).to eq("btn btn-outline")
    end

    it "includes shape class" do
      button = described_class.new(shape: "circle")
      expect(button.css_classes).to eq("btn btn-circle")
    end

    it "includes loading class" do
      button = described_class.new(loading: true)
      expect(button.css_classes).to eq("btn loading")
    end

    it "includes disabled class" do
      button = described_class.new(disabled: true)
      expect(button.css_classes).to eq("btn btn-disabled")
    end

    it "includes active class" do
      button = described_class.new(active: true)
      expect(button.css_classes).to eq("btn btn-active")
    end

    it "combines all options" do
      button = described_class.new(
        variant: "primary",
        size: "lg",
        style: "outline",
        shape: "circle",
        loading: true,
        disabled: true,
        active: true
      )

      expected_classes = "btn btn-primary btn-lg btn-outline btn-circle loading btn-disabled btn-active"
      expect(button.css_classes).to eq(expected_classes)
    end

    context "with custom classes from html_options" do
      it "merges custom class string" do
        button = described_class.new(
          variant: "primary",
          html_options: { class: "custom-class another-class" }
        )

        expect(button.css_classes).to eq("btn btn-primary custom-class another-class")
      end

      it "merges custom class array" do
        button = described_class.new(
          variant: "primary",
          html_options: { class: [ "custom-class", "another-class" ] }
        )

        expect(button.css_classes).to eq("btn btn-primary custom-class another-class")
      end

      it "merges custom class with string key" do
        button = described_class.new(
          variant: "primary",
          html_options: { "class" => "custom-class" }
        )

        expect(button.css_classes).to eq("btn btn-primary custom-class")
      end

      it "works without custom class" do
        button = described_class.new(
          variant: "primary",
          html_options: { id: "test" }
        )

        expect(button.css_classes).to eq("btn btn-primary")
      end
    end
  end

  # Test HTML attributes generation
  describe "#html_attributes" do
    it "generates default attributes" do
      button = described_class.new
      expected = {
        type: "button",
        class: "btn"
      }

      expect(button.html_attributes).to eq(expected)
    end

    it "includes custom type" do
      button = described_class.new(type: "submit")
      expected = {
        type: "submit",
        class: "btn"
      }

      expect(button.html_attributes).to eq(expected)
    end

    it "includes disabled attribute when disabled" do
      button = described_class.new(disabled: true)
      expected = {
        type: "button",
        class: "btn btn-disabled",
        disabled: true
      }

      expect(button.html_attributes).to eq(expected)
    end

    it "includes disabled attribute when loading" do
      button = described_class.new(loading: true)
      expected = {
        type: "button",
        class: "btn loading",
        disabled: true
      }

      expect(button.html_attributes).to eq(expected)
    end

    it "includes disabled attribute when both loading and disabled" do
      button = described_class.new(loading: true, disabled: true)
      expected = {
        type: "button",
        class: "btn loading btn-disabled",
        disabled: true
      }

      expect(button.html_attributes).to eq(expected)
    end

    it "merges html_options" do
      html_options = {
        id: "custom-button",
        data: { test: "value" },
        "data-controller": "button",
        aria: { label: "Custom button" }
      }

      button = described_class.new(
        variant: "primary",
        html_options: html_options
      )

      expected = {
        id: "custom-button",
        data: { test: "value" },
        "data-controller": "button",
        aria: { label: "Custom button" },
        type: "button",
        class: "btn btn-primary"
      }

      expect(button.html_attributes).to eq(expected)
    end

    it "excludes class from html_options (uses css_classes instead)" do
      button = described_class.new(
        variant: "primary",
        html_options: { class: "custom-class", id: "test-button" }
      )

      expected = {
        id: "test-button",
        type: "button",
        class: "btn btn-primary custom-class"
      }

      expect(button.html_attributes).to eq(expected)
    end
  end

  # Test edge cases and parameter combinations
  describe "edge cases" do
    it "does not add classes for nil values" do
      button = described_class.new(
        variant: nil,
        size: nil,
        style: nil,
        shape: nil
      )

      expect(button.css_classes).to eq("btn")
    end

    it "adds empty classes for empty string values" do
      button = described_class.new(
        variant: "",
        size: "",
        style: "",
        shape: ""
      )

      # Empty strings actually generate btn- classes in the current implementation
      expect(button.css_classes).to eq("btn btn- btn- btn- btn-")
    end

    it "does not add classes for false boolean states" do
      button = described_class.new(
        loading: false,
        disabled: false,
        active: false
      )

      expect(button.css_classes).to eq("btn")
    end
  end

  # Test various values
  describe "variant values" do
    %w[primary secondary accent ghost link neutral].each do |variant|
      it "handles #{variant} variant" do
        button = described_class.new(variant: variant)
        expect(button.css_classes).to eq("btn btn-#{variant}")
      end
    end
  end

  describe "size values" do
    %w[xs sm lg].each do |size|
      it "handles #{size} size" do
        button = described_class.new(size: size)
        expect(button.css_classes).to eq("btn btn-#{size}")
      end
    end
  end

  describe "style values" do
    %w[outline glass].each do |style|
      it "handles #{style} style" do
        button = described_class.new(style: style)
        expect(button.css_classes).to eq("btn btn-#{style}")
      end
    end
  end

  describe "shape values" do
    %w[square circle].each do |shape|
      it "handles #{shape} shape" do
        button = described_class.new(shape: shape)
        expect(button.css_classes).to eq("btn btn-#{shape}")
      end
    end
  end

  describe "complex scenarios" do
    it "handles complex combination of attributes" do
      button = described_class.new(
        text: "Complex Button",
        type: "submit",
        variant: "primary",
        size: "lg",
        style: "outline",
        shape: "square",
        icon_left: "plus",
        icon_right: "arrow-right",
        loading: false,
        disabled: false,
        active: true,
        html_options: {
          id: "complex-btn",
          class: "custom-animation hover:scale-105",
          data: { controller: "button", action: "click->button#toggle" },
          "aria-label": "Complex submit button"
        }
      )

      expected_classes = "btn btn-primary btn-lg btn-outline btn-square btn-active custom-animation hover:scale-105"
      expect(button.css_classes).to eq(expected_classes)

      expected_attributes = {
        id: "complex-btn",
        data: { controller: "button", action: "click->button#toggle" },
        "aria-label": "Complex submit button",
        type: "submit",
        class: expected_classes
      }
      expect(button.html_attributes).to eq(expected_attributes)
    end

    it "handles loading overriding active for disabled state" do
      button = described_class.new(loading: true, active: true)

      # Should be disabled due to loading, regardless of active state
      attributes = button.html_attributes
      expect(attributes[:disabled]).to eq(true)
      expect(attributes[:class]).to include("loading")
      expect(attributes[:class]).to include("btn-active")
    end
  end

  # Tests for text attribute handling
  describe "#text attribute" do
    it "stores text properly" do
      button = described_class.new(text: "Test Button")
      expect(button.text).to eq("Test Button")
    end

    it "is accessible after initialization" do
      button = described_class.new(text: "Click Me")
      expect(button.text).to eq("Click Me")
      expect(button).to respond_to(:text)
    end

    it "handles empty string" do
      button = described_class.new(text: "")
      expect(button.text).to eq("")
    end

    it "defaults nil to nil" do
      button = described_class.new(text: nil)
      expect(button.text).to be_nil
    end

    it "handles special characters" do
      special_texts = [
        "Button with spaces",
        "Button-with-dashes",
        "Button_with_underscores",
        "Button123",
        "Button & Symbols!",
        "🚀 Emoji Button",
        "Multi\nLine\nButton"
      ]

      special_texts.each do |text_value|
        button = described_class.new(text: text_value)
        expect(button.text).to eq(text_value)
      end
    end
  end

  # Test icon attributes
  describe "icon attributes" do
    it "stores icon attributes correctly" do
      button = described_class.new(
        icon_left: "heroicon-star",
        icon_right: "heroicon-arrow-right"
      )

      expect(button.icon_left).to eq("heroicon-star")
      expect(button.icon_right).to eq("heroicon-arrow-right")
    end

    it "handles type attribute override from html_options" do
      # The type from html_options should be ignored, constructor type should take precedence
      button = described_class.new(
        type: "submit",
        html_options: { type: "button" }
      )

      attributes = button.html_attributes
      expect(attributes[:type]).to eq("submit")
    end
  end
end
