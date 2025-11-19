# Form Error Component Migration Guide

**Component**: Form Error
**DaisyUI Baseline**: Inline error messages in form components
**HyperUI Target**: Standalone error component with ARIA live regions
**Migration Complexity**: Easy
**Last Updated**: 2025-11-19

---

## Overview

The Form Error component renders accessible error messages for form fields. **Critical Requirement**: Errors MUST have `role="alert"` or `aria-live` to announce changes to screen readers (WCAG 4.1.3 Status Messages).

---

## HTML Structure

### Inline Error Pattern

```html
<p
  id="field-name-error"
  class="mt-1 text-sm text-red-600"
  role="alert"
  aria-live="polite"
  aria-atomic="true"
>
  <svg aria-hidden="true" focusable="false" class="inline h-4 w-4 text-red-600">
    <!-- Error icon -->
  </svg>
  <span>This field is required.</span>
</p>
```

### Form Error Summary (Top of Form)

```html
<div
  role="alert"
  aria-live="assertive"
  aria-atomic="true"
  class="rounded-md border-l-4 border-red-600 bg-red-50 p-4"
>
  <div class="flex items-start">
    <svg class="h-5 w-5 text-red-600" aria-hidden="true" focusable="false">
      <!-- Error icon -->
    </svg>
    <div class="ml-3">
      <h3 class="text-sm font-medium text-red-800">
        There were 3 errors with your submission
      </h3>
      <ul class="mt-2 list-disc space-y-1 pl-5 text-sm text-red-700">
        <li><a href="#email" class="underline hover:text-red-900">Email is required</a></li>
        <li><a href="#password" class="underline hover:text-red-900">Password must be at least 8 characters</a></li>
        <li><a href="#terms" class="underline hover:text-red-900">You must accept the terms</a></li>
      </ul>
    </div>
  </div>
</div>
```

---

## Accessibility Requirements

### CRITICAL: Error Announcement

**WCAG 4.1.3 Status Messages**: Errors MUST be announced to screen readers.

**Options**:
1. `role="alert"` - Implicit `aria-live="assertive"`
2. `aria-live="assertive"` - Critical errors (interrupts)
3. `aria-live="polite"` - Less critical (waits for pause)

### ARIA Attributes

```ruby
def error_aria_attributes
  {
    id: error_id,
    role: "alert",
    "aria-live": aria_live_level,
    "aria-atomic": "true"
  }
end

def aria_live_level
  critical? ? "assertive" : "polite"
end
```

### Visual Requirements

- Error icon MUST have `aria-hidden="true"` and `focusable="false"`
- Error text MUST have 4.5:1 contrast ratio
- Error state indicated by more than just color (icon, border, text)

---

## Migration Guide

### Component Class

```ruby
class FormError < Kumiki::Component
  option :field_id
  option :message
  option :critical, default: -> { false }
  option :icon, default: -> { true }

  def error_classes
    "mt-1 text-sm text-red-600"
  end

  def error_id
    "#{field_id}-error"
  end

  def aria_attributes
    {
      id: error_id,
      role: "alert",
      "aria-live": aria_live_level,
      "aria-atomic": "true"
    }
  end

  def aria_live_level
    critical ? "assertive" : "polite"
  end

  def icon_classes
    "inline h-4 w-4 text-red-600 mr-1"
  end
end
```

### Template (Inline Error)

```erb
<%= tag.p(class: error_classes, **aria_attributes) do %>
  <% if icon %>
    <svg aria-hidden="true" focusable="false" class="<%= icon_classes %>" fill="currentColor" viewBox="0 0 20 20">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
    </svg>
  <% end %>
  <%= tag.span(message) %>
<% end %>
```

### Error Summary Component

```ruby
class FormErrorSummary < Kumiki::Component
  option :errors  # Hash of { field_id => error_message }

  def summary_classes
    "rounded-md border-l-4 border-red-600 bg-red-50 p-4"
  end

  def aria_attributes
    {
      role: "alert",
      "aria-live": "assertive",
      "aria-atomic": "true"
    }
  end

  def error_count
    errors.size
  end

  def error_count_text
    "There #{error_count == 1 ? 'was' : 'were'} #{error_count} #{error_count == 1 ? 'error' : 'errors'} with your submission"
  end
end
```

### Template (Error Summary)

```erb
<%= tag.div(class: summary_classes, **aria_attributes) do %>
  <div class="flex items-start">
    <svg class="h-5 w-5 text-red-600" aria-hidden="true" focusable="false" fill="currentColor" viewBox="0 0 20 20">
      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
    </svg>

    <div class="ml-3">
      <h3 class="text-sm font-medium text-red-800">
        <%= error_count_text %>
      </h3>

      <ul class="mt-2 list-disc space-y-1 pl-5 text-sm text-red-700">
        <% errors.each do |field_id, message| %>
          <li>
            <%= tag.a(
              message,
              href: "##{field_id}",
              class: "underline hover:text-red-900"
            ) %>
          </li>
        <% end %>
      </ul>
    </div>
  </div>
<% end %>
```

---

## JavaScript Requirements (Optional)

### Focus First Invalid Field

```javascript
// app/javascript/controllers/form_validation_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleSubmit(event) {
    const firstInvalidField = this.element.querySelector('[aria-invalid="true"]')

    if (firstInvalidField) {
      event.preventDefault()
      firstInvalidField.focus()
      firstInvalidField.scrollIntoView({ behavior: 'smooth', block: 'center' })
    }
  }
}
```

---

## Implementation Checklist

- [ ] Implement FormError component with role="alert"
- [ ] Implement FormErrorSummary component
- [ ] Add aria_live_level method (assertive vs polite)
- [ ] Add icon with aria-hidden
- [ ] Ensure 4.5:1 contrast ratio for error text
- [ ] Write unit tests for ARIA attributes
- [ ] Test screen reader error announcements
- [ ] Test focus management on form submit

**Status**: Ready for Implementation
**Estimated Effort**: 1 day
