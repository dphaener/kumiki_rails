# Toast Component Migration Guide

**Component**: Toast (Notification)
**DaisyUI Baseline**: [DaisyUI Toast](https://daisyui.com/components/toast/)
**HyperUI Target**: Custom Toast Pattern
**Migration Complexity**: Moderate
**Last Updated**: 2025-11-19

---

## Table of Contents

1. [Overview](#overview)
2. [Variant Analysis](#variant-analysis)
3. [HTML Structure Comparison](#html-structure-comparison)
4. [Accessibility Requirements](#accessibility-requirements)
5. [JavaScript Requirements](#javascript-requirements)
6. [HTML Patterns Used](#html-patterns-used)
7. [Migration Guide](#migration-guide)
8. [Testing Considerations](#testing-considerations)
9. [Implementation Checklist](#implementation-checklist)

---

## Overview

### Component Purpose

The Toast component provides temporary, non-intrusive notifications that appear at the edge of the screen. They communicate success, errors, warnings, or information without interrupting the user's workflow. Toasts auto-dismiss after a timeout or can be manually closed.

### Current DaisyUI Implementation

**Location**: `/lib/kumiki/components/toast.rb`

DaisyUI uses semantic classes with positioning:
- Base class: `.toast`
- Position: `.toast-top`, `.toast-bottom`, `.toast-start`, `.toast-end`
- Content: Uses `.alert` component internally

**Philosophy**: Semantic positioning with semantic alert content.

### HyperUI Target

HyperUI provides utility-based notification patterns:
- Fixed positioning with explicit coordinates
- Border accent styling for severity
- Icon + message + dismiss button layout
- Utility-first composition

**Philosophy**: Utility composition with direct positioning control.

### Migration Complexity Rating: Moderate

**Justification**:
- **Pro**: Simple HTML structure
- **Pro**: Clear positioning utilities
- **Con**: Role-based ARIA logic required (alert vs status)
- **Con**: Auto-dismiss JavaScript logic
- **Con**: Multiple toast stacking management
- **Critical**: WCAG 4.1.3 Status Messages compliance

---

## Variant Analysis

### DaisyUI Variants Available

#### Position Variants (6)

```html
<div class="toast toast-top toast-start">Top Left</div>
<div class="toast toast-top toast-center">Top Center</div>
<div class="toast toast-top toast-end">Top Right</div>
<div class="toast toast-bottom toast-start">Bottom Left</div>
<div class="toast toast-bottom toast-center">Bottom Center</div>
<div class="toast toast-bottom toast-end">Bottom Right (default)</div>
```

#### Content Variants (4)

```html
<div class="toast">
  <div class="alert alert-success">Success notification</div>
</div>

<div class="toast">
  <div class="alert alert-error">Error notification</div>
</div>

<div class="toast">
  <div class="alert alert-warning">Warning notification</div>
</div>

<div class="toast">
  <div class="alert alert-info">Info notification</div>
</div>
```

### HyperUI Variants Available

#### Position Variants

```html
<!-- Bottom Right (default) -->
<div class="fixed bottom-4 right-4 z-50">...</div>

<!-- Top Right -->
<div class="fixed top-4 right-4 z-50">...</div>

<!-- Top Center -->
<div class="fixed top-4 left-1/2 -translate-x-1/2 z-50">...</div>

<!-- Bottom Left -->
<div class="fixed bottom-4 left-4 z-50">...</div>
```

#### Style Variants

```html
<!-- Border Accent (Recommended) -->
<div class="flex items-center gap-4 rounded-lg border-l-4 border-green-600 bg-white p-4 shadow-lg">
  <span class="text-green-600">✓</span>
  <p class="text-gray-900">Success message</p>
  <button aria-label="Dismiss">×</button>
</div>

<!-- Colored Background -->
<div class="flex items-center gap-4 rounded-lg bg-green-50 p-4 shadow-lg">
  <span class="text-green-600">✓</span>
  <p class="text-green-900">Success message</p>
  <button class="text-green-600">×</button>
</div>

<!-- Simple (White Background) -->
<div class="flex items-center gap-4 rounded-lg border border-gray-200 bg-white p-4 shadow-lg">
  <span class="text-green-600">✓</span>
  <p class="text-gray-900">Success message</p>
  <button class="text-gray-400">×</button>
</div>
```

### Variant Gaps

#### Critical Accessibility Gap

**WCAG 4.1.3 Status Messages**: DaisyUI uses generic `.alert` which may not differentiate between critical alerts (errors) and non-critical status updates (success).

**Solution**: Implement role-based logic:
- `role="alert"` + `aria-live="assertive"` for errors/warnings
- `role="status"` + `aria-live="polite"` for success/info

### Variant Mapping Table

| DaisyUI Variant | HyperUI Equivalent | Implementation |
|-----------------|-------------------|----------------|
| `.toast` | `fixed z-50` + position utilities | Direct mapping |
| `.toast-top` | `top-4` | Direct mapping |
| `.toast-bottom` | `bottom-4` | Direct mapping |
| `.toast-start` | `left-4` | Direct mapping |
| `.toast-end` | `right-4` | Direct mapping |
| `.toast-center` | `left-1/2 -translate-x-1/2` | Direct mapping |
| `.alert` (success) | `border-l-4 border-green-600` | Direct mapping |
| `.alert` (error) | `border-l-4 border-red-600` | Direct mapping |
| `.alert` (warning) | `border-l-4 border-yellow-600` | Direct mapping |
| `.alert` (info) | `border-l-4 border-blue-600` | Direct mapping |

---

## HTML Structure Comparison

### Current DaisyUI Structure

```erb
<%= tag.div(class: "toast toast-end") do %>
  <%= tag.div(class: "alert alert-success") do %>
    <span>Success! Your changes have been saved.</span>
  <% end %>
<% end %>
```

**Generated HTML**:
```html
<div class="toast toast-end">
  <div class="alert alert-success">
    <span>Success! Your changes have been saved.</span>
  </div>
</div>
```

### HyperUI Target Structure

```html
<!-- Toast Container (Fixed Position) -->
<div class="fixed bottom-4 right-4 z-50">
  <!-- Single Toast -->
  <div
    role="status"
    aria-live="polite"
    aria-atomic="true"
    class="flex items-center gap-4 rounded-lg border-l-4 border-green-600 bg-white p-4 shadow-lg"
    data-controller="toast"
    data-toast-timeout-value="5000"
  >
    <!-- Icon -->
    <span class="text-green-600">
      <svg class="h-5 w-5" aria-hidden="true" focusable="false" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
      </svg>
    </span>

    <!-- Message -->
    <p class="flex-1 text-sm font-medium text-gray-900">
      Success! Your changes have been saved.
    </p>

    <!-- Dismiss Button -->
    <button
      type="button"
      class="text-gray-400 hover:text-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
      aria-label="Dismiss notification"
      data-action="click->toast#dismiss"
    >
      <svg class="h-5 w-5" aria-hidden="true" focusable="false" fill="currentColor" viewBox="0 0 20 20">
        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"/>
      </svg>
    </button>
  </div>
</div>
```

### Key Structural Differences

1. **Container**: DaisyUI nested structure vs HyperUI flat structure
2. **ARIA Roles**: HyperUI requires explicit `role="alert"` or `role="status"`
3. **Layout**: HyperUI uses flexbox with explicit gap for spacing
4. **Icons**: HyperUI includes inline SVG icons
5. **Dismiss Button**: HyperUI adds explicit close button with aria-label

---

## Accessibility Requirements

### ARIA Attributes Required

#### Critical vs Non-Critical Messages

**Critical (Errors, Warnings)**:
```html
<div
  role="alert"
  aria-live="assertive"
  aria-atomic="true"
  class="..."
>
  Error: Failed to save changes.
</div>
```

**Non-Critical (Success, Info)**:
```html
<div
  role="status"
  aria-live="polite"
  aria-atomic="true"
  class="..."
>
  Success: Changes saved.
</div>
```

**Required Attributes**:
- `role="alert"` or `role="status"`: Semantic role for screen readers
- `aria-live="assertive"` or `aria-live="polite"`: Announcement priority
- `aria-atomic="true"`: Announce full message, not just changes
- `aria-label="Dismiss notification"`: Context for close button

### Role Selection Logic

```ruby
def aria_role
  case type.to_sym
  when :error, :danger, :warning
    "alert"  # Critical messages
  when :success, :info, :notice
    "status"  # Non-critical notifications
  else
    "status"
  end
end

def aria_live_level
  case type.to_sym
  when :error, :danger
    "assertive"  # Interrupts screen reader
  else
    "polite"  # Waits for pause
  end
end
```

### Keyboard Navigation

**Required Keyboard Support**:
- **Tab**: Focus dismiss button (if dismissible)
- **Enter/Space**: Dismiss toast
- **Escape**: Dismiss focused toast (optional)

**Implementation Notes**:
- Toast MUST NOT steal focus when appearing
- User can continue interacting with page
- Dismiss button is keyboard accessible

### Screen Reader Considerations

**Announcement Behavior**:
1. Toast appears: Message announced immediately (assertive) or after pause (polite)
2. User continues workflow: No focus change
3. User tabs to dismiss button: "Dismiss notification, button"
4. User presses Enter: Toast dismissed

---

## JavaScript Requirements

### REQUIRED: Stimulus Toast Controller

```javascript
// app/javascript/controllers/toast_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    timeout: { type: Number, default: 5000 },
    dismissible: { type: Boolean, default: true }
  }

  connect() {
    // Auto-dismiss after timeout
    if (this.timeoutValue > 0) {
      this.timeoutId = setTimeout(() => {
        this.dismiss()
      }, this.timeoutValue)
    }

    // Add entrance animation
    this.element.classList.add("animate-slide-in")
  }

  disconnect() {
    // Clear timeout if component removed
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  dismiss() {
    // Add exit animation
    this.element.classList.add("animate-slide-out")

    // Remove from DOM after animation
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  pauseTimeout() {
    // Pause auto-dismiss when hovering
    if (this.timeoutId) {
      clearTimeout(this.timeoutId)
    }
  }

  resumeTimeout() {
    // Resume auto-dismiss when leaving
    if (this.timeoutValue > 0 && !this.isDismissed) {
      this.timeoutId = setTimeout(() => {
        this.dismiss()
      }, this.timeoutValue)
    }
  }
}
```

### Toast Manager (Multiple Toasts)

```javascript
// app/javascript/controllers/toast_manager_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  show(type, message, options = {}) {
    const toast = this.createToast(type, message, options)
    this.containerTarget.appendChild(toast)
  }

  createToast(type, message, options) {
    const toast = document.createElement("div")
    toast.setAttribute("data-controller", "toast")
    toast.setAttribute("data-toast-timeout-value", options.timeout || 5000)
    toast.setAttribute("role", this.getRoleForType(type))
    toast.setAttribute("aria-live", this.getAriaLiveForType(type))
    toast.setAttribute("aria-atomic", "true")
    toast.className = this.getClassesForType(type)
    toast.innerHTML = this.getToastHTML(type, message)

    return toast
  }

  getRoleForType(type) {
    return ["error", "warning"].includes(type) ? "alert" : "status"
  }

  getAriaLiveForType(type) {
    return ["error", "danger"].includes(type) ? "assertive" : "polite"
  }

  getClassesForType(type) {
    const baseClasses = "flex items-center gap-4 rounded-lg p-4 shadow-lg"
    const colorMap = {
      success: "border-l-4 border-green-600 bg-white",
      error: "border-l-4 border-red-600 bg-white",
      warning: "border-l-4 border-yellow-600 bg-white",
      info: "border-l-4 border-blue-600 bg-white"
    }

    return `${baseClasses} ${colorMap[type] || colorMap.info}`
  }

  getToastHTML(type, message) {
    const iconColor = this.getIconColorForType(type)
    const icon = this.getIconForType(type)

    return `
      <span class="${iconColor}">
        ${icon}
      </span>
      <p class="flex-1 text-sm font-medium text-gray-900">${message}</p>
      <button
        type="button"
        class="text-gray-400 hover:text-gray-600"
        aria-label="Dismiss notification"
        data-action="click->toast#dismiss"
      >×</button>
    `
  }

  getIconColorForType(type) {
    const colorMap = {
      success: "text-green-600",
      error: "text-red-600",
      warning: "text-yellow-600",
      info: "text-blue-600"
    }
    return colorMap[type] || colorMap.info
  }

  getIconForType(type) {
    // Return SVG icon for type
    // Simplified here, use full SVG in production
    const iconMap = {
      success: "✓",
      error: "✕",
      warning: "⚠",
      info: "ℹ"
    }
    return iconMap[type] || iconMap.info
  }
}
```

---

## HTML Patterns Used

### Pattern 1: Overlay Pattern (Fixed Positioning)

```html
<div class="fixed bottom-4 right-4 z-50">
  <!-- Toast content -->
</div>
```

**Purpose**: Position toast at screen edge without affecting layout.

### Pattern 2: Notification Pattern

```html
<div class="flex items-center gap-4 rounded-lg border-l-4 border-green-600 bg-white p-4 shadow-lg">
  <span class="text-green-600">Icon</span>
  <p class="flex-1">Message</p>
  <button>Dismiss</button>
</div>
```

**Purpose**: Icon + message + dismiss button layout.

### Pattern 3: Focus Ring Pattern

```html
<button class="... focus:outline-none focus:ring-2 focus:ring-blue-500">
  Dismiss
</button>
```

**Purpose**: Visible keyboard focus indicator.

---

## Migration Guide

### Step 1: Update Component Class

```ruby
# lib/kumiki/components/toast.rb
class Toast < Kumiki::Component
  option :type, default: -> { :info }
  option :message
  option :position_x, default: -> { :right }
  option :position_y, default: -> { :bottom }
  option :style, default: -> { :border_accent }
  option :dismissible, default: -> { true }
  option :timeout, default: -> { 5000 }

  def container_classes
    ["fixed", "z-50", position_classes].join(" ")
  end

  def toast_classes
    [
      "flex", "items-center", "gap-4",
      "rounded-lg", "p-4", "shadow-lg",
      style_classes
    ].join(" ")
  end

  def aria_role
    ARIA_ROLES[type] || "status"
  end

  def aria_live
    ARIA_LIVE_LEVELS[type] || "polite"
  end

  def icon_classes
    ICON_COLORS[type] || ICON_COLORS[:info]
  end

  private

  def position_classes
    y_class = position_y == :top ? "top-4" : "bottom-4"
    x_class = case position_x
    when :left then "left-4"
    when :center then "left-1/2 -translate-x-1/2"
    when :right then "right-4"
    else "right-4"
    end

    "#{y_class} #{x_class}"
  end

  def style_classes
    case style
    when :border_accent
      "border-l-4 #{border_color} bg-white"
    when :colored_bg
      "#{bg_color}"
    when :simple
      "border border-gray-200 bg-white"
    end
  end

  def border_color
    BORDER_COLORS[type] || BORDER_COLORS[:info]
  end

  def bg_color
    BG_COLORS[type] || BG_COLORS[:info]
  end

  ARIA_ROLES = {
    error: "alert",
    danger: "alert",
    warning: "alert",
    success: "status",
    info: "status",
    notice: "status"
  }.freeze

  ARIA_LIVE_LEVELS = {
    error: "assertive",
    danger: "assertive",
    warning: "polite",
    success: "polite",
    info: "polite",
    notice: "polite"
  }.freeze

  BORDER_COLORS = {
    success: "border-green-600",
    error: "border-red-600",
    warning: "border-yellow-600",
    info: "border-blue-600"
  }.freeze

  BG_COLORS = {
    success: "bg-green-50",
    error: "bg-red-50",
    warning: "bg-yellow-50",
    info: "bg-blue-50"
  }.freeze

  ICON_COLORS = {
    success: "text-green-600",
    error: "text-red-600",
    warning: "text-yellow-600",
    info: "text-blue-600"
  }.freeze
end
```

### Step 2: Update Template

```erb
<%= tag.div(class: container_classes) do %>
  <%= tag.div(
    class: toast_classes,
    role: aria_role,
    "aria-live": aria_live,
    "aria-atomic": "true",
    data: {
      controller: "toast",
      toast_timeout_value: timeout,
      toast_dismissible_value: dismissible
    }
  ) do %>
    <!-- Icon -->
    <%= tag.span(class: icon_classes) do %>
      <%= icon_svg %>
    <% end %>

    <!-- Message -->
    <%= tag.p(message, class: "flex-1 text-sm font-medium text-gray-900") %>

    <!-- Dismiss Button -->
    <% if dismissible %>
      <%= tag.button(
        type: "button",
        class: "text-gray-400 hover:text-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500",
        "aria-label": "Dismiss notification",
        data: { action: "click->toast#dismiss" }
      ) do %>
        ×
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

---

## Testing Considerations

### Accessibility Testing

**Critical Tests**:
1. Role changes based on type (alert vs status)
2. aria-live changes based on severity
3. Screen reader announces message
4. Dismiss button keyboard accessible
5. Icon has aria-hidden="true"

### Functional Testing

```ruby
RSpec.describe Toast, type: :component do
  it "renders error as alert" do
    result = render_inline(Toast.new(type: :error, message: "Error"))
    expect(result.css('[role="alert"]').count).to eq(1)
    expect(result.css('[aria-live="assertive"]').count).to eq(1)
  end

  it "renders success as status" do
    result = render_inline(Toast.new(type: :success, message: "Success"))
    expect(result.css('[role="status"]').count).to eq(1)
    expect(result.css('[aria-live="polite"]').count).to eq(1)
  end

  it "includes dismiss button when dismissible" do
    result = render_inline(Toast.new(message: "Test", dismissible: true))
    expect(result.css('[aria-label="Dismiss notification"]').count).to eq(1)
  end
end
```

---

## Implementation Checklist

### Development

- [ ] Implement position_classes method
- [ ] Implement style_classes method
- [ ] Implement aria_role method with role logic
- [ ] Implement aria_live method with severity logic
- [ ] Add icon rendering with aria-hidden
- [ ] Add dismiss button with aria-label
- [ ] Implement Stimulus controller with auto-dismiss
- [ ] Implement pause/resume on hover
- [ ] Implement toast stacking logic
- [ ] Add entrance/exit animations

### Testing

- [ ] Write role selection tests
- [ ] Write aria-live tests
- [ ] Write position tests
- [ ] Write style variant tests
- [ ] Perform manual screen reader testing
- [ ] Verify auto-dismiss timing
- [ ] Test multiple toast stacking

### Documentation

- [ ] Document role selection logic
- [ ] Document ARIA requirements
- [ ] Add Storybook stories
- [ ] Update design system docs

---

**Status**: Ready for Implementation
**Estimated Effort**: 2-3 days
**Priority**: High (WCAG compliance critical)
