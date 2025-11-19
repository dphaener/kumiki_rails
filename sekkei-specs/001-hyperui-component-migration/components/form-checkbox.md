# Form Checkbox Component Migration Guide

**Component**: Form Checkbox
**DaisyUI Baseline**: [DaisyUI Checkbox](https://daisyui.com/components/checkbox/)
**HyperUI Target**: Native Checkbox with Tailwind Forms
**Migration Complexity**: Easy
**Last Updated**: 2025-11-19

---

## Overview

The Form Checkbox component renders checkbox inputs for boolean or multi-select values. Current implementation has good accessibility. Migration adds fieldset/legend pattern for checkbox groups per WCAG 1.3.1.

---

## Variant Analysis

### DaisyUI Variants

```html
<input type="checkbox" class="checkbox">
<input type="checkbox" class="checkbox checkbox-primary">
<input type="checkbox" class="checkbox checkbox-sm">
<input type="checkbox" class="checkbox checkbox-lg">
```

### HyperUI Target

```html
<!-- Single Checkbox -->
<div class="checkbox-wrapper">
  <input
    type="checkbox"
    id="terms"
    name="terms"
    class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
  />
  <label for="terms" class="ml-2 text-sm text-gray-700">
    I agree to the terms and conditions
  </label>
</div>

<!-- Checkbox Group -->
<fieldset class="form-fieldset">
  <legend class="text-sm font-medium text-gray-700">
    Select your interests
    <span class="text-red-600" aria-label="required">*</span>
  </legend>
  <div class="mt-3 space-y-2">
    <div class="flex items-center gap-3">
      <input type="checkbox" id="interest-tech" name="interests[]" value="tech" class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
      <label for="interest-tech" class="text-sm text-gray-700">Technology</label>
    </div>
    <div class="flex items-center gap-3">
      <input type="checkbox" id="interest-sports" name="interests[]" value="sports" class="h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
      <label for="interest-sports" class="text-sm text-gray-700">Sports</label>
    </div>
  </div>
  <p id="interests-error" class="mt-2 text-sm text-red-600" role="alert" hidden>
    Please select at least one interest.
  </p>
</fieldset>
```

---

## Accessibility Requirements

### Single Checkbox

- `id` on checkbox
- Explicit `<label for="">` association
- `aria-required="true"` when required
- `aria-invalid="true"` when error
- `aria-describedby` for error messages

### Checkbox Group (CRITICAL)

**WCAG 1.3.1 Requirement**: Groups MUST use `<fieldset>` + `<legend>`

```html
<fieldset class="form-fieldset">
  <legend class="text-sm font-medium text-gray-700">Group Label</legend>
  <div class="mt-3 space-y-2">
    <!-- Checkboxes -->
  </div>
</fieldset>
```

### Keyboard Navigation (Native)

- **Tab**: Focus checkbox
- **Space**: Toggle checked state
- **Shift+Tab**: Previous element

---

## Migration Guide

### Component Class

```ruby
class FormCheckbox < Kumiki::Component
  option :name
  option :value, default: -> { nil }
  option :checked, default: -> { false }
  option :label
  option :error, default: -> { nil }
  option :required, default: -> { false }
  option :disabled, default: -> { false }

  def checkbox_classes
    "h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
  end

  def wrapper_classes
    "flex items-center gap-3"
  end

  def label_classes
    "text-sm text-gray-700"
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
end
```

### Template (Single Checkbox)

```erb
<div class="<%= wrapper_classes %>">
  <%= tag.input(
    type: "checkbox",
    id: field_id,
    name: name,
    value: value,
    checked: checked,
    disabled: disabled,
    required: required,
    class: checkbox_classes,
    **aria_attributes
  ) %>

  <%= tag.label(for: field_id, class: label_classes) do %>
    <%= label %>
    <% if required %>
      <%= tag.span("*", class: "text-red-600", "aria-label": "required") %>
    <% end %>
  <% end %>
</div>

<% if error? %>
  <%= tag.p(error, id: "#{field_id}-error", class: error_classes, role: "alert") %>
<% end %>
```

### Template (Checkbox Group)

```ruby
class FormCheckboxGroup < Kumiki::Component
  option :name
  option :legend
  option :options  # Array of [label, value, checked] tuples
  option :error, default: -> { nil }
  option :required, default: -> { false }

  def fieldset_classes
    "form-fieldset"
  end

  def legend_classes
    "text-sm font-medium text-gray-700"
  end

  def group_classes
    "mt-3 space-y-2"
  end

  def error_classes
    "mt-2 text-sm text-red-600"
  end

  def error?
    error.present?
  end
end
```

```erb
<fieldset class="<%= fieldset_classes %>">
  <%= tag.legend(class: legend_classes) do %>
    <%= legend %>
    <% if required %>
      <%= tag.span("*", class: "text-red-600", "aria-label": "required") %>
    <% end %>
  <% end %>

  <div class="<%= group_classes %>">
    <% options.each do |label, value, checked| %>
      <div class="flex items-center gap-3">
        <%= tag.input(
          type: "checkbox",
          id: "#{name}-#{value}",
          name: "#{name}[]",
          value: value,
          checked: checked,
          aria: { describedby: error? ? "#{name}-error" : nil },
          class: "h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
        ) %>

        <%= tag.label(label, for: "#{name}-#{value}", class: "text-sm text-gray-700") %>
      </div>
    <% end %>
  </div>

  <% if error? %>
    <%= tag.p(error, id: "#{name}-error", class: error_classes, role: "alert") %>
  <% end %>
</fieldset>
```

---

## Implementation Checklist

- [ ] Implement single checkbox component
- [ ] Implement checkbox group component with fieldset
- [ ] Add checkbox_classes method
- [ ] Add aria_attributes method
- [ ] Write unit tests for single checkbox
- [ ] Write unit tests for checkbox group
- [ ] Test fieldset/legend screen reader announcement
- [ ] Test keyboard navigation

**Status**: Ready for Implementation
**Estimated Effort**: 1 day
