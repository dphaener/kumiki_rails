# Form Date Picker Component Migration Guide

**Component**: Form Date Picker
**DaisyUI Baseline**: [DaisyUI Input](https://daisyui.com/components/input/) (type="date")
**HyperUI Target**: Native Date Input
**Migration Complexity**: Easy
**Last Updated**: 2025-11-19

---

## Overview

The Form Date Picker component renders date selection fields. **STRONG RECOMMENDATION**: Use native `<input type="date">` for best accessibility. Custom date pickers require extremely complex ARIA grid pattern (2-3 weeks effort).

---

## HTML Structure

### Native Date Input (RECOMMENDED)

```html
<div class="form-group">
  <label for="date-input" class="block text-sm font-medium text-gray-700">
    Select date
    <span class="text-red-600" aria-label="required">*</span>
  </label>
  <input
    type="date"
    id="date-input"
    name="date"
    min="2024-01-01"
    max="2024-12-31"
    aria-required="true"
    aria-invalid="false"
    aria-describedby="date-hint date-error"
    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
  />
  <p id="date-hint" class="mt-1 text-sm text-gray-500">
    Format: MM/DD/YYYY. Select a date between Jan 1, 2024 and Dec 31, 2024.
  </p>
  <p id="date-error" class="mt-1 text-sm text-red-600" role="alert" hidden>
    Please select a valid date.
  </p>
</div>
```

---

## Accessibility Requirements

Same as Form Input:
- `id` for label association
- `aria-required="true"` when required
- `aria-invalid="true"` when error
- `aria-describedby` for hint and error

### Benefits of Native Date Input

1. **Browser-native accessibility**: Built-in screen reader support
2. **Built-in keyboard navigation**: Native controls
3. **Localized date formats**: Automatic based on user locale
4. **Mobile-optimized**: Native mobile date pickers
5. **No JavaScript required**: Works without JS

---

## Custom Date Picker (NOT RECOMMENDED)

If custom date picker is absolutely required, see [WAI-ARIA Date Picker Dialog Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/datepicker-dialog/).

**Required Implementation**:
- Full ARIA grid pattern (`role="application"`, `role="grid"`, `role="gridcell"`)
- Extensive keyboard support (Arrow keys, Home, End, Page Up/Down)
- Month/year navigation
- Date range constraints announced
- Minimum **2-3 weeks** development effort

**Recommendation**: Use native `<input type="date">` unless business requirement absolutely demands custom picker.

---

## Migration Guide

### Component Class

```ruby
class FormDatePicker < Kumiki::Component
  option :name
  option :value, default: -> { nil }
  option :label
  option :hint, default: -> { nil }
  option :error, default: -> { nil }
  option :required, default: -> { false }
  option :disabled, default: -> { false }
  option :min, default: -> { nil }
  option :max, default: -> { nil }

  def input_classes
    classes = ["block", "w-full", "rounded-md", "shadow-sm"]
    classes += state_classes
    classes << "p-3 text-sm"
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

  <%= tag.input(
    type: "date",
    id: field_id,
    name: name,
    value: value,
    min: min,
    max: max,
    disabled: disabled,
    required: required,
    class: input_classes,
    **aria_attributes
  ) %>

  <% if hint %>
    <%= tag.p(hint, id: "#{field_id}-hint", class: hint_classes) %>
  <% end %>

  <% if error? %>
    <%= tag.p(error, id: "#{field_id}-error", class: error_classes, role: "alert") %>
  <% end %>
</div>
```

---

## Implementation Checklist

- [ ] Implement date input with native type="date"
- [ ] Add min/max date constraints
- [ ] Add hint text with date format guidance
- [ ] Write unit tests
- [ ] Test native date picker keyboard navigation
- [ ] Test mobile date picker behavior
- [ ] Document decision to use native input

**Status**: Ready for Implementation
**Estimated Effort**: 0.5 days
