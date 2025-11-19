# HTML Patterns: HyperUI Component Migration

**Feature**: 001-hyperui-component-migration
**Created**: 2025-11-19
**Status**: Analysis Complete
**Purpose**: Document reusable HTML structural patterns extracted from HyperUI components for implementation in Kumiki Rails

---

## Table of Contents

1. [Overview](#overview)
2. [Pattern Categories](#pattern-categories)
3. [Core Structural Patterns](#core-structural-patterns)
4. [Layout Patterns](#layout-patterns)
5. [Form Field Patterns](#form-field-patterns)
6. [Interactive Component Patterns](#interactive-component-patterns)
7. [State Management Patterns](#state-management-patterns)
8. [Tailwind Utility Conventions](#tailwind-utility-conventions)
9. [Cross-Component Patterns](#cross-component-patterns)
10. [Component-Specific Patterns](#component-specific-patterns)
11. [Ruby Helper Method Recommendations](#ruby-helper-method-recommendations)
12. [Implementation Guidelines](#implementation-guidelines)

---

## Overview

### What are HTML Patterns?

HTML patterns are recurring structural templates that define how components are built. In the context of migrating from DaisyUI to HyperUI, these patterns represent the shift from semantic CSS classes (`btn`, `btn-primary`) to utility-first composition (`px-4 py-2 bg-blue-600 text-white rounded`).

### Why Patterns Matter

1. **Consistency**: Ensures all components follow the same structural conventions
2. **Maintainability**: Changes to patterns propagate across all components
3. **Reusability**: Common patterns reduce code duplication
4. **Developer Experience**: Predictable structures make components easier to understand
5. **Accessibility**: Baked-in accessibility patterns ensure WCAG compliance

### Pattern Analysis Methodology

This document analyzes:
- HyperUI component examples from their component library
- DaisyUI component structures from existing Kumiki implementation
- Common Tailwind CSS patterns used across modern UI libraries
- Accessibility requirements from WCAG 2.1 AA guidelines

---

## Pattern Categories

### 1. Core Structural Patterns
- **Container Pattern**: Wrapping elements with consistent spacing/borders
- **Content-Image Pattern**: Card-like structures with media and text
- **Overlay Pattern**: Fixed/absolute positioned layers (modals, toasts)
- **List Pattern**: Repeated items with consistent styling

### 2. Layout Patterns
- **Flexbox Alignment**: `flex items-center gap-X`, `justify-between`
- **Grid Layout**: `grid grid-cols-X gap-Y`
- **Spacing Pattern**: `space-y-X`, `space-x-X`, padding/margin utilities
- **Responsive Layout**: Breakpoint-based layouts (`sm:`, `md:`, `lg:`)

### 3. Form Field Patterns
- **Label-Input Wrapper**: Semantic label + input association
- **Field Group**: Multiple fields with shared context (fieldset/legend)
- **Error Display**: Error message positioning and styling
- **Input Decoration**: Icons, action buttons, helper text

### 4. Interactive Component Patterns
- **Dialog/Modal Pattern**: Overlay + centered content + backdrop
- **Notification Pattern**: Fixed positioning + dismissible structure
- **Dropdown Pattern**: Trigger + floating menu
- **Button Group Pattern**: Multiple buttons with unified styling

### 5. State Patterns
- **Hover States**: `hover:` prefix for interactive feedback
- **Focus States**: `focus:` prefix for keyboard navigation
- **Active States**: `active:` prefix for click feedback
- **Disabled States**: `disabled:` prefix with opacity/cursor changes
- **Error States**: Color/border changes with validation feedback

---

## Core Structural Patterns

### Pattern 1: Container/Wrapper Pattern

**Purpose**: Creates consistent card-like containers with borders, shadows, and backgrounds

**HTML Structure**:
```html
<!-- Basic Container -->
<div class="overflow-hidden rounded-lg border border-gray-200 bg-white">
  <!-- Content -->
</div>

<!-- Container with Shadow -->
<div class="overflow-hidden rounded-lg border border-gray-200 bg-white shadow-sm">
  <!-- Content -->
</div>

<!-- Container with Padding -->
<div class="overflow-hidden rounded-lg border border-gray-200 bg-white p-6">
  <!-- Content -->
</div>
```

**Key Utilities**:
- `overflow-hidden`: Prevents content from escaping rounded corners
- `rounded-lg`: Standard border radius (0.5rem / 8px)
- `border border-gray-200`: Light border for definition
- `bg-white`: White background
- `shadow-sm`: Subtle shadow for depth
- `p-6`: Standard padding (1.5rem / 24px)

**Used In**: Card, Modal, Toast, Form Field Groups

**Variations**:
```html
<!-- Compact Container -->
<div class="rounded-lg border border-gray-200 bg-white p-4">...</div>

<!-- Spacious Container -->
<div class="rounded-lg border border-gray-200 bg-white p-8">...</div>

<!-- No Border Container -->
<div class="rounded-lg bg-white shadow-sm p-6">...</div>

<!-- Colored Container -->
<div class="rounded-lg border border-blue-200 bg-blue-50 p-6">...</div>
```

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module Container
      def container_classes(
        padded: true,
        bordered: true,
        shadowed: false,
        size: :md,
        color: :white
      )
        classes = ["overflow-hidden", "rounded-lg"]

        # Background
        classes << bg_class(color)

        # Border
        classes << "border border-gray-200" if bordered

        # Shadow
        classes << "shadow-sm" if shadowed

        # Padding
        classes << padding_class(size) if padded

        classes.join(" ")
      end

      private

      def padding_class(size)
        {
          xs: "p-3",
          sm: "p-4",
          md: "p-6",
          lg: "p-8",
          xl: "p-10"
        }[size]
      end

      def bg_class(color)
        color == :white ? "bg-white" : "bg-#{color}-50"
      end
    end
  end
end
```

---

### Pattern 2: Content-Image Pattern

**Purpose**: Card structures with image + text content sections

**HTML Structure**:
```html
<!-- Vertical Layout (Image Top) -->
<article class="overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="..." class="h-56 w-full object-cover" alt="..." />
  <div class="p-6">
    <h3 class="text-lg font-semibold text-gray-900">Title</h3>
    <p class="mt-2 text-sm text-gray-600">Description</p>
    <div class="mt-4 flex gap-2">
      <button class="...">Action</button>
    </div>
  </div>
</article>

<!-- Horizontal Layout (Image Left) -->
<article class="flex overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="..." class="h-full w-48 object-cover" alt="..." />
  <div class="flex flex-1 flex-col p-6">
    <h3 class="text-lg font-semibold text-gray-900">Title</h3>
    <p class="mt-2 flex-1 text-sm text-gray-600">Description</p>
    <div class="mt-4 flex gap-2">
      <button class="...">Action</button>
    </div>
  </div>
</article>

<!-- Image Overlay -->
<article class="relative overflow-hidden rounded-lg">
  <img src="..." class="h-96 w-full object-cover" alt="..." />
  <div class="absolute inset-0 bg-gradient-to-t from-black/75 to-transparent"></div>
  <div class="absolute bottom-0 left-0 right-0 p-6 text-white">
    <h3 class="text-2xl font-bold">Title</h3>
    <p class="mt-2 text-sm">Description</p>
  </div>
</article>
```

**Key Utilities**:
- `object-cover`: Crops image to fill container
- `h-56`, `h-full`, `h-96`: Height constraints
- `w-full`, `w-48`: Width constraints
- `flex flex-1 flex-col`: Flexible column layout
- `absolute inset-0`: Full-area overlay
- `bg-gradient-to-t from-black/75`: Gradient overlay

**Used In**: Card, Product Card, Blog Post Card, Profile Card

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module ContentImage
      def content_image_classes(layout: :vertical, image_size: :md)
        case layout
        when :vertical
          {
            container: "overflow-hidden rounded-lg border border-gray-200 bg-white",
            image: "#{image_height(image_size)} w-full object-cover",
            content: "p-6"
          }
        when :horizontal
          {
            container: "flex overflow-hidden rounded-lg border border-gray-200 bg-white",
            image: "h-full #{image_width(image_size)} object-cover",
            content: "flex flex-1 flex-col p-6"
          }
        when :overlay
          {
            container: "relative overflow-hidden rounded-lg",
            image: "#{image_height(image_size)} w-full object-cover",
            overlay: "absolute inset-0 bg-gradient-to-t from-black/75 to-transparent",
            content: "absolute bottom-0 left-0 right-0 p-6 text-white"
          }
        end
      end

      private

      def image_height(size)
        { sm: "h-40", md: "h-56", lg: "h-96" }[size]
      end

      def image_width(size)
        { sm: "w-32", md: "w-48", lg: "w-64" }[size]
      end
    end
  end
end
```

---

### Pattern 3: Overlay Pattern

**Purpose**: Fixed/absolute positioned layers for modals, toasts, notifications

**HTML Structure**:
```html
<!-- Full-Screen Overlay (Modal) -->
<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
  <div class="relative w-full max-w-md rounded-lg bg-white p-6">
    <!-- Modal Content -->
  </div>
</div>

<!-- Corner Positioned Overlay (Toast) -->
<div class="fixed bottom-4 right-4 z-50">
  <div class="rounded-lg border border-gray-200 bg-white p-4 shadow-lg">
    <!-- Toast Content -->
  </div>
</div>

<!-- Top Banner Overlay -->
<div class="fixed left-0 right-0 top-0 z-50 bg-blue-600 p-4 text-white">
  <!-- Banner Content -->
</div>

<!-- Backdrop with Blur -->
<div class="fixed inset-0 z-50 bg-black/50 backdrop-blur-sm">
  <!-- Content -->
</div>
```

**Key Utilities**:
- `fixed`: Fixed positioning relative to viewport
- `inset-0`: Top/right/bottom/left all set to 0 (full coverage)
- `z-50`: High z-index to overlay other content
- `bg-black/50`: Semi-transparent black (50% opacity)
- `backdrop-blur-sm`: Blur effect on backdrop
- `flex items-center justify-center`: Center content

**Positioning Variations**:
```html
<!-- Top -->
<div class="fixed left-0 right-0 top-0 z-50">...</div>
<div class="fixed top-4 left-1/2 -translate-x-1/2 z-50">...</div> <!-- Centered -->

<!-- Bottom -->
<div class="fixed bottom-0 left-0 right-0 z-50">...</div>
<div class="fixed bottom-4 left-1/2 -translate-x-1/2 z-50">...</div> <!-- Centered -->

<!-- Corners -->
<div class="fixed top-4 right-4 z-50">...</div> <!-- Top Right -->
<div class="fixed top-4 left-4 z-50">...</div> <!-- Top Left -->
<div class="fixed bottom-4 right-4 z-50">...</div> <!-- Bottom Right -->
<div class="fixed bottom-4 left-4 z-50">...</div> <!-- Bottom Left -->

<!-- Edge-aligned Middle -->
<div class="fixed right-4 top-1/2 -translate-y-1/2 z-50">...</div> <!-- Middle Right -->
```

**Used In**: Modal, Toast, Notification, Banner, Dropdown

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module Overlay
      def overlay_classes(
        position_y: :center,
        position_x: :center,
        backdrop: true,
        blur: false
      )
        classes = ["fixed", "z-50"]

        # Positioning
        if position_y == :center && position_x == :center
          classes += ["inset-0", "flex", "items-center", "justify-center"]
        else
          classes << position_class(position_y, position_x)
        end

        # Backdrop
        if backdrop
          classes << (blur ? "bg-black/50 backdrop-blur-sm" : "bg-black/50")
        end

        classes.join(" ")
      end

      private

      def position_class(y, x)
        y_class = case y
        when :top then "top-4"
        when :center then "top-1/2 -translate-y-1/2"
        when :bottom then "bottom-4"
        else "top-4"
        end

        x_class = case x
        when :left then "left-4"
        when :center then "left-1/2 -translate-x-1/2"
        when :right then "right-4"
        else "right-4"
        end

        "#{y_class} #{x_class}"
      end
    end
  end
end
```

---

## Layout Patterns

### Pattern 4: Flexbox Alignment Pattern

**Purpose**: Align items horizontally or vertically with consistent spacing

**HTML Structure**:
```html
<!-- Horizontal with Gap -->
<div class="flex items-center gap-3">
  <span>Icon</span>
  <span>Text</span>
  <span>Badge</span>
</div>

<!-- Horizontal with Space Between -->
<div class="flex items-center justify-between">
  <div>Left Content</div>
  <div>Right Content</div>
</div>

<!-- Vertical Stack -->
<div class="flex flex-col gap-4">
  <div>Item 1</div>
  <div>Item 2</div>
  <div>Item 3</div>
</div>

<!-- Centered Content -->
<div class="flex items-center justify-center">
  <div>Centered Content</div>
</div>

<!-- Vertical Alignment Variations -->
<div class="flex items-start gap-3">...</div> <!-- Align top -->
<div class="flex items-center gap-3">...</div> <!-- Align middle -->
<div class="flex items-end gap-3">...</div> <!-- Align bottom -->
<div class="flex items-baseline gap-3">...</div> <!-- Align baseline -->

<!-- Wrapping -->
<div class="flex flex-wrap gap-2">
  <span>Tag 1</span>
  <span>Tag 2</span>
  <span>Tag 3</span>
</div>
```

**Key Utilities**:
- `flex`: Enable flexbox
- `flex-col`: Vertical direction
- `items-center`, `items-start`, `items-end`: Cross-axis alignment
- `justify-between`, `justify-center`, `justify-end`: Main-axis alignment
- `gap-X`: Space between flex items (X = 0.5rem * X)
- `flex-wrap`: Allow wrapping

**Common Combinations**:
```html
<!-- Button with icon -->
<button class="flex items-center gap-2">
  <svg>...</svg>
  <span>Button Text</span>
</button>

<!-- Badge with close button -->
<span class="inline-flex items-center gap-2 rounded bg-blue-600 px-2.5 py-0.5 text-white">
  <span>Badge Text</span>
  <button class="hover:text-gray-200">×</button>
</span>

<!-- Form field with icon -->
<div class="flex items-center gap-2 rounded-lg border border-gray-200 bg-white px-3 py-2">
  <svg class="text-gray-400">...</svg>
  <input type="text" class="flex-1 border-none focus:ring-0" />
</div>

<!-- Card footer actions -->
<div class="mt-4 flex items-center justify-end gap-2">
  <button class="...">Cancel</button>
  <button class="...">Save</button>
</div>
```

**Used In**: Button, Badge, Card, Form Fields, Toast, Modal Actions

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module FlexLayout
      def flex_classes(
        direction: :row,
        align_items: :center,
        justify: :start,
        gap: 3,
        wrap: false
      )
        classes = ["flex"]
        classes << "flex-col" if direction == :col
        classes << "items-#{align_items}" if align_items
        classes << "justify-#{justify}" if justify != :start
        classes << "gap-#{gap}" if gap
        classes << "flex-wrap" if wrap
        classes.join(" ")
      end
    end
  end
end
```

---

### Pattern 5: Spacing Pattern

**Purpose**: Consistent vertical/horizontal spacing between elements

**HTML Structure**:
```html
<!-- Vertical Spacing (space-y) -->
<div class="space-y-4">
  <div>Item 1</div>
  <div>Item 2</div>
  <div>Item 3</div>
</div>

<!-- Horizontal Spacing (space-x) -->
<div class="flex space-x-4">
  <div>Item 1</div>
  <div>Item 2</div>
  <div>Item 3</div>
</div>

<!-- Margin Top Spacing (Explicit) -->
<div>
  <h2>Title</h2>
  <p class="mt-2">Subtitle</p>
  <div class="mt-4">Content</div>
  <div class="mt-6">Footer</div>
</div>

<!-- Padding Spacing -->
<div class="p-6"> <!-- All sides: 1.5rem -->
  <div class="px-4 py-2">...</div> <!-- Horizontal: 1rem, Vertical: 0.5rem -->
  <div class="pt-4 pb-8">...</div> <!-- Top: 1rem, Bottom: 2rem -->
</div>
```

**Spacing Scale**:
```
0 = 0px
0.5 = 0.125rem (2px)
1 = 0.25rem (4px)
1.5 = 0.375rem (6px)
2 = 0.5rem (8px)
2.5 = 0.625rem (10px)
3 = 0.75rem (12px)
4 = 1rem (16px)
5 = 1.25rem (20px)
6 = 1.5rem (24px)
8 = 2rem (32px)
10 = 2.5rem (40px)
12 = 3rem (48px)
```

**Common Patterns**:
```html
<!-- Form Field Stack -->
<div class="space-y-4">
  <div class="form-field">...</div>
  <div class="form-field">...</div>
  <div class="form-field">...</div>
</div>

<!-- Card Content Sections -->
<div class="p-6">
  <h3 class="text-lg font-semibold">Title</h3>
  <p class="mt-2 text-sm text-gray-600">Description</p>
  <div class="mt-4 flex gap-2">Actions</div>
</div>

<!-- List Items -->
<ul class="space-y-2">
  <li>Item 1</li>
  <li>Item 2</li>
  <li>Item 3</li>
</ul>
```

**Used In**: All components for internal spacing

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module Spacing
      SPACING_SCALE = {
        xs: 2,
        sm: 3,
        md: 4,
        lg: 6,
        xl: 8
      }.freeze

      def spacing_classes(type:, size: :md, direction: :all)
        value = SPACING_SCALE[size]

        case type
        when :padding
          padding_class(value, direction)
        when :margin
          margin_class(value, direction)
        when :gap
          "gap-#{value}"
        when :space
          direction == :vertical ? "space-y-#{value}" : "space-x-#{value}"
        end
      end

      private

      def padding_class(value, direction)
        case direction
        when :all then "p-#{value}"
        when :horizontal then "px-#{value}"
        when :vertical then "py-#{value}"
        when :top then "pt-#{value}"
        when :bottom then "pb-#{value}"
        when :left then "pl-#{value}"
        when :right then "pr-#{value}"
        end
      end

      def margin_class(value, direction)
        case direction
        when :all then "m-#{value}"
        when :horizontal then "mx-#{value}"
        when :vertical then "my-#{value}"
        when :top then "mt-#{value}"
        when :bottom then "mb-#{value}"
        when :left then "ml-#{value}"
        when :right then "mr-#{value}"
        end
      end
    end
  end
end
```

---

## Form Field Patterns

### Pattern 6: Label-Input Wrapper Pattern

**Purpose**: Semantic form field structure with label, input, and error display

**HTML Structure**:
```html
<!-- Basic Form Field -->
<div class="form-group">
  <label for="email" class="block text-sm font-medium text-gray-700">
    Email Address
  </label>
  <input
    type="email"
    id="email"
    name="email"
    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
  />
</div>

<!-- With Helper Text -->
<div class="form-group">
  <label for="password" class="block text-sm font-medium text-gray-700">
    Password
  </label>
  <input
    type="password"
    id="password"
    name="password"
    aria-describedby="password-hint"
    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
  />
  <p id="password-hint" class="mt-1 text-sm text-gray-500">
    Must be at least 8 characters
  </p>
</div>

<!-- With Error State -->
<div class="form-group">
  <label for="username" class="block text-sm font-medium text-gray-700">
    Username
  </label>
  <input
    type="text"
    id="username"
    name="username"
    aria-invalid="true"
    aria-describedby="username-error"
    class="mt-1 block w-full rounded-md border-red-600 shadow-sm focus:border-red-500 focus:ring-red-500"
  />
  <p id="username-error" class="mt-1 text-sm text-red-600" role="alert">
    This username is already taken
  </p>
</div>

<!-- With Required Indicator -->
<div class="form-group">
  <label for="name" class="block text-sm font-medium text-gray-700">
    Full Name
    <span class="text-red-600" aria-label="required">*</span>
  </label>
  <input
    type="text"
    id="name"
    name="name"
    required
    aria-required="true"
    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
  />
</div>

<!-- With Leading Icon -->
<div class="form-group">
  <label for="search" class="block text-sm font-medium text-gray-700">
    Search
  </label>
  <div class="relative mt-1">
    <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
      <svg class="h-5 w-5 text-gray-400" aria-hidden="true">...</svg>
    </div>
    <input
      type="search"
      id="search"
      name="search"
      class="block w-full rounded-md border-gray-300 pl-10 shadow-sm focus:border-blue-500 focus:ring-blue-500"
    />
  </div>
</div>

<!-- With Trailing Button -->
<div class="form-group">
  <label for="code" class="block text-sm font-medium text-gray-700">
    Promo Code
  </label>
  <div class="mt-1 flex gap-2">
    <input
      type="text"
      id="code"
      name="code"
      class="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
    />
    <button type="button" class="rounded-md bg-blue-600 px-4 py-2 text-white">
      Apply
    </button>
  </div>
</div>
```

**Key Utilities**:
- `block`: Display as block element
- `w-full`: Full width
- `rounded-md`: Medium border radius
- `border-gray-300`: Default border color
- `shadow-sm`: Subtle shadow
- `focus:border-blue-500 focus:ring-blue-500`: Focus states
- `mt-1`: Spacing between label and input
- `text-sm font-medium text-gray-700`: Label styling
- `text-sm text-gray-500`: Helper text styling
- `text-sm text-red-600`: Error text styling

**State Patterns**:
```html
<!-- Default State -->
<input class="border-gray-300 focus:border-blue-500 focus:ring-blue-500" />

<!-- Error State -->
<input class="border-red-600 focus:border-red-500 focus:ring-red-500" aria-invalid="true" />

<!-- Success State -->
<input class="border-green-600 focus:border-green-500 focus:ring-green-500" />

<!-- Disabled State -->
<input class="cursor-not-allowed bg-gray-100 text-gray-400" disabled />
```

**Used In**: FormInput, FormSelect, FormTextarea, FormDatePicker

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module FormField
      def field_wrapper_classes
        "form-group"
      end

      def label_classes(required: false)
        classes = ["block", "text-sm", "font-medium", "text-gray-700"]
        classes.join(" ")
      end

      def input_classes(error: false, disabled: false, size: :md)
        classes = ["block", "w-full", "rounded-md", "shadow-sm"]

        # Border and focus states
        if error
          classes += ["border-red-600", "focus:border-red-500", "focus:ring-red-500"]
        elsif disabled
          classes += ["border-gray-300", "bg-gray-100", "text-gray-400", "cursor-not-allowed"]
        else
          classes += ["border-gray-300", "focus:border-blue-500", "focus:ring-blue-500"]
        end

        # Spacing
        classes << spacing_for_size(size)

        classes.join(" ")
      end

      def helper_text_classes
        "mt-1 text-sm text-gray-500"
      end

      def error_text_classes
        "mt-1 text-sm text-red-600"
      end

      private

      def spacing_for_size(size)
        {
          sm: "p-2 text-sm",
          md: "p-3 text-sm",
          lg: "p-4 text-base"
        }[size] || "p-3 text-sm"
      end
    end
  end
end
```

---

### Pattern 7: Field Group Pattern

**Purpose**: Group related form fields with semantic fieldset/legend

**HTML Structure**:
```html
<!-- Radio Group -->
<fieldset class="form-fieldset">
  <legend class="text-sm font-medium text-gray-700">
    Choose shipping method
    <span class="text-red-600" aria-label="required">*</span>
  </legend>

  <div class="mt-3 space-y-2">
    <div class="flex items-center gap-3">
      <input
        type="radio"
        id="shipping-standard"
        name="shipping"
        value="standard"
        class="h-4 w-4 border-gray-300 text-blue-600 focus:ring-blue-500"
      />
      <label for="shipping-standard" class="text-sm text-gray-700">
        <span class="font-medium">Standard Shipping</span>
        <span class="text-gray-500">(5-7 business days)</span>
      </label>
    </div>

    <div class="flex items-center gap-3">
      <input
        type="radio"
        id="shipping-express"
        name="shipping"
        value="express"
        class="h-4 w-4 border-gray-300 text-blue-600 focus:ring-blue-500"
      />
      <label for="shipping-express" class="text-sm text-gray-700">
        <span class="font-medium">Express Shipping</span>
        <span class="text-gray-500">(2-3 business days)</span>
      </label>
    </div>
  </div>

  <p id="shipping-error" class="mt-2 text-sm text-red-600" role="alert" hidden>
    Please select a shipping method
  </p>
</fieldset>

<!-- Checkbox Group -->
<fieldset class="form-fieldset">
  <legend class="text-sm font-medium text-gray-700">
    Select your interests
  </legend>

  <div class="mt-3 space-y-2">
    <div class="flex items-start gap-3">
      <input
        type="checkbox"
        id="interest-tech"
        name="interests[]"
        value="tech"
        class="mt-1 h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
      />
      <label for="interest-tech" class="text-sm">
        <span class="font-medium text-gray-900">Technology</span>
        <p class="text-gray-600">News about latest tech trends</p>
      </label>
    </div>

    <div class="flex items-start gap-3">
      <input
        type="checkbox"
        id="interest-sports"
        name="interests[]"
        value="sports"
        class="mt-1 h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
      />
      <label for="interest-sports" class="text-sm">
        <span class="font-medium text-gray-900">Sports</span>
        <p class="text-gray-600">Updates on sports events</p>
      </label>
    </div>
  </div>
</fieldset>

<!-- Field Group with Border -->
<fieldset class="rounded-lg border border-gray-200 p-6">
  <legend class="px-2 text-sm font-medium text-gray-700">
    Payment Information
  </legend>

  <div class="space-y-4">
    <div class="form-group">...</div>
    <div class="form-group">...</div>
  </div>
</fieldset>
```

**Key Utilities**:
- `space-y-2`: Vertical spacing between group items
- `flex items-center gap-3`: Checkbox/radio + label alignment
- `flex items-start gap-3`: Multi-line label alignment
- `h-4 w-4`: Standard checkbox/radio size
- `rounded`: Border radius for checkbox
- `text-blue-600`: Checked color
- `focus:ring-blue-500`: Focus ring color

**Used In**: FormCheckbox (groups), FormRadio (groups), Multi-field sections

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module FieldGroup
      def fieldset_classes(bordered: false)
        classes = ["form-fieldset"]
        classes += ["rounded-lg", "border", "border-gray-200", "p-6"] if bordered
        classes.join(" ")
      end

      def legend_classes
        "text-sm font-medium text-gray-700"
      end

      def group_container_classes
        "mt-3 space-y-2"
      end

      def checkbox_radio_wrapper_classes(multiline: false)
        classes = ["flex", "gap-3"]
        classes << (multiline ? "items-start" : "items-center")
        classes.join(" ")
      end

      def checkbox_classes
        "h-4 w-4 rounded border-gray-300 text-blue-600 focus:ring-blue-500"
      end

      def radio_classes
        "h-4 w-4 border-gray-300 text-blue-600 focus:ring-blue-500"
      end
    end
  end
end
```

---

## Interactive Component Patterns

### Pattern 8: Dialog/Modal Pattern

**Purpose**: Overlay dialog with backdrop, centering, and content container

**HTML Structure**:
```html
<!-- Basic Modal -->
<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50" aria-hidden="true">
  <div
    class="relative w-full max-w-md rounded-lg bg-white p-6 shadow-xl"
    role="dialog"
    aria-modal="true"
    aria-labelledby="modal-title"
    aria-describedby="modal-description"
  >
    <!-- Close button -->
    <button
      type="button"
      class="absolute right-4 top-4 text-gray-400 hover:text-gray-600"
      aria-label="Close dialog"
    >
      <svg class="h-6 w-6" aria-hidden="true">...</svg>
    </button>

    <!-- Content -->
    <h2 id="modal-title" class="text-lg font-semibold text-gray-900">
      Modal Title
    </h2>
    <div id="modal-description" class="mt-2 text-sm text-gray-600">
      <p>Modal content goes here</p>
    </div>

    <!-- Actions -->
    <div class="mt-6 flex justify-end gap-2">
      <button type="button" class="rounded-md border border-gray-300 bg-white px-4 py-2 text-sm font-medium text-gray-700 hover:bg-gray-50">
        Cancel
      </button>
      <button type="button" class="rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700">
        Confirm
      </button>
    </div>
  </div>
</div>

<!-- Modal with Header/Body/Footer Sections -->
<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
  <div class="relative w-full max-w-lg overflow-hidden rounded-lg bg-white shadow-xl">
    <!-- Header -->
    <div class="border-b border-gray-200 px-6 py-4">
      <h2 class="text-lg font-semibold text-gray-900">Modal Title</h2>
      <button
        type="button"
        class="absolute right-4 top-4 text-gray-400 hover:text-gray-600"
        aria-label="Close dialog"
      >
        ×
      </button>
    </div>

    <!-- Body -->
    <div class="px-6 py-4">
      <p class="text-sm text-gray-600">Modal body content</p>
    </div>

    <!-- Footer -->
    <div class="border-t border-gray-200 bg-gray-50 px-6 py-4">
      <div class="flex justify-end gap-2">
        <button type="button" class="...">Cancel</button>
        <button type="button" class="...">Save</button>
      </div>
    </div>
  </div>
</div>

<!-- Full-Screen Modal (Mobile) -->
<div class="fixed inset-0 z-50 md:flex md:items-center md:justify-center md:bg-black/50">
  <div class="h-full w-full overflow-y-auto bg-white md:h-auto md:max-w-2xl md:rounded-lg md:shadow-xl">
    <!-- Content -->
  </div>
</div>

<!-- Side Panel Modal -->
<div class="fixed inset-0 z-50 flex justify-end bg-black/50">
  <div class="h-full w-full max-w-md overflow-y-auto bg-white shadow-xl">
    <!-- Panel content -->
  </div>
</div>
```

**Key Utilities**:
- `fixed inset-0 z-50`: Full-screen fixed overlay
- `flex items-center justify-center`: Center modal
- `bg-black/50`: Semi-transparent backdrop
- `max-w-md`, `max-w-lg`, `max-w-2xl`: Width constraints
- `shadow-xl`: Prominent shadow
- `overflow-hidden`: Clean rounded corners
- `overflow-y-auto`: Scrollable content

**Positioning Variants**:
```html
<!-- Top -->
<div class="fixed inset-0 z-50 flex items-start justify-center bg-black/50 pt-20">...</div>

<!-- Bottom -->
<div class="fixed inset-0 z-50 flex items-end justify-center bg-black/50 pb-20">...</div>

<!-- Side (Right) -->
<div class="fixed inset-0 z-50 flex justify-end bg-black/50">...</div>

<!-- Side (Left) -->
<div class="fixed inset-0 z-50 flex justify-start bg-black/50">...</div>
```

**Used In**: Modal component

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module Dialog
      def dialog_overlay_classes(position_y: :center, position_x: :center)
        classes = ["fixed", "inset-0", "z-50", "bg-black/50"]

        unless position_y == :bottom && position_x == :right
          classes << "flex"
        end

        # Vertical alignment
        classes << case position_y
        when :top then "items-start pt-20"
        when :center then "items-center"
        when :bottom then "items-end pb-20"
        else "items-center"
        end

        # Horizontal alignment
        classes << case position_x
        when :left then "justify-start"
        when :center then "justify-center"
        when :right then "justify-end"
        else "justify-center"
        end

        classes.join(" ")
      end

      def dialog_content_classes(size: :md, layout: :simple)
        classes = ["relative", "w-full", "bg-white", "shadow-xl"]

        # Size
        classes << case size
        when :sm then "max-w-sm"
        when :md then "max-w-md"
        when :lg then "max-w-lg"
        when :xl then "max-w-2xl"
        when :full then "h-full"
        else "max-w-md"
        end

        # Layout
        case layout
        when :simple
          classes += ["rounded-lg", "p-6"]
        when :sections
          classes += ["rounded-lg", "overflow-hidden"]
        when :panel
          classes += ["h-full", "overflow-y-auto"]
        end

        classes.join(" ")
      end
    end
  end
end
```

---

### Pattern 9: Notification/Toast Pattern

**Purpose**: Fixed-position notification with icon, message, and dismiss button

**HTML Structure**:
```html
<!-- Basic Toast -->
<div class="pointer-events-none fixed bottom-4 right-4 z-50 flex flex-col gap-2">
  <div class="pointer-events-auto flex items-center gap-4 rounded-lg border border-gray-200 bg-white p-4 shadow-lg">
    <span class="text-green-600">
      <svg class="h-5 w-5" aria-hidden="true">✓</svg>
    </span>
    <p class="text-sm font-medium text-gray-900">Changes saved successfully</p>
    <button type="button" class="ml-auto text-gray-400 hover:text-gray-600" aria-label="Dismiss">
      <svg class="h-5 w-5" aria-hidden="true">×</svg>
    </button>
  </div>
</div>

<!-- Toast with Border Accent -->
<div class="flex items-center gap-4 rounded-lg border-l-4 border-green-600 bg-white p-4 shadow-lg">
  <span class="text-green-600">
    <svg class="h-5 w-5" aria-hidden="true">✓</svg>
  </span>
  <div class="flex-1">
    <p class="text-sm font-medium text-gray-900">Success!</p>
    <p class="text-xs text-gray-600">Your changes have been saved</p>
  </div>
  <button type="button" class="text-gray-400 hover:text-gray-600" aria-label="Dismiss">
    ×
  </button>
</div>

<!-- Toast with Colored Background -->
<div class="flex items-center gap-4 rounded-lg bg-green-50 p-4 shadow-lg">
  <span class="text-green-600">
    <svg class="h-5 w-5" aria-hidden="true">✓</svg>
  </span>
  <p class="flex-1 text-sm font-medium text-green-900">Changes saved successfully</p>
  <button type="button" class="text-green-600 hover:text-green-800" aria-label="Dismiss">
    ×
  </button>
</div>

<!-- Toast with Action Button -->
<div class="flex items-center gap-4 rounded-lg border border-gray-200 bg-white p-4 shadow-lg">
  <span class="text-blue-600">
    <svg class="h-5 w-5" aria-hidden="true">ℹ</svg>
  </span>
  <div class="flex-1">
    <p class="text-sm font-medium text-gray-900">Update available</p>
    <p class="text-xs text-gray-600">A new version is ready</p>
  </div>
  <button type="button" class="rounded bg-blue-600 px-3 py-1 text-xs font-medium text-white hover:bg-blue-700">
    Update
  </button>
  <button type="button" class="text-gray-400 hover:text-gray-600" aria-label="Dismiss">
    ×
  </button>
</div>

<!-- Toast with Progress Bar -->
<div class="relative overflow-hidden rounded-lg border border-gray-200 bg-white p-4 shadow-lg">
  <div class="flex items-center gap-4">
    <span class="text-blue-600">
      <svg class="h-5 w-5" aria-hidden="true">⟳</svg>
    </span>
    <p class="flex-1 text-sm font-medium text-gray-900">Uploading file...</p>
    <span class="text-xs text-gray-600">45%</span>
  </div>
  <div class="absolute bottom-0 left-0 h-1 bg-blue-600 transition-all" style="width: 45%"></div>
</div>
```

**Color Variants**:
```html
<!-- Success (Green) -->
<div class="... border-l-4 border-green-600 bg-green-50">
  <span class="text-green-600">✓</span>
  <p class="text-green-900">...</p>
</div>

<!-- Error (Red) -->
<div class="... border-l-4 border-red-600 bg-red-50">
  <span class="text-red-600">✕</span>
  <p class="text-red-900">...</p>
</div>

<!-- Warning (Yellow) -->
<div class="... border-l-4 border-yellow-600 bg-yellow-50">
  <span class="text-yellow-600">⚠</span>
  <p class="text-yellow-900">...</p>
</div>

<!-- Info (Blue) -->
<div class="... border-l-4 border-blue-600 bg-blue-50">
  <span class="text-blue-600">ℹ</span>
  <p class="text-blue-900">...</p>
</div>
```

**Position Variants**:
```html
<!-- Top Right -->
<div class="fixed top-4 right-4 z-50">...</div>

<!-- Top Center -->
<div class="fixed top-4 left-1/2 -translate-x-1/2 z-50">...</div>

<!-- Bottom Right -->
<div class="fixed bottom-4 right-4 z-50">...</div>

<!-- Bottom Left -->
<div class="fixed bottom-4 left-4 z-50">...</div>
```

**Used In**: Toast component

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module Notification
      def notification_container_classes(position_y: :bottom, position_x: :right)
        classes = ["fixed", "z-50"]

        # Vertical position
        classes << case position_y
        when :top then "top-4"
        when :bottom then "bottom-4"
        else "bottom-4"
        end

        # Horizontal position
        classes << case position_x
        when :left then "left-4"
        when :center then "left-1/2 -translate-x-1/2"
        when :right then "right-4"
        else "right-4"
        end

        classes.join(" ")
      end

      def notification_classes(color: :info, style: :border_accent)
        classes = ["flex", "items-center", "gap-4", "rounded-lg", "p-4", "shadow-lg"]

        case style
        when :border_accent
          classes += ["border-l-4", "bg-white", border_color(color)]
        when :colored_bg
          classes += [bg_color(color)]
        when :simple
          classes += ["border", "border-gray-200", "bg-white"]
        end

        classes.join(" ")
      end

      def notification_icon_classes(color: :info)
        text_color(color)
      end

      def notification_text_classes(color: :info, style: :border_accent)
        case style
        when :colored_bg
          "text-sm font-medium #{text_dark_color(color)}"
        else
          "text-sm font-medium text-gray-900"
        end
      end

      private

      def border_color(color)
        "border-#{tailwind_color(color)}-600"
      end

      def bg_color(color)
        "bg-#{tailwind_color(color)}-50"
      end

      def text_color(color)
        "text-#{tailwind_color(color)}-600"
      end

      def text_dark_color(color)
        "text-#{tailwind_color(color)}-900"
      end

      def tailwind_color(semantic)
        {
          success: "green",
          error: "red",
          warning: "yellow",
          info: "blue"
        }[semantic] || "blue"
      end
    end
  end
end
```

---

## State Management Patterns

### Pattern 10: Hover/Focus/Active States

**Purpose**: Consistent interactive feedback for user actions

**HTML Structure**:
```html
<!-- Button States -->
<button class="
  rounded-md
  bg-blue-600 text-white
  hover:bg-blue-700
  focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
  active:bg-blue-800
  disabled:cursor-not-allowed disabled:bg-gray-300 disabled:text-gray-500
">
  Button
</button>

<!-- Link States -->
<a href="#" class="
  text-blue-600
  hover:text-blue-800 hover:underline
  focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2
  active:text-blue-900
">
  Link
</a>

<!-- Input States -->
<input class="
  rounded-md border-gray-300
  hover:border-gray-400
  focus:border-blue-500 focus:ring-2 focus:ring-blue-500
  disabled:cursor-not-allowed disabled:bg-gray-100 disabled:text-gray-400
" />

<!-- Card/Container States (Interactive) -->
<article class="
  rounded-lg border border-gray-200 bg-white
  hover:border-gray-300 hover:shadow-md
  focus-within:border-blue-500 focus-within:ring-2 focus-within:ring-blue-500
  transition-all
">
  ...
</article>

<!-- Icon Button States -->
<button class="
  rounded-full p-2
  text-gray-600
  hover:bg-gray-100 hover:text-gray-900
  focus:outline-none focus:ring-2 focus:ring-blue-500
  active:bg-gray-200
">
  <svg>...</svg>
</button>
```

**State Utility Patterns**:

**Hover States**:
```html
<!-- Background color change -->
hover:bg-blue-700

<!-- Text color change -->
hover:text-blue-800

<!-- Border color change -->
hover:border-gray-400

<!-- Shadow change -->
hover:shadow-md
hover:shadow-lg

<!-- Opacity change -->
hover:opacity-80

<!-- Scale change -->
hover:scale-105

<!-- Translate change -->
hover:-translate-y-1
```

**Focus States**:
```html
<!-- Ring (most common for accessibility) -->
focus:outline-none focus:ring-2 focus:ring-blue-500

<!-- Ring with offset -->
focus:ring-2 focus:ring-blue-500 focus:ring-offset-2

<!-- Border color -->
focus:border-blue-500

<!-- Background color -->
focus:bg-blue-50

<!-- Focus within (for containers) -->
focus-within:border-blue-500 focus-within:ring-2
```

**Active States**:
```html
<!-- Background color (darker) -->
active:bg-blue-800

<!-- Text color -->
active:text-blue-900

<!-- Scale (pressed effect) -->
active:scale-95

<!-- Opacity -->
active:opacity-90
```

**Disabled States**:
```html
<!-- Cursor change -->
disabled:cursor-not-allowed

<!-- Opacity -->
disabled:opacity-50

<!-- Background/text colors -->
disabled:bg-gray-100 disabled:text-gray-400

<!-- Pointer events (for non-button elements) -->
pointer-events-none
```

**Transition Classes**:
```html
<!-- All properties -->
transition-all

<!-- Specific properties -->
transition-colors
transition-opacity
transition-shadow
transition-transform

<!-- Duration -->
duration-150
duration-200
duration-300

<!-- Easing -->
ease-in
ease-out
ease-in-out
```

**Used In**: All interactive components

**Ruby Helper Recommendation**:
```ruby
module Kumiki
  module Patterns
    module InteractiveStates
      def button_state_classes(color: :blue, variant: :filled)
        case variant
        when :filled
          filled_button_states(color)
        when :outline
          outline_button_states(color)
        when :ghost
          ghost_button_states(color)
        end
      end

      def input_state_classes(error: false)
        if error
          "border-red-600 focus:border-red-500 focus:ring-red-500 " \
          "disabled:cursor-not-allowed disabled:bg-gray-100 disabled:text-gray-400"
        else
          "border-gray-300 hover:border-gray-400 " \
          "focus:border-blue-500 focus:ring-2 focus:ring-blue-500 " \
          "disabled:cursor-not-allowed disabled:bg-gray-100 disabled:text-gray-400"
        end
      end

      def link_state_classes(color: :blue)
        "text-#{color}-600 hover:text-#{color}-800 hover:underline " \
        "focus:outline-none focus:ring-2 focus:ring-#{color}-500 " \
        "active:text-#{color}-900"
      end

      def card_state_classes(interactive: false)
        if interactive
          "hover:border-gray-300 hover:shadow-md " \
          "focus-within:border-blue-500 focus-within:ring-2 " \
          "transition-all"
        else
          ""
        end
      end

      private

      def filled_button_states(color)
        "bg-#{color}-600 text-white " \
        "hover:bg-#{color}-700 " \
        "focus:outline-none focus:ring-2 focus:ring-#{color}-500 focus:ring-offset-2 " \
        "active:bg-#{color}-800 " \
        "disabled:cursor-not-allowed disabled:bg-gray-300 disabled:text-gray-500"
      end

      def outline_button_states(color)
        "border border-#{color}-600 text-#{color}-600 " \
        "hover:bg-#{color}-600 hover:text-white " \
        "focus:outline-none focus:ring-2 focus:ring-#{color}-500 " \
        "active:bg-#{color}-700 " \
        "disabled:cursor-not-allowed disabled:border-gray-300 disabled:text-gray-400"
      end

      def ghost_button_states(color)
        "text-#{color}-600 " \
        "hover:bg-#{color}-100 " \
        "focus:outline-none focus:ring-2 focus:ring-#{color}-500 " \
        "active:bg-#{color}-200 " \
        "disabled:cursor-not-allowed disabled:text-gray-400"
      end
    end
  end
end
```

---

## Tailwind Utility Conventions

### Common Utility Class Patterns

**Spacing Scale** (0.25rem = 4px increments):
```
0    = 0px
0.5  = 2px
1    = 4px
1.5  = 6px
2    = 8px
2.5  = 10px
3    = 12px
4    = 16px
5    = 20px
6    = 24px
8    = 32px
10   = 40px
12   = 48px
16   = 64px
20   = 80px
24   = 96px
```

**Color Scale** (50-950):
```
50   = Lightest tint
100  = Very light
200  = Light
300  = Light-medium (default borders)
400  = Medium (placeholders, disabled)
500  = Medium-dark (default text, focus rings)
600  = Dark (primary colors, headings)
700  = Darker (hover states)
800  = Very dark (active states)
900  = Darkest (emphasis)
950  = Near black
```

**Common Color Combinations**:
```html
<!-- Primary Button -->
bg-blue-600 text-white hover:bg-blue-700

<!-- Secondary Button -->
bg-gray-600 text-white hover:bg-gray-700

<!-- Success State -->
bg-green-600 text-white | text-green-600 bg-green-100

<!-- Error State -->
bg-red-600 text-white | text-red-600 bg-red-100

<!-- Warning State -->
bg-yellow-600 text-white | text-yellow-600 bg-yellow-100

<!-- Info State -->
bg-blue-600 text-white | text-blue-600 bg-blue-100

<!-- Soft/Subtle -->
bg-gray-100 text-gray-700 hover:bg-gray-200
```

**Typography Scale**:
```html
text-xs    = 0.75rem (12px)
text-sm    = 0.875rem (14px)
text-base  = 1rem (16px)
text-lg    = 1.125rem (18px)
text-xl    = 1.25rem (20px)
text-2xl   = 1.5rem (24px)
text-3xl   = 1.875rem (30px)
text-4xl   = 2.25rem (36px)
```

**Font Weights**:
```html
font-light    = 300
font-normal   = 400
font-medium   = 500
font-semibold = 600
font-bold     = 700
font-extrabold = 800
```

**Border Radius**:
```html
rounded-none  = 0px
rounded-sm    = 0.125rem (2px)
rounded       = 0.25rem (4px)
rounded-md    = 0.375rem (6px)
rounded-lg    = 0.5rem (8px)
rounded-xl    = 0.75rem (12px)
rounded-2xl   = 1rem (16px)
rounded-full  = 9999px (pill/circle)
```

**Shadows**:
```html
shadow-none  = none
shadow-sm    = 0 1px 2px rgba(0,0,0,0.05)
shadow       = 0 1px 3px rgba(0,0,0,0.1)
shadow-md    = 0 4px 6px rgba(0,0,0,0.1)
shadow-lg    = 0 10px 15px rgba(0,0,0,0.1)
shadow-xl    = 0 20px 25px rgba(0,0,0,0.1)
shadow-2xl   = 0 25px 50px rgba(0,0,0,0.25)
```

**Width/Height**:
```html
w-full    = 100%
w-screen  = 100vw
w-1/2     = 50%
w-1/3     = 33.333%
w-2/3     = 66.666%
w-1/4     = 25%
w-auto    = auto

h-full    = 100%
h-screen  = 100vh
h-auto    = auto
```

**Max Width** (commonly used for containers):
```html
max-w-none  = none
max-w-xs    = 20rem (320px)
max-w-sm    = 24rem (384px)
max-w-md    = 28rem (448px)
max-w-lg    = 32rem (512px)
max-w-xl    = 36rem (576px)
max-w-2xl   = 42rem (672px)
max-w-4xl   = 56rem (896px)
max-w-full  = 100%
```

---

## Cross-Component Patterns

### Patterns Used in 3+ Components

#### Pattern 11: Inline-Flex Items-Center Gap Pattern

**Usage**: Horizontally align icon + text, badge content, button content

**HTML Structure**:
```html
<element class="inline-flex items-center gap-2">
  <icon />
  <text />
</element>
```

**Used In**:
- Button: Icon + text
- Badge: Icon/dot + text + close button
- Toast: Icon + message + close button
- Form fields: Input + icon
- Card actions: Multiple buttons

**Variations**:
```html
<!-- Small gap -->
class="inline-flex items-center gap-1"

<!-- Medium gap (most common) -->
class="inline-flex items-center gap-2"

<!-- Large gap -->
class="inline-flex items-center gap-3"

<!-- With vertical alignment variation -->
class="inline-flex items-start gap-2"  <!-- Top aligned -->
class="inline-flex items-baseline gap-2"  <!-- Baseline aligned -->
```

---

#### Pattern 12: Rounded Border Background Padding Pattern

**Usage**: Basic component container structure

**HTML Structure**:
```html
<element class="rounded-{size} border border-{color} bg-{color} p-{size}">
  ...
</element>
```

**Used In**:
- Card
- Input fields
- Select fields
- Textarea
- Badge
- Button
- Toast
- Modal content

**Common Combinations**:
```html
<!-- Input field -->
rounded-md border-gray-300 bg-white p-3

<!-- Button -->
rounded-md bg-blue-600 px-4 py-2

<!-- Card -->
rounded-lg border-gray-200 bg-white p-6

<!-- Badge -->
rounded-full bg-blue-600 px-2.5 py-0.5

<!-- Modal content -->
rounded-lg bg-white p-6
```

---

#### Pattern 13: Text Size Font Weight Color Pattern

**Usage**: Typography hierarchy

**HTML Structure**:
```html
<element class="text-{size} font-{weight} text-{color}">
  ...
</element>
```

**Used In**: All components with text content

**Common Hierarchies**:
```html
<!-- Heading 1 -->
text-2xl font-bold text-gray-900

<!-- Heading 2 -->
text-xl font-semibold text-gray-900

<!-- Heading 3 -->
text-lg font-semibold text-gray-900

<!-- Body text -->
text-base font-normal text-gray-700

<!-- Small text / helper text -->
text-sm font-normal text-gray-600

<!-- Tiny text / captions -->
text-xs font-normal text-gray-500

<!-- Labels -->
text-sm font-medium text-gray-700

<!-- Error text -->
text-sm font-medium text-red-600

<!-- Success text -->
text-sm font-medium text-green-600
```

---

#### Pattern 14: Focus Ring Pattern

**Usage**: Keyboard navigation accessibility

**HTML Structure**:
```html
<element class="focus:outline-none focus:ring-2 focus:ring-{color}-500 focus:ring-offset-2">
  ...
</element>
```

**Used In**:
- All interactive elements (buttons, links, inputs)
- Form fields
- Modal close buttons
- Card links

**Variations**:
```html
<!-- Standard ring -->
focus:outline-none focus:ring-2 focus:ring-blue-500

<!-- Ring with offset (for bordered elements) -->
focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2

<!-- Colored ring (matches component color) -->
focus:outline-none focus:ring-2 focus:ring-green-500  <!-- Success -->
focus:outline-none focus:ring-2 focus:ring-red-500    <!-- Error -->

<!-- Within container -->
focus-within:ring-2 focus-within:ring-blue-500
```

---

## Component-Specific Patterns

### Button Component Patterns

**Base Structure**:
```html
<button class="inline-flex items-center gap-2 rounded-md px-4 py-2 text-sm font-medium transition-colors">
  <icon /> <!-- Optional -->
  <text />
</button>
```

**Variant Combinations**:
```html
<!-- Filled Primary -->
inline-flex items-center gap-2 rounded-md bg-blue-600 px-4 py-2 text-sm font-medium text-white
hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2

<!-- Outline Primary -->
inline-flex items-center gap-2 rounded-md border border-blue-600 bg-transparent px-4 py-2 text-sm font-medium text-blue-600
hover:bg-blue-600 hover:text-white focus:outline-none focus:ring-2 focus:ring-blue-500

<!-- Ghost Primary -->
inline-flex items-center gap-2 rounded-md bg-transparent px-4 py-2 text-sm font-medium text-blue-600
hover:bg-blue-100 focus:outline-none focus:ring-2 focus:ring-blue-500

<!-- Soft Primary -->
inline-flex items-center gap-2 rounded-md bg-blue-100 px-4 py-2 text-sm font-medium text-blue-700
hover:bg-blue-200 focus:outline-none focus:ring-2 focus:ring-blue-500
```

**Size Variations**:
```html
<!-- Extra Small -->
px-2 py-1 text-xs

<!-- Small -->
px-3 py-1.5 text-sm

<!-- Medium (default) -->
px-4 py-2 text-sm

<!-- Large -->
px-6 py-3 text-base

<!-- Extra Large -->
px-8 py-4 text-lg
```

---

### Card Component Patterns

**Base Structure**:
```html
<article class="overflow-hidden rounded-lg border border-gray-200 bg-white shadow-sm">
  <img class="h-56 w-full object-cover" /> <!-- Optional -->
  <div class="p-6">
    <h3 class="text-lg font-semibold text-gray-900">Title</h3>
    <p class="mt-2 text-sm text-gray-600">Description</p>
    <div class="mt-4 flex gap-2">Actions</div>
  </div>
</article>
```

**Layout Variations**:
```html
<!-- Vertical (image top) -->
<article class="overflow-hidden rounded-lg...">
  <img class="h-56 w-full object-cover" />
  <div class="p-6">...</div>
</article>

<!-- Horizontal (image left) -->
<article class="flex overflow-hidden rounded-lg...">
  <img class="h-full w-48 object-cover" />
  <div class="flex flex-1 flex-col p-6">...</div>
</article>

<!-- Header/Body/Footer sections -->
<article class="overflow-hidden rounded-lg...">
  <div class="border-b p-6">Header</div>
  <div class="p-6">Body</div>
  <div class="border-t bg-gray-50 p-6">Footer</div>
</article>
```

---

### Form Input Component Patterns

**Base Structure**:
```html
<div class="form-group">
  <label class="block text-sm font-medium text-gray-700">
    Label
  </label>
  <input class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500" />
</div>
```

**State Variations**:
```html
<!-- Default -->
border-gray-300 focus:border-blue-500 focus:ring-blue-500

<!-- Error -->
border-red-600 focus:border-red-500 focus:ring-red-500

<!-- Success -->
border-green-600 focus:border-green-500 focus:ring-green-500

<!-- Disabled -->
cursor-not-allowed bg-gray-100 text-gray-400
```

**With Decorations**:
```html
<!-- Leading icon -->
<div class="relative">
  <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
    <icon class="h-5 w-5 text-gray-400" />
  </div>
  <input class="block w-full pl-10..." />
</div>

<!-- Trailing button -->
<div class="flex gap-2">
  <input class="block w-full..." />
  <button class="...">Submit</button>
</div>
```

---

### Modal Component Patterns

**Base Structure**:
```html
<div class="fixed inset-0 z-50 flex items-center justify-center bg-black/50">
  <div class="relative w-full max-w-md rounded-lg bg-white p-6 shadow-xl">
    <button class="absolute right-4 top-4 text-gray-400 hover:text-gray-600" aria-label="Close">×</button>
    <h2 class="text-lg font-semibold">Title</h2>
    <div class="mt-2 text-sm text-gray-600">Content</div>
    <div class="mt-6 flex justify-end gap-2">Actions</div>
  </div>
</div>
```

**Size Variations**:
```html
max-w-sm   <!-- Small -->
max-w-md   <!-- Medium (default) -->
max-w-lg   <!-- Large -->
max-w-2xl  <!-- Extra Large -->
max-w-full <!-- Full width -->
```

---

### Toast Component Patterns

**Base Structure**:
```html
<div class="fixed bottom-4 right-4 z-50">
  <div class="flex items-center gap-4 rounded-lg border-l-4 border-green-600 bg-white p-4 shadow-lg">
    <icon class="text-green-600" />
    <p class="flex-1 text-sm font-medium">Message</p>
    <button class="text-gray-400 hover:text-gray-600" aria-label="Dismiss">×</button>
  </div>
</div>
```

**Color Variations**:
```html
<!-- Success -->
border-l-4 border-green-600 bg-white
icon: text-green-600
text: text-gray-900

<!-- Error -->
border-l-4 border-red-600 bg-white
icon: text-red-600
text: text-gray-900

<!-- Warning -->
border-l-4 border-yellow-600 bg-white
icon: text-yellow-600
text: text-gray-900

<!-- Info -->
border-l-4 border-blue-600 bg-white
icon: text-blue-600
text: text-gray-900
```

---

## Ruby Helper Method Recommendations

### 1. Pattern-Based Component Generator

```ruby
module Kumiki
  module Components
    module Patterns
      # Include all pattern modules
      include Container
      include ContentImage
      include Overlay
      include FlexLayout
      include Spacing
      include FormField
      include FieldGroup
      include Dialog
      include Notification
      include InteractiveStates
    end
  end
end
```

### 2. Utility Class Builder

```ruby
module Kumiki
  class UtilityBuilder
    def initialize
      @classes = []
    end

    def add(*classes)
      @classes += classes.flatten.compact
      self
    end

    def spacing(type:, size: :md, direction: :all)
      add(Patterns::Spacing.spacing_classes(type: type, size: size, direction: direction))
    end

    def flex(direction: :row, align_items: :center, justify: :start, gap: 3)
      add(Patterns::FlexLayout.flex_classes(
        direction: direction,
        align_items: align_items,
        justify: justify,
        gap: gap
      ))
    end

    def container(padded: true, bordered: true, shadowed: false, size: :md)
      add(Patterns::Container.container_classes(
        padded: padded,
        bordered: bordered,
        shadowed: shadowed,
        size: size
      ))
    end

    def build
      @classes.uniq.join(" ")
    end
  end
end
```

### 3. Component-Specific Pattern Helpers

```ruby
module Kumiki
  module Components
    class Button
      include Patterns

      def button_classes
        UtilityBuilder.new
          .add("inline-flex", "items-center", "gap-2", "rounded-md", "font-medium", "transition-colors")
          .add(size_classes)
          .add(color_variant_classes)
          .add(button_state_classes(color: color, variant: style))
          .build
      end

      private

      def size_classes
        {
          xs: "px-2 py-1 text-xs",
          sm: "px-3 py-1.5 text-sm",
          md: "px-4 py-2 text-sm",
          lg: "px-6 py-3 text-base",
          xl: "px-8 py-4 text-lg"
        }[size] || "px-4 py-2 text-sm"
      end

      def color_variant_classes
        COLORS.dig(color, style) || COLORS.dig(:primary, :filled)
      end
    end

    class Card
      include Patterns

      def card_classes
        UtilityBuilder.new
          .container(padded: false, bordered: bordered, shadowed: shadowed)
          .add("overflow-hidden")
          .add(card_state_classes(interactive: interactive))
          .build
      end

      def card_content_classes
        UtilityBuilder.new
          .spacing(type: :padding, size: size)
          .build
      end
    end

    class FormInput
      include Patterns

      def field_wrapper_classes
        "form-group"
      end

      def input_classes
        UtilityBuilder.new
          .add("block", "w-full", "rounded-md", "shadow-sm")
          .add(input_size_classes)
          .add(input_state_classes(error: error?))
          .build
      end

      private

      def input_size_classes
        {
          sm: "p-2 text-sm",
          md: "p-3 text-sm",
          lg: "p-4 text-base"
        }[size] || "p-3 text-sm"
      end
    end
  end
end
```

### 4. Pattern Testing Helpers

```ruby
# spec/support/pattern_testing.rb
module PatternTesting
  def expect_container_pattern(html, options = {})
    expect(html).to include("rounded-lg")
    expect(html).to include("bg-white") if options.fetch(:background, true)
    expect(html).to include("border") if options.fetch(:bordered, true)
    expect(html).to include("shadow-sm") if options.fetch(:shadowed, false)
  end

  def expect_flex_pattern(html, direction: :row, gap: nil)
    expect(html).to include("flex")
    expect(html).to include("flex-col") if direction == :col
    expect(html).to include("gap-#{gap}") if gap
  end

  def expect_form_field_pattern(html)
    expect(html).to include("block")
    expect(html).to include("w-full")
    expect(html).to include("rounded-md")
    expect(html).to include("border-gray-300") # or error state
  end

  def expect_interactive_states(html, type: :button)
    case type
    when :button
      expect(html).to include("hover:")
      expect(html).to include("focus:")
      expect(html).to include("disabled:")
    when :input
      expect(html).to include("focus:border")
      expect(html).to include("focus:ring")
    end
  end
end
```

---

## Implementation Guidelines

### 1. Pattern Application Strategy

**Step 1: Identify Pattern**
- Determine which pattern(s) apply to the component
- Check if pattern is core structural, layout, or state-based

**Step 2: Choose Base Pattern**
- Select the most appropriate base pattern
- Identify variations needed

**Step 3: Apply Utilities**
- Build class string using pattern helpers
- Add component-specific overrides

**Step 4: Test Pattern**
- Visual regression testing
- Accessibility testing
- Responsive testing

### 2. Pattern Composition Rules

**Rule 1: Layer Patterns**
```ruby
# Combine multiple patterns
UtilityBuilder.new
  .container(padded: true, bordered: true)  # Container pattern
  .flex(gap: 3)                             # Layout pattern
  .add(interactive_states)                  # State pattern
  .build
```

**Rule 2: Override with Specificity**
```ruby
# Component-specific overrides
base_classes = container_classes(padded: true)
specific_classes = "p-4" # Override padding
[base_classes, specific_classes].join(" ")
```

**Rule 3: Maintain Consistency**
```ruby
# Use constants for pattern variations
CONTAINER_SIZES = {
  sm: "p-4",
  md: "p-6",
  lg: "p-8"
}.freeze
```

### 3. Migration Path

**Phase 1: Extract Current Patterns**
1. Analyze existing DaisyUI components
2. Map to HyperUI equivalents
3. Document pattern differences

**Phase 2: Implement Pattern Helpers**
1. Create pattern modules
2. Implement UtilityBuilder
3. Add pattern testing helpers

**Phase 3: Migrate Components**
1. Start with simple components (Button, Badge)
2. Progress to complex components (Modal, Card)
3. Validate patterns in production

**Phase 4: Refine and Optimize**
1. Identify pattern duplications
2. Extract shared patterns
3. Performance optimization

### 4. Documentation Standards

**Pattern Documentation Template**:
```markdown
## Pattern Name

**Purpose**: Brief description

**HTML Structure**:
```html
<!-- Example structure -->
```

**Key Utilities**:
- utility-class: description

**Used In**: Component list

**Variations**:
```html
<!-- Variation examples -->
```

**Ruby Helper**:
```ruby
# Helper implementation
```
```

### 5. Quality Checklist

**For Each Pattern**:
- [ ] Documented with purpose and examples
- [ ] Ruby helper method implemented
- [ ] Used in at least 3 components (for cross-component patterns)
- [ ] Tested for accessibility
- [ ] Tested for responsiveness
- [ ] Variants documented
- [ ] Migration guide created

---

## Conclusion

### Pattern Summary

This document catalogs **14 major HTML patterns** extracted from HyperUI components:

**Core Structural** (3):
1. Container/Wrapper Pattern
2. Content-Image Pattern
3. Overlay Pattern

**Layout** (2):
4. Flexbox Alignment Pattern
5. Spacing Pattern

**Form Field** (2):
6. Label-Input Wrapper Pattern
7. Field Group Pattern

**Interactive** (2):
8. Dialog/Modal Pattern
9. Notification/Toast Pattern

**State Management** (1):
10. Hover/Focus/Active States Pattern

**Cross-Component** (4):
11. Inline-Flex Items-Center Gap Pattern
12. Rounded Border Background Padding Pattern
13. Text Size Font Weight Color Pattern
14. Focus Ring Pattern

### Implementation Benefits

1. **Consistency**: All components share common structural patterns
2. **Maintainability**: Pattern changes propagate automatically
3. **Developer Experience**: Predictable, documented patterns
4. **Accessibility**: Baked-in WCAG compliance
5. **Performance**: Optimized utility class generation

### Next Steps

1. **Implement Pattern Helpers**: Create Ruby modules for each pattern
2. **Build UtilityBuilder**: Implement utility class builder
3. **Migrate Components**: Apply patterns to existing components
4. **Test Thoroughly**: Visual regression, accessibility, responsive
5. **Document Migration**: Create before/after migration guides

---

**Document Version**: 1.0
**Last Updated**: 2025-11-19
**Status**: Complete
