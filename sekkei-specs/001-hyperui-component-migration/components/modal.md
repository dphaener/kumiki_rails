# Modal Component Migration Guide

**Component**: Modal (Dialog)
**DaisyUI Baseline**: [DaisyUI Modal](https://daisyui.com/components/modal/)
**HyperUI Target**: Custom Modal Pattern
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

The Modal component displays content in a layer above the main application, blocking interaction with the underlying page until dismissed. It is used for confirmations, forms, alerts, and detailed content views that require user attention.

### Current DaisyUI Implementation

**Location**: `/lib/kumiki/components/modal.rb`

DaisyUI uses the native HTML `<dialog>` element with DaisyUI classes:
- Base element: `<dialog>` with `.modal` class
- Modal box: `.modal-box` for content container
- Modal backdrop: `.modal-backdrop` for overlay
- Close action: `.modal-action` for action buttons

**Philosophy**: Leverage native `<dialog>` API with semantic class names.

**Key Feature**: Native `showModal()` and `close()` methods.

### HyperUI Target

HyperUI provides utility-based modal patterns:
- Fixed full-screen overlay with `fixed inset-0`
- Centered content with flexbox
- Semi-transparent backdrop
- Utility classes for sizing and styling

**Philosophy**: Utility composition with manual focus management.

**Key Difference**: Custom implementation instead of native `<dialog>`.

### Migration Complexity Rating: Moderate

**Justification**:
- **Pro**: Simple HTML structure
- **Pro**: Well-documented ARIA patterns
- **Con**: Complex JavaScript for focus trap
- **Con**: Must implement focus return manually
- **Con**: Keyboard event handling required (ESC key)
- **Critical**: WCAG 2.1 AA compliance requires focus management

---

## Variant Analysis

### DaisyUI Variants Available

#### Size Variants (3)

```html
<dialog class="modal modal-sm">Small Modal</dialog>
<dialog class="modal modal-md">Medium Modal</dialog>
<dialog class="modal modal-lg">Large Modal</dialog>
```

#### Position Variants (3)

```html
<dialog class="modal modal-top">Top Positioned</dialog>
<dialog class="modal modal-middle">Center (default)</dialog>
<dialog class="modal modal-bottom">Bottom Positioned</dialog>
```

#### Style Variants

```html
<!-- Standard modal -->
<dialog class="modal">
  <div class="modal-box">Content</div>
</dialog>

<!-- Responsive modal (full-screen on mobile) -->
<dialog class="modal">
  <div class="modal-box w-11/12 max-w-5xl">Content</div>
</dialog>
```

### HyperUI Variants Available

HyperUI provides utility-based variations:

#### Size Variants

```html
<!-- Small -->
<div class="... max-w-sm">Content</div>

<!-- Medium -->
<div class="... max-w-md">Content</div>

<!-- Large -->
<div class="... max-w-lg">Content</div>

<!-- Extra Large -->
<div class="... max-w-2xl">Content</div>
```

#### Position Variants

```html
<!-- Center (default) -->
<div class="fixed inset-0 flex items-center justify-center">...</div>

<!-- Top -->
<div class="fixed inset-0 flex items-start justify-center pt-20">...</div>

<!-- Bottom -->
<div class="fixed inset-0 flex items-end justify-center pb-20">...</div>
```

#### Layout Variants

```html
<!-- Simple Modal -->
<div class="relative w-full max-w-md rounded-lg bg-white p-6">
  <h2>Title</h2>
  <p>Content</p>
  <div class="flex gap-2">Actions</div>
</div>

<!-- Sectioned Modal (Header/Body/Footer) -->
<div class="relative w-full max-w-lg overflow-hidden rounded-lg bg-white">
  <div class="border-b border-gray-200 px-6 py-4">
    <h2>Header</h2>
  </div>
  <div class="px-6 py-4">Body</div>
  <div class="border-t border-gray-200 bg-gray-50 px-6 py-4">
    Footer
  </div>
</div>
```

### Variant Gaps

#### DaisyUI → HyperUI Gaps

1. **Native Dialog**: DaisyUI uses `<dialog>` element, HyperUI uses custom `<div>`
   - **Solution**: Implement custom dialog with ARIA attributes

2. **Backdrop Dismissal**: DaisyUI `.modal-backdrop` has built-in click-to-close
   - **Solution**: Add JavaScript click handler on backdrop

3. **ESC Key**: Native dialog supports ESC key automatically
   - **Solution**: Add keyboard event listener for ESC

### Variant Mapping Table

| DaisyUI Variant | HyperUI Equivalent | Implementation |
|-----------------|-------------------|----------------|
| `<dialog class="modal">` | `<div class="fixed inset-0..." role="dialog">` | Custom implementation |
| `.modal-box` | `<div class="relative w-full max-w-md...">` | Direct mapping |
| `.modal-backdrop` | `<div class="fixed inset-0 bg-black/50">` | Direct mapping |
| `.modal-sm` | `max-w-sm` | Direct mapping |
| `.modal-md` | `max-w-md` | Direct mapping |
| `.modal-lg` | `max-w-lg` | Direct mapping |
| `.modal-top` | `items-start pt-20` | Direct mapping |
| `.modal-middle` | `items-center` | Direct mapping |
| `.modal-bottom` | `items-end pb-20` | Direct mapping |

---

## HTML Structure Comparison

### Current DaisyUI Structure

```erb
<%= tag.dialog(
  id: "modal-#{id}",
  class: "modal",
  data: { controller: "modal" }
) do %>
  <div class="modal-box">
    <h3 class="font-bold text-lg"><%= title %></h3>
    <p class="py-4"><%= content %></p>
    <div class="modal-action">
      <button class="btn" onclick="this.closest('dialog').close()">Close</button>
      <button class="btn btn-primary">Confirm</button>
    </div>
  </div>
  <form method="dialog" class="modal-backdrop">
    <button>close</button>
  </form>
<% end %>
```

**Generated HTML**:
```html
<dialog id="modal-123" class="modal" data-controller="modal">
  <div class="modal-box">
    <h3 class="font-bold text-lg">Modal Title</h3>
    <p class="py-4">Modal content</p>
    <div class="modal-action">
      <button class="btn">Close</button>
      <button class="btn btn-primary">Confirm</button>
    </div>
  </div>
  <form method="dialog" class="modal-backdrop">
    <button>close</button>
  </form>
</dialog>
```

### HyperUI Target Structure

```html
<!-- Modal Overlay + Content -->
<div
  class="fixed inset-0 z-50 flex items-center justify-center bg-black/50"
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title"
  aria-describedby="modal-description"
  data-controller="modal"
  data-action="click->modal#clickBackdrop keydown->modal#handleKeydown"
>
  <!-- Modal Content -->
  <div
    class="relative w-full max-w-md rounded-lg bg-white p-6 shadow-xl"
    data-modal-target="content"
    data-action="click->modal#stopPropagation"
  >
    <!-- Close Button -->
    <button
      type="button"
      class="absolute right-4 top-4 text-gray-400 hover:text-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
      aria-label="Close dialog"
      data-action="click->modal#close"
    >
      <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>
    </button>

    <!-- Title -->
    <h2 id="modal-title" class="text-lg font-semibold text-gray-900">
      Modal Title
    </h2>

    <!-- Content -->
    <div id="modal-description" class="mt-2 text-sm text-gray-600">
      <p>Modal content goes here</p>
    </div>

    <!-- Actions -->
    <div class="mt-6 flex justify-end gap-2">
      <button
        type="button"
        class="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-blue-500"
        data-action="click->modal#close"
      >
        Cancel
      </button>
      <button
        type="button"
        class="rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
      >
        Confirm
      </button>
    </div>
  </div>
</div>
```

### Key Structural Differences

1. **Container Element**:
   - DaisyUI: `<dialog>` (native HTML element)
   - HyperUI: `<div role="dialog">` (custom implementation)

2. **Backdrop**:
   - DaisyUI: Separate `.modal-backdrop` with `<form method="dialog">`
   - HyperUI: Same div as overlay with click handler

3. **ARIA Attributes**:
   - DaisyUI: Minimal ARIA (relies on native `<dialog>`)
   - HyperUI: Full ARIA implementation required

4. **Close Mechanism**:
   - DaisyUI: `dialog.close()` method or form submission
   - HyperUI: JavaScript event handler

---

## Accessibility Requirements

### ARIA Attributes Required

```html
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title-id"
  aria-describedby="modal-description-id"
  tabindex="-1"
>
  <h2 id="modal-title-id">Modal Title</h2>
  <div id="modal-description-id">Modal content</div>
</div>
```

**Required Attributes**:
- `role="dialog"`: Identifies element as dialog
- `aria-modal="true"`: Indicates modal behavior (no interaction with background)
- `aria-labelledby`: References modal title element ID
- `aria-describedby`: References modal content element ID
- `tabindex="-1"`: Allows programmatic focus

### Keyboard Navigation

**Required Keyboard Support** (WCAG 2.1.1, 2.1.2):

| Key | Action | WCAG Criterion |
|-----|--------|----------------|
| **Tab** | Move to next focusable element within modal (circular) | 2.1.1 Keyboard |
| **Shift+Tab** | Move to previous focusable element within modal (circular) | 2.1.1 Keyboard |
| **Escape** | Close modal and return focus to trigger element | 2.1.1 Keyboard |
| **Enter/Space** | Activate focused button | 2.1.1 Keyboard |

**Implementation Notes**:
- Focus MUST be trapped within modal (no escaping to page)
- First Tab from last element returns to first element
- ESC key closes modal regardless of current focus
- Focus returns to element that opened modal

### Focus Management

**CRITICAL REQUIREMENTS** (WCAG 2.4.3 Focus Order):

1. **On Open**:
   - Store reference to element that triggered modal
   - Move focus to first focusable element or modal container
   - Trap focus within modal boundaries

2. **During Interaction**:
   - Tab cycles through focusable elements (circular)
   - No focus escapes modal
   - Background content is inert

3. **On Close**:
   - Return focus to trigger element
   - If trigger no longer exists, focus appropriate fallback
   - Remove modal from DOM

### Screen Reader Considerations

**Announcement Pattern**:
1. Modal opens: "Dialog, [Modal Title]"
2. Content announced: Modal description text
3. Interactive elements: "Button, [Button Label]"
4. Close: Focus returns to trigger

---

## JavaScript Requirements

### REQUIRED: Stimulus Modal Controller

```javascript
// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = {
    open: Boolean
  }

  connect() {
    if (this.openValue) {
      this.open()
    }
  }

  open() {
    // Store trigger element for focus return
    this.previousFocusedElement = document.activeElement

    // Show modal
    this.element.classList.remove("hidden")

    // Set initial focus
    this.setInitialFocus()

    // Trap focus
    this.trapFocus()

    // Prevent body scroll
    document.body.style.overflow = "hidden"
  }

  close() {
    // Hide modal
    this.element.classList.add("hidden")

    // Restore body scroll
    document.body.style.overflow = ""

    // Return focus to trigger
    if (this.previousFocusedElement && this.previousFocusedElement.focus) {
      this.previousFocusedElement.focus()
    }

    // Dispatch custom event for cleanup
    this.dispatch("closed")
  }

  clickBackdrop(event) {
    // Close if clicking backdrop (not content)
    if (event.target === this.element) {
      this.close()
    }
  }

  stopPropagation(event) {
    // Prevent clicks on content from closing modal
    event.stopPropagation()
  }

  handleKeydown(event) {
    if (event.key === "Escape") {
      event.preventDefault()
      this.close()
    } else if (event.key === "Tab") {
      this.handleTabKey(event)
    }
  }

  setInitialFocus() {
    // Find first focusable element
    const focusableElements = this.getFocusableElements()

    if (focusableElements.length > 0) {
      focusableElements[0].focus()
    } else {
      // No focusable elements, focus modal itself
      this.element.setAttribute("tabindex", "-1")
      this.element.focus()
    }
  }

  trapFocus() {
    // Focus trap is implemented in handleTabKey
  }

  handleTabKey(event) {
    const focusableElements = this.getFocusableElements()

    if (focusableElements.length === 0) return

    const firstElement = focusableElements[0]
    const lastElement = focusableElements[focusableElements.length - 1]
    const activeElement = document.activeElement

    if (event.shiftKey) {
      // Shift+Tab: Reverse
      if (activeElement === firstElement) {
        event.preventDefault()
        lastElement.focus()
      }
    } else {
      // Tab: Forward
      if (activeElement === lastElement) {
        event.preventDefault()
        firstElement.focus()
      }
    }
  }

  getFocusableElements() {
    const focusableSelectors = [
      'button:not([disabled])',
      '[href]',
      'input:not([disabled])',
      'select:not([disabled])',
      'textarea:not([disabled])',
      '[tabindex]:not([tabindex="-1"])'
    ].join(', ')

    return Array.from(this.contentTarget.querySelectorAll(focusableSelectors))
  }
}
```

### Modal Trigger Implementation

```erb
<button
  type="button"
  data-action="click->modal#open"
  data-modal-target="trigger"
>
  Open Modal
</button>
```

---

## HTML Patterns Used

### Pattern 1: Overlay Pattern (Full-Screen)

```html
<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
  <!-- Content -->
</div>
```

**Purpose**: Full-screen overlay with semi-transparent backdrop.

### Pattern 2: Dialog Pattern

```html
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title"
  aria-describedby="modal-description"
  class="relative w-full max-w-md rounded-lg bg-white p-6 shadow-xl"
>
  <!-- Content -->
</div>
```

**Purpose**: ARIA-compliant dialog container.

### Pattern 3: Focus Ring Pattern

```html
<button class="... focus:outline-none focus:ring-2 focus:ring-blue-500">
  Close
</button>
```

**Purpose**: Visible keyboard focus indicators.

---

## Migration Guide

### Step 1: Update Component Class

**After** (HyperUI):
```ruby
# lib/kumiki/components/modal.rb
class Modal < Kumiki::Component
  option :id, default: -> { SecureRandom.hex(6) }
  option :size, default: -> { :md }
  option :position_y, default: -> { :center }
  option :title
  option :open, default: -> { false }

  def modal_classes
    ["fixed", "inset-0", "z-50", "flex", "bg-black/50", position_classes, visibility_classes].join(" ")
  end

  def content_classes
    ["relative", "w-full", size_class, "rounded-lg", "bg-white", "p-6", "shadow-xl"].join(" ")
  end

  def title_id
    "#{id}-title"
  end

  def description_id
    "#{id}-description"
  end

  private

  def position_classes
    case position_y
    when :top then "items-start justify-center pt-20"
    when :bottom then "items-end justify-center pb-20"
    else "items-center justify-center"
    end
  end

  def size_class
    SIZES[size] || SIZES[:md]
  end

  def visibility_classes
    open ? "" : "hidden"
  end

  SIZES = {
    sm: "max-w-sm",
    md: "max-w-md",
    lg: "max-w-lg",
    xl: "max-w-2xl",
    full: "max-w-full"
  }.freeze
end
```

### Step 2: Update Template

```erb
<%= tag.div(
  class: modal_classes,
  role: "dialog",
  "aria-modal": "true",
  "aria-labelledby": title_id,
  "aria-describedby": description_id,
  tabindex: "-1",
  data: {
    controller: "modal",
    action: "click->modal#clickBackdrop keydown->modal#handleKeydown"
  }
) do %>
  <%= tag.div(
    class: content_classes,
    data: {
      modal_target: "content",
      action: "click->modal#stopPropagation"
    }
  ) do %>
    <!-- Close Button -->
    <%= tag.button(
      type: "button",
      class: "absolute right-4 top-4 text-gray-400 hover:text-gray-600 focus:outline-none focus:ring-2 focus:ring-blue-500",
      "aria-label": "Close dialog",
      data: { action: "click->modal#close" }
    ) do %>
      <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
      </svg>
    <% end %>

    <!-- Title -->
    <% if title %>
      <%= tag.h2(title, id: title_id, class: "text-lg font-semibold text-gray-900") %>
    <% end %>

    <!-- Content -->
    <%= tag.div(id: description_id, class: "mt-2 text-sm text-gray-600") do %>
      <%= content %>
    <% end %>

    <!-- Actions Slot -->
    <% if actions %>
      <%= tag.div(class: "mt-6 flex justify-end gap-2") do %>
        <%= actions %>
      <% end %>
    <% end %>
  <% end %>
<% end %>
```

### Step 3: Update Usage

```erb
<%= render Modal.new(
  title: "Confirm Delete",
  size: :md,
  open: false
) do |modal| %>
  <%= modal.content { "Are you sure you want to delete this item?" } %>
  <%= modal.actions do %>
    <%= render Button.new(style: :outline, data: { action: "click->modal#close" }) { "Cancel" } %>
    <%= render Button.new(color: :danger) { "Delete" } %>
  <% end %>
<% end %>
```

---

## Testing Considerations

### Accessibility Testing

**Critical Tests**:
1. Focus trap works correctly (Tab/Shift+Tab cycles)
2. ESC key closes modal and returns focus
3. Focus returns to trigger element
4. ARIA attributes present
5. Keyboard navigation works without mouse

### Functional Testing

```ruby
RSpec.describe Modal, type: :component do
  it "renders with ARIA attributes" do
    result = render_inline(Modal.new(title: "Test"))
    expect(result.css('[role="dialog"]').count).to eq(1)
    expect(result.css('[aria-modal="true"]').count).to eq(1)
  end

  it "hides by default" do
    result = render_inline(Modal.new)
    expect(result.css(".hidden").count).to eq(1)
  end

  it "shows when open" do
    result = render_inline(Modal.new(open: true))
    expect(result.css(".hidden").count).to eq(0)
  end
end
```

---

## Implementation Checklist

### Development

- [ ] Implement modal_classes method with overlay pattern
- [ ] Implement content_classes method with size variants
- [ ] Add ARIA attributes (role, aria-modal, aria-labelledby, aria-describedby)
- [ ] Add close button with proper aria-label
- [ ] Implement Stimulus controller with focus management
- [ ] Implement ESC key handler
- [ ] Implement Tab key trap
- [ ] Implement backdrop click-to-close
- [ ] Store and restore trigger element focus
- [ ] Prevent body scroll when modal open

### Testing

- [ ] Write focus trap tests (Tab/Shift+Tab)
- [ ] Write ESC key test
- [ ] Write focus return test
- [ ] Write ARIA attribute tests
- [ ] Perform manual keyboard navigation testing
- [ ] Perform manual screen reader testing
- [ ] Verify WCAG 2.1 AA compliance

### Documentation

- [ ] Document breaking changes from native dialog
- [ ] Add Storybook stories
- [ ] Document JavaScript requirements
- [ ] Update design system docs

---

**Status**: Ready for Implementation
**Estimated Effort**: 3-4 days
**Priority**: High (complex accessibility requirements)
