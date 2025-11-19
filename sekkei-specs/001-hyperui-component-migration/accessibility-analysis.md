# Accessibility Analysis: HyperUI Component Migration

**Document Version**: 1.0
**Created**: 2025-11-19
**WCAG Compliance Target**: WCAG 2.1 Level AA

## Executive Summary

This document provides a comprehensive accessibility analysis for migrating from DaisyUI to HyperUI component patterns. The analysis evaluates WCAG 2.1 AA compliance requirements, identifies critical accessibility gaps, and provides actionable guidance for maintaining and enhancing accessibility during migration.

**Critical Findings**:
- Current DaisyUI implementation has strong accessibility foundation (ARIA attributes, semantic HTML)
- HyperUI patterns require additional JavaScript for accessibility features (focus traps, keyboard navigation)
- Native `<dialog>` element provides better accessibility than custom implementations
- Gap analysis identifies 8 critical, 5 moderate, and 3 minor accessibility issues requiring attention

---

## 1. Overview: WCAG 2.1 AA Compliance Goal

### 1.1 Compliance Scope

This migration must maintain WCAG 2.1 Level AA compliance across all components, specifically addressing:

- **Perceivable**: Information and UI components must be presentable to users in ways they can perceive
  - 1.3.1 Info and Relationships (Level A)
  - 1.4.3 Contrast (Minimum) (Level AA)
  - 1.4.11 Non-text Contrast (Level AA)

- **Operable**: UI components and navigation must be operable
  - 2.1.1 Keyboard (Level A)
  - 2.1.2 No Keyboard Trap (Level A)
  - 2.4.3 Focus Order (Level A)
  - 2.4.7 Focus Visible (Level AA)

- **Understandable**: Information and operation of UI must be understandable
  - 3.2.1 On Focus (Level A)
  - 3.2.2 On Input (Level A)
  - 3.3.1 Error Identification (Level A)
  - 3.3.2 Labels or Instructions (Level A)
  - 3.3.3 Error Suggestion (Level AA)

- **Robust**: Content must be robust enough for reliable interpretation by assistive technologies
  - 4.1.2 Name, Role, Value (Level A)
  - 4.1.3 Status Messages (Level AA)

### 1.2 Testing Requirements

All migrated components must be validated with:
- **Keyboard-only navigation** (Tab, Shift+Tab, Enter, Space, Escape, Arrow keys)
- **Screen readers** (VoiceOver on macOS, NVDA/JAWS on Windows)
- **Color contrast analyzers** (WCAG AA requires 4.5:1 for normal text, 3:1 for large text)
- **Focus visibility testing** (visible focus indicators at all times)

---

## 2. Critical Components Analysis

### 2.1 Modal Component

#### Current DaisyUI Implementation

**Strengths**:
```ruby
# From /Users/darinhaener/code/kumiki_rails/app/views/kumiki/components/_modal.html.erb
<%= tag.dialog(**modal_data.html_attributes.merge(
      "aria-modal" => "true",
      "role" => "dialog"
    )) do %>
```

- Uses semantic `<dialog>` element (native browser support)
- Includes `aria-modal="true"` and `role="dialog"`
- Backdrop button has `aria-label="Close modal"`
- Stimulus controller: `rails-components--dismiss`

**WCAG Compliance**:
- ✅ 4.1.2 Name, Role, Value (uses role="dialog", aria-modal)
- ✅ 2.1.2 No Keyboard Trap (native dialog ESC key support)
- ⚠️ 2.4.3 Focus Order (no visible focus trap implementation)
- ❌ Focus return on close (not explicitly handled)

#### HyperUI Pattern Requirements

**From HyperUI Documentation**:
- Custom Web Components for modal behavior
- ARIA attributes: `role="dialog"`, `aria-modal="true"`, `aria-labelledby`, `aria-describedby`
- Focus trap pattern required (keyboard navigation contained within modal)
- ESC key handler for dismissal
- Focus return to trigger element on close

**Required Structure**:
```html
<div role="dialog"
     aria-modal="true"
     aria-labelledby="modal-title"
     aria-describedby="modal-description"
     tabindex="-1">
  <div class="modal-overlay" aria-hidden="true"></div>
  <div class="modal-content">
    <h2 id="modal-title">Modal Title</h2>
    <div id="modal-description">Modal content</div>
    <button type="button" aria-label="Close dialog">×</button>
  </div>
</div>
```

#### Migration Requirements

**CRITICAL: Focus Management**
```javascript
// Required Stimulus controller behavior
class ModalController extends Controller {
  static targets = ["dialog", "closeButton"]

  connect() {
    // Store the element that triggered the modal
    this.triggerElement = document.activeElement

    // Set initial focus to first focusable element or modal itself
    this.setInitialFocus()

    // Trap focus within modal
    this.trapFocus()
  }

  disconnect() {
    // Return focus to trigger element
    if (this.triggerElement && this.triggerElement.focus) {
      this.triggerElement.focus()
    }
  }

  trapFocus() {
    // Implement focus trap logic
    // On Tab: cycle through focusable elements
    // On Shift+Tab: reverse cycle
    // Prevent focus from leaving modal
  }
}
```

**Required ARIA Attributes**:
- `role="dialog"` (on outer container)
- `aria-modal="true"` (indicates modal behavior)
- `aria-labelledby="[modal-title-id]"` (references modal heading)
- `aria-describedby="[modal-description-id]"` (references modal content)
- `tabindex="-1"` (on modal container for programmatic focus)

**Required Keyboard Support**:
- **ESC**: Close modal and return focus
- **Tab**: Move to next focusable element within modal (circular)
- **Shift+Tab**: Move to previous focusable element within modal (circular)
- **Enter/Space**: Activate buttons within modal

---

### 2.2 Toast Component

#### Current DaisyUI Implementation

**Strengths**:
```erb
<%= tag.div(**toast_data.html_attributes.merge(
      "aria-live" => "polite",
      "aria-atomic" => "true"
    )) do %>
```

- Includes `role="alert"` on container
- `aria-live="polite"` for non-disruptive announcements
- `aria-atomic="true"` ensures full message is read
- Auto-dismiss functionality with Stimulus controller

