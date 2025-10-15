require "rails_helper"

RSpec.describe Kumiki::Components::Modal, type: :model do
  # Test initialization with default values
  it "initialize with defaults" do
    modal = Kumiki::Components::Modal.new

    expect(modal.id).not_to be_nil
    assert_match(/^modal-\w+$/, modal.id) # Should generate a unique ID
    expect(modal.html_options).to eq({})
  end

  it "initialize with custom values" do
    html_options = { data: { test: "value" }, aria: { label: "Custom modal" } }
    modal = Kumiki::Components::Modal.new(
      id: "custom-modal",
      html_options: html_options
    )

    expect(modal.id).to eq("custom-modal")
    expect(modal.html_options).to eq(html_options)
  end

  # Test CSS class generation
  it "css classes default" do
    modal = Kumiki::Components::Modal.new
    expected_classes = "modal modal-open"
    expect(modal.css_classes).to eq(expected_classes)
  end

  it "css classes always includes base classes" do
    modal = Kumiki::Components::Modal.new
    base_classes = [ "modal", "modal-open" ]

    base_classes.each do |base_class|
      expect(modal.css_classes).to include(base_class)
    end
  end

  # Test custom class merging from html_options
  it "css classes with custom class string" do
    modal = Kumiki::Components::Modal.new(
      html_options: { class: "custom-class another-class" }
    )

    expect(modal.css_classes).to include("custom-class")
    expect(modal.css_classes).to include("another-class")
    expect(modal.css_classes).to include("modal")
    expect(modal.css_classes).to include("modal-open")
  end

  it "css classes with custom class array" do
    modal = Kumiki::Components::Modal.new(
      html_options: { class: [ "custom-class", "another-class" ] }
    )

    expect(modal.css_classes).to include("custom-class")
    expect(modal.css_classes).to include("another-class")
    expect(modal.css_classes).to include("modal")
    expect(modal.css_classes).to include("modal-open")
  end

  it "css classes with custom class string key" do
    modal = Kumiki::Components::Modal.new(
      html_options: { "class" => "custom-class" }
    )

    expect(modal.css_classes).to include("custom-class")
    expect(modal.css_classes).to include("modal")
    expect(modal.css_classes).to include("modal-open")
  end

  it "css classes without custom class" do
    modal = Kumiki::Components::Modal.new(
      html_options: { id: "test" }
    )

    expect(modal.css_classes).to include("modal")
    expect(modal.css_classes).to include("modal-open")
    expect(modal.css_classes).not_to include("custom")
  end

  # Test HTML attributes generation
  it "html attributes default" do
    modal = Kumiki::Components::Modal.new
    attributes = modal.html_attributes

    expect(attributes[:id]).not_to be_nil
    assert_match(/^modal-\w+$/, attributes[:id])
    expect(attributes[:class]).to include("modal")
    expect(attributes[:class]).to include("modal-open")
    expect(attributes["data-controller"]).to eq("rails-components--dismiss")
    expect(attributes["open"]).to eq(true)
  end

  it "html attributes with custom id" do
    modal = Kumiki::Components::Modal.new(id: "my-modal")
    attributes = modal.html_attributes

    expect(attributes[:id]).to eq("my-modal")
    expect(attributes[:class]).to include("modal")
    expect(attributes[:class]).to include("modal-open")
    expect(attributes["data-controller"]).to eq("rails-components--dismiss")
    expect(attributes["open"]).to eq(true)
  end

  it "html attributes with html options" do
    html_options = {
      id: "custom-modal",
      data: { test: "value", action: "click->modal#close" },
      "data-action" => "click->modal#close",
      aria: { label: "Custom modal dialog" },
      role: "dialog"
    }

    modal = Kumiki::Components::Modal.new(html_options: html_options)
    attributes = modal.html_attributes

    expect(attributes[:id]).to eq("custom-modal")
    expect(attributes[:data]).to eq({ test: "value", action: "click->modal#close" })
    expect(attributes["data-action"]).to eq("click->modal#close")
    expect(attributes[:aria]).to eq({ label: "Custom modal dialog" })
    expect(attributes[:role]).to eq("dialog")
    expect(attributes[:class]).to include("modal")
    expect(attributes[:class]).to include("modal-open")
    expect(attributes["data-controller"]).to eq("rails-components--dismiss")
    expect(attributes["open"]).to eq(true)
  end

  it "html attributes excludes class from html options" do
    modal = Kumiki::Components::Modal.new(
      html_options: { class: "custom-class", id: "test-modal" }
    )

    attributes = modal.html_attributes

    expect(attributes[:id]).to eq("test-modal")
    expect(attributes[:class]).to include("modal")
    expect(attributes[:class]).to include("modal-open")
    expect(attributes[:class]).to include("custom-class")
  end

  it "html attributes excludes string class from html options" do
    modal = Kumiki::Components::Modal.new(
      html_options: { "class" => "custom-class", id: "test-modal" }
    )

    attributes = modal.html_attributes

    expect(attributes[:id]).to eq("test-modal")
    expect(attributes[:class]).to include("modal")
    expect(attributes[:class]).to include("modal-open")
    expect(attributes[:class]).to include("custom-class")
  end

  # Test ID generation and handling
  it "id generation uniqueness" do
    modal1 = Kumiki::Components::Modal.new
    modal2 = Kumiki::Components::Modal.new

    expect(modal1.id).not_to eq(modal2.id)
    assert_match(/^modal-\w+$/, modal1.id)
    assert_match(/^modal-\w+$/, modal2.id)
  end

  it "custom id overrides generated id" do
    modal = Kumiki::Components::Modal.new(id: "specific-modal")
    expect(modal.id).to eq("specific-modal")
  end

  it "id from html options overrides generated id" do
    modal = Kumiki::Components::Modal.new(html_options: { id: "html-options-modal" })
    expect(modal.id).to eq("html-options-modal")
  end

  it "explicit id parameter takes precedence over html options" do
    modal = Kumiki::Components::Modal.new(
      id: "explicit-modal",
      html_options: { id: "html-options-modal" }
    )
    expect(modal.id).to eq("explicit-modal")
  end

  # Test edge cases and parameter combinations
  it "nil values handled gracefully" do
    modal = Kumiki::Components::Modal.new(
      id: nil,
      html_options: nil
    )

    # Should not crash and should handle nil values appropriately
    expect(modal.css_classes).not_to be_nil
    expect(modal.html_attributes).not_to be_nil
    expect(modal.id).not_to be_nil
    assert_match(/^modal-\w+$/, modal.id)
  end

  it "empty string values" do
    modal = Kumiki::Components::Modal.new(
      id: "",
      html_options: {}
    )

    # Empty ID should generate a default ID
    expect(modal.id).not_to eq("")
    assert_match(/^modal-\w+$/, modal.id)
    expect(modal.css_classes).to include("modal")
    expect(modal.css_classes).to include("modal-open")
  end

  it "whitespace only id" do
    modal = Kumiki::Components::Modal.new(id: "   ")

    # Whitespace-only ID should be stripped and generate default if empty
    expect(modal.id).not_to eq("   ")
    assert_match(/^modal-\w+$/, modal.id)
  end

  it "complex combination scenario" do
    modal = Kumiki::Components::Modal.new(
      id: "complex-modal",
      html_options: {
        class: "custom-animation fade-in-up",
        data: {
          action: "click->modal#close keydown.escape->modal#close",
          target: "modal.overlay"
        },
        "aria-live" => "polite",
        "aria-modal" => "true",
        role: "dialog",
        tabindex: "-1"
      }
    )

    # Test CSS classes
    css_classes = modal.css_classes
    expect(css_classes).to include("modal")
    expect(css_classes).to include("modal-open")
    expect(css_classes).to include("custom-animation")
    expect(css_classes).to include("fade-in-up")

    # Test HTML attributes
    attributes = modal.html_attributes
    expect(attributes[:id]).to eq("complex-modal")
    expect(attributes["aria-live"]).to eq("polite")
    expect(attributes["aria-modal"]).to eq("true")
    expect(attributes[:role]).to eq("dialog")
    expect(attributes[:tabindex]).to eq("-1")
    expect(attributes[:data]).to eq({
      action: "click->modal#close keydown.escape->modal#close",
      target: "modal.overlay"
    })
    expect(attributes["data-controller"]).to eq("rails-components--dismiss")
    expect(attributes["open"]).to eq(true)

    # Test ID
    expect(modal.id).to eq("complex-modal")
  end

  it "custom class array with mixed content" do
    modal = Kumiki::Components::Modal.new(
      html_options: { class: [ "", "valid-class", nil, "another-class" ].compact }
    )

    css_classes = modal.css_classes
    expect(css_classes).to include("valid-class")
    expect(css_classes).to include("another-class")
    expect(css_classes).to include("modal")
    expect(css_classes).to include("modal-open")
  end

  it "empty html options class" do
    modal = Kumiki::Components::Modal.new(html_options: { class: "" })
    expect(modal.css_classes).to include("modal")
    expect(modal.css_classes).to include("modal-open")
  end

  it "whitespace only custom class" do
    modal = Kumiki::Components::Modal.new(html_options: { class: "   " })
    # Should still include base classes
    expect(modal.css_classes).to include("modal")
    expect(modal.css_classes).to include("modal-open")
  end

  # Test CSS class order
  it "css classes order is consistent" do
    modal = Kumiki::Components::Modal.new
    classes = modal.css_classes.split(" ")

    # Check that base classes come in expected order
    expect(classes[0]).to eq("modal")
    expect(classes[1]).to eq("modal-open")
  end

  it "css classes order with custom classes" do
    modal = Kumiki::Components::Modal.new(
      html_options: { class: "custom-class another-class" }
    )
    classes = modal.css_classes.split(" ")

    # Base classes should come first
    expect(classes[0]).to eq("modal")
    expect(classes[1]).to eq("modal-open")
    # Custom classes should follow
    expect(classes).to include("custom-class")
    expect(classes).to include("another-class")
  end

  # Test HTML attribute exclusion and merging
  it "html attributes excludes class but merges others" do
    modal = Kumiki::Components::Modal.new(
      html_options: {
        class: "should-be-merged",
        id: "test-id",
        "data-test" => "value"
      }
    )

    attributes = modal.html_attributes
    expect(attributes[:id]).to eq("test-id")
    expect(attributes["data-test"]).to eq("value")
    expect(attributes[:class]).to include("should-be-merged")
    expect(attributes[:class]).to include("modal")
    expect(attributes[:class]).to include("modal-open")
  end

  # Test that modal is stateless (always open when rendered)
  it "modal is always open when rendered" do
    modal = Kumiki::Components::Modal.new
    expect(modal.css_classes).to include("modal-open")
    expect(modal.html_attributes["open"]).to eq(true)
  end

  it "modal stateless nature" do
    # Modal should not have state management methods
    modal = Kumiki::Components::Modal.new

    # Should not respond to state-related methods
    expect(modal).not_to respond_to(:open?)
    expect(modal).not_to respond_to(:closed?)
    expect(modal).not_to respond_to(:toggle)
    expect(modal).not_to respond_to(:open)
    expect(modal).not_to respond_to(:close)
  end

  # Test different ID formats
  it "various id formats" do
    test_ids = [
      "simple-modal",
      "modal_with_underscores",
      "modal123",
      "modal-with-numbers-456",
      "MODAL_UPPERCASE",
      "modalCamelCase"
    ]

    test_ids.each do |id|
      modal = Kumiki::Components::Modal.new(id: id)
      expect(modal.id).to eq(id)
      attributes = modal.html_attributes
      expect(attributes[:id]).to eq(id)
    end
  end

  # Test accessibility attributes
  it "modal works with accessibility attributes" do
    modal = Kumiki::Components::Modal.new(
      html_options: {
        "aria-labelledby" => "modal-title",
        "aria-describedby" => "modal-description",
        "aria-modal" => "true",
        role: "dialog"
      }
    )

    attributes = modal.html_attributes
    expect(attributes["aria-labelledby"]).to eq("modal-title")
    expect(attributes["aria-describedby"]).to eq("modal-description")
    expect(attributes["aria-modal"]).to eq("true")
    expect(attributes[:role]).to eq("dialog")
  end

  # Test data attributes for JavaScript integration with rails-components-- prefix
  it "modal uses rails-components--dismiss Stimulus controller" do
    modal = Kumiki::Components::Modal.new

    attributes = modal.html_attributes
    expect(attributes["data-controller"]).to eq("rails-components--dismiss")
  end

  it "modal works with additional Stimulus data attributes" do
    modal = Kumiki::Components::Modal.new(
      html_options: {
        data: {
          action: "click->modal#close keydown.escape@window->modal#close",
          "modal-target" => "overlay",
          "modal-backdrop-value" => "static"
        }
      }
    )

    attributes = modal.html_attributes
    expected_data = {
      action: "click->modal#close keydown.escape@window->modal#close",
      "modal-target" => "overlay",
      "modal-backdrop-value" => "static"
    }
    expect(attributes[:data]).to eq(expected_data)
    expect(attributes["data-controller"]).to eq("rails-components--dismiss")
  end

  # Test that component can be initialized multiple times with consistent behavior
  it "multiple modal instances are independent" do
    modal1 = Kumiki::Components::Modal.new(id: "modal-1")
    modal2 = Kumiki::Components::Modal.new(id: "modal-2")
    modal3 = Kumiki::Components::Modal.new # Auto-generated ID

    expect(modal1.id).to eq("modal-1")
    expect(modal2.id).to eq("modal-2")
    expect(modal1.id).not_to eq(modal2.id)
    expect(modal1.id).not_to eq(modal3.id)
    expect(modal2.id).not_to eq(modal3.id)

    # All should have same CSS classes
    [ modal1, modal2, modal3 ].each do |modal|
      expect(modal.css_classes).to include("modal")
      expect(modal.css_classes).to include("modal-open")
    end
  end

  # Test symbol handling
  it "id with symbol input" do
    modal = Kumiki::Components::Modal.new(id: :symbol_modal)
    expect(modal.id).to eq("symbol_modal")
  end

  # Test that the component is ready for DaisyUI dialog integration
  it "modal ready for dialog element" do
    modal = Kumiki::Components::Modal.new(
      html_options: {
        "data-dialog" => "true"
      }
    )

    attributes = modal.html_attributes
    expect(attributes["open"]).to eq(true)
    expect(attributes["data-dialog"]).to eq("true")
    expect(attributes[:class]).to include("modal")
    expect(attributes[:class]).to include("modal-open")
  end

  # Test comprehensive real-world scenarios
  it "real world confirmation modal" do
    modal = Kumiki::Components::Modal.new(
      id: "confirmation-modal",
      html_options: {
        class: "modal-backdrop-blur",
        role: "dialog",
        "aria-modal" => "true",
        "aria-labelledby" => "confirmation-title",
        data: {
          action: "click@window->modal#clickOutside keydown.escape@window->modal#escape"
        }
      }
    )

    css_classes = modal.css_classes
    expect(css_classes).to include("modal")
    expect(css_classes).to include("modal-open")
    expect(css_classes).to include("modal-backdrop-blur")

    attributes = modal.html_attributes
    expect(attributes[:id]).to eq("confirmation-modal")
    expect(attributes[:role]).to eq("dialog")
    expect(attributes["aria-modal"]).to eq("true")
    expect(attributes["aria-labelledby"]).to eq("confirmation-title")
    expect(attributes["data-controller"]).to eq("rails-components--dismiss")
  end

  it "real world form modal" do
    modal = Kumiki::Components::Modal.new(
      id: "user-form-modal",
      html_options: {
        class: "modal-form",
        data: {
          action: "submit->form#submit",
          "modal-target" => "container",
          "form-target" => "modal"
        },
        "aria-live" => "polite"
      }
    )

    css_classes = modal.css_classes
    expect(css_classes).to include("modal")
    expect(css_classes).to include("modal-open")
    expect(css_classes).to include("modal-form")

    attributes = modal.html_attributes
    expect(attributes[:id]).to eq("user-form-modal")
    expect(attributes["aria-live"]).to eq("polite")
    expect(attributes[:data]).to eq({
      action: "submit->form#submit",
      "modal-target" => "container",
      "form-target" => "modal"
    })
    expect(attributes["data-controller"]).to eq("rails-components--dismiss")
  end
end
