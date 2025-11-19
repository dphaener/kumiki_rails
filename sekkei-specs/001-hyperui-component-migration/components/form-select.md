# Form Select Component Migration Guide

**Component**: Form Select
**DaisyUI Baseline**: [DaisyUI Select](https://daisyui.com/components/select/)
**HyperUI Target**: Native Select with Tailwind Forms
**Migration Complexity**: Easy
**Last Updated**: 2025-11-19

---

## Overview

The Form Select component renders dropdown selection fields. Current implementation has strong accessibility with native `<select>` element. Migration maintains native HTML semantics with utility styling.

**Key Recommendation**: Use native `<select>` element. Avoid custom dropdowns unless absolutely necessary due to complex ARIA combobox pattern requirements.

---

## Variant Analysis

### DaisyUI Variants

```html
<select class="select select-bordered">
  <option>Option 1</option>
</select>

<select class="select select-sm">Small</select>
<select class="select select-md">Medium</select>
<select class="select select-lg">Large</select>
```

### HyperUI Target

```html
<select class="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">
  <option value="">Select an option</option>
  <option value="1">Option 1</option>
  <option value="2">Option 2</option>
</select>
```

---

## HTML Structure

### HyperUI Pattern

```html
<div class="form-group">
  <label for="country" class="block text-sm font-medium text-gray-700">
    Country
    <span class="text-red-600" aria-label="required">*</span>
  </label>
  <select
    id="country"
    name="country"
    aria-required="true"
    aria-invalid="false"
    aria-describedby="country-error"
    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
  >
    <option value="">Select a country</option>
    <option value="us">United States</option>
    <option value="ca">Canada</option>
  </select>
  <p id="country-error" class="mt-1 text-sm text-red-600" role="alert" hidden>
    Please select a country.
  </p>
</div>
```

---

## Accessibility Requirements

### ARIA Attributes

Same as Form Input:
- `id` for label association
- `aria-required="true"` when required
- `aria-invalid="true"` when error
- `aria-describedby` links to error messages

### Keyboard Navigation (Native)

- **Tab**: Focus select
- **Space**: Open dropdown
- **Arrow Up/Down**: Navigate options
- **Enter**: Select option
- **Escape**: Close dropdown

---

## Migration Guide

### Component Class

```ruby
class FormSelect < Kumiki::Component
  option :name
  option :options  # Array of [label, value] pairs
  option :selected, default: -> { nil }
  option :label
  option :error, default: -> { nil }
  option :required, default: -> { false }
  option :disabled, default: -> { false }
  option :size, default: -> { :md }
  option :include_blank, default: -> { nil }

  def select_classes
    classes = ["block", "w-full", "rounded-md", "shadow-sm"]
    classes += state_classes
    classes << size_class
    classes.join(" ")
  end

  def label_classes
    "block text-sm font-medium text-gray-700"
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
    attrs[:"aria-describedby"] = "#{field_id}-error" if error?
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

  <%= tag.select(
    id: field_id,
    name: name,
    disabled: disabled,
    required: required,
    class: select_classes,
    **aria_attributes
  ) do %>
    <% if include_blank %>
      <%= tag.option(include_blank, value: "") %>
    <% end %>

    <% options.each do |label, value| %>
      <%= tag.option(label, value: value, selected: value == selected) %>
    <% end %>
  <% end %>

  <% if error? %>
    <%= tag.p(error, id: "#{field_id}-error", class: error_classes, role: "alert") %>
  <% end %>
</div>
```

---

## Implementation Checklist

- [ ] Implement select_classes with state logic
- [ ] Implement options rendering
- [ ] Add include_blank support
- [ ] Add selected value handling
- [ ] Write unit tests
- [ ] Test keyboard navigation
- [ ] Screen reader testing

**Status**: Ready for Implementation
**Estimated Effort**: 0.5 days