**WCAG Compliance**:
- ✅ 4.1.3 Status Messages (uses aria-live regions)
- ✅ 3.2.1 On Focus (toasts don't steal focus)
- ⚠️ 2.1.1 Keyboard (dismissible toasts need keyboard support)
- ⚠️ 1.4.11 Non-text Contrast (close button contrast not guaranteed)

#### HyperUI Pattern Requirements

**From HyperUI Documentation**:
- `role="alert"` for important messages (error, warning)
- `role="status"` for less critical notifications (info, success)
- `aria-live="assertive"` for critical alerts (overrides screen reader)
- `aria-live="polite"` for regular notifications
- Dismissible toasts require close button with `aria-label`

**Required Structure**:
```html
<!-- Critical alert -->
<div role="alert"
     aria-live="assertive"
     aria-atomic="true"
     class="toast toast-error">
  <div class="toast-content">
    <svg aria-hidden="true" focusable="false"><!-- icon --></svg>
    <p>Error: Failed to save changes</p>
  </div>
  <button type="button"
          aria-label="Dismiss notification"
          class="toast-close">
    <span aria-hidden="true">&times;</span>
  </button>
</div>

<!-- Regular notification -->
<div role="status"
     aria-live="polite"
     aria-atomic="true"
     class="toast toast-success">
  <p>Changes saved successfully</p>
</div>
```

#### Migration Requirements

**CRITICAL: Role Selection Logic**
```ruby
# Add to Toast component
def aria_role
  case type.to_s
  when "error", "danger", "warning"
    "alert"  # Critical messages
  when "notice", "success", "info"
    "status"  # Non-critical notifications
  else
    "status"
  end
end

def aria_live_level
  case type.to_s
  when "error", "danger"
    "assertive"  # Interrupts screen reader
  else
    "polite"  # Waits for pause
  end
end
```

**Required ARIA Attributes**:
- `role="alert"` or `role="status"` (based on severity)
- `aria-live="assertive"` or `aria-live="polite"` (based on severity)
- `aria-atomic="true"` (full message announced)
- `aria-label="Dismiss notification"` (on close button)

**Required Keyboard Support**:
- **Focus**: Close button must be keyboard accessible
- **Enter/Space**: Dismiss toast
- **ESC**: Optional - dismiss focused toast

**Required Visual Indicators**:
- Icons must have `aria-hidden="true"` and `focusable="false"`
- Text must have 4.5:1 contrast ratio with background
- Close button must have 3:1 contrast ratio
- Focus indicator must be visible on close button

---

### 2.3 Form Input Component

#### Current DaisyUI Implementation

**Strengths**:
```ruby
# From /Users/darinhaener/code/kumiki_rails/app/components/kumiki/components/form_input.rb
attributes[:"aria-required"] = true if required
if error?
  attributes[:"aria-invalid"] = true
  attributes[:"aria-describedby"] = "#{field_id}_errors" if field_id
end
attributes[:id] = field_id if field_id
```

- Explicit label association via `for` attribute
- `aria-required` for required fields
- `aria-invalid` for error states
- `aria-describedby` links errors to inputs
- Unique IDs generated for accessibility

**WCAG Compliance**:
- ✅ 3.3.2 Labels or Instructions (proper label association)
- ✅ 3.3.1 Error Identification (aria-invalid + aria-describedby)
- ✅ 4.1.2 Name, Role, Value (native input semantics preserved)
- ✅ 1.3.1 Info and Relationships (label + input relationship)

#### HyperUI Pattern Requirements

**From HyperUI Documentation**:
- Uses `@tailwindcss/forms` plugin (native HTML form controls)
- Label association required for all inputs
- Error states conveyed with ARIA attributes
- Optional helper text with `aria-describedby`

**Required Structure**:
```html
<div class="form-group">
  <label for="email-input" class="form-label">
    Email Address
    <span class="required-indicator" aria-label="required">*</span>
  </label>

  <input type="email"
         id="email-input"
         name="email"
         aria-required="true"
         aria-invalid="false"
         aria-describedby="email-hint email-error"
         class="form-input">

  <p id="email-hint" class="form-hint">
    We'll never share your email with anyone else.
  </p>

  <p id="email-error" class="form-error" role="alert">
    Please enter a valid email address.
  </p>
</div>
```

#### Migration Requirements

**No Breaking Changes Required** - Current implementation meets requirements

**Enhancement Opportunities**:
1. Add `aria-describedby` for helper text (not just errors)
2. Add `autocomplete` attributes for common fields (email, name, address)
3. Consider `aria-labelledby` for complex label structures
4. Add `inputmode` for mobile keyboards (numeric, email, tel, url)

**Required ARIA Attributes** (Already Implemented):
- `id` on input (for label association)
- `aria-required="true"` (when required)
- `aria-invalid="true"` (when error state)
- `aria-describedby="[error-id] [hint-id]"` (links to descriptions)

**Required HTML Patterns** (Already Implemented):
- `<label for="[input-id]">` (explicit association)
- `<input id="[input-id]">` (unique ID)
- Error message with `id` matching `aria-describedby`

---

### 2.4 Form Select Component

#### Current DaisyUI Implementation

**Strengths** (Same as Form Input):
```ruby
attributes[:"aria-required"] = true if required
if error?
  attributes[:"aria-invalid"] = true
  attributes[:"aria-describedby"] = "#{field_id}_errors" if field_id
end
```

**WCAG Compliance**:
- ✅ 3.3.2 Labels or Instructions (proper label association)
- ✅ 4.1.2 Name, Role, Value (native select semantics)
- ⚠️ Custom dropdowns require additional ARIA (if implemented later)

#### HyperUI Pattern Requirements

**Standard Native Select**:
```html
<div class="form-group">
  <label for="country-select" class="form-label">
    Country
  </label>

  <select id="country-select"
          name="country"
          aria-required="true"
          aria-invalid="false"
          aria-describedby="country-error"
          class="form-select">
    <option value="">Select a country</option>
    <option value="us">United States</option>
    <option value="ca">Canada</option>
  </select>

  <p id="country-error" class="form-error" role="alert">
    Please select a country.
  </p>
</div>
```

**Custom Dropdown (Advanced Pattern)**:

If implementing custom styled dropdowns (combobox pattern):
```html
<div class="combobox" data-controller="combobox">
  <label id="combobox-label" for="combobox-input">
    Choose a fruit
  </label>

  <input type="text"
         id="combobox-input"
         role="combobox"
         aria-expanded="false"
         aria-controls="combobox-listbox"
         aria-labelledby="combobox-label"
         aria-autocomplete="list"
         class="combobox-input">

  <ul id="combobox-listbox"
      role="listbox"
      aria-labelledby="combobox-label"
      hidden>
    <li role="option" aria-selected="false">Apple</li>
    <li role="option" aria-selected="false">Banana</li>
  </ul>
</div>
```

#### Migration Requirements

**Standard Select** (No Changes Required):
- Current implementation fully accessible
- Native `<select>` provides best accessibility

**Custom Dropdown** (If Needed - Out of Initial Scope):
- Requires full ARIA combobox pattern
- Complex keyboard navigation (Arrow keys, Home, End, Page Up/Down)
- Focus management and visual feedback
- **Recommendation**: Use native `<select>` unless absolutely necessary

---

### 2.5 Form Checkbox Component

#### Current DaisyUI Implementation

**Strengths**:
```ruby
# From /Users/darinhaener/code/kumiki_rails/app/components/kumiki/components/form_checkbox.rb
attributes[:"aria-required"] = true if required
attributes[:"aria-invalid"] = true if error?
attributes[:id] = field_id if field_id
```

```erb
<label class="label cursor-pointer justify-start gap-2" for="<%= component_data.field_id %>">
  <%= tag.input(**component_data.html_attributes) %>
  <span class="label-text"><%= component_data.label %></span>
</label>
```

**WCAG Compliance**:
- ✅ 4.1.2 Name, Role, Value (native checkbox semantics)
- ✅ 1.3.1 Info and Relationships (label wraps checkbox)
- ✅ 2.1.1 Keyboard (native Space key to toggle)

#### HyperUI Pattern Requirements

**Standard Checkbox**:
```html
<div class="form-group">
  <div class="checkbox-wrapper">
    <input type="checkbox"
           id="terms-checkbox"
           name="terms"
           aria-required="true"
           aria-invalid="false"
           aria-describedby="terms-error"
           class="form-checkbox">

    <label for="terms-checkbox" class="checkbox-label">
      I agree to the terms and conditions
    </label>
  </div>

  <p id="terms-error" class="form-error" role="alert">
    You must accept the terms to continue.
  </p>
</div>
```

**Checkbox Group**:
```html
<fieldset class="form-fieldset">
  <legend class="form-legend">
    Select your interests
    <span class="required-indicator" aria-label="required">*</span>
  </legend>

  <div class="checkbox-group">
    <div class="checkbox-wrapper">
      <input type="checkbox" id="interest-tech" name="interests[]" value="tech">
      <label for="interest-tech">Technology</label>
    </div>

    <div class="checkbox-wrapper">
      <input type="checkbox" id="interest-sports" name="interests[]" value="sports">
      <label for="interest-sports">Sports</label>
    </div>
  </div>

  <p id="interests-error" class="form-error" role="alert">
    Please select at least one interest.
  </p>
</fieldset>
```

#### Migration Requirements

**Single Checkbox** (Minor Enhancements):
- Current implementation is accessible
- Consider adding `aria-describedby` for helper text

**Checkbox Group** (New Pattern):
- Use `<fieldset>` and `<legend>` for grouping
- Each checkbox needs unique ID and label association
- Group errors associated with fieldset
- Required indicator on legend, not individual checkboxes

**Required ARIA Attributes**:
- `id` on checkbox (for label association)
- `aria-required="true"` (when required)
- `aria-invalid="true"` (when error state)
- `aria-describedby="[error-id]"` (links to errors)

**Required Keyboard Support** (Native):
- **Tab**: Move between checkboxes
- **Space**: Toggle checkbox state
- **Shift+Tab**: Move backwards

---

### 2.6 Form Radio Component

#### Current DaisyUI Implementation

**Analysis needed** - Similar to checkbox but with radio button semantics

#### HyperUI Pattern Requirements

**Radio Group** (Required Pattern):
```html
<fieldset class="form-fieldset">
  <legend class="form-legend">
    Choose a shipping method
    <span class="required-indicator" aria-label="required">*</span>
  </legend>

  <div class="radio-group" role="radiogroup" aria-required="true">
    <div class="radio-wrapper">
      <input type="radio"
             id="shipping-standard"
             name="shipping"
             value="standard"
             aria-describedby="shipping-error">
      <label for="shipping-standard">Standard (5-7 days)</label>
    </div>

    <div class="radio-wrapper">
      <input type="radio"
             id="shipping-express"
             name="shipping"
             value="express"
             aria-describedby="shipping-error">
      <label for="shipping-express">Express (2-3 days)</label>
    </div>
  </div>

  <p id="shipping-error" class="form-error" role="alert">
    Please select a shipping method.
  </p>
</fieldset>
```

#### Migration Requirements

**CRITICAL: Fieldset + Legend Required**
- Radio buttons MUST be wrapped in `<fieldset>` with `<legend>`
- WCAG 1.3.1 requires programmatic grouping
- Screen readers announce legend when entering group

**Required ARIA Attributes**:
- `role="radiogroup"` on container (optional, native fieldset implies)
- `aria-required="true"` on group (not individual radios)
- `aria-describedby="[error-id]"` on each radio (shared error)
- `aria-invalid="true"` on first radio when group has error

**Required Keyboard Support** (Native):
- **Tab**: Move to radio group (focuses checked radio or first if none checked)
- **Arrow keys**: Select next/previous radio (automatically checks)
- **Shift+Tab**: Move to previous focusable element

---

### 2.7 Form Textarea Component

#### Current DaisyUI Implementation

**Expected** - Same accessibility pattern as Form Input

#### HyperUI Pattern Requirements

**Standard Textarea**:
```html
<div class="form-group">
  <label for="message-textarea" class="form-label">
    Message
    <span class="required-indicator" aria-label="required">*</span>
  </label>

  <textarea id="message-textarea"
            name="message"
            rows="5"
            maxlength="500"
            aria-required="true"
            aria-invalid="false"
            aria-describedby="message-hint message-error"
            class="form-textarea"></textarea>

  <p id="message-hint" class="form-hint">
    Maximum 500 characters. <span aria-live="polite">Characters remaining: <span id="char-count">500</span></span>
  </p>

  <p id="message-error" class="form-error" role="alert">
    Message must be at least 10 characters.
  </p>
</div>
```

#### Migration Requirements

**Enhancement: Character Counter**
```javascript
// Optional Stimulus controller for character counter
class CharacterCounterController extends Controller {
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
      this.countTarget.setAttribute('role', 'status')
      this.countTarget.setAttribute('aria-live', 'polite')
    }
  }
}
```

**Required ARIA Attributes** (Same as Input):
- `id` on textarea (for label association)
- `aria-required="true"` (when required)
- `aria-invalid="true"` (when error state)
- `aria-describedby="[hint-id] [error-id]"` (links to descriptions)

---

### 2.8 Form File Input Component

#### Current DaisyUI Implementation

**Analysis needed** - File inputs have unique accessibility considerations

#### HyperUI Pattern Requirements

**Standard File Input**:
```html
<div class="form-group">
  <label for="file-input" class="form-label">
    Upload document
    <span class="required-indicator" aria-label="required">*</span>
  </label>

  <input type="file"
         id="file-input"
         name="document"
         accept=".pdf,.doc,.docx"
         aria-required="true"
         aria-invalid="false"
         aria-describedby="file-hint file-error"
         class="form-file-input">

  <p id="file-hint" class="form-hint">
    Accepted formats: PDF, DOC, DOCX. Maximum size: 10MB.
  </p>

  <p id="file-error" class="form-error" role="alert">
    Please select a valid file.
  </p>

  <div aria-live="polite" aria-atomic="true" class="file-status">
    <!-- Dynamic status updates after file selection -->
  </div>
</div>
```

**Custom Drag-and-Drop File Input** (Advanced):
```html
<div class="form-group">
  <label id="file-drop-label" class="form-label">
    Upload files
  </label>

  <div class="file-drop-zone"
       data-controller="file-drop"
       role="button"
       tabindex="0"
       aria-labelledby="file-drop-label"
       aria-describedby="file-drop-hint">

    <input type="file"
           id="file-drop-input"
           name="files[]"
           multiple
           hidden
           aria-labelledby="file-drop-label">

    <p>Drag files here or click to browse</p>
  </div>

  <p id="file-drop-hint" class="form-hint">
    You can upload multiple files. Drag and drop or click to select.
  </p>

  <ul role="list" aria-live="polite" class="file-list">
    <!-- Dynamic list of selected files -->
  </ul>
</div>
```

#### Migration Requirements

**CRITICAL: File Selection Feedback**
- File selection MUST be announced to screen readers
- Use `aria-live="polite"` region for status updates
- Provide clear error messages for invalid files

**Custom File Input Accessibility**:
```javascript
class FileDropController extends Controller {
  static targets = ["input", "status", "list"]

  handleFileSelect(event) {
    const files = Array.from(event.target.files)

    // Update status region for screen readers
    this.statusTarget.textContent = `${files.length} file(s) selected`

    // Update file list
    this.updateFileList(files)
  }

  updateFileList(files) {
    // Clear previous list
    this.listTarget.innerHTML = ''

    files.forEach((file, index) => {
      const li = document.createElement('li')
      li.textContent = `${file.name} (${this.formatSize(file.size)})`

      // Add remove button
      const removeBtn = document.createElement('button')
      removeBtn.textContent = 'Remove'
      removeBtn.setAttribute('aria-label', `Remove ${file.name}`)
      removeBtn.addEventListener('click', () => this.removeFile(index))

      li.appendChild(removeBtn)
      this.listTarget.appendChild(li)
    })
  }
}
```

**Required ARIA Attributes**:
- `id` on input (for label association)
- `aria-required="true"` (when required)
- `aria-invalid="true"` (when error state)
- `aria-describedby="[hint-id] [error-id]"` (links to descriptions)
- `aria-live="polite"` on status region (announces file selection)

**Custom Drop Zone**:
- `role="button"` on drop zone (keyboard accessible)
- `tabindex="0"` (makes focusable)
- `aria-labelledby` (references label)
- `aria-describedby` (references instructions)

---

### 2.9 Form Date Picker Component

#### Current DaisyUI Implementation

**Analysis needed** - Date pickers are complex for accessibility

#### HyperUI Pattern Requirements

**Native Date Input** (Recommended):
```html
<div class="form-group">
  <label for="date-input" class="form-label">
    Select date
    <span class="required-indicator" aria-label="required">*</span>
  </label>

  <input type="date"
         id="date-input"
         name="date"
         min="2024-01-01"
         max="2024-12-31"
         aria-required="true"
         aria-invalid="false"
         aria-describedby="date-hint date-error"
         class="form-date-input">

  <p id="date-hint" class="form-hint">
    Format: MM/DD/YYYY. Select a date between Jan 1, 2024 and Dec 31, 2024.
  </p>

  <p id="date-error" class="form-error" role="alert">
    Please select a valid date.
  </p>
</div>
```

**Custom Date Picker** (Complex - Out of Scope):

Custom date pickers require full ARIA grid pattern with complex keyboard navigation. **Recommendation: Use native `<input type="date">` for best accessibility.**

If custom date picker is required:
- ARIA `role="application"` with extensive keyboard handlers
- Grid pattern for calendar navigation
- Announce selected date and constraints
- Fallback to text input for screen reader users
- See [WAI-ARIA Authoring Practices - Date Picker](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/datepicker-dialog/)

#### Migration Requirements

**Strong Recommendation**: Use native `<input type="date">`
- Browser-native accessibility
- Built-in keyboard navigation
- Localized date formats
- Mobile-optimized

**If Custom Picker Required** (Complex):
- Full ARIA grid implementation
- Extensive keyboard support (Arrow keys, Home, End, Page Up/Down)
- Month/year navigation
- Date range constraints announced
- **Estimated effort**: 2-3 weeks for full accessibility

---

### 2.10 Form Error Component

#### Current DaisyUI Implementation

**Strengths**:
```ruby
# Error messages linked via aria-describedby
attributes[:"aria-describedby"] = "#{field_id}_errors" if field_id
```

#### HyperUI Pattern Requirements

**Error Message Pattern**:
```html
<p id="field-name-error"
   class="form-error"
   role="alert">
  <svg aria-hidden="true" focusable="false" class="error-icon">
    <!-- Error icon -->
  </svg>
  <span>This field is required.</span>
</p>
```

**Inline Validation** (Enhanced):
```html
<div class="form-group">
  <label for="email-input" class="form-label">Email</label>

  <input type="email"
         id="email-input"
         name="email"
         aria-invalid="true"
         aria-describedby="email-error"
         class="form-input form-input-error">

  <p id="email-error"
     class="form-error"
     role="alert"
     aria-live="polite">
    Please enter a valid email address.
  </p>
</div>
```

#### Migration Requirements

**CRITICAL: Error Announcement**
- Errors MUST have `role="alert"` OR `aria-live="assertive"`
- Screen readers announce errors immediately
- Errors MUST be linked via `aria-describedby`

**Error Pattern Requirements**:
```ruby
# Enhanced FormError component
class FormError
  def aria_attributes
    {
      id: error_id,
      role: "alert",
      "aria-live": "polite",  # Or "assertive" for critical errors
      "aria-atomic": "true"
    }
  end
end
```

**Required ARIA Attributes**:
- `id` on error message (for aria-describedby linking)
- `role="alert"` (announces error to screen readers)
- `aria-live="polite"` or `aria-live="assertive"` (live region)
- `aria-atomic="true"` (reads full message, not just changes)

**Visual Requirements**:
- Error icon must have `aria-hidden="true"` and `focusable="false"`
- Error text must have 4.5:1 contrast ratio
- Error state indicated by more than just color (icon, border, text)

---

### 2.11 Button Component

#### Current DaisyUI Implementation

**Strengths**:
```ruby
# From /Users/darinhaener/code/kumiki_rails/app/components/kumiki/components/button.rb
attributes[:disabled] = true if disabled || loading
```

```erb
<% if button_data.loading %>
  <span class="loading loading-spinner loading-sm mr-2"></span>
<% end %>
```

**WCAG Compliance**:
- ✅ 4.1.2 Name, Role, Value (native button semantics)
- ✅ 2.1.1 Keyboard (native Enter/Space activation)
- ⚠️ Loading state not announced to screen readers

#### HyperUI Pattern Requirements

**Standard Button**:
```html
<button type="button"
        class="btn btn-primary"
        aria-label="Clear descriptive label">
  Button Text
</button>
```

**Icon-Only Button**:
```html
<button type="button"
        class="btn btn-icon"
        aria-label="Close dialog">
  <svg aria-hidden="true" focusable="false">
    <!-- Icon -->
  </svg>
</button>
```

**Loading Button**:
```html
<button type="button"
        class="btn btn-primary"
        aria-busy="true"
        aria-live="polite"
        disabled>
  <svg class="spinner" aria-hidden="true" focusable="false">
    <!-- Spinner icon -->
  </svg>
  <span class="visually-hidden">Loading, please wait</span>
  <span aria-hidden="true">Loading...</span>
</button>
```

**Toggle Button**:
```html
<button type="button"
        class="btn btn-toggle"
        aria-pressed="false"
        aria-label="Toggle dark mode">
  <svg aria-hidden="true" focusable="false">
    <!-- Icon changes based on state -->
  </svg>
  <span>Dark Mode</span>
</button>
```

#### Migration Requirements

**CRITICAL: Loading State Accessibility**
```ruby
# Enhanced Button component
class Button
  def loading_attributes
    return {} unless loading

    {
      "aria-busy": "true",
      "aria-live": "polite",
      disabled: true
    }
  end

  def loading_text
    # Hidden text announced to screen readers
    '<span class="sr-only">Loading, please wait</span>'.html_safe
  end
end
```

**Required ARIA Attributes**:
- `aria-label` (when button has no visible text or icon-only)
- `aria-busy="true"` (when loading state)
- `aria-pressed="true|false"` (for toggle buttons)
- `aria-expanded="true|false"` (for dropdown/accordion triggers)
- `disabled` (when not interactive)

**Icon Handling**:
- Icons MUST have `aria-hidden="true"` and `focusable="false"`
- Button text provides accessible name (not icon)
- Loading spinner hidden from screen readers

**Required Keyboard Support** (Native):
- **Enter**: Activate button
- **Space**: Activate button
- **Tab**: Focus button
- **Shift+Tab**: Focus previous element

---

### 2.12 Badge Component

#### Current DaisyUI Implementation

**Analysis needed** - Badges are typically presentational

#### HyperUI Pattern Requirements

**Presentational Badge**:
```html
<span class="badge badge-success">
  Active
</span>
```

**Status Badge** (with semantic meaning):
```html
<span class="badge badge-warning"
      role="status"
      aria-label="Status: Pending review">
  Pending
</span>
```

**Interactive Badge** (dismissible):
```html
<span class="badge badge-tag">
  <span>Tag Name</span>
  <button type="button"
          class="badge-remove"
          aria-label="Remove tag: Tag Name">
    <svg aria-hidden="true" focusable="false">×</svg>
  </button>
</span>
```

#### Migration Requirements

**Semantic Badges**:
- Add `role="status"` when badge conveys dynamic status
- Add `aria-label` when badge text alone is insufficient
- Ensure 4.5:1 contrast ratio for text

**Interactive Badges**:
- Remove button must have `aria-label` with context
- Icon must have `aria-hidden="true"`
- Button must be keyboard accessible

---

### 2.13 Card Component

#### Current DaisyUI Implementation

**Strengths**: Semantic HTML structure

#### HyperUI Pattern Requirements

**Standard Card**:
```html
<article class="card">
  <header class="card-header">
    <h3 class="card-title">Card Title</h3>
  </header>

  <div class="card-body">
    <p>Card content</p>
  </div>

  <footer class="card-footer">
    <button type="button">Action</button>
  </footer>
</article>
```

**Interactive Card** (clickable):
```html
<article class="card">
  <a href="/details"
     class="card-link"
     aria-label="View details for: Card Title">
    <h3 class="card-title">Card Title</h3>
    <p class="card-body">Card content</p>
  </a>
</article>
```

#### Migration Requirements

**Semantic Structure**:
- Use `<article>` for independent content units
- Use `<section>` for thematic grouping within card
- Use heading hierarchy (`<h2>`, `<h3>`, etc.)

**Interactive Cards**:
- Entire card should be one focusable element (single link/button)
- Add descriptive `aria-label` when card link text is insufficient
- Ensure focus indicator covers entire clickable area

**Required Keyboard Support**:
- **Tab**: Focus interactive elements within card
- **Enter**: Activate primary action (link/button)

---

## 3. ARIA Pattern Requirements

### 3.1 Modal Dialog Pattern

**WAI-ARIA Reference**: [Dialog (Modal) Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/)

**Required Roles**:
- `role="dialog"` on modal container
- `aria-modal="true"` indicates modal behavior

**Required Properties**:
- `aria-labelledby="[modal-title-id]"` (references modal heading)
- `aria-describedby="[modal-description-id]"` (references modal content)
- `tabindex="-1"` (on modal container for programmatic focus)

**Required States**:
- `aria-hidden="true"` on background content when modal open (optional but recommended)

**Implementation Example**:
```html
<div role="dialog"
     aria-modal="true"
     aria-labelledby="modal-title"
     aria-describedby="modal-description"
     tabindex="-1"
     class="modal">

  <div class="modal-content">
    <h2 id="modal-title">Confirm Delete</h2>
    <p id="modal-description">Are you sure you want to delete this item?</p>

    <div class="modal-actions">
      <button type="button" class="btn-cancel">Cancel</button>
      <button type="button" class="btn-confirm">Delete</button>
    </div>
  </div>
</div>
```

---

### 3.2 Alert Pattern

**WAI-ARIA Reference**: [Alert Role](https://www.w3.org/WAI/ARIA/apg/patterns/alert/)

**Required Roles**:
- `role="alert"` for critical messages (error, warning)
- `role="status"` for non-critical notifications (info, success)

**Required Properties**:
- `aria-live="assertive"` for critical alerts (interrupts screen reader)
- `aria-live="polite"` for regular notifications (waits for pause)
- `aria-atomic="true"` (full message announced, not just changes)

**Implementation Example**:
```html
<!-- Critical error -->
<div role="alert"
     aria-live="assertive"
     aria-atomic="true"
     class="toast toast-error">
  <p>Error: Your session has expired. Please log in again.</p>
</div>

<!-- Success notification -->
<div role="status"
     aria-live="polite"
     aria-atomic="true"
     class="toast toast-success">
  <p>Your changes have been saved successfully.</p>
</div>
```

---

### 3.3 Form Input Pattern

**WAI-ARIA Reference**: [Form Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/form/)

**Required Properties**:
- `aria-required="true"` when field is required
- `aria-invalid="true"` when field has validation error
- `aria-describedby="[hint-id] [error-id]"` links to helper text and errors

**Required Labels**:
- Explicit `<label for="[input-id]">` association
- OR `aria-label` for accessible name
- OR `aria-labelledby` for complex label structures

**Implementation Example**:
```html
<div class="form-group">
  <label for="username" class="form-label">
    Username
    <span aria-label="required">*</span>
  </label>

  <input type="text"
         id="username"
         name="username"
         aria-required="true"
         aria-invalid="false"
         aria-describedby="username-hint username-error">

  <p id="username-hint">Choose a unique username (3-20 characters)</p>
  <p id="username-error" role="alert" hidden>Username is already taken</p>
</div>
```

---

### 3.4 Radio Group Pattern

**WAI-ARIA Reference**: [Radio Group Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radio/)

**Required Structure**:
- `<fieldset>` wrapping radio group
- `<legend>` providing group label

**Required Properties**:
- `role="radiogroup"` (optional, fieldset implies)
- `aria-required="true"` on group or first radio
- `aria-describedby="[error-id]"` on each radio (shared error)

**Implementation Example**:
```html
<fieldset class="form-fieldset">
  <legend>Choose a payment method <span aria-label="required">*</span></legend>

  <div role="radiogroup" aria-required="true">
    <div class="radio-wrapper">
      <input type="radio" id="payment-card" name="payment" value="card">
      <label for="payment-card">Credit/Debit Card</label>
    </div>

    <div class="radio-wrapper">
      <input type="radio" id="payment-paypal" name="payment" value="paypal">
      <label for="payment-paypal">PayPal</label>
    </div>
  </div>

  <p id="payment-error" role="alert" hidden>Please select a payment method</p>
</fieldset>
```

---

### 3.5 Button Pattern

**WAI-ARIA Reference**: [Button Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/button/)

**Required Properties**:
- `aria-label` when button has no visible text
- `aria-pressed="true|false"` for toggle buttons
- `aria-expanded="true|false"` for buttons that control visibility
- `aria-busy="true"` when button is in loading state

**Implementation Examples**:

**Icon Button**:
```html
<button type="button" aria-label="Close dialog">
  <svg aria-hidden="true" focusable="false"><!-- X icon --></svg>
</button>
```

**Toggle Button**:
```html
<button type="button"
        aria-pressed="false"
        aria-label="Mute audio"
        onclick="this.setAttribute('aria-pressed', this.getAttribute('aria-pressed') === 'false')">
  <svg aria-hidden="true"><!-- Volume icon --></svg>
  Mute
</button>
```

**Loading Button**:
```html
<button type="submit" aria-busy="true" disabled>
  <span class="sr-only">Processing, please wait</span>
  <span aria-hidden="true">Processing...</span>
</button>
```

---

## 4. Keyboard Navigation Requirements

### 4.1 Modal Dialog Keyboard Support

**Required Keyboard Shortcuts**:

| Key | Action | WCAG Criterion |
|-----|--------|----------------|
| **Tab** | Move focus to next focusable element within modal (circular) | 2.1.1 Keyboard, 2.1.2 No Keyboard Trap |
| **Shift+Tab** | Move focus to previous focusable element within modal (circular) | 2.1.1 Keyboard, 2.1.2 No Keyboard Trap |
| **Escape** | Close modal and return focus to trigger element | 2.1.1 Keyboard |
| **Enter** (on button) | Activate button within modal | 2.1.1 Keyboard |

**Implementation Notes**:
- Focus trap prevents Tab from leaving modal
- First or last Tab wraps to opposite end
- ESC key closes modal regardless of current focus
- Focus returns to element that opened modal

**Stimulus Controller Example**:
```javascript
export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this.previousFocus = document.activeElement
    this.focusableElements = this.dialogTarget.querySelectorAll(
      'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
    )

    // Set focus to first focusable element or modal itself
    if (this.focusableElements.length > 0) {
      this.focusableElements[0].focus()
    } else {
      this.dialogTarget.focus()
    }

    // Trap focus
    this.dialogTarget.addEventListener('keydown', this.handleKeydown.bind(this))
  }

  handleKeydown(event) {
    if (event.key === 'Escape') {
      this.close()
    }

    if (event.key === 'Tab') {
      this.trapFocus(event)
    }
  }

  trapFocus(event) {
    const firstElement = this.focusableElements[0]
    const lastElement = this.focusableElements[this.focusableElements.length - 1]

    if (event.shiftKey && document.activeElement === firstElement) {
      event.preventDefault()
      lastElement.focus()
    } else if (!event.shiftKey && document.activeElement === lastElement) {
      event.preventDefault()
      firstElement.focus()
    }
  }

  close() {
    this.dialogTarget.remove()
    if (this.previousFocus && this.previousFocus.focus) {
      this.previousFocus.focus()
    }
  }
}
```

---

### 4.2 Toast Notification Keyboard Support

**Required Keyboard Shortcuts**:

| Key | Action | WCAG Criterion |
|-----|--------|----------------|
| **Tab** | Focus close button (if dismissible) | 2.1.1 Keyboard |
| **Enter/Space** (on close button) | Dismiss toast | 2.1.1 Keyboard |
| **Escape** | Dismiss focused toast (optional enhancement) | 2.1.1 Keyboard |

**Implementation Notes**:
- Toast does NOT trap focus (page remains navigable)
- Toast close button is keyboard accessible
- Auto-dismiss does not interfere with keyboard navigation

---

### 4.3 Form Field Keyboard Support

**Required Keyboard Shortcuts**:

| Component | Key | Action | WCAG Criterion |
|-----------|-----|--------|----------------|
| **Input/Textarea** | Tab | Focus field | 2.1.1 Keyboard |
| | Shift+Tab | Focus previous | 2.1.1 Keyboard |
| | Arrow keys | Move cursor | Native behavior |
| **Select** | Tab | Focus select | 2.1.1 Keyboard |
| | Space | Open dropdown | 2.1.1 Keyboard |
| | Arrow keys | Navigate options | Native behavior |
| | Enter | Select option | Native behavior |
| **Checkbox** | Tab | Focus checkbox | 2.1.1 Keyboard |
| | Space | Toggle checked | 2.1.1 Keyboard |
| **Radio Group** | Tab | Focus group (first or checked radio) | 2.1.1 Keyboard |
| | Arrow keys | Select next/previous radio | 2.1.1 Keyboard |
| | Space | Check focused radio | 2.1.1 Keyboard |

**Implementation Notes**:
- All native form controls have built-in keyboard support
- Custom-styled controls MUST preserve native keyboard behavior
- Radio groups use Arrow keys for selection (not Tab between radios)

---

### 4.4 Button Keyboard Support

**Required Keyboard Shortcuts**:

| Key | Action | WCAG Criterion |
|-----|--------|----------------|
| **Tab** | Focus button | 2.1.1 Keyboard |
| **Shift+Tab** | Focus previous element | 2.1.1 Keyboard |
| **Enter** | Activate button | 2.1.1 Keyboard |
| **Space** | Activate button | 2.1.1 Keyboard |

**Implementation Notes**:
- Native `<button>` elements handle all keyboard interactions
- Disabled buttons are not focusable
- Loading buttons remain focusable but disabled

---

## 5. Focus Management

### 5.1 Modal Focus Management

**Focus Requirements**:

1. **On Open**:
   - Store reference to element that opened modal (trigger element)
   - Set focus to first focusable element within modal
   - If no focusable elements, set focus to modal container (`tabindex="-1"`)

2. **During Interaction**:
   - Focus trapped within modal (Tab cycles through focusable elements)
   - Background content inert (not focusable)

3. **On Close**:
   - Return focus to trigger element
   - If trigger element no longer exists, focus next logical element
   - Remove modal from DOM

**Implementation Example**:
```javascript
class ModalController extends Controller {
  static targets = ["dialog"]

  open() {
    // Store trigger element
    this.triggerElement = document.activeElement

    // Show modal
    this.dialogTarget.showModal() // Native <dialog> method

    // Set initial focus
    this.setInitialFocus()

    // Trap focus
    this.trapFocus()
  }

  setInitialFocus() {
    // Find first focusable element
    const focusable = this.dialogTarget.querySelector(
      'button:not([disabled]), [href], input:not([disabled]), ' +
      'select:not([disabled]), textarea:not([disabled]), ' +
      '[tabindex]:not([tabindex="-1"])'
    )

    if (focusable) {
      focusable.focus()
    } else {
      // Focus modal container
      this.dialogTarget.setAttribute('tabindex', '-1')
      this.dialogTarget.focus()
    }
  }

  close() {
    // Close modal
    this.dialogTarget.close() // Native <dialog> method

    // Return focus to trigger
    if (this.triggerElement && this.triggerElement.focus) {
      this.triggerElement.focus()
    } else {
      // Fallback to body or main content
      document.querySelector('main')?.focus()
    }
  }
}
```

---

### 5.2 Toast Focus Management

**Focus Requirements**:

**Toasts MUST NOT steal focus**:
- Toast appears without changing focus
- User can continue interacting with page
- Screen reader announces toast via `aria-live` region

**Dismissible Toast**:
- Close button is focusable via Tab
- User can Tab to close button to dismiss
- Dismissing toast does not change focus (unless close button was focused)

**Implementation Notes**:
```javascript
class ToastController extends Controller {
  show() {
    // Add toast to DOM
    document.body.appendChild(this.element)

    // Do NOT set focus to toast
    // Screen reader announces via aria-live
  }

  dismiss() {
    // Check if close button was focused
    const wasCloseButtonFocused = this.element.contains(document.activeElement)

    // Remove toast
    this.element.remove()

    // If close button was focused, move focus to next logical element
    if (wasCloseButtonFocused) {
      document.querySelector('main')?.focus()
    }
  }
}
```

---

### 5.3 Form Field Focus Management

**Focus Requirements**:

1. **Error State**:
   - When form submission fails, set focus to first invalid field
   - Announce error count and first error to screen readers

2. **Field Validation**:
   - Inline validation does NOT change focus
   - Error messages announced via `aria-live` or `role="alert"`

3. **Multi-Step Forms**:
   - Focus first field of new step when advancing
   - Focus last field of previous step when going back

**Implementation Example**:
```javascript
class FormController extends Controller {
  async submit(event) {
    event.preventDefault()

    const response = await this.submitForm()

    if (response.errors) {
      this.handleErrors(response.errors)
    }
  }

  handleErrors(errors) {
    // Find first invalid field
    const firstInvalidField = this.element.querySelector('[aria-invalid="true"]')

    if (firstInvalidField) {
      // Set focus to first invalid field
      firstInvalidField.focus()

      // Scroll into view
      firstInvalidField.scrollIntoView({ behavior: 'smooth', block: 'center' })
    }

    // Announce error summary
    const errorSummary = `Form has ${errors.length} error${errors.length > 1 ? 's' : ''}`
    this.announceToScreenReader(errorSummary)
  }

  announceToScreenReader(message) {
    const announcement = document.createElement('div')
    announcement.setAttribute('role', 'alert')
    announcement.setAttribute('aria-live', 'assertive')
    announcement.textContent = message
    document.body.appendChild(announcement)

    // Remove after announcement
    setTimeout(() => announcement.remove(), 1000)
  }
}
```

---

### 5.4 Focus Visibility

**WCAG 2.4.7 Focus Visible (Level AA)**:

All interactive elements MUST have a visible focus indicator when focused via keyboard.

**Required Focus Styles**:

```css
/* Global focus styles */
*:focus {
  outline: 2px solid #4F46E5; /* Indigo-600 */
  outline-offset: 2px;
}

/* Remove outline for mouse users (optional, but maintain for keyboard) */
*:focus:not(:focus-visible) {
  outline: none;
}

*:focus-visible {
  outline: 2px solid #4F46E5;
  outline-offset: 2px;
}

/* Component-specific focus styles */
.btn:focus-visible {
  outline: 2px solid currentColor;
  outline-offset: 2px;
  box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.2);
}

.form-input:focus {
  border-color: #4F46E5;
  ring: 2px solid rgba(79, 70, 229, 0.2);
}

.modal:focus {
  /* Modal container focus (when no focusable children) */
  outline: 2px solid #4F46E5;
  outline-offset: -2px; /* Inside modal */
}
```

**Contrast Requirements**:
- Focus indicator MUST have 3:1 contrast ratio with adjacent colors
- Focus indicator MUST be at least 2 CSS pixels thick

---

## 6. Gap Analysis: DaisyUI vs HyperUI

### 6.1 Critical Gaps (Must Address)

| Component | Gap | DaisyUI Status | HyperUI Status | Impact | Remediation |
|-----------|-----|----------------|----------------|--------|-------------|
| **Modal** | Focus trap implementation | ⚠️ Partial (no explicit trap) | ❌ Requires custom JS | High - WCAG 2.1.2 violation | Implement Stimulus focus trap controller |
| **Modal** | Focus return on close | ❌ Not implemented | ❌ Requires custom JS | High - WCAG 2.4.3 violation | Store trigger element, restore focus on close |
| **Toast** | Role-based announcements | ⚠️ Uses `role="alert"` for all | ❌ No guidance | Medium - WCAG 4.1.3 | Use `role="alert"` for errors, `role="status"` for info |
| **Button** | Loading state announcement | ❌ Not announced | ❌ No guidance | High - WCAG 4.1.2 | Add `aria-busy="true"` and visually hidden text |
| **Radio** | Fieldset + legend grouping | ⚠️ Implementation unknown | ✅ Documented pattern | High - WCAG 1.3.1 | Wrap radio groups in `<fieldset>` with `<legend>` |
| **Form** | Error focus management | ❌ Not implemented | ❌ No guidance | Medium - WCAG 3.3.1 | Focus first invalid field on submit |
| **File Input** | Selection announcement | ❌ Not implemented | ⚠️ Partial guidance | Medium - WCAG 4.1.3 | Add `aria-live` status region |
| **Date Picker** | Native vs custom picker | ⚠️ Implementation unknown | ⚠️ No clear guidance | High - Complex ARIA | Strong recommendation: use native `<input type="date">` |

**Severity**: Critical gaps affect WCAG Level A or AA compliance and MUST be addressed before migration.

---

### 6.2 Moderate Gaps (Should Address)

| Component | Gap | DaisyUI Status | HyperUI Status | Impact | Remediation |
|-----------|-----|----------------|----------------|--------|-------------|
| **Modal** | `aria-labelledby` usage | ⚠️ Not implemented | ✅ Documented | Medium | Add `aria-labelledby` referencing modal title |
| **Toast** | Dismissible toast keyboard | ⚠️ Unknown | ⚠️ Partial | Medium | Ensure close button is focusable and has `aria-label` |
| **Badge** | Status badge semantics | ⚠️ Presentational only | ⚠️ No guidance | Low | Add `role="status"` for dynamic badges |
| **Button** | Toggle button state | ❌ Not implemented | ⚠️ Partial | Medium | Add `aria-pressed` for toggle buttons |
| **Form** | Helper text association | ⚠️ Partial (errors only) | ✅ Documented | Medium | Include hint IDs in `aria-describedby` |

**Severity**: Moderate gaps affect usability for assistive technology users but don't necessarily violate WCAG.

---

### 6.3 Minor Gaps (Nice to Have)

| Component | Gap | DaisyUI Status | HyperUI Status | Impact | Remediation |
|-----------|-----|----------------|----------------|--------|-------------|
| **Input** | Autocomplete attributes | ❌ Not implemented | ⚠️ No guidance | Low | Add `autocomplete` for common fields |
| **Input** | Input mode for mobile | ❌ Not implemented | ⚠️ No guidance | Low | Add `inputmode` attributes (numeric, email, tel) |
| **Textarea** | Character counter | ❌ Not implemented | ⚠️ No guidance | Low | Add live region for remaining characters |

**Severity**: Minor gaps are enhancements that improve user experience but are not required for compliance.

---

### 6.4 Gap Summary by WCAG Criterion

| WCAG Criterion | Affected Components | Gap Count | Severity |
|----------------|---------------------|-----------|----------|
| **1.3.1 Info and Relationships** | Radio, Checkbox | 1 | Critical |
| **2.1.1 Keyboard** | Modal, Toast, All Forms | 3 | Critical |
| **2.1.2 No Keyboard Trap** | Modal | 1 | Critical |
| **2.4.3 Focus Order** | Modal, Form | 2 | Critical |
| **3.3.1 Error Identification** | Form | 1 | Critical |
| **4.1.2 Name, Role, Value** | Button (loading), Radio | 2 | Critical |
| **4.1.3 Status Messages** | Toast, File Input | 2 | Critical |

**Total Critical Gaps**: 8
**Total Moderate Gaps**: 5
**Total Minor Gaps**: 3

---

## 7. Recommendations: Prioritized Enhancements

### 7.1 Priority 1: Critical (Must Do Before Launch)

**1. Implement Modal Focus Trap**
- **Effort**: 2-3 days
- **Impact**: High - prevents keyboard users from getting trapped
- **Implementation**: Stimulus controller with Tab event handling
- **Testing**: Keyboard-only navigation, screen reader testing

**2. Implement Modal Focus Return**
- **Effort**: 1 day
- **Impact**: High - restores user context after modal closes
- **Implementation**: Store trigger element reference, restore focus on close
- **Testing**: Open/close modals, verify focus returns

**3. Add Radio/Checkbox Fieldset Grouping**
- **Effort**: 1 day
- **Impact**: High - required for WCAG 1.3.1 compliance
- **Implementation**: Update templates to wrap groups in `<fieldset>` + `<legend>`
- **Testing**: Screen reader announces group label

**4. Enhance Button Loading State**
- **Effort**: 1 day
- **Impact**: High - informs screen reader users of loading state
- **Implementation**: Add `aria-busy="true"` and visually hidden loading text
- **Testing**: Screen reader announces "Loading, please wait"

**5. Implement Form Error Focus Management**
- **Effort**: 2 days
- **Impact**: High - guides users to errors after validation
- **Implementation**: Stimulus controller to focus first invalid field
- **Testing**: Submit form with errors, verify focus moves

**6. Add File Input Selection Announcement**
- **Effort**: 1 day
- **Impact**: Medium-High - confirms file selection to screen reader users
- **Implementation**: Add `aria-live="polite"` status region
- **Testing**: Select files, verify announcement

**7. Document Date Picker Strategy**
- **Effort**: 0.5 days
- **Impact**: High - prevents complex ARIA implementation
- **Recommendation**: Use native `<input type="date">` unless business requirement demands custom picker
- **Testing**: Native date picker keyboard navigation

**8. Enhance Toast Role Selection**
- **Effort**: 1 day
- **Impact**: Medium - improves announcement priority
- **Implementation**: Use `role="alert"` for errors, `role="status"` for info
- **Testing**: Screen reader announces appropriately

**Total Effort**: 9.5 days

---

### 7.2 Priority 2: Important (Should Do Before Launch)

**1. Add Modal `aria-labelledby`**
- **Effort**: 0.5 days
- **Impact**: Medium - improves modal identification
- **Implementation**: Reference modal title ID in `aria-labelledby`
- **Testing**: Screen reader announces modal title on open

**2. Ensure Toast Keyboard Dismissal**
- **Effort**: 1 day
- **Impact**: Medium - allows keyboard users to dismiss toasts
- **Implementation**: Focusable close button with `aria-label`
- **Testing**: Tab to close button, press Enter to dismiss

**3. Add Toggle Button ARIA States**
- **Effort**: 1 day
- **Impact**: Medium - announces toggle state to screen readers
- **Implementation**: Add `aria-pressed="true|false"` to toggle buttons
- **Testing**: Screen reader announces "pressed" or "not pressed"

**4. Enhance Form Field Helper Text**
- **Effort**: 0.5 days
- **Impact**: Medium - associates hints with inputs
- **Implementation**: Include hint IDs in `aria-describedby`
- **Testing**: Screen reader reads hints when focusing field

**5. Add Status Badge Semantics**
- **Effort**: 0.5 days
- **Impact**: Low-Medium - announces dynamic status changes
- **Implementation**: Add `role="status"` to status badges
- **Testing**: Screen reader announces badge changes

**Total Effort**: 3.5 days

---

### 7.3 Priority 3: Nice to Have (Post-Launch Enhancements)

**1. Add Autocomplete Attributes**
- **Effort**: 1 day
- **Impact**: Low - improves autofill UX
- **Implementation**: Add `autocomplete` to common fields (email, name, address)
- **Testing**: Browser autofill suggestions

**2. Add Input Mode Attributes**
- **Effort**: 0.5 days
- **Impact**: Low - optimizes mobile keyboards
- **Implementation**: Add `inputmode` (numeric, email, tel, url)
- **Testing**: Mobile device keyboard displays

**3. Add Textarea Character Counter**
- **Effort**: 1 day
- **Impact**: Low - informs users of remaining characters
- **Implementation**: Live region with character count
- **Testing**: Screen reader announces remaining characters

**4. Enhance Card Semantics**
- **Effort**: 0.5 days
- **Impact**: Low - improves content structure
- **Implementation**: Use `<article>`, proper heading hierarchy
- **Testing**: Screen reader navigation by landmarks

**Total Effort**: 3 days

---

### 7.4 Recommended Implementation Order

1. **Week 1**: Priority 1 Items 1-4 (Modal focus trap, focus return, fieldset grouping, button loading)
2. **Week 2**: Priority 1 Items 5-8 (Form error focus, file input announcement, date picker strategy, toast roles)
3. **Week 3**: Priority 2 Items 1-5 (Modal labeling, toast keyboard, toggle states, helper text, badge semantics)
4. **Post-Launch**: Priority 3 Items (Autocomplete, input mode, character counter, card semantics)

**Total Estimated Effort**: 16 days (3 weeks)

---

## 8. Testing Checklist

### 8.1 Keyboard-Only Navigation Testing

**Test Environment**: Disconnect mouse, use keyboard only

#### Modal Component
- [ ] Tab to button that opens modal
- [ ] Press Enter/Space to open modal
- [ ] Verify focus moves to first focusable element in modal
- [ ] Press Tab repeatedly, verify focus cycles within modal only
- [ ] Press Shift+Tab, verify reverse cycling
- [ ] Press Escape, verify modal closes
- [ ] Verify focus returns to trigger button after close
- [ ] Verify background content is not focusable while modal open

#### Toast Component
- [ ] Trigger toast notification
- [ ] Verify focus remains on current element (toast doesn't steal focus)
- [ ] Press Tab to find close button (if dismissible)
- [ ] Press Enter/Space on close button to dismiss
- [ ] Verify page remains fully navigable with toast present

#### Form Components
- [ ] Tab through all form fields in logical order
- [ ] Verify each field receives visible focus indicator
- [ ] Press Space on checkbox to toggle
- [ ] Tab to radio group, use Arrow keys to select
- [ ] Press Space on focused radio to select
- [ ] Tab to select field, press Space to open dropdown
- [ ] Use Arrow keys to navigate options
- [ ] Press Enter to select option
- [ ] Submit form with errors, verify focus moves to first invalid field

#### Button Component
- [ ] Tab to button
- [ ] Press Enter to activate
- [ ] Press Space to activate
- [ ] Verify disabled buttons are not focusable
- [ ] Verify loading buttons remain focused but don't activate

---

### 8.2 Screen Reader Testing

**Test Tools**: VoiceOver (macOS), NVDA (Windows), JAWS (Windows)

#### Modal Component
- [ ] Open modal, verify announcement: "Dialog, [Modal Title]"
- [ ] Navigate modal content, verify all elements announced
- [ ] Tab to close button, verify announcement: "Close modal, button"
- [ ] Press Escape, verify modal closes and focus returns
- [ ] Verify background content marked with `aria-hidden="true"` (if implemented)

#### Toast Component
- [ ] Trigger error toast, verify immediate announcement: "[Error message]"
- [ ] Trigger success toast, verify polite announcement: "[Success message]"
- [ ] Verify toast type (alert/status) affects announcement priority
- [ ] Navigate to close button, verify announcement: "Dismiss notification, button"

#### Form Components
- [ ] Focus input field, verify announcement: "[Label], [required if required], edit text"
- [ ] Focus field with error, verify announcement: "[Label], invalid entry, [error message], edit text"
- [ ] Focus field with hint, verify announcement: "[Label], [hint text], edit text"
- [ ] Focus checkbox, verify announcement: "[Label], checkbox, [checked/unchecked]"
- [ ] Focus radio group, verify announcement: "[Group label], radio group, [count] items"
- [ ] Navigate radio buttons, verify announcement: "[Label], radio button, [selected/unselected], [position] of [total]"
- [ ] Focus select field, verify announcement: "[Label], select, [current selection]"

#### Button Component
- [ ] Focus button, verify announcement: "[Button text], button"
- [ ] Focus icon-only button, verify announcement: "[aria-label], button"
- [ ] Focus loading button, verify announcement: "Loading, please wait, button, dimmed" (or similar)
- [ ] Focus toggle button, verify announcement: "[Button text], toggle button, [pressed/not pressed]"

#### Badge Component
- [ ] Navigate to status badge, verify announcement: "[Badge text], status" (if role="status")
- [ ] Navigate to presentational badge, verify announcement: "[Badge text]" (no role)

---

### 8.3 Color Contrast Testing

**Test Tools**:
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
- Chrome DevTools: Inspect → Accessibility → Contrast

#### Components to Test
- [ ] Button text on all variant backgrounds (4.5:1 minimum)
- [ ] Form labels and input text (4.5:1 minimum)
- [ ] Error messages on background (4.5:1 minimum)
- [ ] Toast text on toast background (4.5:1 minimum)
- [ ] Badge text on badge background (4.5:1 minimum)
- [ ] Focus indicators on all backgrounds (3:1 minimum)
- [ ] Close button icons (3:1 minimum for non-text)
- [ ] Placeholder text (may be lower than 4.5:1, but recommended to meet)

#### Test Procedure
1. Use color picker to identify foreground and background colors
2. Input colors into contrast checker
3. Verify ratio meets WCAG AA standard (4.5:1 for text, 3:1 for large text/UI components)
4. If fails, adjust colors and retest

---

### 8.4 Focus Visibility Testing

**Test Procedure**: Use keyboard navigation, verify visible focus indicators

#### All Components
- [ ] Tab to each interactive element
- [ ] Verify focus indicator is visible (outline, ring, or custom style)
- [ ] Verify focus indicator has 3:1 contrast with background
- [ ] Verify focus indicator is at least 2px thick
- [ ] Verify focus indicator is not obscured by other elements
- [ ] Test in light and dark mode (if applicable)

#### Specific Tests
- [ ] Modal: Verify focus visible on first element when opened
- [ ] Form fields: Verify focus ring on all input types
- [ ] Buttons: Verify focus ring or outline
- [ ] Links: Verify focus outline
- [ ] Custom controls: Verify programmatic focus matches visual focus

---

### 8.5 Automated Accessibility Testing

**Test Tools**:
- axe DevTools (Chrome/Firefox extension)
- Lighthouse (Chrome DevTools)
- pa11y (CI integration)

#### Test Procedure
1. Run automated scan on each component page
2. Review identified issues (sort by severity)
3. Fix critical and serious issues
4. Retest after fixes
5. Document false positives or known issues

#### Common Issues to Watch For
- Missing alt text on images
- Insufficient color contrast
- Missing form labels
- Missing ARIA attributes
- Incorrect heading hierarchy
- Missing skip links
- Duplicate IDs

---

### 8.6 Manual Accessibility Review

#### Components to Review
- [ ] All form fields have associated labels (explicit `for` attribute or `aria-label`)
- [ ] All required fields marked with `aria-required="true"` or `required`
- [ ] All error states marked with `aria-invalid="true"`
- [ ] All error messages linked via `aria-describedby`
- [ ] All icons have `aria-hidden="true"` or descriptive `aria-label`
- [ ] All interactive elements are keyboard accessible
- [ ] All modals trap focus and return focus on close
- [ ] All toasts use `role="alert"` or `role="status"` appropriately
- [ ] All buttons have accessible names (text, `aria-label`, or `aria-labelledby`)
- [ ] All custom controls have appropriate ARIA roles

---

## 9. WAI-ARIA References

### 9.1 Official ARIA Authoring Practices Guide

**Primary Resource**: [WAI-ARIA Authoring Practices Guide (APG)](https://www.w3.org/WAI/ARIA/apg/)

This comprehensive guide provides implementation patterns for common widgets and design patterns.

---

### 9.2 Component-Specific References

#### Modal Dialog
- **Pattern**: [Dialog (Modal) Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/)
- **Example**: [Modal Dialog Example](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/dialog/)
- **Key Points**:
  - Use `role="dialog"` and `aria-modal="true"`
  - Provide `aria-labelledby` and `aria-describedby`
  - Implement focus trap and keyboard navigation
  - Return focus to trigger element on close

#### Alert
- **Pattern**: [Alert Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/alert/)
- **Key Points**:
  - Use `role="alert"` for important messages
  - Use `aria-live="assertive"` for critical alerts
  - Use `aria-live="polite"` for regular notifications
  - Don't use for static error messages (use `aria-describedby` instead)

#### Form Fields
- **Pattern**: [Form Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/form/)
- **Key Points**:
  - Use explicit label association (`<label for="">`)
  - Use `aria-required` for required fields
  - Use `aria-invalid` for validation errors
  - Use `aria-describedby` to link to error messages and hints

#### Radio Group
- **Pattern**: [Radio Group Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/radio/)
- **Example**: [Radio Group Example](https://www.w3.org/WAI/ARIA/apg/patterns/radio/examples/radio/)
- **Key Points**:
  - Wrap in `<fieldset>` with `<legend>`
  - Use Arrow keys for selection, not Tab
  - Focus moves to checked radio (or first if none checked)

#### Button
- **Pattern**: [Button Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/button/)
- **Example**: [Button Examples](https://www.w3.org/WAI/ARIA/apg/patterns/button/examples/button/)
- **Key Points**:
  - Use `<button>` element when possible
  - Provide accessible name via text, `aria-label`, or `aria-labelledby`
  - Use `aria-pressed` for toggle buttons
  - Use `aria-expanded` for buttons controlling visibility

#### Combobox (Custom Select)
- **Pattern**: [Combobox Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/)
- **Example**: [Combobox with Listbox Popup](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-select-only/)
- **Key Points**:
  - Complex pattern, recommend native `<select>` instead
  - Requires `role="combobox"`, `aria-expanded`, `aria-controls`
  - Requires listbox popup with `role="listbox"` and `role="option"`
  - Extensive keyboard support (Arrow keys, Home, End, Page Up/Down)

#### Date Picker
- **Pattern**: [Date Picker Dialog Example](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/datepicker-dialog/)
- **Key Points**:
  - Extremely complex pattern (grid navigation, month/year selection)
  - **Strong recommendation**: Use native `<input type="date">`
  - Custom pickers require weeks of accessibility work
  - Fallback to text input for AT users

---

### 9.3 WCAG 2.1 Guidelines

**Official Standard**: [Web Content Accessibility Guidelines (WCAG) 2.1](https://www.w3.org/TR/WCAG21/)

#### Relevant Success Criteria for Component Migration

**Level A (Must Meet)**:
- [1.3.1 Info and Relationships](https://www.w3.org/WAI/WCAG21/Understanding/info-and-relationships.html) - Semantic structure, label associations
- [2.1.1 Keyboard](https://www.w3.org/WAI/WCAG21/Understanding/keyboard.html) - All functionality keyboard accessible
- [2.1.2 No Keyboard Trap](https://www.w3.org/WAI/WCAG21/Understanding/no-keyboard-trap.html) - Focus not trapped (except modals)
- [2.4.3 Focus Order](https://www.w3.org/WAI/WCAG21/Understanding/focus-order.html) - Logical tab order
- [3.3.1 Error Identification](https://www.w3.org/WAI/WCAG21/Understanding/error-identification.html) - Errors clearly identified
- [3.3.2 Labels or Instructions](https://www.w3.org/WAI/WCAG21/Understanding/labels-or-instructions.html) - All inputs labeled
- [4.1.2 Name, Role, Value](https://www.w3.org/WAI/WCAG21/Understanding/name-role-value.html) - ARIA roles and states

**Level AA (Must Meet)**:
- [1.4.3 Contrast (Minimum)](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html) - 4.5:1 text contrast
- [1.4.11 Non-text Contrast](https://www.w3.org/WAI/WCAG21/Understanding/non-text-contrast.html) - 3:1 UI component contrast
- [2.4.7 Focus Visible](https://www.w3.org/WAI/WCAG21/Understanding/focus-visible.html) - Visible focus indicators
- [3.3.3 Error Suggestion](https://www.w3.org/WAI/WCAG21/Understanding/error-suggestion.html) - Provide error correction suggestions
- [4.1.3 Status Messages](https://www.w3.org/WAI/WCAG21/Understanding/status-messages.html) - Status announced to AT

---

### 9.4 Additional Resources

#### Testing Tools
- **axe DevTools**: https://www.deque.com/axe/devtools/
- **WAVE Browser Extension**: https://wave.webaim.org/extension/
- **Lighthouse**: Built into Chrome DevTools
- **pa11y**: https://pa11y.org/ (CI integration)

#### Screen Readers
- **NVDA (Windows, Free)**: https://www.nvaccess.org/
- **JAWS (Windows, Commercial)**: https://www.freedomscientific.com/products/software/jaws/
- **VoiceOver (macOS/iOS, Built-in)**: Enable in System Preferences → Accessibility

#### Color Contrast
- **WebAIM Contrast Checker**: https://webaim.org/resources/contrastchecker/
- **Colorable**: https://colorable.jxnblk.com/
- **Contrast Ratio**: https://contrast-ratio.com/

#### Educational Resources
- **WebAIM**: https://webaim.org/ (Articles, training, resources)
- **The A11Y Project**: https://www.a11yproject.com/ (Checklist, resources)
- **MDN Accessibility**: https://developer.mozilla.org/en-US/docs/Web/Accessibility
- **Inclusive Components**: https://inclusive-components.design/ (Component patterns)

---

## 10. Document Changelog

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-19 | Claude Code | Initial comprehensive accessibility analysis |

---

## Appendix A: Quick Reference - Component Accessibility Checklist

### Modal
- [ ] `role="dialog"` and `aria-modal="true"`
- [ ] `aria-labelledby` referencing title
- [ ] `aria-describedby` referencing content
- [ ] Focus trap implemented
- [ ] ESC key closes modal
- [ ] Focus returns to trigger on close
- [ ] Backdrop dismisses modal

### Toast
- [ ] `role="alert"` (errors) or `role="status"` (info)
- [ ] `aria-live="assertive"` (errors) or `aria-live="polite"` (info)
- [ ] `aria-atomic="true"`
- [ ] Dismissible toast has focusable close button with `aria-label`
- [ ] Does NOT steal focus

### Form Input
- [ ] Explicit `<label for="">` association
- [ ] `aria-required="true"` when required
- [ ] `aria-invalid="true"` when error
- [ ] `aria-describedby` links to hint and error
- [ ] Unique `id` on input

### Form Select
- [ ] Same as Form Input
- [ ] Use native `<select>` element
- [ ] Avoid custom dropdowns unless absolutely necessary

### Form Checkbox
- [ ] Explicit `<label for="">` association
- [ ] `aria-required="true"` when required
- [ ] `aria-invalid="true"` when error
- [ ] Groups wrapped in `<fieldset>` with `<legend>`

### Form Radio
- [ ] Wrapped in `<fieldset>` with `<legend>`
- [ ] Each radio has explicit label
- [ ] `aria-describedby` on each radio for shared error
- [ ] Arrow key navigation between radios

### Form Textarea
- [ ] Same as Form Input
- [ ] Character counter in `aria-live="polite"` region (optional)

### Form File Input
- [ ] Same as Form Input
- [ ] `aria-live="polite"` status region announces selection
- [ ] Custom drop zone has `role="button"`, `tabindex="0"`, `aria-labelledby`

### Form Date Picker
- [ ] **Recommended**: Use native `<input type="date">`
- [ ] If custom: Full ARIA grid pattern (very complex)

### Form Error
- [ ] `role="alert"` or `aria-live="polite"`
- [ ] `aria-atomic="true"`
- [ ] Unique `id` for `aria-describedby` linking
- [ ] Icon has `aria-hidden="true"`

### Button
- [ ] Accessible name (text, `aria-label`, or `aria-labelledby`)
- [ ] `aria-busy="true"` when loading
- [ ] `aria-pressed="true|false"` for toggles
- [ ] `aria-expanded="true|false"` for dropdowns
- [ ] Icons have `aria-hidden="true"`

### Badge
- [ ] `role="status"` for dynamic status badges
- [ ] Dismissible badges have focusable button with `aria-label`
- [ ] Icon has `aria-hidden="true"`

### Card
- [ ] Use `<article>` for independent content
- [ ] Proper heading hierarchy
- [ ] Interactive cards have single focusable element
- [ ] Link has descriptive `aria-label` if needed

---

**End of Accessibility Analysis Document**
