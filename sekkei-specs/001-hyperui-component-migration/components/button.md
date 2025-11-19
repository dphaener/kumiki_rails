# Button Component Migration Guide

**Component**: Button
**DaisyUI Baseline**: [DaisyUI Button](https://daisyui.com/components/button/)
**HyperUI Target**: [HyperUI Marketing Buttons](https://www.hyperui.dev/components/marketing/buttons)
**Migration Complexity**: Easy
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

The Button component is a fundamental interactive element used throughout the application for user actions. It provides visual feedback through states (hover, focus, active, disabled, loading) and supports multiple variants (colors, sizes, styles) to convey hierarchy and context.

### Current DaisyUI Implementation

**Location**: `/lib/kumiki/components/button.rb`

DaisyUI uses semantic component classes that encapsulate styling:
- Base class: `btn`
- Modifiers: `btn-primary`, `btn-lg`, `btn-outline`
- State management: `disabled`, data attributes for loading

**Philosophy**: Semantic, theme-aware component classes that reference CSS custom properties.

### HyperUI Target

HyperUI provides 12 button variants composed of utility classes:
- Utility-first approach with explicit Tailwind classes
- No semantic class names
- Direct color scale references (blue-600, green-600, etc.)
- State management via Tailwind pseudo-classes

**Philosophy**: Utility composition for maximum flexibility.

### Migration Complexity Rating: Easy

**Justification**:
- Similar HTML structure (`<button>` element in both)
- No JavaScript required (beyond Stimulus for loading state management)
- Clear mapping from semantic classes to utility combinations
- Well-documented HyperUI variants
- Straightforward state management

---

## Variant Analysis

### DaisyUI Variants Available

#### Color Variants (8)

```html
<button class="btn btn-neutral">Neutral</button>
<button class="btn btn-primary">Primary</button>
<button class="btn btn-secondary">Secondary</button>
<button class="btn btn-accent">Accent</button>
<button class="btn btn-info">Info</button>
<button class="btn btn-success">Success</button>
<button class="btn btn-warning">Warning</button>
<button class="btn btn-error">Error</button>
```

#### Size Variants (5)

```html
<button class="btn btn-xs">Extra Small</button>
<button class="btn btn-sm">Small</button>
<button class="btn btn-md">Medium</button>
<button class="btn btn-lg">Large</button>
<button class="btn btn-xl">Extra Large</button>
```

#### Style Variants (6)

```html
<button class="btn">Filled (default)</button>
<button class="btn btn-outline">Outline</button>
<button class="btn btn-dash">Dashed</button>
<button class="btn btn-soft">Soft</button>
<button class="btn btn-ghost">Ghost</button>
<button class="btn btn-link">Link</button>
```

#### Shape Modifiers (4)

```html
<button class="btn btn-wide">Wide</button>
<button class="btn btn-block">Block</button>
<button class="btn btn-square">Square</button>
<button class="btn btn-circle">Circle</button>
```

### HyperUI Variants Available

HyperUI provides 12 example buttons with utility-based variants:

#### Color (via utility combinations)

```html
<!-- Primary (Blue) -->
<button class="rounded bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
  Primary
</button>

<!-- Success (Green) -->
<button class="rounded bg-green-600 px-4 py-2 text-white hover:bg-green-700">
  Success
</button>

<!-- Error (Red) -->
<button class="rounded bg-red-600 px-4 py-2 text-white hover:bg-red-700">
  Error
</button>
```

#### Size (via padding/text utilities)

```html
<!-- Small -->
<button class="rounded bg-blue-600 px-3 py-1.5 text-sm text-white">
  Small
</button>

<!-- Medium (default) -->
<button class="rounded bg-blue-600 px-4 py-2 text-base text-white">
  Medium
</button>

<!-- Large -->
<button class="rounded bg-blue-600 px-6 py-3 text-lg text-white">
  Large
</button>
```

#### Style (via border/background utilities)

```html
<!-- Filled -->
<button class="rounded bg-blue-600 px-4 py-2 text-white hover:bg-blue-700">
  Filled
</button>

<!-- Outline -->
<button class="rounded border border-blue-600 bg-transparent px-4 py-2 text-blue-600 hover:bg-blue-600 hover:text-white">
  Outline
</button>

<!-- Ghost -->
<button class="rounded bg-transparent px-4 py-2 text-blue-600 hover:bg-blue-50">
  Ghost
</button>
```

### Variant Gaps

#### DaisyUI → HyperUI Gaps

1. **Dash Style**: DaisyUI's `btn-dash` (dashed borders) not in HyperUI examples
   - **Solution**: Add `border-dashed` utility to outline variant

2. **Soft Style**: DaisyUI's `btn-soft` not explicitly shown in HyperUI
   - **Solution**: Define as `bg-{color}-100 text-{color}-700 hover:bg-{color}-200`

3. **Link Style**: Not in HyperUI examples
   - **Solution**: Implement as `bg-transparent underline hover:no-underline p-0`

4. **Semantic Color Names**: DaisyUI uses `primary`, `secondary`, `accent`; HyperUI uses direct color references
   - **Solution**: Create mapping layer from semantic names to Tailwind colors

### Variant Mapping Table

| DaisyUI Variant | HyperUI Equivalent | Implementation |
|-----------------|-------------------|----------------|
| `btn-primary` | `bg-blue-600 text-white hover:bg-blue-700` | Direct mapping |
| `btn-secondary` | `bg-purple-600 text-white hover:bg-purple-700` | Direct mapping |
| `btn-accent` | `bg-pink-600 text-white hover:bg-pink-700` | Direct mapping |
| `btn-success` | `bg-green-600 text-white hover:bg-green-700` | Direct mapping |
| `btn-error` | `bg-red-600 text-white hover:bg-red-700` | Direct mapping |
| `btn-warning` | `bg-yellow-600 text-white hover:bg-yellow-700` | Direct mapping |
| `btn-info` | `bg-cyan-600 text-white hover:bg-cyan-700` | Direct mapping |
| `btn-neutral` | `bg-gray-600 text-white hover:bg-gray-700` | Direct mapping |
| `btn-outline` | `border border-{color}-600 text-{color}-600 hover:bg-{color}-600 hover:text-white` | Direct mapping |
| `btn-ghost` | `text-{color}-600 hover:bg-{color}-100` | Direct mapping |
| `btn-soft` | `bg-{color}-100 text-{color}-700 hover:bg-{color}-200` | Custom implementation |
| `btn-dash` | `border border-dashed border-{color}-600 text-{color}-600` | Custom implementation |
| `btn-link` | `text-{color}-600 underline hover:no-underline bg-transparent p-0` | Custom implementation |
| `btn-xs` | `px-2 py-1 text-xs` | Direct mapping |
| `btn-sm` | `px-3 py-1.5 text-sm` | Direct mapping |
| `btn-md` | `px-4 py-2 text-base` | Direct mapping |
| `btn-lg` | `px-6 py-3 text-lg` | Direct mapping |
| `btn-xl` | `px-8 py-4 text-xl` | Direct mapping |
| `btn-wide` | `px-12` | Direct mapping |
| `btn-block` | `w-full block` | Direct mapping |
| `btn-square` | `p-2 aspect-square` | Direct mapping |
| `btn-circle` | `p-2 rounded-full aspect-square` | Direct mapping |

---

## HTML Structure Comparison

### Current DaisyUI Structure

```erb
<%= render Button.new(color: :primary, size: :md, style: :filled) do %>
  Click Me
<% end %>
```

**Generated HTML**:
```html
<button class="btn btn-primary btn-md">
  Click Me
</button>
```

**With Icon**:
```erb
<%= render Button.new(color: :primary, icon: :check) do %>
  Save
<% end %>
```

```html
<button class="btn btn-primary">
  <svg class="w-4 h-4 mr-2">...</svg>
  Save
</button>
```

**Loading State**:
```erb
<%= render Button.new(color: :primary, loading: true) do %>
  Saving...
<% end %>
```

```html
<button class="btn btn-primary" disabled>
  <span class="loading loading-spinner loading-sm mr-2"></span>
  Saving...
</button>
```

### HyperUI Target Structure

```html
<!-- Basic Button -->
<button class="inline-block rounded bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
  Click Me
</button>

<!-- With Icon -->
<button class="inline-flex items-center gap-2 rounded bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2">
  <svg class="h-4 w-4" aria-hidden="true" focusable="false">...</svg>
  <span>Save</span>
</button>

<!-- Loading State -->
<button class="inline-flex items-center gap-2 rounded bg-blue-600 px-4 py-2 text-sm font-medium text-white focus:outline-none focus:ring-2 focus:ring-blue-500" aria-busy="true" disabled>
  <svg class="h-4 w-4 animate-spin" aria-hidden="true" focusable="false">...</svg>
  <span class="sr-only">Loading, please wait</span>
  <span aria-hidden="true">Saving...</span>
</button>
```

### Key Structural Differences

1. **Display Model**: DaisyUI uses `btn` (implicit inline-block), HyperUI uses explicit `inline-block` or `inline-flex`

2. **Icon Layout**:
   - DaisyUI: Icon as direct child with margin
   - HyperUI: `inline-flex items-center gap-2` for icon + text layout

3. **Loading State**:
   - DaisyUI: Uses `loading` component classes
   - HyperUI: Custom spinner with `animate-spin`, `aria-busy="true"`, and screen reader text

4. **Focus States**:
   - DaisyUI: Handled by component class
   - HyperUI: Explicit `focus:outline-none focus:ring-2 focus:ring-{color}-500 focus:ring-offset-2`

5. **Typography**:
   - DaisyUI: Handled by component class
   - HyperUI: Explicit `text-sm font-medium`

---

## Accessibility Requirements

### ARIA Attributes Required

#### Standard Button
```html
<button type="button">
  Button Text
</button>
```
**Note**: Standard buttons with visible text require no ARIA attributes.

#### Icon-Only Button
```html
<button type="button" aria-label="Close dialog">
  <svg aria-hidden="true" focusable="false">
    <!-- Icon -->
  </svg>
</button>
```
- `aria-label`: Provides accessible name when no visible text
- Icons must have `aria-hidden="true"` and `focusable="false"`

#### Loading Button
```html
<button type="button" aria-busy="true" aria-live="polite" disabled>
  <svg aria-hidden="true" focusable="false"><!-- Spinner --></svg>
  <span class="sr-only">Loading, please wait</span>
  <span aria-hidden="true">Loading...</span>
</button>
```
- `aria-busy="true"`: Indicates loading state
- `aria-live="polite"`: Announces state change (optional)
- `disabled`: Prevents interaction during loading
- `<span class="sr-only">`: Hidden text for screen readers

#### Toggle Button
```html
<button type="button" aria-pressed="false" aria-label="Toggle dark mode">
  <svg aria-hidden="true" focusable="false"><!-- Icon --></svg>
  <span>Dark Mode</span>
</button>
```
- `aria-pressed`: Indicates toggle state (true/false)
- State should update via JavaScript on click

### Keyboard Navigation

**Required Keyboard Support** (native `<button>` behavior):
- **Tab**: Move focus to button
- **Shift+Tab**: Move focus to previous element
- **Enter**: Activate button
- **Space**: Activate button

**Implementation Notes**:
- Disabled buttons are not focusable
- Loading buttons remain focusable but `disabled` prevents activation

### Focus Management

**Focus Indicator Requirements** (WCAG 2.4.7):
- Visible focus indicator required for keyboard navigation
- Minimum 2px outline or ring
- 3:1 contrast ratio with background

**Implementation**:
```html
focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
```

### Screen Reader Considerations

1. **Icon-Only Buttons**: Must have `aria-label` providing button purpose
2. **Icons**: Must have `aria-hidden="true"` and `focusable="false"` to prevent announcement
3. **Loading State**: Hidden text via `sr-only` class announces loading to screen readers
4. **Button Text**: Provides accessible name automatically

---

## JavaScript Requirements

### Loading State Management

**Behavior**:
1. User clicks button to trigger async action
2. Button enters loading state (spinner visible, disabled)
3. On completion/error, button returns to normal state

**Stimulus Controller**:
```javascript
// app/javascript/controllers/button_loading_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["spinner", "text"]
  static values = { loading: Boolean }

  connect() {
    this.updateState()
  }

  loadingValueChanged() {
    this.updateState()
  }

  updateState() {
    if (this.loadingValue) {
      this.element.disabled = true
      this.element.setAttribute('aria-busy', 'true')
      this.spinnerTarget.classList.remove('hidden')
      this.textTarget.setAttribute('aria-hidden', 'true')
    } else {
      this.element.disabled = false
      this.element.removeAttribute('aria-busy')
      this.spinnerTarget.classList.add('hidden')
      this.textTarget.removeAttribute('aria-hidden')
    }
  }

  setLoading() {
    this.loadingValue = true
  }

  clearLoading() {
    this.loadingValue = false
  }
}
```

**Usage**:
```erb
<%= render Button.new(
  color: :primary,
  data: {
    controller: "button-loading",
    action: "ajax:before->button-loading#setLoading ajax:complete->button-loading#clearLoading"
  }
) do %>
  <svg data-button-loading-target="spinner" class="hidden h-4 w-4 animate-spin" aria-hidden="true">...</svg>
  <span data-button-loading-target="text">Save</span>
<% end %>
```

### Toggle State Management

For toggle buttons (aria-pressed):

```javascript
// app/javascript/controllers/button_toggle_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { pressed: Boolean }

  toggle(event) {
    event.preventDefault()
    this.pressedValue = !this.pressedValue
    this.element.setAttribute('aria-pressed', this.pressedValue.toString())

    // Dispatch custom event for application to handle
    this.dispatch("toggled", { detail: { pressed: this.pressedValue } })
  }
}
```

---

## HTML Patterns Used

### Pattern 1: Inline-Flex Items-Center Gap (Icon + Text)

```html
<button class="inline-flex items-center gap-2">
  <svg class="h-4 w-4" aria-hidden="true">...</svg>
  <span>Button Text</span>
</button>
```

**Purpose**: Horizontally align icon and text with consistent spacing.

**Key Utilities**:
- `inline-flex`: Display as inline flex container
- `items-center`: Vertical centering
- `gap-2`: 0.5rem spacing between icon and text

### Pattern 2: Rounded Border Background Padding

```html
<button class="rounded bg-blue-600 px-4 py-2 text-white">
  Button
</button>
```

**Purpose**: Core button container styling.

**Key Utilities**:
- `rounded`: Border radius (0.25rem)
- `bg-blue-600`: Background color
- `px-4 py-2`: Horizontal/vertical padding
- `text-white`: Text color

### Pattern 3: Hover/Focus/Active States

```html
<button class="
  bg-blue-600
  hover:bg-blue-700
  focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
  active:bg-blue-800
  disabled:cursor-not-allowed disabled:bg-gray-300 disabled:text-gray-500
">
  Button
</button>
```

**Purpose**: Interactive state feedback.

**Key Utilities**:
- `hover:bg-blue-700`: Darker background on hover
- `focus:ring-2`: Focus ring for keyboard navigation
- `active:bg-blue-800`: Darker background on click
- `disabled:*`: Gray styling when disabled

---

## Migration Guide

### Step 1: Update Component Class

**Before** (DaisyUI):
```ruby
# lib/kumiki/components/button.rb
class Button < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :md }

  def button_classes
    ["btn", color_class, size_class].compact.join(" ")
  end

  private

  def color_class
    "btn-#{color}" if color
  end

  def size_class
    "btn-#{size}" if size != :md
  end
end
```

**After** (HyperUI):
```ruby
# lib/kumiki/components/button.rb
class Button < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :md }
  option :style, default: -> { :filled }
  option :shape, default: -> { nil }
  option :loading, default: -> { false }
  option :disabled, default: -> { false }

  def button_classes
    [
      base_classes,
      size_classes,
      color_style_classes,
      shape_classes,
      state_classes
    ].compact.join(" ")
  end

  private

  def base_classes
    "inline-flex items-center gap-2 rounded font-medium transition-colors"
  end

  def size_classes
    SIZES[size] || SIZES[:md]
  end

  def color_style_classes
    COLORS.dig(color, style) || COLORS.dig(:primary, :filled)
  end

  def shape_classes
    SHAPES[shape] if shape
  end

  def state_classes
    classes = []
    classes << "cursor-not-allowed opacity-50" if disabled || loading
    classes.join(" ")
  end

  SIZES = {
    xs: "px-2 py-1 text-xs",
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-sm",
    lg: "px-6 py-3 text-base",
    xl: "px-8 py-4 text-lg"
  }.freeze

  COLORS = {
    neutral: {
      filled: "bg-gray-600 text-white hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-gray-500 focus:ring-offset-2 active:bg-gray-800",
      outline: "border border-gray-600 text-gray-600 bg-transparent hover:bg-gray-600 hover:text-white focus:outline-none focus:ring-2 focus:ring-gray-500",
      soft: "bg-gray-100 text-gray-700 hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-gray-500",
      ghost: "text-gray-600 hover:bg-gray-100 focus:outline-none focus:ring-2 focus:ring-gray-500",
      link: "text-gray-600 underline hover:no-underline bg-transparent p-0"
    },
    primary: {
      filled: "bg-blue-600 text-white hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 active:bg-blue-800",
      outline: "border border-blue-600 text-blue-600 bg-transparent hover:bg-blue-600 hover:text-white focus:outline-none focus:ring-2 focus:ring-blue-500",
      soft: "bg-blue-100 text-blue-700 hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-500",
      ghost: "text-blue-600 hover:bg-blue-100 focus:outline-none focus:ring-2 focus:ring-blue-500",
      link: "text-blue-600 underline hover:no-underline bg-transparent p-0"
    },
    # ... more colors
  }.freeze

  SHAPES = {
    wide: "px-12",
    block: "w-full block",
    square: "p-2 aspect-square",
    circle: "p-2 rounded-full aspect-square"
  }.freeze
end
```

### Step 2: Update Template

**Before** (DaisyUI):
```erb
<%= tag.button(**html_attributes) do %>
  <% if loading %>
    <span class="loading loading-spinner loading-sm mr-2"></span>
  <% end %>

  <% if icon %>
    <%= render_icon(icon, class: "w-4 h-4 mr-2") %>
  <% end %>

  <%= content %>
<% end %>
```

**After** (HyperUI):
```erb
<%= tag.button(**html_attributes) do %>
  <% if loading %>
    <svg class="h-4 w-4 animate-spin" aria-hidden="true" focusable="false">
      <!-- Spinner SVG -->
    </svg>
    <span class="sr-only">Loading, please wait</span>
  <% end %>

  <% if icon && !loading %>
    <%= render_icon(icon, class: "h-4 w-4", "aria-hidden": "true", focusable: "false") %>
  <% end %>

  <% if loading %>
    <span aria-hidden="true"><%= content %></span>
  <% else %>
    <%= content %>
  <% end %>
<% end %>
```

### Step 3: Update Usage Examples

**Before**:
```erb
<%= render Button.new(color: :primary, size: :md) do %>
  Save
<% end %>

<%= render Button.new(color: :primary, style: :outline) do %>
  Cancel
<% end %>

<%= render Button.new(color: :success, loading: true) do %>
  Saving...
<% end %>
```

**After** (API unchanged - internal implementation different):
```erb
<%= render Button.new(color: :primary, size: :md) do %>
  Save
<% end %>

<%= render Button.new(color: :primary, style: :outline) do %>
  Cancel
<% end %>

<%= render Button.new(color: :success, loading: true) do %>
  Saving...
<% end %>
```

### API Changes

**No Breaking Changes**: The component API remains the same. All changes are internal to class generation.

**New Options Available**:
- `style:` now supports `:soft` and `:link` variants
- `shape:` supports `:wide`, `:block`, `:square`, `:circle`

### Migration Steps

1. **Backup Current Implementation**: Copy existing button component files
2. **Update Component Class**: Replace class generation logic with HyperUI patterns
3. **Update Template**: Replace DaisyUI-specific markup with HyperUI patterns
4. **Test Visually**: Verify all variants render correctly
5. **Test Accessibility**: Verify keyboard navigation, focus states, screen reader compatibility
6. **Update Storybook**: Update component stories with new variants
7. **Deploy**: Release new button component

### Migration Notes

- **No CSS Changes Required**: All styling comes from Tailwind utilities
- **Loading State**: Requires updated Stimulus controller for `aria-busy` management
- **Icon-Only Buttons**: Ensure `aria-label` is provided
- **Theme Colors**: Map semantic colors (primary, secondary) to specific Tailwind colors in implementation

---

## Testing Considerations

### Visual Regression Testing

**Key Test Scenarios**:
1. **All Color Variants**: Verify primary, secondary, accent, success, warning, error, info, neutral
2. **All Size Variants**: Verify xs, sm, md, lg, xl
3. **All Style Variants**: Verify filled, outline, soft, ghost, link
4. **All Shape Modifiers**: Verify wide, block, square, circle
5. **State Variations**: Verify hover, focus, active, disabled, loading
6. **Icon Buttons**: Verify icon placement, icon-only buttons
7. **Responsive**: Verify rendering at mobile, tablet, desktop breakpoints

**Screenshot Comparison**:
- Capture before (DaisyUI) and after (HyperUI) screenshots
- Compare visually for consistency
- Note intentional design differences

### Accessibility Testing

**Automated Tests** (axe-core):
```javascript
describe('Button accessibility', () => {
  it('passes axe accessibility checks', async () => {
    const html = renderButton({ color: 'primary' }, 'Click Me')
    const results = await axe(html)
    expect(results.violations).toHaveLength(0)
  })
})
```

**Manual Tests**:
1. **Keyboard Navigation**:
   - Tab to button, verify focus indicator visible
   - Press Enter, verify button activates
   - Press Space, verify button activates
   - Verify disabled buttons are not focusable

2. **Screen Reader Testing** (VoiceOver, NVDA, JAWS):
   - Button with text: Announces "Click Me, button"
   - Icon-only button: Announces aria-label, button
   - Loading button: Announces loading state and loading text
   - Toggle button: Announces pressed/not pressed state

3. **Color Contrast**:
   - Verify button text has 4.5:1 contrast ratio with background
   - Verify focus ring has 3:1 contrast ratio with background

### Functional Testing

**RSpec Component Tests**:
```ruby
RSpec.describe Button, type: :component do
  describe "rendering" do
    it "renders with primary color" do
      result = render_inline(Button.new(color: :primary)) { "Click" }
      expect(result.css("button").text).to eq("Click")
      expect(result.css("button").attr("class")).to include("bg-blue-600")
    end

    it "renders with outline style" do
      result = render_inline(Button.new(style: :outline, color: :primary)) { "Click" }
      expect(result.css("button").attr("class")).to include("border")
      expect(result.css("button").attr("class")).to include("border-blue-600")
    end

    it "renders disabled state" do
      result = render_inline(Button.new(disabled: true)) { "Click" }
      expect(result.css("button").attr("disabled")).to be_present
    end

    it "renders loading state with aria-busy" do
      result = render_inline(Button.new(loading: true)) { "Loading" }
      expect(result.css("button").attr("aria-busy")).to eq("true")
      expect(result.css("button").attr("disabled")).to be_present
    end

    it "renders icon-only button with aria-label" do
      result = render_inline(Button.new(icon: :close, aria_label: "Close dialog")) { "" }
      expect(result.css("button").attr("aria-label")).to eq("Close dialog")
      expect(result.css("svg").attr("aria-hidden")).to eq("true")
    end
  end
end
```

### Edge Cases to Verify

1. **Long Text**: Verify text wrapping behavior
2. **Multiple Icons**: Verify layout with leading and trailing icons
3. **Empty Content**: Verify icon-only buttons require aria-label
4. **Loading + Disabled**: Verify both states can coexist
5. **Shape + Size Combinations**: Verify square/circle with different sizes
6. **Link Style in Flex Container**: Verify link buttons align correctly

---

## Implementation Checklist

### Development

- [ ] Create COLORS constant with all color variants (8 colors × 5 styles = 40 combinations)
- [ ] Create SIZES constant with all size variants (5 sizes)
- [ ] Create SHAPES constant with shape modifiers (4 shapes)
- [ ] Implement base_classes method
- [ ] Implement size_classes method
- [ ] Implement color_style_classes method
- [ ] Implement shape_classes method
- [ ] Implement state_classes method
- [ ] Update template with HyperUI HTML patterns
- [ ] Add loading state markup with aria-busy
- [ ] Add icon-only button support with aria-label validation
- [ ] Add toggle button support with aria-pressed

### Testing

- [ ] Write unit tests for all color variants
- [ ] Write unit tests for all size variants
- [ ] Write unit tests for all style variants
- [ ] Write unit tests for shape modifiers
- [ ] Write unit tests for state combinations (disabled, loading)
- [ ] Write accessibility tests (axe-core)
- [ ] Perform manual keyboard navigation testing
- [ ] Perform manual screen reader testing
- [ ] Verify color contrast for all variants
- [ ] Capture visual regression screenshots

### Documentation

- [ ] Update component README with new API
- [ ] Add Storybook stories for all variants
- [ ] Document breaking changes (if any)
- [ ] Add migration examples to changelog
- [ ] Update design system documentation

### Deployment

- [ ] Merge to feature branch
- [ ] Deploy to staging environment
- [ ] Verify in staging
- [ ] Get design review approval
- [ ] Deploy to production
- [ ] Monitor for issues

---

**Status**: Ready for Implementation
**Estimated Effort**: 2-3 days
**Priority**: High (foundational component)
