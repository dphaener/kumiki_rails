# Form File Input Component Migration Guide

**Component**: Form File Input
**DaisyUI Baseline**: [DaisyUI File Input](https://daisyui.com/components/file-input/)
**HyperUI Target**: Native File Input with Tailwind Forms
**Migration Complexity**: Moderate
**Last Updated**: 2025-11-19

---

## Overview

The Form File Input component renders file upload fields. Key accessibility requirement: File selection MUST be announced to screen readers via `aria-live` region (WCAG 4.1.3 Status Messages).

---

## HTML Structure

### Standard File Input

```html
<div class="form-group">
  <label for="file-input" class="block text-sm font-medium text-gray-700">
    Upload document
    <span class="text-red-600" aria-label="required">*</span>
  </label>
  <input
    type="file"
    id="file-input"
    name="document"
    accept=".pdf,.doc,.docx"
    aria-required="true"
    aria-invalid="false"
    aria-describedby="file-hint file-error file-status"
    class="mt-1 block w-full text-sm text-gray-700 file:mr-4 file:rounded-md file:border-0 file:bg-blue-600 file:px-4 file:py-2 file:text-sm file:font-medium file:text-white hover:file:bg-blue-700"
  />
  <p id="file-hint" class="mt-1 text-sm text-gray-500">
    Accepted formats: PDF, DOC, DOCX. Maximum size: 10MB.
  </p>
  <div id="file-status" aria-live="polite" aria-atomic="true" class="mt-1 text-sm text-gray-700">
    <!-- Dynamic file selection status -->
  </div>
  <p id="file-error" class="mt-1 text-sm text-red-600" role="alert" hidden>
    Please select a valid file.
  </p>
</div>
```

---

## Accessibility Requirements

### CRITICAL: File Selection Announcement

**WCAG 4.1.3 Status Messages**: File selection MUST be announced via `aria-live` region.

```html
<div aria-live="polite" aria-atomic="true" class="file-status">
  1 file selected: document.pdf (2.3 MB)
</div>
```

### ARIA Attributes

- `id` for label association
- `aria-required="true"` when required
- `aria-invalid="true"` when error
- `aria-describedby` includes hint, error, AND status region
- Status region has `aria-live="polite"` and `aria-atomic="true"`

---

## JavaScript Requirements

### File Selection Announcement Controller

```javascript
// app/javascript/controllers/file_input_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "status"]

  handleChange(event) {
    const files = Array.from(event.target.files)

    if (files.length === 0) {
      this.statusTarget.textContent = "No file selected"
    } else if (files.length === 1) {
      const file = files[0]
      this.statusTarget.textContent = `1 file selected: ${file.name} (${this.formatSize(file.size)})`
    } else {
      this.statusTarget.textContent = `${files.length} files selected`
    }
  }

  formatSize(bytes) {
    if (bytes < 1024) return `${bytes} B`
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
  }
}
```

---

## Migration Guide

### Component Class

```ruby
class FormFileInput < Kumiki::Component
  option :name
  option :label
  option :hint, default: -> { nil }
  option :error, default: -> { nil }
  option :required, default: -> { false }
  option :disabled, default: -> { false }
  option :accept, default: -> { nil }
  option :multiple, default: -> { false }

  def input_classes
    "mt-1 block w-full text-sm text-gray-700 file:mr-4 file:rounded-md file:border-0 file:bg-blue-600 file:px-4 file:py-2 file:text-sm file:font-medium file:text-white hover:file:bg-blue-700"
  end

  def label_classes
    "block text-sm font-medium text-gray-700"
  end

  def hint_classes
    "mt-1 text-sm text-gray-500"
  end

  def status_classes
    "mt-1 text-sm text-gray-700"
  end

  def error_classes
    "mt-1 text-sm text-red-600"
  end

  def field_id
    @field_id ||= "#{name}-#{SecureRandom.hex(4)}"
  end

  def status_id
    "#{field_id}-status"
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
    describedby << status_id
    attrs[:"aria-describedby"] = describedby.join(" ") if describedby.any?

    attrs
  end
end
```

### Template

```erb
<div class="form-group" data-controller="file-input">
  <%= tag.label(for: field_id, class: label_classes) do %>
    <%= label %>
    <% if required %>
      <%= tag.span("*", class: "text-red-600", "aria-label": "required") %>
    <% end %>
  <% end %>

  <%= tag.input(
    type: "file",
    id: field_id,
    name: name,
    accept: accept,
    multiple: multiple,
    disabled: disabled,
    required: required,
    class: input_classes,
    data: {
      file_input_target: "input",
      action: "change->file-input#handleChange"
    },
    **aria_attributes
  ) %>

  <% if hint %>
    <%= tag.p(hint, id: "#{field_id}-hint", class: hint_classes) %>
  <% end %>

  <%= tag.div(
    id: status_id,
    "aria-live": "polite",
    "aria-atomic": "true",
    class: status_classes,
    data: { file_input_target: "status" }
  ) %>

  <% if error? %>
    <%= tag.p(error, id: "#{field_id}-error", class: error_classes, role: "alert") %>
  <% end %>
</div>
```

---

## Implementation Checklist

- [ ] Implement input_classes with file: pseudo-element
- [ ] Add status region with aria-live
- [ ] Implement Stimulus controller for file selection
- [ ] Add formatSize helper for file size display
- [ ] Support multiple file selection
- [ ] Write unit tests
- [ ] Test screen reader file announcement

**Status**: Ready for Implementation
**Estimated Effort**: 1.5 days
