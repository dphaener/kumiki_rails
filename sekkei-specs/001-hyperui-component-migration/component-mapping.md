# Component Mapping: DaisyUI to HyperUI

**Feature**: HyperUI Component Migration Analysis
**Created**: 2025-11-19
**Status**: Complete

## Overview

This document provides a comprehensive mapping of all 13 DaisyUI-based Kumiki components to their HyperUI equivalents. The analysis reveals that **11 out of 13 components** have direct or adapted HyperUI equivalents, while **2 components** (FormDatePicker and FormError) require custom implementation using HyperUI patterns.

### Key Findings

- **Direct Mappings**: 7 components (Button, Badge, Card, Modal, Toast, FormCheckbox, FormRadio)
- **Adapted Mappings**: 4 components (FormInput, FormSelect, FormTextarea, FormFileInput)
- **Custom/Gap**: 2 components (FormDatePicker, FormError)
- **Overall Migration Outlook**: Favorable - most components have clear HyperUI equivalents with similar functionality

## Component Mapping Summary Table

| DaisyUI Component | HyperUI Equivalent | Mapping Type | Complexity | Key Differences |
|-------------------|-------------------|--------------|------------|-----------------|
| Button | Marketing: Buttons (12 variants) | Direct | Easy | Utility classes vs component classes |
| Badge | Application: Badges (10 variants) | Direct | Easy | Utility-based styling vs semantic classes |
| Card | Marketing: Cards (9 variants) | Direct | Easy | More flexible layout options |
| Modal | Application: Modals (12 variants) | Direct | Medium | Requires custom JS for focus trap/ARIA |
| Toast | Application: Toasts (12 variants) | Direct | Medium | Similar structure, needs positioning logic |
| FormInput | Application: Inputs (4 variants) | Adapted | Easy | Wrapper structure differs slightly |
| FormSelect | Application: Selects (6 variants) | Adapted | Easy | Native select with enhanced styling |
| FormTextarea | Application: Textareas (6 variants) | Adapted | Easy | Action placement patterns differ |
| FormCheckbox | Application: Checkboxes (6 variants) | Direct | Easy | Similar structure with better descriptions |
| FormRadio | Application: Radio Groups (5 variants) | Direct | Easy | Enhanced group patterns |
| FormFileInput | Application: File Uploaders (4 variants) | Adapted | Medium | Drag-and-drop capabilities require JS |
| FormDatePicker | No direct equivalent | Custom | Hard | Must build using HyperUI input + date library |
| FormError | No direct equivalent | Custom | Easy | Build using HyperUI typography + color patterns |

## Complexity Distribution

### Easy (8 components)
Button, Badge, Card, FormInput, FormSelect, FormTextarea, FormCheckbox, FormRadio, FormError

These components have simple HTML structures, minimal JavaScript requirements, and clear HyperUI equivalents or patterns.

### Medium (3 components)
Modal, Toast, FormFileInput

These components require moderate JavaScript implementation for interactivity (focus management, notifications, file handling) or have structural differences requiring adaptation.

### Hard (2 components)
FormDatePicker

This component requires significant custom implementation, integrating a third-party date library with HyperUI styling patterns, plus complex accessibility requirements.

## Component Details

### 1. Button

