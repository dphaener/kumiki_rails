# Form Radio Component Migration Guide

**Component**: Form Radio
**DaisyUI Baseline**: [DaisyUI Radio](https://daisyui.com/components/radio/)
**HyperUI Target**: Native Radio with Tailwind Forms
**Migration Complexity**: Easy
**Last Updated**: 2025-11-19

---

## Overview

The Form Radio component renders radio button inputs for single-select choices. **Critical Requirement**: Radio buttons MUST be wrapped in `<fieldset>` with `<legend>` per WCAG 1.3.1.

---

## HTML Structure

### HyperUI Pattern (REQUIRED)

```html
<fieldset class="form-fieldset">
  <legend class="text-sm font-medium text-gray-700">
    Choose a shipping method
    <span class="text-red-600" aria-label="required">*</span>
  </legend>

  <div class="mt-3 space-y-2" role="radiogroup" aria-required="true">
    <div class="flex items-center gap-3">
      <input
        type="radio"
        id="shipping-standard"
        name="shipping"
        value="standard"
        aria-describedby="shipping-error"
        class="h-4 w-4 border-gray-300 text-blue-600 focus:ring-blue-500"
      />
      <label for="shipping-standard" class="text-sm text-gray-700">
        <span class="font-medium">Standard Shipping</span>
        <span class="text-gray-500">(5-7 business days)</span>
      </label>
    </div>

    <div class="flex items-center gap-3">
      <input
        type="radio"
        id="shipping-express"
        name="shipping"
        value="express"
        aria-describedby="shipping-error"
        class="h-4 w-4 border-gray-300 text-blue-600 focus:ring-blue-500"
      />
      <label for="shipping-express" class="text-sm text-gray-700">
        <span class="font-medium">Express Shipping</span>
        <span class="text-gray-500">(2-3 business days)</span>
      </label>
    </div>
  </div>

  <p id="shipping-error" class="mt-2 text-sm text-red-600" role="alert" hidden>
    Please select a shipping method.
  </p>
</fieldset>
```

---

## Accessibility Requirements

### CRITICAL: Fieldset + Legend Required

**WCAG 1.3.1 Info and Relationships**: Radio groups MUST use `<fieldset>` + `<legend>`.

### ARIA Attributes

- `role="radiogroup"` on container (optional, fieldset implies)
- `aria-required="true"` on group
- `aria-describedby="[error-id]"` on each radio (shared error)
- `aria-invalid="true"` on first radio when group has error

### Keyboard Navigation (Native)

- **Tab**: Focus group (focuses checked radio or first if none checked)
- **Arrow Up/Down**: Select previous/next radio (automatically checks)
- **Arrow Left/Right**: Select previous/next radio
- **Space**: Check focused radio

**Note**: Tab does NOT move between radios in a group. Arrow keys select next/previous.

---

## Migration Guide

### Component Class

```ruby
class FormRadioGroup < Kumiki::Component
  option :name
  option :legend
  option :options  # Array of [label, value, description] tuples
  option :selected, default: -> { nil }
  option :error, default: -> { nil }
  option :required, default: -> { false }
  option :disabled, default: -> { false }

  def fieldset_classes
    "form-fieldset"
  end

  def legend_classes
    "text-sm font-medium text-gray-700"
  end

  def radiogroup_classes
    "mt-3 space-y-2"
  end

  def radio_classes
    "h-4 w-4 border-gray-300 text-blue-600 focus:ring-blue-500"
  end

  def label_classes
    "text-sm text-gray-700"
  end

  def error_classes
    "mt-2 text-sm text-red-600"
  end

  def error?
    error.present?
  end

  def radio_id(value)
    "#{name}-#{value}"
  end

  def radio_aria_attributes
    attrs = {}
    attrs[:"aria-describedby"] = "#{name}-error" if error?
    attrs
  end

  def radiogroup_aria_attributes
    attrs = {}
    attrs[:"aria-required"] = "true" if required
    attrs
  end
end
```

### Template

```erb
<fieldset class="<%= fieldset_classes %>">
  <%= tag.legend(class: legend_classes) do %>
    <%= legend %>
    <% if required %>
      <%= tag.span("*", class: "text-red-600", "aria-label": "required") %>
    <% end %>
  <% end %>

  <%= tag.div(
    class: radiogroup_classes,
    role: "radiogroup",
    **radiogroup_aria_attributes
  ) do %>
    <% options.each do |label, value, description| %>
      <div class="flex items-center gap-3">
        <%= tag.input(
          type: "radio",
          id: radio_id(value),
          name: name,
          value: value,
          checked: value == selected,
          disabled: disabled,
          class: radio_classes,
          **radio_aria_attributes
        ) %>

        <%= tag.label(for: radio_id(value), class: label_classes) do %>
          <%= tag.span(label, class: "font-medium") %>
          <% if description %>
            <%= tag.span(description, class: "text-gray-500") %>
          <% end %>
        <% end %>
      </div>
    <% end %>
  <% end %>

  <% if error? %>
    <%= tag.p(error, id: "#{name}-error", class: error_classes, role: "alert") %>
  <% end %>
</fieldset>
```

---

## Implementation Checklist

- [ ] Implement radio group with fieldset/legend
- [ ] Add radiogroup_classes method
- [ ] Add radio_classes method
- [ ] Add aria_attributes methods
- [ ] Support optional description per radio
- [ ] Write unit tests
- [ ] Test Arrow key navigation
- [ ] Test screen reader fieldset announcement

**Status**: Ready for Implementation
**Estimated Effort**: 1 day
