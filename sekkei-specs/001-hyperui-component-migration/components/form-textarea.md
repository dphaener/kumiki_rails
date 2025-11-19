# Form Textarea Component Migration Guide

**Component**: Form Textarea
**DaisyUI Baseline**: [DaisyUI Textarea](https://daisyui.com/components/textarea/)
**HyperUI Target**: Native Textarea with Tailwind Forms
**Migration Complexity**: Easy
**Last Updated**: 2025-11-19

---

## Overview

The Form Textarea component renders multi-line text input fields. Identical accessibility patterns to Form Input with additional row height control.

---

## Variant Analysis

### DaisyUI Variants

```html
<textarea class="textarea textarea-bordered"></textarea>
<textarea class="textarea textarea-sm">Small</textarea>
<textarea class="textarea textarea-lg">Large</textarea>
```

### HyperUI Target

```html
<textarea
  rows="5"
  class="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
></textarea>
```

---

## HTML Structure

```html
<div class="form-group">
  <label for="message" class="block text-sm font-medium text-gray-700">
    Message
    <span class="text-red-600" aria-label="required">*</span>
  </label>
  <textarea
    id="message"
    name="message"
    rows="5"
    maxlength="500"
    aria-required="true"
    aria-invalid="false"
    aria-describedby="message-hint message-error"
    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
  ></textarea>
  <p id="message-hint" class="mt-1 text-sm text-gray-500">
    Maximum 500 characters.
    <span aria-live="polite">Characters remaining: <span id="char-count">500</span></span>
  </p>
  <p id="message-error" class="mt-1 text-sm text-red-600" role="alert" hidden>
    Message must be at least 10 characters.
  </p>
</div>
```

---

## Accessibility Requirements

Same as Form Input, plus:

### Character Counter (Optional Enhancement)

```javascript
// app/javascript/controllers/character_counter_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["textarea", "count"]
  static values = { max: Number }

  connect() {
    this.update()
  }

  update() {
    const remaining = this.maxValue - this.textareaTarget.value.length
    this.countTarget.textContent = remaining

    // Warn when low
    if (remaining < 50) {
      this.countTarget.parentElement.setAttribute('role', 'status')
      this.countTarget.parentElement.setAttribute('aria-live', 'polite')
    }
  }
}
```

---

## Migration Guide

### Component Class

```ruby
class FormTextarea < Kumiki::Component
  option :name
  option :value, default: -> { nil }
  option :placeholder, default: -> { nil }
  option :label
  option :hint, default: -> { nil }
  option :error, default: -> { nil }
  option :required, default: -> { false }
  option :disabled, default: -> { false }
  option :size, default: -> { :md }
  option :rows, default: -> { 5 }
  option :maxlength, default: -> { nil }
  option :character_counter, default: -> { false }

  def textarea_classes
    classes = ["block", "w-full", "rounded-md", "shadow-sm"]
    classes += state_classes
    classes << size_class
    classes.join(" ")
  end

  def label_classes
    "block text-sm font-medium text-gray-700"
  end

  def hint_classes
    "mt-1 text-sm text-gray-500"
  end

  def error_classes
    "mt-1 text-sm text-red-600"
  end

  def field_id
    @field_id ||= "#{name}-#{SecureRandom.hex(4)}"
  end

  def error?
    error.present?
  end

  def aria_attributes
    attrs = {}
    attrs[:"aria-required"] = "true" if required
    attrs[:"aria-invalid"] = "true" if error?

    describedby = []
    describedby << "#{field_id}-hint" if hint
    describedby << "#{field_id}-error" if error?
    attrs[:"aria-describedby"] = describedby.join(" ") if describedby.any?

    attrs
  end

  private

  def state_classes
    if error?
      ["border-red-600", "focus:border-red-500", "focus:ring-red-500"]
    elsif disabled
      ["border-gray-300", "bg-gray-100", "text-gray-400", "cursor-not-allowed"]
    else
      ["border-gray-300", "focus:border-blue-500", "focus:ring-blue-500"]
    end
  end

  def size_class
    {
      sm: "p-2 text-sm",
      md: "p-3 text-sm",
      lg: "p-4 text-base"
    }[size] || "p-3 text-sm"
  end
end
```

### Template

```erb
<div class="form-group">
  <%= tag.label(for: field_id, class: label_classes) do %>
    <%= label %>
    <% if required %>
      <%= tag.span("*", class: "text-red-600", "aria-label": "required") %>
    <% end %>
  <% end %>

  <%= tag.textarea(
    value,
    id: field_id,
    name: name,
    placeholder: placeholder,
    rows: rows,
    maxlength: maxlength,
    disabled: disabled,
    required: required,
    class: textarea_classes,
    data: character_counter ? {
      controller: "character-counter",
      character_counter_target: "textarea",
      character_counter_max_value: maxlength,
      action: "input->character-counter#update"
    } : {},
    **aria_attributes
  ) %>

  <% if hint %>
    <%= tag.p(id: "#{field_id}-hint", class: hint_classes) do %>
      <%= hint %>
      <% if character_counter && maxlength %>
        <%= tag.span("aria-live": "polite") do %>
          Characters remaining: <%= tag.span(maxlength, id: "char-count", data: { character_counter_target: "count" }) %>
        <% end %>
      <% end %>
    <% end %>
  <% end %>

  <% if error? %>
    <%= tag.p(error, id: "#{field_id}-error", class: error_classes, role: "alert") %>
  <% end %>
</div>
```

---

## Implementation Checklist

- [ ] Implement textarea_classes
- [ ] Add rows and maxlength support
- [ ] Add character counter Stimulus controller
- [ ] Write unit tests
- [ ] Test keyboard navigation
- [ ] Screen reader testing for character counter

**Status**: Ready for Implementation
**Estimated Effort**: 1 day
