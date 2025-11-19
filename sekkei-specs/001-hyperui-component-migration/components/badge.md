# Badge Component Migration Guide

**Component**: Badge
**DaisyUI Baseline**: [DaisyUI Badge](https://daisyui.com/components/badge/)
**HyperUI Target**: [HyperUI Application Badges](https://www.hyperui.dev/components/application/badges)
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

The Badge component is a small label element used to display status, counts, or categorization throughout the application. It provides visual emphasis for metadata and supports multiple variants (colors, sizes, styles) to convey different semantic meanings.

### Current DaisyUI Implementation

**Location**: `/lib/kumiki/components/badge.rb`

DaisyUI uses semantic component classes:
- Base class: `badge`
- Modifiers: `badge-primary`, `badge-lg`, `badge-outline`
- Presentational element (no interactive behavior by default)

**Philosophy**: Semantic, theme-aware component classes for consistent status indicators.

### HyperUI Target

HyperUI provides 10 badge variants composed of utility classes:
- Utility-first approach with explicit Tailwind classes
- Direct color scale references (blue-600, green-600, etc.)
- Flexible composition for icons, close buttons, and text
- State management via Tailwind pseudo-classes

**Philosophy**: Utility composition for maximum visual flexibility.

### Migration Complexity Rating: Easy

**Justification**:
- Simple HTML structure (span or div element)
- No JavaScript required (unless implementing dismissible badges)
- Clear mapping from semantic classes to utility combinations
- Well-documented HyperUI variants
- Straightforward state management

---

## Variant Analysis

### DaisyUI Variants Available

#### Color Variants (8)

```html
<span class="badge badge-neutral">Neutral</span>
<span class="badge badge-primary">Primary</span>
<span class="badge badge-secondary">Secondary</span>
<span class="badge badge-accent">Accent</span>
<span class="badge badge-info">Info</span>
<span class="badge badge-success">Success</span>
<span class="badge badge-warning">Warning</span>
<span class="badge badge-error">Error</span>
```

#### Size Variants (5)

```html
<span class="badge badge-xs">Extra Small</span>
<span class="badge badge-sm">Small</span>
<span class="badge badge-md">Medium</span>
<span class="badge badge-lg">Large</span>
<span class="badge badge-xl">Extra Large</span>
```

#### Style Variants (4)

```html
<span class="badge">Filled (default)</span>
<span class="badge badge-outline">Outline</span>
<span class="badge badge-soft">Soft</span>
<span class="badge badge-ghost">Ghost</span>
```

### HyperUI Variants Available

HyperUI provides 10 example badges with utility-based variants:

#### Color (via utility combinations)

```html
<!-- Primary (Blue) Filled -->
<span class="inline-flex items-center rounded bg-blue-600 px-2.5 py-0.5 text-xs font-medium text-white">
  Primary
</span>

<!-- Success (Green) Soft -->
<span class="inline-flex items-center rounded bg-green-100 px-2.5 py-0.5 text-xs font-medium text-green-700">
  Success
</span>

<!-- Error (Red) Outline -->
<span class="inline-flex items-center rounded border border-red-600 px-2.5 py-0.5 text-xs font-medium text-red-600">
  Error
</span>
```

#### Size (via padding/text utilities)

```html
<!-- Extra Small -->
<span class="inline-flex items-center rounded bg-blue-600 px-2 py-0.5 text-xs text-white">
  XS
</span>

<!-- Small (default) -->
<span class="inline-flex items-center rounded bg-blue-600 px-2.5 py-0.5 text-xs text-white">
  SM
</span>

<!-- Medium -->
<span class="inline-flex items-center rounded bg-blue-600 px-3 py-1 text-sm text-white">
  MD
</span>

<!-- Large -->
<span class="inline-flex items-center rounded bg-blue-600 px-3.5 py-1.5 text-base text-white">
  LG
</span>
```

#### Style (via border/background utilities)

```html
<!-- Filled -->
<span class="inline-flex items-center rounded bg-blue-600 px-2.5 py-0.5 text-white">
  Filled
</span>

<!-- Soft (light background) -->
<span class="inline-flex items-center rounded bg-blue-100 px-2.5 py-0.5 text-blue-700">
  Soft
</span>

<!-- Outline -->
<span class="inline-flex items-center rounded border border-blue-600 bg-transparent px-2.5 py-0.5 text-blue-600">
  Outline
</span>

<!-- Ghost (no background) -->
<span class="inline-flex items-center text-blue-600">
  Ghost
</span>
```

#### With Icons/Dots

```html
<!-- With leading dot -->
<span class="inline-flex items-center gap-1.5 rounded bg-blue-600 px-2.5 py-0.5 text-xs text-white">
  <span class="h-1.5 w-1.5 rounded-full bg-white"></span>
  Active
</span>

<!-- With icon -->
<span class="inline-flex items-center gap-1 rounded bg-green-100 px-2.5 py-0.5 text-xs text-green-700">
  <svg class="h-3 w-3" aria-hidden="true">✓</svg>
  Verified
</span>

<!-- Dismissible (with close button) -->
<span class="inline-flex items-center gap-2 rounded bg-blue-600 px-2.5 py-0.5 text-xs text-white">
  Tag
  <button type="button" class="hover:text-gray-200" aria-label="Remove tag">
    <svg class="h-3 w-3" aria-hidden="true">×</svg>
  </button>
</span>
```

#### Shape Modifiers

```html
<!-- Rounded (default) -->
<span class="inline-flex items-center rounded ...">Badge</span>

<!-- Pill (fully rounded) -->
<span class="inline-flex items-center rounded-full ...">Badge</span>

<!-- Square (no rounding) -->
<span class="inline-flex items-center ...">Badge</span>
```

### Variant Gaps

#### DaisyUI → HyperUI Gaps

1. **Semantic Color Names**: DaisyUI uses `primary`, `secondary`, `accent`; HyperUI uses direct color references
   - **Solution**: Create mapping layer from semantic names to Tailwind colors

2. **Ghost Style**: Not explicitly shown in HyperUI, but straightforward to implement
   - **Solution**: Define as transparent background with colored text

#### HyperUI → DaisyUI Opportunities

1. **Icon Integration**: HyperUI shows more flexible icon patterns
2. **Dismissible Badges**: Close button patterns with transitions
3. **Dot Indicators**: Leading/trailing dot patterns for status
4. **Custom Shapes**: More control over border radius

### Variant Mapping Table

| DaisyUI Variant | HyperUI Equivalent | Implementation |
|-----------------|-------------------|----------------|
| `badge-primary` | `bg-blue-600 text-white` | Direct mapping |
| `badge-secondary` | `bg-purple-600 text-white` | Direct mapping |
| `badge-accent` | `bg-pink-600 text-white` | Direct mapping |
| `badge-success` | `bg-green-600 text-white` | Direct mapping |
| `badge-error` | `bg-red-600 text-white` | Direct mapping |
| `badge-warning` | `bg-yellow-600 text-white` | Direct mapping |
| `badge-info` | `bg-cyan-600 text-white` | Direct mapping |
| `badge-neutral` | `bg-gray-600 text-white` | Direct mapping |
| `badge-outline` | `border border-{color}-600 text-{color}-600 bg-transparent` | Direct mapping |
| `badge-soft` | `bg-{color}-100 text-{color}-700` | Direct mapping |
| `badge-ghost` | `text-{color}-600 bg-transparent` | Direct mapping |
| `badge-xs` | `px-2 py-0.5 text-xs` | Direct mapping |
| `badge-sm` | `px-2.5 py-0.5 text-xs` | Direct mapping |
| `badge-md` | `px-3 py-1 text-sm` | Direct mapping |
| `badge-lg` | `px-3.5 py-1.5 text-base` | Direct mapping |
| `badge-xl` | `px-4 py-2 text-lg` | Direct mapping |

---

## HTML Structure Comparison

### Current DaisyUI Structure

```erb
<%= render Badge.new(color: :primary, size: :sm) do %>
  Active
<% end %>
```

**Generated HTML**:
```html
<span class="badge badge-primary badge-sm">
  Active
</span>
```

**With Icon**:
```erb
<%= render Badge.new(color: :success, icon: :check) do %>
  Verified
<% end %>
```

```html
<span class="badge badge-success">
  <svg class="w-3 h-3 mr-1">...</svg>
  Verified
</span>
```

### HyperUI Target Structure

```html
<!-- Basic Badge -->
<span class="inline-flex items-center rounded bg-blue-600 px-2.5 py-0.5 text-xs font-medium text-white">
  Active
</span>

<!-- With Dot Indicator -->
<span class="inline-flex items-center gap-1.5 rounded bg-green-100 px-2.5 py-0.5 text-xs font-medium text-green-700">
  <span class="h-1.5 w-1.5 rounded-full bg-green-600"></span>
  Online
</span>

<!-- With Icon -->
<span class="inline-flex items-center gap-1 rounded bg-green-100 px-2.5 py-0.5 text-xs font-medium text-green-700">
  <svg class="h-3 w-3" aria-hidden="true" focusable="false">✓</svg>
  Verified
</span>

<!-- Dismissible -->
<span class="inline-flex items-center gap-2 rounded bg-blue-600 px-2.5 py-0.5 text-xs font-medium text-white">
  <span>Technology</span>
  <button type="button" class="hover:text-gray-200" aria-label="Remove Technology tag">
    <svg class="h-3 w-3" aria-hidden="true" focusable="false">×</svg>
  </button>
</span>
```

### Key Structural Differences

1. **Display Model**: DaisyUI uses `badge` (implicit inline-block), HyperUI uses explicit `inline-flex items-center`

2. **Icon Layout**:
   - DaisyUI: Icon as direct child with margin
   - HyperUI: `inline-flex items-center gap-1` for icon + text layout

3. **Dot Indicators**:
   - DaisyUI: Not standard
   - HyperUI: Common pattern with `span` element for status dot

4. **Typography**:
   - DaisyUI: Handled by component class
   - HyperUI: Explicit `text-xs font-medium`

5. **Dismissible Pattern**:
   - DaisyUI: Not standard
   - HyperUI: Button element with hover state

---

## Accessibility Requirements

### ARIA Attributes Required

#### Standard Badge (Presentational)
```html
<span class="...">
  Badge Text
</span>
```
**Note**: Presentational badges with visible text require no ARIA attributes.

#### Status Badge (Semantic)
```html
<span class="..." role="status" aria-label="Status: Active">
  <span class="h-1.5 w-1.5 rounded-full bg-green-600" aria-hidden="true"></span>
  Active
</span>
```
- `role="status"`: Indicates this badge conveys status information
- `aria-label`: Provides context when dot alone is insufficient
- Dot must have `aria-hidden="true"` (decorative)

#### Badge with Icon
```html
<span class="...">
  <svg aria-hidden="true" focusable="false">✓</svg>
  <span>Verified</span>
</span>
```
- Icons must have `aria-hidden="true"` and `focusable="false"`
- Text provides accessible label

#### Dismissible Badge
```html
<span class="...">
  <span>Tag Name</span>
  <button type="button" aria-label="Remove Tag Name tag">
    <svg aria-hidden="true" focusable="false">×</svg>
  </button>
</span>
```
- Close button must have descriptive `aria-label`
- Icon must have `aria-hidden="true"` and `focusable="false"`
- Button must be keyboard accessible

### Keyboard Navigation

**Required Keyboard Support** (for dismissible badges):
- **Tab**: Move focus to close button
- **Shift+Tab**: Move focus to previous element
- **Enter**: Remove badge
- **Space**: Remove badge

**Implementation Notes**:
- Non-interactive badges are not focusable
- Dismissible badge close button must be focusable

### Focus Management

**Focus Indicator Requirements** (WCAG 2.4.7):
- Close button requires visible focus indicator
- Minimum 2px outline or ring
- 3:1 contrast ratio with background

**Implementation**:
```html
<button class="... focus:outline-none focus:ring-2 focus:ring-blue-500">
  ×
</button>
```

### Screen Reader Considerations

1. **Presentational Badges**: Read as plain text
2. **Status Badges**: Use `role="status"` for dynamic status updates
3. **Icons/Dots**: Must have `aria-hidden="true"` to prevent announcement
4. **Dismissible Badges**: Close button announces as "Remove [badge text] tag, button"

### Color Contrast

**WCAG Requirements**:
- Text on badge background: 4.5:1 minimum contrast ratio
- Close button icon: 3:1 minimum contrast ratio
- Focus indicator: 3:1 minimum contrast ratio

**Common Issues**:
- Yellow badges with white text (warning badges)
- Light soft backgrounds with light text
- Gray ghost badges on white backgrounds

**Solutions**:
```html
<!-- Warning badge with sufficient contrast -->
<span class="bg-yellow-600 text-white">Warning</span>  <!-- Good: 4.8:1 -->

<!-- NOT: bg-yellow-400 text-white (insufficient contrast) -->

<!-- Soft badge with dark text -->
<span class="bg-blue-100 text-blue-700">Info</span>  <!-- Good: 9.2:1 -->
```

---

## JavaScript Requirements

### Dismissible Badge Management

**Behavior**:
1. User clicks close button
2. Badge animates out (optional)
3. Badge is removed from DOM
4. Event is dispatched for application handling

**Stimulus Controller**:
```javascript
// app/javascript/controllers/badge_dismissible_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["badge"]

  dismiss(event) {
    event.preventDefault()

    // Optional: Fade out animation
    this.element.classList.add('opacity-0', 'transition-opacity', 'duration-200')

    // Remove after animation completes
    setTimeout(() => {
      // Dispatch custom event for application to handle
      this.dispatch("dismissed", {
        detail: {
          value: this.element.textContent.trim()
        }
      })

      this.element.remove()
    }, 200)
  }
}
```

**Usage**:
```erb
<%= render Badge.new(
  color: :primary,
  dismissible: true,
  data: {
    controller: "badge-dismissible",
    action: "click->badge-dismissible#dismiss"
  }
) do %>
  <span>Technology</span>
  <button
    type="button"
    data-action="badge-dismissible#dismiss"
    aria-label="Remove Technology tag"
  >
    <svg>×</svg>
  </button>
<% end %>
```

### No JavaScript Required (Non-Dismissible)

Non-dismissible badges are purely presentational and require no JavaScript.

---

## HTML Patterns Used

### Pattern 1: Inline-Flex Items-Center Gap (Icon + Text)

```html
<span class="inline-flex items-center gap-1.5">
  <svg class="h-3 w-3" aria-hidden="true">...</svg>
  <span>Badge Text</span>
</span>
```

**Purpose**: Horizontally align icon/dot and text with consistent spacing.

**Key Utilities**:
- `inline-flex`: Display as inline flex container
- `items-center`: Vertical centering
- `gap-1.5`: 0.375rem spacing between icon and text

### Pattern 2: Rounded Background Padding

```html
<span class="rounded bg-blue-600 px-2.5 py-0.5 text-white">
  Badge
</span>
```

**Purpose**: Core badge container styling.

**Key Utilities**:
- `rounded`: Border radius (0.25rem)
- `bg-blue-600`: Background color
- `px-2.5 py-0.5`: Horizontal/vertical padding (compact)
- `text-white`: Text color

### Pattern 3: Pill Shape

```html
<span class="rounded-full bg-blue-600 px-3 py-0.5">
  Badge
</span>
```

**Purpose**: Fully rounded pill-shaped badge.

**Key Utilities**:
- `rounded-full`: Full border radius (9999px)
- Slightly increased horizontal padding for visual balance

---

## Migration Guide

### Step 1: Update Component Class

**Before** (DaisyUI):
```ruby
# lib/kumiki/components/badge.rb
class Badge < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :sm }

  def badge_classes
    ["badge", color_class, size_class].compact.join(" ")
  end

  private

  def color_class
    "badge-#{color}" if color
  end

  def size_class
    "badge-#{size}" if size != :sm
  end
end
```

**After** (HyperUI):
```ruby
# lib/kumiki/components/badge.rb
class Badge < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :sm }
  option :style, default: -> { :filled }
  option :shape, default: -> { :rounded }
  option :dot, default: -> { false }
  option :dismissible, default: -> { false }

  def badge_classes
    [
      base_classes,
      size_classes,
      color_style_classes,
      shape_classes
    ].compact.join(" ")
  end

  private

  def base_classes
    "inline-flex items-center font-medium"
  end

  def size_classes
    SIZES[size] || SIZES[:sm]
  end

  def color_style_classes
    COLORS.dig(color, style) || COLORS.dig(:primary, :filled)
  end

  def shape_classes
    SHAPES[shape] if shape
  end

  SIZES = {
    xs: "gap-1 px-2 py-0.5 text-xs",
    sm: "gap-1.5 px-2.5 py-0.5 text-xs",
    md: "gap-1.5 px-3 py-1 text-sm",
    lg: "gap-2 px-3.5 py-1.5 text-base",
    xl: "gap-2 px-4 py-2 text-lg"
  }.freeze

  COLORS = {
    neutral: {
      filled: "bg-gray-600 text-white",
      soft: "bg-gray-100 text-gray-700",
      outline: "border border-gray-600 text-gray-600 bg-transparent",
      ghost: "text-gray-600 bg-transparent"
    },
    primary: {
      filled: "bg-blue-600 text-white",
      soft: "bg-blue-100 text-blue-700",
      outline: "border border-blue-600 text-blue-600 bg-transparent",
      ghost: "text-blue-600 bg-transparent"
    },
    secondary: {
      filled: "bg-purple-600 text-white",
      soft: "bg-purple-100 text-purple-700",
      outline: "border border-purple-600 text-purple-600 bg-transparent",
      ghost: "text-purple-600 bg-transparent"
    },
    accent: {
      filled: "bg-pink-600 text-white",
      soft: "bg-pink-100 text-pink-700",
      outline: "border border-pink-600 text-pink-600 bg-transparent",
      ghost: "text-pink-600 bg-transparent"
    },
    info: {
      filled: "bg-cyan-600 text-white",
      soft: "bg-cyan-100 text-cyan-700",
      outline: "border border-cyan-600 text-cyan-600 bg-transparent",
      ghost: "text-cyan-600 bg-transparent"
    },
    success: {
      filled: "bg-green-600 text-white",
      soft: "bg-green-100 text-green-700",
      outline: "border border-green-600 text-green-600 bg-transparent",
      ghost: "text-green-600 bg-transparent"
    },
    warning: {
      filled: "bg-yellow-600 text-white",
      soft: "bg-yellow-100 text-yellow-700",
      outline: "border border-yellow-600 text-yellow-600 bg-transparent",
      ghost: "text-yellow-600 bg-transparent"
    },
    error: {
      filled: "bg-red-600 text-white",
      soft: "bg-red-100 text-red-700",
      outline: "border border-red-600 text-red-600 bg-transparent",
      ghost: "text-red-600 bg-transparent"
    }
  }.freeze

  SHAPES = {
    rounded: "rounded",
    pill: "rounded-full",
    square: ""
  }.freeze
end
```

### Step 2: Update Template

**Before** (DaisyUI):
```erb
<%= tag.span(**html_attributes) do %>
  <% if icon %>
    <%= render_icon(icon, class: "w-3 h-3 mr-1") %>
  <% end %>

  <%= content %>
<% end %>
```

**After** (HyperUI):
```erb
<%= tag.span(**html_attributes) do %>
  <% if dot %>
    <span class="h-1.5 w-1.5 rounded-full <%= dot_color %>" aria-hidden="true"></span>
  <% elsif icon %>
    <%= render_icon(icon, class: "h-3 w-3", "aria-hidden": "true", focusable: "false") %>
  <% end %>

  <span><%= content %></span>

  <% if dismissible %>
    <button
      type="button"
      class="hover:text-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-500"
      aria-label="Remove <%= content %> tag"
    >
      <svg class="h-3 w-3" aria-hidden="true" focusable="false">
        <!-- Close icon -->
        <path d="M6 18L18 6M6 6l12 12" stroke="currentColor" stroke-width="2"/>
      </svg>
    </button>
  <% end %>
<% end %>
```

### Step 3: Update Usage Examples

**Before**:
```erb
<%= render Badge.new(color: :success, size: :sm) do %>
  Active
<% end %>

<%= render Badge.new(color: :warning, style: :outline) do %>
  Pending
<% end %>
```

**After** (API unchanged - internal implementation different):
```erb
<%= render Badge.new(color: :success, size: :sm) do %>
  Active
<% end %>

<%= render Badge.new(color: :warning, style: :outline) do %>
  Pending
<% end %>

<!-- New features available -->
<%= render Badge.new(color: :success, dot: true) do %>
  Online
<% end %>

<%= render Badge.new(color: :primary, dismissible: true) do %>
  Technology
<% end %>
```

### API Changes

**No Breaking Changes**: The component API remains the same. All changes are internal to class generation.

**New Options Available**:
- `dot:` supports status dot indicator
- `dismissible:` supports close button
- `shape:` supports `:rounded`, `:pill`, `:square`

### Migration Steps

1. **Backup Current Implementation**: Copy existing badge component files
2. **Update Component Class**: Replace class generation logic with HyperUI patterns
3. **Update Template**: Replace DaisyUI-specific markup with HyperUI patterns
4. **Test Visually**: Verify all variants render correctly
5. **Test Accessibility**: Verify keyboard navigation, focus states, screen reader compatibility
6. **Update Storybook**: Update component stories with new variants
7. **Deploy**: Release new badge component

---

## Testing Considerations

### Visual Regression Testing

**Key Test Scenarios**:
1. **All Color Variants**: Verify primary, secondary, accent, success, warning, error, info, neutral
2. **All Size Variants**: Verify xs, sm, md, lg, xl
3. **All Style Variants**: Verify filled, soft, outline, ghost
4. **All Shape Variations**: Verify rounded, pill, square
5. **With Dot Indicator**: Verify dot displays correctly
6. **With Icon**: Verify icon alignment
7. **Dismissible**: Verify close button displays and functions
8. **Color Contrast**: Verify all combinations meet WCAG AA standards

### Accessibility Testing

**Automated Tests** (axe-core):
```javascript
describe('Badge accessibility', () => {
  it('passes axe accessibility checks', async () => {
    const html = renderBadge({ color: 'success' }, 'Active')
    const results = await axe(html)
    expect(results.violations).toHaveLength(0)
  })

  it('dismissible badge has accessible close button', async () => {
    const html = renderBadge({ dismissible: true }, 'Tag')
    expect(html).toContain('aria-label="Remove Tag tag"')
  })
})
```

**Manual Tests**:
1. **Keyboard Navigation** (dismissible only):
   - Tab to close button, verify focus indicator visible
   - Press Enter, verify badge is dismissed
   - Press Space, verify badge is dismissed

2. **Screen Reader Testing** (VoiceOver, NVDA, JAWS):
   - Standard badge: Announces text content
   - Status badge with dot: Announces "Status: Active" or similar
   - Dismissible badge: Announces "Remove [text] tag, button" on close button

3. **Color Contrast**:
   - Verify all color combinations have 4.5:1 contrast ratio
   - Verify close button icon has 3:1 contrast ratio
   - Test warning badges especially (yellow can be problematic)

### Functional Testing

**RSpec Component Tests**:
```ruby
RSpec.describe Badge, type: :component do
  describe "rendering" do
    it "renders with success color" do
      result = render_inline(Badge.new(color: :success)) { "Active" }
      expect(result.css("span").text).to eq("Active")
      expect(result.css("span").attr("class")).to include("bg-green-600")
    end

    it "renders with soft style" do
      result = render_inline(Badge.new(style: :soft, color: :primary)) { "Info" }
      expect(result.css("span").attr("class")).to include("bg-blue-100")
      expect(result.css("span").attr("class")).to include("text-blue-700")
    end

    it "renders with dot indicator" do
      result = render_inline(Badge.new(dot: true, color: :success)) { "Online" }
      expect(result.css("span span.h-1.5").count).to eq(1)
    end

    it "renders with close button when dismissible" do
      result = render_inline(Badge.new(dismissible: true)) { "Tag" }
      expect(result.css("button").count).to eq(1)
      expect(result.css("button").attr("aria-label")).to include("Remove Tag")
    end
  end
end
```

### Edge Cases to Verify

1. **Long Text**: Verify badge doesn't break layout with very long text
2. **Empty Content**: Verify badge with only icon/dot displays correctly
3. **Multiple Badges in Row**: Verify spacing when multiple badges are adjacent
4. **Badge in Button**: Verify badge renders correctly when nested in button
5. **Dismissible Animation**: Verify smooth fade-out animation

---

## Implementation Checklist

### Development

- [ ] Create COLORS constant with all color variants (8 colors × 4 styles = 32 combinations)
- [ ] Create SIZES constant with all size variants (5 sizes)
- [ ] Create SHAPES constant with shape modifiers (3 shapes)
- [ ] Implement base_classes method
- [ ] Implement size_classes method
- [ ] Implement color_style_classes method
- [ ] Implement shape_classes method
- [ ] Update template with HyperUI HTML patterns
- [ ] Add dot indicator support
- [ ] Add icon support with proper ARIA attributes
- [ ] Add dismissible badge support with close button
- [ ] Create Stimulus controller for dismissible behavior

### Testing

- [ ] Write unit tests for all color variants
- [ ] Write unit tests for all size variants
- [ ] Write unit tests for all style variants
- [ ] Write unit tests for shape modifiers
- [ ] Write unit tests for dot indicator
- [ ] Write unit tests for dismissible behavior
- [ ] Write accessibility tests (axe-core)
- [ ] Perform manual keyboard navigation testing (dismissible)
- [ ] Perform manual screen reader testing
- [ ] Verify color contrast for all variants (especially warning)
- [ ] Capture visual regression screenshots

### Documentation

- [ ] Update component README with new API
- [ ] Add Storybook stories for all variants
- [ ] Document new features (dot, dismissible, shape)
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
**Estimated Effort**: 1-2 days
**Priority**: High (commonly used component)