- **Current**: DaisyUI Button component with semantic classes (`btn`, `btn-primary`, `btn-outline`)
- **Target**: [HyperUI Marketing Buttons](https://www.hyperui.dev/components/marketing/buttons) - 12 variants
- **Mapping Type**: Direct
- **Complexity**: Easy

**Complexity Justification**: Button has very similar HTML structure (using `<button>` element in both), minimal variants needed for basic functionality, and no JavaScript requirements. The main difference is transitioning from DaisyUI's component class approach (`btn`, `btn-primary`) to HyperUI's utility-first approach (`px-4 py-2 bg-blue-600 text-white rounded`).

**HTML Structure Differences**:
- **DaisyUI**: `<button class="btn btn-primary">Click me</button>`
- **HyperUI**: `<button class="inline-block px-4 py-2 text-white bg-blue-600 rounded hover:bg-blue-700">Click me</button>`
- Key difference: DaisyUI uses semantic component classes, HyperUI uses atomic Tailwind utilities

**CSS Class Differences**:
- **DaisyUI patterns**: `btn`, `btn-primary`, `btn-secondary`, `btn-lg`, `btn-outline`, `btn-ghost`, `btn-wide`
- **HyperUI patterns**: Utility-based - `px-4`, `py-2`, `bg-blue-600`, `text-white`, `rounded`, `hover:bg-blue-700`, size via padding variations
- Philosophy: Semantic component classes (DaisyUI) vs composition of atomic utilities (HyperUI)

---

### 2. Badge

- **Current**: DaisyUI Badge with semantic styling (`badge`, `badge-primary`, `badge-outline`)
- **Target**: [HyperUI Application Badges](https://www.hyperui.dev/components/application/badges) - 10 variants
- **Mapping Type**: Direct
- **Complexity**: Easy

**Complexity Justification**: Badge components are structurally simple (span or div container), have few variants (primarily color and size), and require no JavaScript. HTML structure is nearly identical between DaisyUI and HyperUI. Migration involves converting semantic classes to utility classes.

**HTML Structure Differences**:
- **DaisyUI**: `<span class="badge badge-primary">New</span>`
- **HyperUI**: `<span class="inline-flex items-center px-2 py-1 text-xs font-semibold text-blue-600 bg-blue-100 rounded-full">New</span>`
- Key difference: More explicit utility classes for spacing, typography, and rounding in HyperUI

**CSS Class Differences**:
- **DaisyUI patterns**: `badge`, `badge-primary`, `badge-sm`, `badge-outline`, `badge-ghost`, `badge-soft`
- **HyperUI patterns**: `inline-flex items-center`, `px-2 py-1`, `text-xs`, `font-semibold`, `text-{color}-600`, `bg-{color}-100`, `rounded-full`
- Philosophy: Pre-composed badge styles (DaisyUI) vs explicit utility composition (HyperUI)

---

### 3. Card

- **Current**: DaisyUI Card with structured sections (`card`, `card-body`, `card-title`, `card-actions`)
- **Target**: [HyperUI Marketing Cards](https://www.hyperui.dev/components/marketing/cards) - 9 variants
- **Mapping Type**: Direct
- **Complexity**: Easy

**Complexity Justification**: Card components are presentational containers with no interactive behavior. HTML structure is similar (container with title, body, actions sections). Main work involves mapping DaisyUI's semantic section classes to HyperUI's utility-based layout patterns. No JavaScript required.

**HTML Structure Differences**:
- **DaisyUI**:
  ```html
  <div class="card bg-base-100 shadow-sm">
    <figure><img src="..." /></figure>
    <div class="card-body">
      <h2 class="card-title">Title</h2>
      <p>Content</p>
      <div class="card-actions justify-end">
        <button class="btn btn-primary">Action</button>
      </div>
    </div>
  </div>
  ```
- **HyperUI**:
  ```html
  <div class="overflow-hidden rounded-lg shadow-sm bg-white">
    <img class="object-cover w-full h-48" src="..." />
    <div class="p-4">
      <h3 class="text-lg font-semibold">Title</h3>
      <p class="text-gray-600">Content</p>
      <div class="mt-4">
        <button class="px-4 py-2 text-white bg-blue-600 rounded">Action</button>
      </div>
    </div>
  </div>
  ```
- Key difference: DaisyUI uses specialized element classes (`card-body`, `card-title`), HyperUI uses generic utility classes for spacing and typography

**CSS Class Differences**:
- **DaisyUI patterns**: `card`, `card-body`, `card-title`, `card-actions`, `card-border`, `card-side`, `image-full`
- **HyperUI patterns**: `overflow-hidden rounded-lg shadow-sm`, `p-4`, `text-lg font-semibold`, `text-gray-600`, `mt-4`
- Philosophy: Structured component sections (DaisyUI) vs flexible utility-based layout (HyperUI)

---

### 4. Modal

- **Current**: DaisyUI Modal with dialog or checkbox-based toggle (`modal`, `modal-box`, `modal-backdrop`)
- **Target**: [HyperUI Application Modals](https://www.hyperui.dev/components/application/modals) - 12 variants
- **Mapping Type**: Direct
- **Complexity**: Medium

**Complexity Justification**: Modal has similar HTML structure between DaisyUI and HyperUI (overlay + dialog container), but requires moderate JavaScript for focus management, keyboard navigation (ESC to close, Tab trap), and ARIA attributes for accessibility. DaisyUI offers checkbox-based no-JS solution; HyperUI requires custom JS implementation. Multiple variants exist but core pattern is consistent.

**HTML Structure Differences**:
- **DaisyUI**: Uses `<dialog>` element with `showModal()` method, or checkbox toggle pattern with hidden input
  ```html
  <dialog id="modal" class="modal">
    <div class="modal-box">
      <h3 class="font-bold">Title</h3>
      <p>Content</p>
      <div class="modal-action">
        <button class="btn">Close</button>
      </div>
    </div>
    <form method="dialog" class="modal-backdrop">
      <button>close</button>
    </form>
  </dialog>
  ```
- **HyperUI**: Uses div-based overlay with focus trap and ARIA
  ```html
  <div class="fixed inset-0 z-50 bg-gray-900/50" aria-hidden="true">
    <div class="flex items-center justify-center min-h-screen p-4">
      <div class="bg-white rounded-lg p-6 max-w-md" role="dialog" aria-modal="true">
        <h2 class="text-lg font-semibold">Title</h2>
        <p class="text-gray-600">Content</p>
        <div class="mt-4 flex gap-2">
          <button class="px-4 py-2 bg-blue-600 text-white rounded">Confirm</button>
        </div>
      </div>
    </div>
  </div>
  ```
- Key difference: DaisyUI can use native `<dialog>` with minimal JS; HyperUI uses custom overlay requiring manual focus management and ARIA implementation

**CSS Class Differences**:
- **DaisyUI patterns**: `modal`, `modal-box`, `modal-backdrop`, `modal-action`, `modal-open`, `modal-top`, `modal-middle`, `modal-bottom`
- **HyperUI patterns**: `fixed inset-0 z-50`, `bg-gray-900/50`, `flex items-center justify-center`, `min-h-screen`, `bg-white rounded-lg p-6`, `max-w-md`
- Philosophy: Component-based state management (DaisyUI) vs utility-based positioning and overlay (HyperUI)

---

### 5. Toast

- **Current**: DaisyUI Toast container for notifications (`toast`, positioned on corners)
- **Target**: [HyperUI Application Toasts](https://www.hyperui.dev/components/application/toasts) - 12 variants
- **Mapping Type**: Direct
- **Complexity**: Medium

**Complexity Justification**: Toast has similar structure (fixed-position notification container with dismiss button), but requires JavaScript for show/hide logic, auto-dismiss timers, and accessibility (role="alert", aria-live). HyperUI provides more visual variants (success, error, warning, info) than DaisyUI's basic positioning wrapper. Implementation is straightforward but needs custom JS for notification queue management.

**HTML Structure Differences**:
- **DaisyUI**: Wrapper container with positioning classes
  ```html
  <div class="toast toast-top toast-end">
    <div class="alert alert-success">
      <span>Message saved successfully</span>
    </div>
  </div>
  ```
- **HyperUI**: Individual toast components with state indicators
  ```html
  <div role="alert" class="rounded-lg bg-green-50 p-4 text-green-800">
    <div class="flex items-start gap-3">
      <span class="text-2xl">✅</span>
      <div>
        <strong class="block font-medium">Success</strong>
        <p class="mt-1 text-sm">Your changes have been saved</p>
      </div>
      <button class="ml-auto" aria-label="Close">
        <span class="sr-only">Close</span>
        ×
      </button>
    </div>
  </div>
  ```
- Key difference: DaisyUI toast is primarily a positioning wrapper; HyperUI includes full notification structure with semantic state colors and icons

**CSS Class Differences**:
- **DaisyUI patterns**: `toast`, `toast-top`, `toast-bottom`, `toast-start`, `toast-center`, `toast-end`, `toast-middle`
- **HyperUI patterns**: `rounded-lg`, `bg-{color}-50`, `p-4`, `text-{color}-800`, `flex items-start gap-3`, `ml-auto`
- Philosophy: Positioning container (DaisyUI) vs complete notification component (HyperUI)

---

### 6. FormInput

- **Current**: DaisyUI Input with semantic classes (`input`, `input-bordered`, color/size variants)
- **Target**: [HyperUI Application Inputs](https://www.hyperui.dev/components/application/inputs) - 4 variants
- **Mapping Type**: Adapted
- **Complexity**: Easy

**Complexity Justification**: Input fields have simple HTML structure (label + input), minimal styling differences, and no JavaScript requirements. Main adaptation involves HyperUI's more elaborate wrapper structure for icons and floating labels, whereas DaisyUI can apply classes directly to input. Structurally straightforward migration.

**HTML Structure Differences**:
- **DaisyUI**: Can use simple input or label wrapper
  ```html
  <input type="text" class="input input-bordered input-primary" placeholder="Email" />
  <!-- OR with wrapper -->
  <label class="input input-bordered flex items-center gap-2">
    <svg>...</svg>
    <input type="text" />
  </label>
  ```
- **HyperUI**: Structured label + input pattern with explicit wrapper
  ```html
  <div>
    <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
    <input
      type="email"
      id="email"
      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
      placeholder="you@example.com"
    />
  </div>
  ```
- Key difference: DaisyUI allows flexible input-only or wrapper approach; HyperUI prefers explicit label + input structure for accessibility

**CSS Class Differences**:
- **DaisyUI patterns**: `input`, `input-bordered`, `input-ghost`, `input-primary`, `input-sm`, `input-md`, `input-lg`
- **HyperUI patterns**: `block w-full rounded-md`, `border-gray-300`, `shadow-sm`, `focus:border-blue-500`, `focus:ring-blue-500`, `mt-1`
- Philosophy: Component class with modifiers (DaisyUI) vs explicit utility composition for every state (HyperUI)

---

### 7. FormSelect

- **Current**: DaisyUI Select with native dropdown (`select`, color/size variants)
- **Target**: [HyperUI Application Selects](https://www.hyperui.dev/components/application/selects) - 6 variants
- **Mapping Type**: Adapted
- **Complexity**: Easy

**Complexity Justification**: Select uses native `<select>` element in both libraries, requiring no JavaScript. Styling differences are minimal - both use @tailwindcss/forms plugin for base styles. Main adaptation is wrapper structure and explicit utility classes in HyperUI vs DaisyUI's component classes. Straightforward migration with similar functionality.

**HTML Structure Differences**:
- **DaisyUI**:
  ```html
  <select class="select select-bordered select-primary">
    <option disabled selected>Pick one</option>
    <option>Option 1</option>
    <option>Option 2</option>
  </select>
  ```
- **HyperUI**:
  ```html
  <div>
    <label for="option" class="block text-sm font-medium text-gray-700">Select option</label>
    <select
      id="option"
      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
    >
      <option>Option 1</option>
      <option>Option 2</option>
    </select>
  </div>
  ```
- Key difference: Both use native select; HyperUI adds explicit label wrapper and accessibility attributes

**CSS Class Differences**:
- **DaisyUI patterns**: `select`, `select-bordered`, `select-ghost`, `select-primary`, `select-sm`, `select-md`, `select-lg`
- **HyperUI patterns**: `block w-full rounded-md`, `border-gray-300`, `shadow-sm`, `focus:border-blue-500`, `focus:ring-blue-500`, `mt-1`
- Philosophy: Component class approach (DaisyUI) vs @tailwindcss/forms base + utility overrides (HyperUI)

---

### 8. FormTextarea

- **Current**: DaisyUI Textarea with semantic classes (`textarea`, `textarea-bordered`)
- **Target**: [HyperUI Application Textareas](https://www.hyperui.dev/components/application/textareas) - 6 variants
- **Mapping Type**: Adapted
- **Complexity**: Easy

**Complexity Justification**: Textarea is a simple native element with no JavaScript requirements. Both libraries use native `<textarea>`. Main adaptation involves HyperUI's "actions inside/outside" pattern for submit buttons positioned relative to textarea, whereas DaisyUI treats textarea as standalone. Migration is straightforward with pattern choice for action button placement.

**HTML Structure Differences**:
- **DaisyUI**:
  ```html
  <textarea class="textarea textarea-bordered textarea-primary" placeholder="Enter text"></textarea>
  ```
- **HyperUI**: Offers action button patterns
  ```html
  <div>
    <label for="message" class="block text-sm font-medium text-gray-700">Message</label>
    <textarea
      id="message"
      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
      rows="4"
    ></textarea>
    <div class="mt-2 flex justify-end">
      <button class="px-4 py-2 bg-blue-600 text-white rounded">Submit</button>
    </div>
  </div>
  ```
- Key difference: HyperUI includes action button positioning patterns; DaisyUI treats textarea as standalone form element

**CSS Class Differences**:
- **DaisyUI patterns**: `textarea`, `textarea-bordered`, `textarea-ghost`, `textarea-primary`, `textarea-sm`, `textarea-md`, `textarea-lg`
- **HyperUI patterns**: `block w-full rounded-md`, `border-gray-300`, `shadow-sm`, `focus:border-blue-500`, `focus:ring-blue-500`, action placement utilities
- Philosophy: Standalone component (DaisyUI) vs textarea + action composition pattern (HyperUI)

---

### 9. FormCheckbox

- **Current**: DaisyUI Checkbox with semantic classes (`checkbox`, color/size variants)
- **Target**: [HyperUI Application Checkboxes](https://www.hyperui.dev/components/application/checkboxes) - 6 variants
- **Mapping Type**: Direct
- **Complexity**: Easy

**Complexity Justification**: Checkbox uses native `<input type="checkbox">` in both libraries with no JavaScript required. HTML structure is very similar (label + input). HyperUI adds optional description text patterns. Migration is straightforward with minor styling adjustments from component classes to utilities. Accessibility is handled natively by semantic HTML.

**HTML Structure Differences**:
- **DaisyUI**:
  ```html
  <input type="checkbox" class="checkbox checkbox-primary" checked />
  <label>
    <input type="checkbox" class="checkbox" />
    <span>Label text</span>
  </label>
  ```
- **HyperUI**:
  ```html
  <label class="flex items-start gap-3">
    <input type="checkbox" class="mt-1 rounded border-gray-300 text-blue-600 focus:ring-blue-500" />
    <div>
      <strong class="text-sm font-medium text-gray-900">Option</strong>
      <p class="text-sm text-gray-600">Optional description text</p>
    </div>
  </label>
  ```
- Key difference: HyperUI includes description text pattern; DaisyUI simpler label association

**CSS Class Differences**:
- **DaisyUI patterns**: `checkbox`, `checkbox-primary`, `checkbox-sm`, `checkbox-md`, `checkbox-lg`
- **HyperUI patterns**: `rounded border-gray-300`, `text-blue-600`, `focus:ring-blue-500`, layout utilities for description text
- Philosophy: Component class (DaisyUI) vs @tailwindcss/forms base + utility overrides + description pattern (HyperUI)

---

### 10. FormRadio

- **Current**: DaisyUI Radio with semantic classes (`radio`, color/size variants)
- **Target**: [HyperUI Application Radio Groups](https://www.hyperui.dev/components/application/radio-groups) - 5 variants
- **Mapping Type**: Direct
- **Complexity**: Easy

**Complexity Justification**: Radio uses native `<input type="radio">` with shared name attribute for grouping. No JavaScript required. HTML structure is nearly identical between libraries. HyperUI emphasizes group patterns with better visual separation and optional input fields alongside radios. Migration involves converting component classes to utilities and adopting HyperUI's group layout patterns.

**HTML Structure Differences**:
- **DaisyUI**:
  ```html
  <input type="radio" name="option" class="radio radio-primary" checked />
  <input type="radio" name="option" class="radio radio-primary" />
  ```
- **HyperUI**:
  ```html
  <fieldset>
    <legend class="sr-only">Choose option</legend>
    <div class="space-y-2">
      <label class="flex items-center gap-3 cursor-pointer">
        <input type="radio" name="option" class="rounded-full border-gray-300 text-blue-600" checked />
        <span class="text-sm font-medium">Option 1</span>
      </label>
      <label class="flex items-center gap-3 cursor-pointer">
        <input type="radio" name="option" class="rounded-full border-gray-300 text-blue-600" />
        <span class="text-sm font-medium">Option 2</span>
      </label>
    </div>
  </fieldset>
  ```
- Key difference: HyperUI uses fieldset/legend for accessibility and emphasizes group layout with spacing utilities

**CSS Class Differences**:
- **DaisyUI patterns**: `radio`, `radio-primary`, `radio-sm`, `radio-md`, `radio-lg`
- **HyperUI patterns**: `rounded-full border-gray-300`, `text-blue-600`, `flex items-center gap-3`, `space-y-2` for group spacing
- Philosophy: Individual component styling (DaisyUI) vs group layout pattern with utilities (HyperUI)

---

### 11. FormFileInput

- **Current**: DaisyUI File Input with semantic classes (`file-input`, color/size variants)
- **Target**: [HyperUI Application File Uploaders](https://www.hyperui.dev/components/application/file-uploaders) - 4 variants
- **Mapping Type**: Adapted
- **Complexity**: Medium

**Complexity Justification**: Basic file input uses native `<input type="file">` and is straightforward. However, HyperUI's file uploaders showcase advanced features like drag-and-drop zones, file preview, and progress indicators which require JavaScript implementation. DaisyUI's file input is simpler, focused on styled native input. Migration can be easy (native input) or medium (if adopting drag-and-drop patterns).

**HTML Structure Differences**:
- **DaisyUI**:
  ```html
  <input type="file" class="file-input file-input-bordered file-input-primary" />
  ```
- **HyperUI**: Enhanced with drop zone
  ```html
  <label class="block">
    <span class="sr-only">Choose file</span>
    <input
      type="file"
      class="block w-full text-sm text-gray-500
             file:mr-4 file:py-2 file:px-4
             file:rounded-full file:border-0
             file:bg-blue-50 file:text-blue-700
             hover:file:bg-blue-100"
    />
  </label>
  <!-- OR with drag-and-drop zone (requires JS) -->
  <div class="border-2 border-dashed border-gray-300 rounded-lg p-6 text-center">
    <input type="file" class="hidden" id="file-upload" />
    <label for="file-upload" class="cursor-pointer">
      <p class="text-gray-600">Drag and drop or click to upload</p>
    </label>
  </div>
  ```
- Key difference: DaisyUI is styled native input; HyperUI offers both native styling and drag-and-drop patterns

**CSS Class Differences**:
- **DaisyUI patterns**: `file-input`, `file-input-bordered`, `file-input-ghost`, `file-input-primary`, size variants
- **HyperUI patterns**: `file:` pseudo-element utilities (`file:mr-4`, `file:py-2`, `file:rounded-full`, `file:bg-blue-50`), drag zone utilities (`border-2 border-dashed`, `rounded-lg`, `p-6`)
- Philosophy: Styled native input (DaisyUI) vs enhanced interaction patterns with drag-and-drop (HyperUI)

---

### 12. FormDatePicker

- **Current**: Assumed DaisyUI-based date picker component (not documented in DaisyUI core components)
- **Target**: No direct HyperUI equivalent
- **Mapping Type**: Custom
- **Complexity**: Hard

**Complexity Justification**: Neither DaisyUI nor HyperUI provide built-in date picker components. This requires custom implementation by integrating a JavaScript date library (e.g., Flatpickr, date-fns + custom UI, or native `<input type="date">`) with HyperUI's input styling patterns. Significant work includes calendar UI, keyboard navigation, date validation, accessibility (ARIA roles, labels, keyboard shortcuts), and multiple date format support. This is the most complex migration task.

**HTML Structure Differences**:
- **DaisyUI**: No native component (likely uses native date input or third-party library)
  ```html
  <input type="date" class="input input-bordered" />
  ```
- **HyperUI**: Must build custom implementation
  ```html
  <div>
    <label for="date" class="block text-sm font-medium text-gray-700">Select date</label>
    <input
      type="date"
      id="date"
      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
    />
  </div>
  <!-- OR integrate third-party library like Flatpickr with HyperUI styling -->
  <div>
    <label class="block text-sm font-medium text-gray-700">Select date</label>
    <input
      type="text"
      class="mt-1 block w-full rounded-md border-gray-300 shadow-sm"
      data-controller="flatpickr"
    />
  </div>
  ```
- Key difference: No direct mapping; must choose approach (native input, third-party library, custom calendar) and apply HyperUI styling patterns

**CSS Class Differences**:
- **DaisyUI patterns**: Would use standard `input` classes
- **HyperUI patterns**: Must apply input styling utilities + custom calendar dropdown styling if building custom picker
- Philosophy: No established pattern in either library; custom implementation required

**Recommendation**:
1. **Quick solution**: Use native `<input type="date">` with HyperUI input styling
2. **Enhanced solution**: Integrate Flatpickr or similar library, style with HyperUI utilities, wrap with Stimulus controller
3. **Custom solution**: Build calendar component using HyperUI patterns, implement full keyboard and accessibility support

---

### 13. FormError

- **Current**: Assumed DaisyUI-based error message component (not documented as standalone component)
- **Target**: No direct HyperUI equivalent
- **Mapping Type**: Custom
- **Complexity**: Easy

**Complexity Justification**: Neither DaisyUI nor HyperUI provide dedicated error message components, but both libraries have clear color and typography patterns for errors. Implementation is simple - create a text element with error styling using HyperUI's color utilities (`text-red-600`, `bg-red-50`, etc.). No JavaScript required. Associate with form inputs via `aria-describedby` for accessibility.

**HTML Structure Differences**:
- **DaisyUI**: Likely uses utility classes or alert component
  ```html
  <span class="text-error text-sm">This field is required</span>
  <!-- OR -->
  <div class="alert alert-error">
    <span>Error message</span>
  </div>
  ```
- **HyperUI**: Build using typography + color utilities
  ```html
  <p class="mt-1 text-sm text-red-600" id="email-error">
    This field is required
  </p>
  <!-- OR with icon -->
  <div class="mt-1 flex items-start gap-2 text-sm text-red-600">
    <svg class="w-4 h-4 mt-0.5">...</svg>
    <p id="field-error">Invalid email format</p>
  </div>
  ```
- Key difference: No dedicated component in either library; HyperUI pattern uses explicit utility composition

**CSS Class Differences**:
- **DaisyUI patterns**: `text-error`, `text-sm`, or `alert alert-error`
- **HyperUI patterns**: `text-sm text-red-600`, `mt-1`, optional `flex items-start gap-2` for icon, `bg-red-50 border border-red-200 p-3 rounded` for alert-style
- Philosophy: Semantic error color class (DaisyUI) vs explicit red color utilities (HyperUI)

**Recommendation**:
Create a reusable Ruby component that wraps error text with HyperUI error styling patterns, associates with form inputs via `aria-describedby`, and supports optional icon/alert styling.

---

## Gap Analysis

### Components Requiring Custom Implementation

#### FormDatePicker (HARD - Custom)

**Why No Equivalent**: Neither DaisyUI nor HyperUI provide comprehensive date picker components. DaisyUI lacks a date picker entirely. HyperUI focuses on native form inputs without calendar overlays.

**Recommendation**:
1. **Short-term**: Use native `<input type="date">` with HyperUI input styling. Pros: zero dependencies, works immediately. Cons: inconsistent UI across browsers, limited customization.
2. **Long-term**: Integrate a proven JavaScript date library:
   - **Flatpickr** (recommended): Lightweight, accessible, theme-able. Apply HyperUI utilities to Flatpickr's calendar classes.
   - **date-fns + custom UI**: Full control, but more implementation work for calendar UI and accessibility.
   - Wrap with Stimulus controller for Hotwire integration.
   - Apply HyperUI input styling to trigger input, match HyperUI color/typography patterns for calendar dropdown.

**Implementation Checklist**:
- [ ] Choose date library (Flatpickr recommended)
- [ ] Create Ruby component wrapper
- [ ] Style calendar with HyperUI utilities (colors, spacing, borders, shadows)
- [ ] Implement Stimulus controller for lifecycle management
- [ ] Add ARIA attributes (`role="dialog"`, `aria-label`, keyboard navigation)
- [ ] Support date formats and localization
- [ ] Test keyboard navigation (arrows, Enter, ESC)
- [ ] Test screen reader compatibility

#### FormError (EASY - Custom)

**Why No Equivalent**: Neither library provides a dedicated error component. Both expect developers to compose error messages using color and typography utilities.

**Recommendation**:
Create a standardized FormError Ruby component that:
- Accepts error message text as prop
- Renders with HyperUI error styling: `text-sm text-red-600 mt-1`
- Supports optional icon (inline SVG or emoji)
- Generates unique ID for `aria-describedby` association with inputs
- Supports "alert-style" variant with background (`bg-red-50 border border-red-200 p-3 rounded`) for prominent errors

**Implementation Pattern**:
```ruby
# Example component API
<%= render Kumiki::FormErrorComponent.new(
  message: "This field is required",
  field_id: "email",
  style: :inline # or :alert
) %>
```

**HTML Output**:
```html
<p class="mt-1 text-sm text-red-600" id="email-error" role="alert">
  This field is required
</p>
```

**Implementation Checklist**:
- [ ] Create FormErrorComponent Ruby class
- [ ] Support inline and alert style variants
- [ ] Generate accessible IDs for aria-describedby
- [ ] Add role="alert" for screen readers
- [ ] Support optional icon rendering
- [ ] Match HyperUI color patterns (red-600, red-50, red-200)
- [ ] Create documentation with examples
- [ ] Add component tests

---

## Recommendations

### 1. Start with Easy Complexity Components

Begin migration with the 8 "easy" components to establish patterns and build confidence:
- **First batch**: Button, Badge, Card (presentational, no JS)
- **Second batch**: FormInput, FormSelect, FormTextarea, FormCheckbox, FormRadio (form elements, similar patterns)
- **Third batch**: FormError (custom but simple)

This approach allows the team to:
- Establish utility-class composition patterns
- Create reusable Ruby component base classes
- Document migration workflow for others to follow
- Build test patterns for components

### 2. Handle Medium Complexity Next

After establishing patterns, tackle components requiring JavaScript:
- **Modal**: Implement focus trap and ARIA patterns using Stimulus controller
- **Toast**: Build notification queue system with show/hide logic and auto-dismiss
- **FormFileInput**: Decide if basic styled input is sufficient or if drag-and-drop is needed

Each of these benefits from the patterns established during easy component migration.

### 3. Address FormDatePicker Last

Save FormDatePicker for last because it:
- Has the highest complexity and risk
- Requires evaluation of third-party libraries
- Can block other components if attempted too early
- Benefits from lessons learned during earlier migrations

Consider shipping v0.2.0 without FormDatePicker and adding it in v0.2.1 if needed.

### 4. Create Shared Utility Patterns

During migration, establish reusable patterns for:
- **Color mapping**: Document DaisyUI semantic colors → HyperUI utility color mappings (primary → blue-600, success → green-600, etc.)
- **Size mapping**: Document size variants (sm, md, lg) → specific padding/font-size utilities
- **State styling**: Create consistent hover/focus/disabled patterns using Tailwind utilities
- **Layout helpers**: Create Ruby helper methods for common patterns (flex gap-3, space-y-2, etc.)

### 5. Validation Approach

For each migrated component:
- **Visual regression tests**: Capture screenshots of DaisyUI version, compare HyperUI migration
- **Accessibility testing**: Run axe-core or similar tool on component examples
- **Cross-browser testing**: Test on Chrome, Firefox, Safari for visual consistency
- **Responsive testing**: Verify mobile, tablet, desktop breakpoints
- **Keyboard navigation**: Test all interactive components with keyboard-only navigation

### 6. Documentation During Migration

Create documentation as components are migrated:
- **Migration guide per component**: Document DaisyUI classes → HyperUI utilities mappings
- **Before/after code examples**: Show actual Kumiki API usage for both versions
- **Breaking changes log**: Document any API changes from v0.1.x to v0.2.0
- **Design tokens**: Document color, spacing, and typography decisions

### 7. Consider Incremental Release

Given the scope of this migration:
- **Option A (Big Bang)**: Release v0.2.0 with all components migrated at once
  - Pros: Clean break, all components consistent
  - Cons: Higher risk, longer timeline, more coordination needed
- **Option B (Incremental)**: Release preview versions (v0.2.0-alpha, v0.2.0-beta) with subsets of components
  - Pros: Earlier feedback, lower risk per release
  - Cons: Managing two component systems temporarily, more release overhead

Recommend **Option B** for lower risk and earlier validation of migration approach.

---

## References

- **DaisyUI Components**: https://daisyui.com/components/
- **HyperUI Components**: https://www.hyperui.dev/
- **Kumiki Rails**: `lib/kumiki/components/` (baseline for existing API)
- **Data Model**: [data-model.md](./data-model.md)
- **Implementation Plan**: [plan.md](./plan.md)
- **Feature Specification**: [spec.md](./spec.md)

---

**Document Status**: ✅ Complete
**Next Steps**: Proceed to WP02 (Variant Comparison Analysis)
