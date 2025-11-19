# Variant Comparison: DaisyUI vs HyperUI

**Feature**: 001-hyperui-component-migration
**Created**: 2025-11-19
**Status**: Analysis Document

## Table of Contents

1. [Overview](#overview)
2. [Philosophy Comparison](#philosophy-comparison)
3. [Variant Availability Matrix](#variant-availability-matrix)
4. [Component-by-Component Analysis](#component-by-component-analysis)
5. [Gap Analysis](#gap-analysis)
6. [Migration Recommendations](#migration-recommendations)
7. [Implementation Strategy](#implementation-strategy)

---

## Overview

This document analyzes the variant systems between DaisyUI and HyperUI to inform the migration strategy for Kumiki Rails components. The fundamental challenge is bridging two different design philosophies:

- **DaisyUI**: Semantic, prop-based variants with consistent naming across components
- **HyperUI**: Utility-first, class-based styling with visual diversity through utility combinations

### Key Insights

1. **Semantic vs Utility-First**: DaisyUI uses props like `color="primary"` while HyperUI uses utility classes like `bg-blue-600 text-white`
2. **Consistency vs Flexibility**: DaisyUI prioritizes consistent APIs; HyperUI prioritizes design flexibility
3. **Variant Count**: DaisyUI has fewer, well-defined variants; HyperUI has infinite combinations
4. **State Management**: DaisyUI handles states through data attributes; HyperUI uses Tailwind pseudo-classes
5. **Theme Integration**: DaisyUI variants map to theme variables; HyperUI uses Tailwind's color system

---

## Philosophy Comparison

### DaisyUI Approach

**Characteristics**:
- Semantic variant names (`primary`, `secondary`, `accent`, etc.)
- Consistent prop API across all components
- Theme-aware (variants reference CSS custom properties)
- Limited but predictable options
- State managed through data attributes

**Example**:
```erb
<%= render Button.new(color: :primary, size: :lg, style: :outline) do %>
  Click Me
<% end %>
```

**Generated HTML**:
```html
<button class="btn btn-primary btn-lg btn-outline">
  Click Me
</button>
```

### HyperUI Approach

**Characteristics**:
- Utility-first class combinations
- No semantic variant names
- Direct Tailwind color scale usage
- Infinite customization through utility combinations
- State managed through Tailwind pseudo-classes

**Example**:
```html
<button class="inline-block rounded border border-blue-600 bg-blue-600 px-12 py-3 text-sm font-medium text-white hover:bg-transparent hover:text-blue-600 focus:outline-none focus:ring active:text-blue-500">
  Click Me
</button>
```

### Kumiki Rails Strategy

**Proposed Approach**:
Provide semantic variant props that generate HyperUI-style utility class combinations:

```ruby
class Button < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :md }
  option :style, default: -> { :filled }

  private

  def color_classes
    COLORS[color] || COLORS[:primary]
  end

  COLORS = {
    primary: "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500",
    secondary: "bg-gray-600 text-white hover:bg-gray-700 focus:ring-gray-500",
    # ... more mappings
  }.freeze
end
```

---

## Variant Availability Matrix

### Legend

- **Full**: Complete support with multiple options
- **Partial**: Limited support or requires custom implementation
- **None**: No direct equivalent
- **Custom**: Requires custom Kumiki implementation

| Component | Color Variants | Size Variants | Style Variants | State Variants | Shape Modifiers |
|-----------|----------------|---------------|----------------|----------------|-----------------|
| **Button** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: Full (6)<br>HyperUI: Partial (examples) | DaisyUI: Full<br>HyperUI: Full (Tailwind) | DaisyUI: Full (4)<br>HyperUI: Custom via utilities |
| **Badge** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: Full (4)<br>HyperUI: Partial (examples) | DaisyUI: None<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |
| **Card** | DaisyUI: Theme-based<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: Partial (4)<br>HyperUI: Partial (examples) | DaisyUI: None<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |
| **Modal** | DaisyUI: Theme-based<br>HyperUI: Custom via utilities | DaisyUI: None<br>HyperUI: Custom via utilities | DaisyUI: None<br>HyperUI: Partial (examples) | DaisyUI: Full (open)<br>HyperUI: Full (Tailwind) | DaisyUI: Full (position)<br>HyperUI: Custom via utilities |
| **Toast** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: None<br>HyperUI: Custom via utilities | DaisyUI: None<br>HyperUI: Partial (examples) | DaisyUI: None<br>HyperUI: Full (Tailwind) | DaisyUI: Full (9 positions)<br>HyperUI: Custom via utilities |
| **FormInput** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: Partial (ghost)<br>HyperUI: Partial (examples) | DaisyUI: Full<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |
| **FormSelect** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: Partial (ghost)<br>HyperUI: Partial (examples) | DaisyUI: Full<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |
| **FormTextarea** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: Partial (ghost)<br>HyperUI: Partial (examples) | DaisyUI: Full<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |
| **FormCheckbox** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: None<br>HyperUI: Partial (examples) | DaisyUI: Full<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |
| **FormRadio** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: None<br>HyperUI: Partial (examples) | DaisyUI: Full<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |
| **FormFileInput** | DaisyUI: Full (8)<br>HyperUI: Custom via utilities | DaisyUI: Full (5)<br>HyperUI: Custom via utilities | DaisyUI: Partial (ghost)<br>HyperUI: Partial (examples) | DaisyUI: Full<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |
| **FormDatePicker** | DaisyUI: None (custom)<br>HyperUI: Custom via utilities | DaisyUI: None (custom)<br>HyperUI: Custom via utilities | DaisyUI: None (custom)<br>HyperUI: Partial (examples) | DaisyUI: None (custom)<br>HyperUI: Full (Tailwind) | DaisyUI: None (custom)<br>HyperUI: Custom via utilities |
| **FormError** | DaisyUI: Full (8, via alert)<br>HyperUI: Custom via utilities | DaisyUI: None<br>HyperUI: Custom via utilities | DaisyUI: None<br>HyperUI: Partial (examples) | DaisyUI: None<br>HyperUI: Full (Tailwind) | DaisyUI: None<br>HyperUI: Custom via utilities |

---

## Component-by-Component Analysis

### 1. Button

#### DaisyUI Variants

**Color Variants** (8):
```html
<!-- Semantic color props -->
<button class="btn btn-neutral">Neutral</button>
<button class="btn btn-primary">Primary</button>
<button class="btn btn-secondary">Secondary</button>
<button class="btn btn-accent">Accent</button>
<button class="btn btn-info">Info</button>
<button class="btn btn-success">Success</button>
<button class="btn btn-warning">Warning</button>
<button class="btn btn-error">Error</button>
```

**Size Variants** (5):
```html
<button class="btn btn-xs">Extra Small</button>
<button class="btn btn-sm">Small</button>
<button class="btn btn-md">Medium</button>
<button class="btn btn-lg">Large</button>
<button class="btn btn-xl">Extra Large</button>
```

**Style Variants** (6):
```html
<button class="btn">Filled (default)</button>
<button class="btn btn-outline">Outline</button>
<button class="btn btn-dash">Dashed</button>
<button class="btn btn-soft">Soft</button>
<button class="btn btn-ghost">Ghost</button>
<button class="btn btn-link">Link</button>
```

**Shape Modifiers** (4):
```html
<button class="btn btn-wide">Wide</button>
<button class="btn btn-block">Block</button>
<button class="btn btn-square">Square</button>
<button class="btn btn-circle">Circle</button>
```

#### HyperUI Approach

**Color** (via utility combinations):
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

**Size** (via padding/text utilities):
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

**Style** (via border/background utilities):
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

**Shape** (via width/display utilities):
```html
<!-- Wide -->
<button class="rounded bg-blue-600 px-12 py-2 text-white">
  Wide
</button>

<!-- Block -->
<button class="block w-full rounded bg-blue-600 px-4 py-2 text-white">
  Block
</button>

<!-- Square -->
<button class="rounded bg-blue-600 p-2 text-white">
  <svg>...</svg>
</button>

<!-- Circle -->
<button class="rounded-full bg-blue-600 p-2 text-white">
  <svg>...</svg>
</button>
```

#### Gap Analysis

**DaisyUI → HyperUI Gaps**:
1. **Semantic color names**: No direct equivalent - need manual mapping to Tailwind colors
2. **Dash style**: Not in HyperUI examples - requires custom border-dashed implementation
3. **Soft style**: Not explicitly shown - need to define as bg-{color}-100 text-{color}-700
4. **Link style**: Not in HyperUI examples - requires removing background/border

**HyperUI → DaisyUI Opportunities**:
1. **Gradient backgrounds**: `bg-gradient-to-r from-blue-600 to-purple-600`
2. **Custom shadows**: `shadow-lg shadow-blue-500/50`
3. **Ring variants**: `ring-2 ring-blue-500 ring-offset-2`
4. **Icon positioning**: More flexible utility-based icon placement

#### Recommended Mapping

```ruby
# lib/kumiki/components/button.rb
class Button < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :md }
  option :style, default: -> { :filled }
  option :shape, default: -> { nil }

  COLORS = {
    neutral: {
      filled: "bg-gray-600 text-white hover:bg-gray-700 focus:ring-gray-500",
      outline: "border border-gray-600 text-gray-600 hover:bg-gray-600 hover:text-white focus:ring-gray-500",
      soft: "bg-gray-100 text-gray-700 hover:bg-gray-200 focus:ring-gray-500",
      ghost: "text-gray-600 hover:bg-gray-100 focus:ring-gray-500",
      link: "text-gray-600 underline hover:text-gray-800"
    },
    primary: {
      filled: "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500",
      outline: "border border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white focus:ring-blue-500",
      soft: "bg-blue-100 text-blue-700 hover:bg-blue-200 focus:ring-blue-500",
      ghost: "text-blue-600 hover:bg-blue-100 focus:ring-blue-500",
      link: "text-blue-600 underline hover:text-blue-800"
    },
    secondary: {
      filled: "bg-purple-600 text-white hover:bg-purple-700 focus:ring-purple-500",
      outline: "border border-purple-600 text-purple-600 hover:bg-purple-600 hover:text-white focus:ring-purple-500",
      soft: "bg-purple-100 text-purple-700 hover:bg-purple-200 focus:ring-purple-500",
      ghost: "text-purple-600 hover:bg-purple-100 focus:ring-purple-500",
      link: "text-purple-600 underline hover:text-purple-800"
    },
    accent: {
      filled: "bg-pink-600 text-white hover:bg-pink-700 focus:ring-pink-500",
      outline: "border border-pink-600 text-pink-600 hover:bg-pink-600 hover:text-white focus:ring-pink-500",
      soft: "bg-pink-100 text-pink-700 hover:bg-pink-200 focus:ring-pink-500",
      ghost: "text-pink-600 hover:bg-pink-100 focus:ring-pink-500",
      link: "text-pink-600 underline hover:text-pink-800"
    },
    info: {
      filled: "bg-cyan-600 text-white hover:bg-cyan-700 focus:ring-cyan-500",
      outline: "border border-cyan-600 text-cyan-600 hover:bg-cyan-600 hover:text-white focus:ring-cyan-500",
      soft: "bg-cyan-100 text-cyan-700 hover:bg-cyan-200 focus:ring-cyan-500",
      ghost: "text-cyan-600 hover:bg-cyan-100 focus:ring-cyan-500",
      link: "text-cyan-600 underline hover:text-cyan-800"
    },
    success: {
      filled: "bg-green-600 text-white hover:bg-green-700 focus:ring-green-500",
      outline: "border border-green-600 text-green-600 hover:bg-green-600 hover:text-white focus:ring-green-500",
      soft: "bg-green-100 text-green-700 hover:bg-green-200 focus:ring-green-500",
      ghost: "text-green-600 hover:bg-green-100 focus:ring-green-500",
      link: "text-green-600 underline hover:text-green-800"
    },
    warning: {
      filled: "bg-yellow-600 text-white hover:bg-yellow-700 focus:ring-yellow-500",
      outline: "border border-yellow-600 text-yellow-600 hover:bg-yellow-600 hover:text-white focus:ring-yellow-500",
      soft: "bg-yellow-100 text-yellow-700 hover:bg-yellow-200 focus:ring-yellow-500",
      ghost: "text-yellow-600 hover:bg-yellow-100 focus:ring-yellow-500",
      link: "text-yellow-600 underline hover:text-yellow-800"
    },
    error: {
      filled: "bg-red-600 text-white hover:bg-red-700 focus:ring-red-500",
      outline: "border border-red-600 text-red-600 hover:bg-red-600 hover:text-white focus:ring-red-500",
      soft: "bg-red-100 text-red-700 hover:bg-red-200 focus:ring-red-500",
      ghost: "text-red-600 hover:bg-red-100 focus:ring-red-500",
      link: "text-red-600 underline hover:text-red-800"
    }
  }.freeze

  SIZES = {
    xs: "px-2 py-1 text-xs",
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-base",
    lg: "px-6 py-3 text-lg",
    xl: "px-8 py-4 text-xl"
  }.freeze

  SHAPES = {
    wide: "px-12",
    block: "w-full block",
    square: "p-2 aspect-square",
    circle: "p-2 rounded-full aspect-square"
  }.freeze
end
```

---

### 2. Badge

#### DaisyUI Variants

**Color Variants** (8):
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

**Size Variants** (5):
```html
<span class="badge badge-xs">XS</span>
<span class="badge badge-sm">SM</span>
<span class="badge badge-md">MD</span>
<span class="badge badge-lg">LG</span>
<span class="badge badge-xl">XL</span>
```

**Style Variants** (4):
```html
<span class="badge">Filled (default)</span>
<span class="badge badge-soft">Soft</span>
<span class="badge badge-ghost">Ghost</span>
<span class="badge badge-outline">Outline</span>
```

#### HyperUI Approach

**Color** (via utility combinations):
```html
<!-- Primary -->
<span class="inline-flex items-center rounded bg-blue-600 px-2.5 py-0.5 text-xs font-medium text-white">
  Primary
</span>

<!-- Success -->
<span class="inline-flex items-center rounded bg-green-600 px-2.5 py-0.5 text-xs font-medium text-white">
  Success
</span>

<!-- Soft variant -->
<span class="inline-flex items-center rounded bg-blue-100 px-2.5 py-0.5 text-xs font-medium text-blue-700">
  Soft Primary
</span>
```

**Size** (via padding/text utilities):
```html
<!-- Extra Small -->
<span class="inline-flex items-center rounded bg-blue-600 px-2 py-0.5 text-xs text-white">
  XS
</span>

<!-- Small -->
<span class="inline-flex items-center rounded bg-blue-600 px-2.5 py-1 text-sm text-white">
  SM
</span>

<!-- Medium -->
<span class="inline-flex items-center rounded bg-blue-600 px-3 py-1.5 text-base text-white">
  MD
</span>
```

**Style** (via border/background utilities):
```html
<!-- Filled -->
<span class="inline-flex items-center rounded bg-blue-600 px-2.5 py-0.5 text-xs text-white">
  Filled
</span>

<!-- Outline -->
<span class="inline-flex items-center rounded border border-blue-600 px-2.5 py-0.5 text-xs text-blue-600">
  Outline
</span>

<!-- Soft -->
<span class="inline-flex items-center rounded bg-blue-100 px-2.5 py-0.5 text-xs text-blue-700">
  Soft
</span>
```

#### Gap Analysis

**DaisyUI → HyperUI Gaps**:
1. **Ghost style**: Not explicitly in HyperUI - requires transparent background
2. **Dash style**: Not in HyperUI examples - requires border-dashed

**HyperUI → DaisyUI Opportunities**:
1. **Icon integration**: `inline-flex items-center gap-1` for badge icons
2. **Removable badges**: Close button patterns with transitions
3. **Pill shapes**: Full rounded variants (`rounded-full`)
4. **Dot indicators**: Leading/trailing dot patterns

#### Recommended Mapping

```ruby
# lib/kumiki/components/badge.rb
class Badge < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :sm }
  option :style, default: -> { :filled }

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

  SIZES = {
    xs: "px-2 py-0.5 text-xs",
    sm: "px-2.5 py-0.5 text-xs",
    md: "px-3 py-1 text-sm",
    lg: "px-3.5 py-1.5 text-base",
    xl: "px-4 py-2 text-lg"
  }.freeze
end
```

---

### 3. Card

#### DaisyUI Variants

**Size Variants** (5):
```html
<div class="card card-xs">Extra Small Card</div>
<div class="card card-sm">Small Card</div>
<div class="card card-md">Medium Card</div>
<div class="card card-lg">Large Card</div>
<div class="card card-xl">Extra Large Card</div>
```

**Style Modifiers** (4):
```html
<div class="card">Default</div>
<div class="card card-border">With Border</div>
<div class="card card-dash">Dashed Border</div>
<div class="card card-image-full">Image Overlay</div>
<div class="card card-side">Side Layout</div>
```

#### HyperUI Approach

**Structure** (via utility combinations):
```html
<!-- Basic Card -->
<article class="rounded-lg border border-gray-200 bg-white p-6">
  <h3 class="text-lg font-medium">Card Title</h3>
  <p class="text-gray-600">Card content</p>
</article>

<!-- Card with Shadow -->
<article class="rounded-lg border border-gray-200 bg-white p-6 shadow-sm">
  <h3 class="text-lg font-medium">Card Title</h3>
  <p class="text-gray-600">Card content</p>
</article>

<!-- Card with Image -->
<article class="overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="..." class="h-56 w-full object-cover" />
  <div class="p-6">
    <h3 class="text-lg font-medium">Card Title</h3>
    <p class="text-gray-600">Card content</p>
  </div>
</article>

<!-- Horizontal Card -->
<article class="flex overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="..." class="h-full w-48 object-cover" />
  <div class="flex flex-1 flex-col p-6">
    <h3 class="text-lg font-medium">Card Title</h3>
    <p class="text-gray-600">Card content</p>
  </div>
</article>
```

**Size** (via padding utilities):
```html
<!-- Compact -->
<article class="rounded-lg border border-gray-200 bg-white p-4">
  Content
</article>

<!-- Default -->
<article class="rounded-lg border border-gray-200 bg-white p-6">
  Content
</article>

<!-- Spacious -->
<article class="rounded-lg border border-gray-200 bg-white p-8">
  Content
</article>
```

#### Gap Analysis

**DaisyUI → HyperUI Gaps**:
1. **Size variants**: Not semantic in HyperUI - requires padding mapping
2. **Dash border**: Not in examples - requires `border-dashed`
3. **Image-full**: Not explicitly shown - requires custom overlay implementation

**HyperUI → DaisyUI Opportunities**:
1. **Hover effects**: Rich hover states with transitions
2. **Grid layouts**: Card grid patterns
3. **Interactive states**: Click/focus states for clickable cards
4. **Complex layouts**: More flexible header/body/footer patterns

#### Recommended Mapping

```ruby
# lib/kumiki/components/card.rb
class Card < Kumiki::Component
  option :size, default: -> { :md }
  option :bordered, default: -> { true }
  option :shadow, default: -> { false }
  option :image_full, default: -> { false }
  option :side, default: -> { false }

  SIZES = {
    xs: "p-3",
    sm: "p-4",
    md: "p-6",
    lg: "p-8",
    xl: "p-10"
  }.freeze

  def base_classes
    classes = ["rounded-lg", "bg-white"]
    classes << (bordered ? "border border-gray-200" : "")
    classes << "shadow-sm" if shadow
    classes.join(" ")
  end

  def layout_classes
    side ? "flex" : ""
  end
end
```

---

### 4. Modal

#### DaisyUI Variants

**Positioning Variants**:
```html
<dialog class="modal modal-top">Top</dialog>
<dialog class="modal modal-middle">Middle (default)</dialog>
<dialog class="modal modal-bottom">Bottom</dialog>
<dialog class="modal modal-start">Start</dialog>
<dialog class="modal modal-end">End</dialog>
<dialog class="modal modal-top modal-start">Top Start</dialog>
<!-- ...other combinations -->
```

**State**:
```html
<dialog class="modal" open>Open Modal</dialog>
```

#### HyperUI Approach

**Structure** (via utility combinations):
```html
<!-- Modal Overlay -->
<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
  <!-- Modal Content -->
  <div class="relative w-full max-w-md rounded-lg bg-white p-6">
    <h2 class="text-lg font-medium">Modal Title</h2>
    <p class="text-gray-600">Modal content</p>
  </div>
</div>
```

**Positioning** (via Flexbox utilities):
```html
<!-- Top -->
<div class="fixed inset-0 z-50 flex items-start justify-center bg-black/50 pt-16">
  <!-- content -->
</div>

<!-- Middle (default) -->
<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
  <!-- content -->
</div>

<!-- Bottom -->
<div class="fixed inset-0 z-50 flex items-end justify-center bg-black/50 pb-16">
  <!-- content -->
</div>

<!-- Start -->
<div class="fixed inset-0 z-50 flex items-center justify-start bg-black/50 pl-16">
  <!-- content -->
</div>

<!-- End -->
<div class="fixed inset-0 z-50 flex items-center justify-end bg-black/50 pr-16">
  <!-- content -->
</div>
```

**Size** (via max-width utilities):
```html
<!-- Small -->
<div class="w-full max-w-sm rounded-lg bg-white p-6">...</div>

<!-- Medium (default) -->
<div class="w-full max-w-md rounded-lg bg-white p-6">...</div>

<!-- Large -->
<div class="w-full max-w-2xl rounded-lg bg-white p-6">...</div>

<!-- Full Width -->
<div class="w-full max-w-full rounded-lg bg-white p-6">...</div>
```

#### Gap Analysis

**DaisyUI → HyperUI Gaps**:
1. **Native dialog element**: HyperUI uses div-based approach
2. **Combined positions**: Requires combining Flexbox utilities

**HyperUI → DaisyUI Opportunities**:
1. **Backdrop blur**: `backdrop-blur-sm` effects
2. **Slide transitions**: Animation utilities for entrance/exit
3. **Responsive sizing**: Breakpoint-based sizing
4. **Custom z-index**: Flexible stacking order

#### Recommended Mapping

```ruby
# lib/kumiki/components/modal.rb
class Modal < Kumiki::Component
  option :position_y, default: -> { :middle }
  option :position_x, default: -> { :center }
  option :size, default: -> { :md }
  option :backdrop_blur, default: -> { false }

  POSITIONS_Y = {
    top: "items-start pt-16",
    middle: "items-center",
    bottom: "items-end pb-16"
  }.freeze

  POSITIONS_X = {
    start: "justify-start pl-16",
    center: "justify-center",
    end: "justify-end pr-16"
  }.freeze

  SIZES = {
    sm: "max-w-sm",
    md: "max-w-md",
    lg: "max-w-2xl",
    xl: "max-w-4xl",
    full: "max-w-full mx-4"
  }.freeze

  def overlay_classes
    classes = ["fixed", "inset-0", "z-50", "flex"]
    classes << POSITIONS_Y[position_y]
    classes << POSITIONS_X[position_x]
    classes << (backdrop_blur ? "bg-black/50 backdrop-blur-sm" : "bg-black/50")
    classes.join(" ")
  end

  def content_classes
    ["relative", "w-full", SIZES[size], "rounded-lg", "bg-white", "p-6"].join(" ")
  end
end
```

---

### 5. Toast

#### DaisyUI Variants

**Positioning** (9 combinations):
```html
<!-- Vertical: top, middle, bottom -->
<!-- Horizontal: start, center, end -->
<div class="toast toast-top toast-start">Top Start</div>
<div class="toast toast-top toast-center">Top Center</div>
<div class="toast toast-top toast-end">Top End</div>
<div class="toast toast-middle toast-start">Middle Start</div>
<div class="toast toast-middle toast-center">Middle Center</div>
<div class="toast toast-middle toast-end">Middle End</div>
<div class="toast toast-bottom toast-start">Bottom Start</div>
<div class="toast toast-bottom toast-center">Bottom Center</div>
<div class="toast toast-bottom toast-end">Bottom End</div>
```

**Color Variants** (via alert inside toast):
```html
<div class="toast">
  <div class="alert alert-info">Info message</div>
</div>
<div class="toast">
  <div class="alert alert-success">Success message</div>
</div>
<div class="toast">
  <div class="alert alert-warning">Warning message</div>
</div>
<div class="toast">
  <div class="alert alert-error">Error message</div>
</div>
```

#### HyperUI Approach

**Structure** (via utility combinations):
```html
<!-- Toast Container (positioned) -->
<div class="fixed bottom-4 right-4 z-50">
  <!-- Toast Item -->
  <div class="flex items-center gap-4 rounded-lg bg-white p-4 shadow-lg">
    <span class="text-green-600">
      <svg>...</svg>
    </span>
    <p class="text-sm font-medium text-gray-900">Success message</p>
    <button class="text-gray-400 hover:text-gray-600">
      <svg>...</svg>
    </button>
  </div>
</div>
```

**Positioning** (via fixed positioning):
```html
<!-- Top Right (common default) -->
<div class="fixed top-4 right-4 z-50">...</div>

<!-- Top Left -->
<div class="fixed top-4 left-4 z-50">...</div>

<!-- Top Center -->
<div class="fixed top-4 left-1/2 -translate-x-1/2 z-50">...</div>

<!-- Bottom Right -->
<div class="fixed bottom-4 right-4 z-50">...</div>

<!-- Bottom Left -->
<div class="fixed bottom-4 left-4 z-50">...</div>

<!-- Bottom Center -->
<div class="fixed bottom-4 left-1/2 -translate-x-1/2 z-50">...</div>
```

**Color** (via background/icon color):
```html
<!-- Success -->
<div class="flex items-center gap-4 rounded-lg bg-white p-4 shadow-lg border-l-4 border-green-600">
  <span class="text-green-600">✓</span>
  <p class="text-sm font-medium">Success!</p>
</div>

<!-- Error -->
<div class="flex items-center gap-4 rounded-lg bg-white p-4 shadow-lg border-l-4 border-red-600">
  <span class="text-red-600">✕</span>
  <p class="text-sm font-medium">Error!</p>
</div>

<!-- Warning -->
<div class="flex items-center gap-4 rounded-lg bg-white p-4 shadow-lg border-l-4 border-yellow-600">
  <span class="text-yellow-600">⚠</span>
  <p class="text-sm font-medium">Warning!</p>
</div>

<!-- Info -->
<div class="flex items-center gap-4 rounded-lg bg-white p-4 shadow-lg border-l-4 border-blue-600">
  <span class="text-blue-600">ℹ</span>
  <p class="text-sm font-medium">Info!</p>
</div>
```

#### Gap Analysis

**DaisyUI → HyperUI Gaps**:
1. **Middle positioning**: Less common in HyperUI patterns
2. **Stacking multiple toasts**: Requires custom container logic

**HyperUI → DaisyUI Opportunities**:
1. **Progress indicators**: Timeout bars
2. **Rich content**: Multi-line toasts with actions
3. **Animation**: Slide/fade entrance/exit transitions
4. **Grouped toasts**: Stack management for multiple toasts

#### Recommended Mapping

```ruby
# lib/kumiki/components/toast.rb
class Toast < Kumiki::Component
  option :position_y, default: -> { :bottom }
  option :position_x, default: -> { :end }
  option :color, default: -> { :info }
  option :dismissible, default: -> { true }

  POSITIONS_Y = {
    top: "top-4",
    middle: "top-1/2 -translate-y-1/2",
    bottom: "bottom-4"
  }.freeze

  POSITIONS_X = {
    start: "left-4",
    center: "left-1/2 -translate-x-1/2",
    end: "right-4"
  }.freeze

  COLORS = {
    neutral: "border-l-4 border-gray-600 text-gray-900",
    primary: "border-l-4 border-blue-600 text-blue-900",
    info: "border-l-4 border-cyan-600 text-cyan-900",
    success: "border-l-4 border-green-600 text-green-900",
    warning: "border-l-4 border-yellow-600 text-yellow-900",
    error: "border-l-4 border-red-600 text-red-900"
  }.freeze

  def container_classes
    ["fixed", "z-50", POSITIONS_Y[position_y], POSITIONS_X[position_x]].join(" ")
  end

  def toast_classes
    ["flex", "items-center", "gap-4", "rounded-lg", "bg-white", "p-4",
     "shadow-lg", COLORS[color]].join(" ")
  end
end
```

---

### 6-11. Form Components (Input, Select, Textarea, Checkbox, Radio, FileInput)

These components share very similar variant patterns, so they're analyzed together.

#### DaisyUI Variants (Common Pattern)

**Color Variants** (8):
```html
<input class="input input-neutral" />
<input class="input input-primary" />
<input class="input input-secondary" />
<input class="input input-accent" />
<input class="input input-info" />
<input class="input input-success" />
<input class="input input-warning" />
<input class="input input-error" />
```

**Size Variants** (5):
```html
<input class="input input-xs" />
<input class="input input-sm" />
<input class="input input-md" />
<input class="input input-lg" />
<input class="input input-xl" />
```

**Style Variants**:
```html
<input class="input" /> <!-- Default bordered -->
<input class="input input-ghost" /> <!-- Transparent background -->
```

**State Variants**:
```html
<input class="input" disabled />
<input class="input" required />
<input class="input input-error" /> <!-- Error state -->
```

#### HyperUI Approach (Common Pattern)

**Structure** (via utility combinations):
```html
<!-- Text Input -->
<input
  type="text"
  class="w-full rounded-lg border-gray-200 p-3 text-sm focus:ring-2 focus:ring-blue-500"
/>

<!-- Select -->
<select class="w-full rounded-lg border-gray-200 p-3 text-sm focus:ring-2 focus:ring-blue-500">
  <option>Option 1</option>
</select>

<!-- Textarea -->
<textarea
  class="w-full rounded-lg border-gray-200 p-3 text-sm focus:ring-2 focus:ring-blue-500"
  rows="4"
></textarea>

<!-- Checkbox -->
<input
  type="checkbox"
  class="h-5 w-5 rounded border-gray-300 text-blue-600 focus:ring-2 focus:ring-blue-500"
/>

<!-- Radio -->
<input
  type="radio"
  class="h-5 w-5 border-gray-300 text-blue-600 focus:ring-2 focus:ring-blue-500"
/>

<!-- File Input -->
<input
  type="file"
  class="w-full rounded-lg border-gray-200 p-3 text-sm focus:ring-2 focus:ring-blue-500"
/>
```

**Size** (via padding/text utilities):
```html
<!-- Small -->
<input class="rounded-lg border-gray-200 p-2 text-xs focus:ring-2" />

<!-- Medium (default) -->
<input class="rounded-lg border-gray-200 p-3 text-sm focus:ring-2" />

<!-- Large -->
<input class="rounded-lg border-gray-200 p-4 text-base focus:ring-2" />
```

**Color/State** (via border/ring utilities):
```html
<!-- Default -->
<input class="border-gray-200 focus:ring-blue-500" />

<!-- Success -->
<input class="border-green-600 focus:ring-green-500" />

<!-- Error -->
<input class="border-red-600 focus:ring-red-500" />

<!-- Disabled -->
<input class="border-gray-200 bg-gray-100 text-gray-400 cursor-not-allowed" disabled />
```

#### Gap Analysis

**DaisyUI → HyperUI Gaps**:
1. **Semantic color mapping**: Need to map semantic colors to border/ring colors
2. **Ghost style**: Requires transparent border and background
3. **Consistent sizing**: Need standard padding/text combinations

**HyperUI → DaisyUI Opportunities**:
1. **Focus ring customization**: More control over ring width/offset
2. **Placeholder styling**: Rich placeholder text styling
3. **Icon integration**: Leading/trailing icon patterns
4. **Validation states**: Richer validation UI patterns

#### Recommended Mapping (Form Input Example)

```ruby
# lib/kumiki/components/form/input.rb
class Form::Input < Kumiki::Component
  option :color, default: -> { :neutral }
  option :size, default: -> { :md }
  option :style, default: -> { :bordered }
  option :error, default: -> { false }

  COLORS = {
    neutral: "border-gray-200 focus:border-gray-400 focus:ring-gray-500",
    primary: "border-blue-600 focus:border-blue-700 focus:ring-blue-500",
    secondary: "border-purple-600 focus:border-purple-700 focus:ring-purple-500",
    accent: "border-pink-600 focus:border-pink-700 focus:ring-pink-500",
    info: "border-cyan-600 focus:border-cyan-700 focus:ring-cyan-500",
    success: "border-green-600 focus:border-green-700 focus:ring-green-500",
    warning: "border-yellow-600 focus:border-yellow-700 focus:ring-yellow-500",
    error: "border-red-600 focus:border-red-700 focus:ring-red-500"
  }.freeze

  SIZES = {
    xs: "p-1.5 text-xs",
    sm: "p-2 text-sm",
    md: "p-3 text-sm",
    lg: "p-4 text-base",
    xl: "p-5 text-lg"
  }.freeze

  STYLES = {
    bordered: "border bg-white",
    ghost: "border border-transparent bg-transparent hover:border-gray-200"
  }.freeze

  def input_classes
    classes = ["w-full", "rounded-lg", "focus:ring-2", "focus:outline-none"]
    classes << STYLES[style]
    classes << SIZES[size]
    classes << (error ? COLORS[:error] : COLORS[color])
    classes << "disabled:bg-gray-100 disabled:text-gray-400 disabled:cursor-not-allowed"
    classes.join(" ")
  end
end
```

---

### 12. FormDatePicker

This is a custom component with no direct DaisyUI equivalent.

#### Implementation Approach

**Base Structure**:
```html
<!-- Date Input with Native Picker -->
<input
  type="date"
  class="w-full rounded-lg border-gray-200 p-3 text-sm focus:ring-2 focus:ring-blue-500"
/>

<!-- Or Custom Calendar UI -->
<div class="relative">
  <input
    type="text"
    class="w-full rounded-lg border-gray-200 p-3 text-sm focus:ring-2 focus:ring-blue-500"
    placeholder="Select date"
  />
  <button class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400">
    <svg><!-- Calendar icon --></svg>
  </button>

  <!-- Calendar Dropdown -->
  <div class="absolute top-full mt-2 rounded-lg border border-gray-200 bg-white p-4 shadow-lg">
    <!-- Calendar grid here -->
  </div>
</div>
```

#### Recommended Mapping

```ruby
# lib/kumiki/components/form/date_picker.rb
class Form::DatePicker < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :md }
  option :native, default: -> { true }
  option :error, default: -> { false }

  # Similar size/color mappings as other form components
  # Plus calendar-specific options

  option :min_date, default: -> { nil }
  option :max_date, default: -> { nil }
  option :format, default: -> { "%Y-%m-%d" }
end
```

---

### 13. FormError

#### DaisyUI Approach

Uses alert component or utility classes:
```html
<div class="alert alert-error">
  <span>Error message</span>
</div>

<!-- Or simple text -->
<span class="text-error text-sm">Error message</span>
```

#### HyperUI Approach

**Error Message Patterns**:
```html
<!-- Inline Error -->
<p class="text-sm text-red-600">This field is required</p>

<!-- Error with Icon -->
<div class="flex items-center gap-2 text-sm text-red-600">
  <svg class="h-4 w-4"><!-- Error icon --></svg>
  <span>This field is required</span>
</div>

<!-- Alert-style Error -->
<div class="flex items-center gap-3 rounded-lg border border-red-600 bg-red-50 p-4">
  <span class="text-red-600">
    <svg><!-- Error icon --></svg>
  </span>
  <p class="text-sm font-medium text-red-800">
    Please correct the errors below
  </p>
</div>
```

#### Recommended Mapping

```ruby
# lib/kumiki/components/form/error.rb
class Form::Error < Kumiki::Component
  option :style, default: -> { :inline }
  option :color, default: -> { :error }

  STYLES = {
    inline: "text-sm",
    icon: "flex items-center gap-2 text-sm",
    alert: "flex items-center gap-3 rounded-lg border p-4"
  }.freeze

  COLORS = {
    error: {
      inline: "text-red-600",
      icon: "text-red-600",
      alert: "border-red-600 bg-red-50 text-red-800"
    },
    warning: {
      inline: "text-yellow-600",
      icon: "text-yellow-600",
      alert: "border-yellow-600 bg-yellow-50 text-yellow-800"
    },
    info: {
      inline: "text-blue-600",
      icon: "text-blue-600",
      alert: "border-blue-600 bg-blue-50 text-blue-800"
    }
  }.freeze
end
```

---

## Gap Analysis

### Critical Gaps Requiring Custom Implementation

#### 1. Semantic Color Mapping

**Issue**: DaisyUI uses semantic names (`primary`, `secondary`, `accent`) that map to CSS custom properties. HyperUI uses direct Tailwind color scale references.

**Impact**: All components

**Solution**:
```ruby
# lib/kumiki/theme.rb
module Kumiki
  class Theme
    SEMANTIC_COLORS = {
      neutral: "gray",
      primary: "blue",
      secondary: "purple",
      accent: "pink",
      info: "cyan",
      success: "green",
      warning: "yellow",
      error: "red"
    }.freeze

    def self.color_classes(semantic_color, variant: :filled, shade: 600)
      tailwind_color = SEMANTIC_COLORS[semantic_color]

      case variant
      when :filled
        "bg-#{tailwind_color}-#{shade} text-white hover:bg-#{tailwind_color}-#{shade + 100}"
      when :outline
        "border border-#{tailwind_color}-#{shade} text-#{tailwind_color}-#{shade} hover:bg-#{tailwind_color}-#{shade} hover:text-white"
      when :soft
        "bg-#{tailwind_color}-100 text-#{tailwind_color}-700 hover:bg-#{tailwind_color}-200"
      when :ghost
        "text-#{tailwind_color}-#{shade} hover:bg-#{tailwind_color}-100"
      end
    end
  end
end
```

#### 2. Dash Border Style

**Issue**: DaisyUI's `dash` variant (dashed borders) not common in HyperUI examples.

**Impact**: Button, Badge, Card

**Solution**:
```ruby
# Add to style variants
STYLES = {
  # ...existing styles
  dash: "border border-dashed"
}.freeze
```

#### 3. Size Consistency

**Issue**: Need standardized size scale across all components.

**Impact**: All components

**Solution**:
```ruby
# lib/kumiki/sizing.rb
module Kumiki
  module Sizing
    COMPONENT_SIZES = {
      button: {
        xs: "px-2 py-1 text-xs",
        sm: "px-3 py-1.5 text-sm",
        md: "px-4 py-2 text-base",
        lg: "px-6 py-3 text-lg",
        xl: "px-8 py-4 text-xl"
      },
      badge: {
        xs: "px-2 py-0.5 text-xs",
        sm: "px-2.5 py-0.5 text-xs",
        md: "px-3 py-1 text-sm",
        lg: "px-3.5 py-1.5 text-base",
        xl: "px-4 py-2 text-lg"
      },
      form_input: {
        xs: "p-1.5 text-xs",
        sm: "p-2 text-sm",
        md: "p-3 text-sm",
        lg: "p-4 text-base",
        xl: "p-5 text-lg"
      }
      # ...more component sizes
    }.freeze
  end
end
```

#### 4. Link-style Buttons

**Issue**: HyperUI doesn't show link-style button examples.

**Impact**: Button component

**Solution**:
```ruby
STYLES = {
  # ...existing styles
  link: "bg-transparent border-none underline hover:no-underline p-0"
}.freeze
```

#### 5. Ghost Form Inputs

**Issue**: DaisyUI's ghost input style (transparent border/background) not common in HyperUI.

**Impact**: Form components

**Solution**:
```ruby
STYLES = {
  bordered: "border bg-white",
  ghost: "border border-transparent bg-transparent hover:border-gray-200 focus:border-gray-400"
}.freeze
```

### Minor Gaps (Nice to Have)

#### 1. Middle Positioning for Toast/Modal

**Issue**: HyperUI examples don't commonly show middle vertical positioning.

**Solution**: Use Flexbox utilities with `items-center` and transform utilities.

#### 2. Image-full Card Style

**Issue**: DaisyUI's image overlay card not explicitly in HyperUI.

**Solution**: Use `relative` container with `absolute` overlay positioning.

#### 3. Wide Button Modifier

**Issue**: No explicit "wide" button in HyperUI.

**Solution**: Use increased horizontal padding (`px-12` or higher).

---

## Migration Recommendations

### 1. Establish Color Theme System

**Priority**: Critical

**Action**:
1. Create `Kumiki::Theme` module with semantic-to-Tailwind color mappings
2. Define standard color shades for each semantic color
3. Provide theme configuration in Rails initializer

**Example**:
```ruby
# config/initializers/kumiki.rb
Kumiki.configure do |config|
  config.theme.primary_color = "blue"
  config.theme.secondary_color = "purple"
  config.theme.accent_color = "pink"
  # ...more theme config
end
```

### 2. Create Variant Concern

**Priority**: High

**Action**:
Create shared concern for variant handling:

```ruby
# lib/kumiki/concerns/variant_support.rb
module Kumiki
  module Concerns
    module VariantSupport
      extend ActiveSupport::Concern

      included do
        option :color, default: -> { :primary }
        option :size, default: -> { :md }
        option :style, default: -> { :filled }
      end

      def color_classes
        self.class::COLORS.dig(color, style) || ""
      end

      def size_classes
        self.class::SIZES[size] || ""
      end

      def base_classes
        [
          self.class::BASE_CLASSES,
          color_classes,
          size_classes
        ].join(" ")
      end
    end
  end
end
```

### 3. Provide Escape Hatch for Custom Classes

**Priority**: High

**Action**:
Allow developers to pass custom Tailwind classes:

```ruby
class Button < Kumiki::Component
  option :class, default: -> { "" }

  def button_classes
    [base_classes, options[:class]].join(" ")
  end
end
```

**Usage**:
```erb
<%= render Button.new(color: :primary, class: "shadow-lg") do %>
  Custom Button
<% end %>
```

### 4. Document Variant Mapping

**Priority**: High

**Action**:
Create comprehensive documentation showing DaisyUI → Kumiki equivalents:

```markdown
# Variant Migration Guide

## Button Color Variants

| DaisyUI | Kumiki | Generated Classes |
|---------|--------|-------------------|
| `color="primary"` | `color: :primary` | `bg-blue-600 text-white hover:bg-blue-700` |
| `color="secondary"` | `color: :secondary` | `bg-purple-600 text-white hover:bg-purple-700` |
```

### 5. Implement Fallback Classes

**Priority**: Medium

**Action**:
Provide fallback for undefined variants:

```ruby
def color_classes
  COLORS.dig(color, style) || COLORS.dig(:primary, style) || ""
end
```

### 6. Support State Data Attributes

**Priority**: Medium

**Action**:
Maintain DaisyUI's state management approach where appropriate:

```ruby
def state_attributes
  attrs = {}
  attrs[:disabled] = true if disabled
  attrs[:"data-loading"] = true if loading
  attrs
end
```

### 7. Create Variant Builder Helper

**Priority**: Low

**Action**:
Provide helper for complex variant combinations:

```ruby
# lib/kumiki/variant_builder.rb
module Kumiki
  class VariantBuilder
    def self.build(component:, color:, size:, style:)
      color_classes = component::COLORS.dig(color, style)
      size_classes = component::SIZES[size]

      [color_classes, size_classes].compact.join(" ")
    end
  end
end
```

---

## Implementation Strategy

### Phase 1: Foundation (Week 1)

1. **Create Theme System**
   - Implement `Kumiki::Theme` module
   - Define semantic color mappings
   - Create configuration system

2. **Implement Variant Concern**
   - Create `VariantSupport` concern
   - Define standard option structure
   - Implement class generation methods

3. **Build Size Scale**
   - Define `Kumiki::Sizing` module
   - Create component-specific size mappings
   - Document size scale rationale

### Phase 2: Core Components (Week 2)

1. **Implement Button**
   - All color variants
   - All size variants
   - All style variants
   - All shape modifiers
   - Tests for each variant

2. **Implement Badge**
   - All color variants
   - All size variants
   - All style variants
   - Tests for each variant

3. **Implement Card**
   - Size variants
   - Border/shadow options
   - Layout variants
   - Tests for each variant

### Phase 3: Interactive Components (Week 3)

1. **Implement Modal**
   - Positioning system
   - Size variants
   - Backdrop options
   - Animation support
   - Tests

2. **Implement Toast**
   - Positioning system
   - Color variants
   - Dismissible functionality
   - Stacking support
   - Tests

### Phase 4: Form Components (Week 4-5)

1. **Implement Form Inputs**
   - Input, Select, Textarea
   - Color/size/style variants
   - Error state integration
   - Tests

2. **Implement Form Controls**
   - Checkbox, Radio, FileInput
   - Color/size variants
   - Tests

3. **Implement FormDatePicker**
   - Native date input variant
   - Custom calendar UI variant
   - Tests

4. **Implement FormError**
   - Multiple display styles
   - Color variants
   - Tests

### Phase 5: Polish & Documentation (Week 6)

1. **Comprehensive Testing**
   - Visual regression tests
   - Accessibility tests
   - Browser compatibility tests

2. **Documentation**
   - Variant migration guide
   - API documentation
   - Usage examples
   - Storybook integration

3. **Performance Optimization**
   - Class string optimization
   - Memoization where appropriate
   - Benchmark against DaisyUI

---

## Success Metrics

### API Consistency
- All components use consistent `color`, `size`, `style` option names
- Variant names match DaisyUI semantic naming
- Generated classes follow predictable patterns

### Completeness
- 100% of DaisyUI color variants mapped
- 100% of DaisyUI size variants mapped
- 100% of DaisyUI style variants mapped
- All gaps documented with solutions

### Developer Experience
- Drop-in replacement for DaisyUI components
- Clear error messages for invalid variants
- Comprehensive documentation
- IntelliSense support for variant options

### Visual Quality
- All variants match or exceed HyperUI visual quality
- Consistent spacing/sizing across components
- Smooth hover/focus transitions
- Accessible color contrast

---

## Conclusion

The migration from DaisyUI's semantic variant system to HyperUI's utility-first approach requires:

1. **Semantic-to-Utility Mapping**: A robust theme system that maps semantic color names to Tailwind color utilities
2. **Standardized Size Scale**: Consistent sizing across all component types
3. **Style Variant Implementation**: Custom implementations for styles not common in HyperUI (dash, soft, ghost, link)
4. **Flexible API**: Maintaining DaisyUI's developer-friendly prop-based API while generating HyperUI-quality utility classes
5. **Escape Hatches**: Allowing custom class injection for maximum flexibility

By following the implementation strategy and recommendations in this document, Kumiki Rails can provide a seamless migration path from DaisyUI to HyperUI-based components while maintaining API compatibility and developer experience.
