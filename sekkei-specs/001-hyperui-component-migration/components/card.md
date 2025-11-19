# Card Component Migration Guide

**Component**: Card
**DaisyUI Baseline**: [DaisyUI Card](https://daisyui.com/components/card/)
**HyperUI Target**: [HyperUI Marketing Cards](https://www.hyperui.dev/components/marketing/cards)
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

The Card component is a versatile container element used throughout the application to group related content. It provides visual separation through borders and shadows, supports various layouts (vertical, horizontal, overlay), and can include images, titles, descriptions, and action buttons.

### Current DaisyUI Implementation

**Location**: `/lib/kumiki/components/card.rb`

DaisyUI uses semantic component classes with structured sections:
- Base class: `card`
- Section classes: `card-body`, `card-title`, `card-actions`
- Modifiers: `card-bordered`, `card-side`, `image-full`

**Philosophy**: Semantic, structured sections with predefined layouts.

### HyperUI Target

HyperUI provides 9 card variants composed of utility classes:
- Utility-first approach with explicit Tailwind classes
- Flexible layout using flexbox and grid
- Direct control over spacing, borders, shadows
- No semantic section classes

**Philosophy**: Utility composition for maximum layout flexibility.

### Migration Complexity Rating: Easy

**Justification**:
- Simple HTML structure (div container in both)
- No JavaScript required (unless implementing interactive cards)
- Clear mapping from semantic sections to utility layouts
- Well-documented HyperUI variants
- Straightforward content organization

---

## Variant Analysis

### DaisyUI Variants Available

#### Size Variants (5)

```html
<div class="card card-xs">Extra Small Card</div>
<div class="card card-sm">Small Card</div>
<div class="card card-md">Medium Card</div>
<div class="card card-lg">Large Card</div>
<div class="card card-xl">Extra Large Card</div>
```

#### Style Modifiers (5)

```html
<div class="card">Default (no border, shadow)</div>
<div class="card card-bordered">With Border</div>
<div class="card card-side">Horizontal Layout</div>
<div class="card image-full">Image Overlay</div>
<div class="card card-compact">Compact Padding</div>
```

#### Section Structure

```html
<div class="card">
  <figure><img src="..." /></figure>
  <div class="card-body">
    <h2 class="card-title">Title</h2>
    <p>Content</p>
    <div class="card-actions justify-end">
      <button class="btn">Action</button>
    </div>
  </div>
</div>
```

### HyperUI Variants Available

HyperUI provides 9 example cards with utility-based layouts:

#### Layout Variants

```html
<!-- Vertical Layout (Image Top) -->
<article class="overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="..." class="h-56 w-full object-cover" />
  <div class="p-6">
    <h3 class="text-lg font-semibold text-gray-900">Title</h3>
    <p class="mt-2 text-sm text-gray-600">Description</p>
  </div>
</article>

<!-- Horizontal Layout (Image Left) -->
<article class="flex overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="..." class="h-full w-48 object-cover" />
  <div class="flex flex-1 flex-col p-6">
    <h3 class="text-lg font-semibold text-gray-900">Title</h3>
    <p class="mt-2 text-sm text-gray-600">Description</p>
  </div>
</article>

<!-- Image Overlay -->
<article class="relative overflow-hidden rounded-lg">
  <img src="..." class="h-96 w-full object-cover" />
  <div class="absolute inset-0 bg-gradient-to-t from-black/75 to-transparent"></div>
  <div class="absolute bottom-0 left-0 right-0 p-6 text-white">
    <h3 class="text-2xl font-bold">Title</h3>
    <p class="mt-2 text-sm">Description</p>
  </div>
</article>
```

#### Size Variants (via padding)

```html
<!-- Compact -->
<div class="... p-4">Content</div>

<!-- Default -->
<div class="... p-6">Content</div>

<!-- Spacious -->
<div class="... p-8">Content</div>
```

#### Style Variants

```html
<!-- Bordered (default) -->
<div class="border border-gray-200 bg-white">...</div>

<!-- Shadow -->
<div class="border border-gray-200 bg-white shadow-sm">...</div>

<!-- Elevated Shadow -->
<div class="border border-gray-200 bg-white shadow-md">...</div>

<!-- No Border -->
<div class="bg-white shadow-sm">...</div>
```

### Variant Gaps

#### DaisyUI → HyperUI Gaps

1. **Size variants**: DaisyUI's `card-xs`, `card-sm`, etc. not in HyperUI
   - **Solution**: Map to padding variations (p-3, p-4, p-6, p-8, p-10)

2. **Card-side**: DaisyUI's `card-side` not explicitly named
   - **Solution**: Implement as `flex` layout with image on left

3. **Image-full**: DaisyUI's image overlay not in all examples
   - **Solution**: Use `relative` container with `absolute` positioned overlay

4. **Card-actions**: DaisyUI's semantic actions section
   - **Solution**: Use flex utilities for action button layout

#### HyperUI → DaisyUI Opportunities

1. **Hover Effects**: Rich interactive states with transitions
2. **Grid Layouts**: Multiple card layouts in grid
3. **Gradient Overlays**: More sophisticated image overlays
4. **Flexible Spacing**: More control over internal spacing

### Variant Mapping Table

| DaisyUI Variant | HyperUI Equivalent | Implementation |
|-----------------|-------------------|----------------|
| `card` | `overflow-hidden rounded-lg border border-gray-200 bg-white` | Direct mapping |
| `card-bordered` | `border border-gray-200` | Direct mapping |
| `card-side` | `flex` layout with image | Direct mapping |
| `image-full` | `relative` with `absolute` overlay | Custom implementation |
| `card-xs` | `p-3` | Direct mapping |
| `card-sm` | `p-4` | Direct mapping |
| `card-md` | `p-6` | Direct mapping |
| `card-lg` | `p-8` | Direct mapping |
| `card-xl` | `p-10` | Direct mapping |
| `card-compact` | `p-3` or `p-4` | Direct mapping |
| `card-title` | `text-lg font-semibold text-gray-900` | Direct mapping |
| `card-body` | `p-6` (or size variant) | Direct mapping |
| `card-actions` | `mt-4 flex gap-2 justify-end` | Direct mapping |

---

## HTML Structure Comparison

### Current DaisyUI Structure

```erb
<%= render Card.new(bordered: true, size: :md) do |card| %>
  <% card.with_image do %>
    <%= image_tag "photo.jpg", alt: "Photo" %>
  <% end %>

  <% card.with_body do %>
    <% card.with_title { "Card Title" } %>
    <p>Card content goes here</p>

    <% card.with_actions do %>
      <%= render Button.new(color: :primary) { "Action" } %>
    <% end %>
  <% end %>
<% end %>
```

**Generated HTML**:
```html
<div class="card card-bordered">
  <figure><img src="photo.jpg" alt="Photo" /></figure>
  <div class="card-body">
    <h2 class="card-title">Card Title</h2>
    <p>Card content goes here</p>
    <div class="card-actions justify-end">
      <button class="btn btn-primary">Action</button>
    </div>
  </div>
</div>
```

### HyperUI Target Structure

```html
<!-- Vertical Card -->
<article class="overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="photo.jpg" alt="Photo" class="h-56 w-full object-cover" />
  <div class="p-6">
    <h3 class="text-lg font-semibold text-gray-900">Card Title</h3>
    <p class="mt-2 text-sm text-gray-600">Card content goes here</p>
    <div class="mt-4 flex gap-2 justify-end">
      <button class="rounded bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700">
        Action
      </button>
    </div>
  </div>
</article>

<!-- Horizontal Card -->
<article class="flex overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="photo.jpg" alt="Photo" class="h-full w-48 object-cover" />
  <div class="flex flex-1 flex-col p-6">
    <h3 class="text-lg font-semibold text-gray-900">Card Title</h3>
    <p class="mt-2 flex-1 text-sm text-gray-600">Card content goes here</p>
    <div class="mt-4 flex gap-2 justify-end">
      <button class="rounded bg-blue-600 px-4 py-2 text-sm font-medium text-white hover:bg-blue-700">
        Action
      </button>
    </div>
  </div>
</article>

<!-- Image Overlay Card -->
<article class="relative overflow-hidden rounded-lg">
  <img src="photo.jpg" alt="Photo" class="h-96 w-full object-cover" />
  <div class="absolute inset-0 bg-gradient-to-t from-black/75 to-transparent"></div>
  <div class="absolute bottom-0 left-0 right-0 p-6 text-white">
    <h3 class="text-2xl font-bold">Card Title</h3>
    <p class="mt-2 text-sm">Card content goes here</p>
  </div>
</article>
```

### Key Structural Differences

1. **Container Element**: Both use container div, but HyperUI uses `<article>` for semantic HTML

2. **Image Handling**:
   - DaisyUI: `<figure>` wrapper with image
   - HyperUI: Direct `<img>` with explicit sizing classes

3. **Section Structure**:
   - DaisyUI: Semantic `card-body`, `card-title`, `card-actions` classes
   - HyperUI: Utility-based spacing and typography

4. **Layout Control**:
   - DaisyUI: `card-side` modifier for horizontal
   - HyperUI: `flex` utility for horizontal layout

5. **Overlay Pattern**:
   - DaisyUI: `image-full` class
   - HyperUI: `relative` + `absolute` positioning with gradient

---

## Accessibility Requirements

### ARIA Attributes Required

#### Standard Card (Presentational)
```html
<article class="...">
  <h3>Card Title</h3>
  <p>Card content</p>
</article>
```
**Note**: Presentational cards with proper heading hierarchy require no ARIA attributes.

#### Interactive Card (Clickable)
```html
<article class="...">
  <a href="/details" class="..." aria-label="View details for: Card Title">
    <h3>Card Title</h3>
    <p>Card content</p>
  </a>
</article>
```
- `aria-label`: Provides context for link when card contains multiple interactive elements

#### Card with Multiple Actions
```html
<article class="...">
  <h3>Card Title</h3>
  <p>Card content</p>
  <div role="group" aria-label="Card actions">
    <button aria-label="Edit Card Title">Edit</button>
    <button aria-label="Delete Card Title">Delete</button>
  </div>
</article>
```
- `role="group"`: Groups related action buttons
- `aria-label` on group: Provides context for actions
- `aria-label` on buttons: Provides context for each action

### Keyboard Navigation

**Required Keyboard Support** (for interactive cards):
- **Tab**: Move focus to card link or first interactive element
- **Shift+Tab**: Move focus to previous element
- **Enter**: Activate card link or focused button
- **Space**: Activate focused button

**Implementation Notes**:
- Non-interactive cards are not focusable
- Interactive cards should have one primary focusable link/button
- Multiple actions should be individually focusable

### Focus Management

**Focus Indicator Requirements** (WCAG 2.4.7):
- Interactive cards must have visible focus indicator
- Minimum 2px outline or ring
- 3:1 contrast ratio with background

**Implementation**:
```html
<a href="#" class="block focus:outline-none focus:ring-2 focus:ring-blue-500">
  <!-- Card content -->
</a>
```

### Screen Reader Considerations

1. **Heading Hierarchy**: Use proper heading levels (h2, h3, h4)
2. **Semantic HTML**: Use `<article>` for independent content units
3. **Image Alt Text**: Provide descriptive alt text for images
4. **Link Context**: Provide context when card is clickable (aria-label)

---

## JavaScript Requirements

### No JavaScript Required (Basic Cards)

Basic presentational cards require no JavaScript.

### Interactive Card Click Handling (Optional)

If entire card should be clickable:

```javascript
// app/javascript/controllers/card_click_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link"]

  click(event) {
    // If click is not on an interactive element, navigate to primary link
    if (!event.target.closest('a, button')) {
      this.linkTarget.click()
    }
  }
}
```

**Usage**:
```erb
<%= tag.article(
  class: "...",
  data: {
    controller: "card-click",
    action: "click->card-click#click"
  }
) do %>
  <h3>Card Title</h3>
  <p>Content</p>
  <a href="/details" data-card-click-target="link" class="...">View Details</a>
<% end %>
```

### Hover Effects (CSS Only)

```html
<article class="... transition-all hover:shadow-lg hover:border-gray-300">
  <!-- Card content -->
</article>
```

---

## HTML Patterns Used

### Pattern 1: Container Pattern (Rounded Border Background)

```html
<article class="overflow-hidden rounded-lg border border-gray-200 bg-white">
  <!-- Content -->
</article>
```

**Purpose**: Core card container with consistent styling.

**Key Utilities**:
- `overflow-hidden`: Prevents content from escaping rounded corners
- `rounded-lg`: Standard border radius
- `border border-gray-200`: Light border
- `bg-white`: White background

### Pattern 2: Content-Image Pattern (Vertical)

```html
<article class="overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="..." class="h-56 w-full object-cover" />
  <div class="p-6">
    <h3 class="text-lg font-semibold text-gray-900">Title</h3>
    <p class="mt-2 text-sm text-gray-600">Description</p>
  </div>
</article>
```

**Purpose**: Standard card layout with image above content.

**Key Utilities**:
- `h-56`: Fixed image height
- `w-full`: Full width image
- `object-cover`: Crop image to fit
- `p-6`: Content padding

### Pattern 3: Content-Image Pattern (Horizontal)

```html
<article class="flex overflow-hidden rounded-lg border border-gray-200 bg-white">
  <img src="..." class="h-full w-48 object-cover" />
  <div class="flex flex-1 flex-col p-6">
    <h3>Title</h3>
    <p class="flex-1">Description</p>
  </div>
</article>
```

**Purpose**: Side-by-side layout with image on left.

**Key Utilities**:
- `flex`: Enable flexbox layout
- `h-full w-48`: Fixed image width, full height
- `flex-1 flex-col`: Flexible content column
- `flex-1` on description: Push actions to bottom

### Pattern 4: Image Overlay Pattern

```html
<article class="relative overflow-hidden rounded-lg">
  <img src="..." class="h-96 w-full object-cover" />
  <div class="absolute inset-0 bg-gradient-to-t from-black/75 to-transparent"></div>
  <div class="absolute bottom-0 left-0 right-0 p-6 text-white">
    <h3>Title</h3>
  </div>
</article>
```

**Purpose**: Text overlaid on image with gradient backdrop.

**Key Utilities**:
- `relative`: Position context for overlay
- `absolute inset-0`: Full-area overlay
- `bg-gradient-to-t from-black/75`: Gradient from bottom
- `absolute bottom-0 left-0 right-0`: Position content at bottom

### Pattern 5: Spacing Pattern (Internal)

```html
<div class="p-6">
  <h3 class="text-lg font-semibold">Title</h3>
  <p class="mt-2 text-sm text-gray-600">Description</p>
  <div class="mt-4 flex gap-2">Actions</div>
</div>
```

**Purpose**: Consistent vertical spacing within card.

**Key Utilities**:
- `p-6`: Container padding
- `mt-2`: Small spacing after title
- `mt-4`: Medium spacing before actions
- `gap-2`: Spacing between action buttons

---

## Migration Guide

### Step 1: Update Component Class

**Before** (DaisyUI):
```ruby
# lib/kumiki/components/card.rb
class Card < Kumiki::Component
  option :bordered, default: -> { false }
  option :side, default: -> { false }
  option :size, default: -> { :md }

  def card_classes
    ["card", border_class, side_class, size_class].compact.join(" ")
  end

  private

  def border_class
    "card-bordered" if bordered
  end

  def side_class
    "card-side" if side
  end

  def size_class
    "card-#{size}" if size != :md
  end
end
```

**After** (HyperUI):
```ruby
# lib/kumiki/components/card.rb
class Card < Kumiki::Component
  option :layout, default: -> { :vertical }
  option :bordered, default: -> { true }
  option :shadow, default: -> { false }
  option :size, default: -> { :md }
  option :image_height, default: -> { :md }
  option :interactive, default: -> { false }

  def card_classes
    [
      base_classes,
      layout_classes,
      border_shadow_classes,
      interactive_classes
    ].compact.join(" ")
  end

  def content_classes
    size_classes
  end

  def image_classes
    case layout
    when :vertical
      "#{image_height_class} w-full object-cover"
    when :horizontal
      "h-full #{image_width_class} object-cover"
    when :overlay
      "#{image_height_class} w-full object-cover"
    end
  end

  private

  def base_classes
    "overflow-hidden rounded-lg bg-white"
  end

  def layout_classes
    case layout
    when :horizontal
      "flex"
    when :overlay
      "relative"
    else
      ""
    end
  end

  def border_shadow_classes
    classes = []
    classes << "border border-gray-200" if bordered
    classes << "shadow-sm" if shadow == :sm
    classes << "shadow-md" if shadow == :md
    classes << "shadow-lg" if shadow == :lg
    classes.join(" ")
  end

  def interactive_classes
    interactive ? "transition-all hover:shadow-lg hover:border-gray-300" : ""
  end

  def size_classes
    SIZES[size] || SIZES[:md]
  end

  def image_height_class
    IMAGE_HEIGHTS[image_height] || IMAGE_HEIGHTS[:md]
  end

  def image_width_class
    IMAGE_WIDTHS[image_height] || IMAGE_WIDTHS[:md]
  end

  SIZES = {
    xs: "p-3",
    sm: "p-4",
    md: "p-6",
    lg: "p-8",
    xl: "p-10"
  }.freeze

  IMAGE_HEIGHTS = {
    sm: "h-40",
    md: "h-56",
    lg: "h-96"
  }.freeze

  IMAGE_WIDTHS = {
    sm: "w-32",
    md: "w-48",
    lg: "w-64"
  }.freeze
end
```

### Step 2: Update Template

**Before** (DaisyUI):
```erb
<%= tag.div(class: card_classes) do %>
  <% if image %>
    <figure><%= image %></figure>
  <% end %>

  <div class="card-body">
    <% if title %>
      <h2 class="card-title"><%= title %></h2>
    <% end %>

    <%= content %>

    <% if actions %>
      <div class="card-actions justify-end">
        <%= actions %>
      </div>
    <% end %>
  </div>
<% end %>
```

**After** (HyperUI):
```erb
<%= tag.article(class: card_classes) do %>
  <% if layout == :vertical && image %>
    <%= tag.img(src: image, alt: image_alt, class: image_classes) %>
  <% end %>

  <% if layout == :horizontal %>
    <% if image %>
      <%= tag.img(src: image, alt: image_alt, class: image_classes) %>
    <% end %>
    <%= tag.div(class: "flex flex-1 flex-col #{content_classes}") do %>
      <%= render_card_content %>
    <% end %>
  <% elsif layout == :overlay %>
    <%= tag.img(src: image, alt: image_alt, class: image_classes) %>
    <%= tag.div(class: "absolute inset-0 bg-gradient-to-t from-black/75 to-transparent") %>
    <%= tag.div(class: "absolute bottom-0 left-0 right-0 #{content_classes} text-white") do %>
      <%= render_card_content %>
    <% end %>
  <% else %>
    <%= tag.div(class: content_classes) do %>
      <%= render_card_content %>
    <% end %>
  <% end %>
<% end %>

<% def render_card_content %>
  <% if title %>
    <%= tag.h3(title, class: title_classes) %>
  <% end %>

  <%= tag.div(class: "mt-2 text-sm text-gray-600") { content } %>

  <% if actions %>
    <%= tag.div(class: "mt-4 flex gap-2 justify-end") { actions } %>
  <% end %>
<% end %>

<% def title_classes %>
  case layout
  when :overlay
    "text-2xl font-bold"
  else
    "text-lg font-semibold text-gray-900"
  end
<% end %>
```

### Step 3: Update Usage Examples

**Before**:
```erb
<%= render Card.new(bordered: true, size: :md) do |card| %>
  <% card.with_image do %>
    <%= image_tag "photo.jpg" %>
  <% end %>

  <% card.with_body do %>
    <% card.with_title { "Card Title" } %>
    <p>Card content</p>

    <% card.with_actions do %>
      <%= render Button.new { "Action" } %>
    <% end %>
  <% end %>
<% end %>
```

**After** (API changed for flexibility):
```erb
<%= render Card.new(
  layout: :vertical,
  bordered: true,
  shadow: :sm,
  size: :md,
  image: "photo.jpg",
  image_alt: "Photo description",
  title: "Card Title"
) do %>
  <p>Card content</p>
<% end %>

<!-- With actions block -->
<%= render Card.new(...) do |card| %>
  <%= card.content { "Card content" } %>
  <%= card.actions do %>
    <%= render Button.new { "Action" } %>
  <% end %>
<% end %>
```

### API Changes

**Breaking Changes**:
- Removed `card-side` option, use `layout: :horizontal`
- Removed `image-full` option, use `layout: :overlay`
- Changed section slots to simpler content/actions pattern

**New Options Available**:
- `layout:` supports `:vertical`, `:horizontal`, `:overlay`
- `shadow:` supports `:sm`, `:md`, `:lg`
- `interactive:` adds hover effects
- `image_height:` controls image size

### Migration Steps

1. **Backup Current Implementation**: Copy existing card component files
2. **Update Component Class**: Replace class generation logic with HyperUI patterns
3. **Update Template**: Replace DaisyUI-specific markup with HyperUI patterns
4. **Update Usage**: Convert all card instances to new API
5. **Test Visually**: Verify all layouts render correctly
6. **Test Accessibility**: Verify heading hierarchy, keyboard navigation
7. **Update Storybook**: Update component stories with new variants
8. **Deploy**: Release new card component

---

## Testing Considerations

### Visual Regression Testing

**Key Test Scenarios**:
1. **Vertical Layout**: Image top, content below
2. **Horizontal Layout**: Image left, content right
3. **Overlay Layout**: Text overlaid on image
4. **No Image**: Text-only card
5. **All Size Variants**: xs, sm, md, lg, xl padding
6. **Border/Shadow Combinations**: bordered + shadow variations
7. **Interactive State**: Hover effects
8. **Responsive**: Mobile, tablet, desktop layouts

**Screenshot Comparison**:
- Capture before (DaisyUI) and after (HyperUI) screenshots
- Compare layouts and spacing
- Note intentional design differences

### Accessibility Testing

**Automated Tests** (axe-core):
```javascript
describe('Card accessibility', () => {
  it('passes axe accessibility checks', async () => {
    const html = renderCard({ title: 'Card Title' }, 'Content')
    const results = await axe(html)
    expect(results.violations).toHaveLength(0)
  })

  it('has proper heading hierarchy', async () => {
    const html = renderCard({ title: 'Card Title' })
    expect(html).toContain('<h3')
  })

  it('interactive card has accessible link', async () => {
    const html = renderCard({ interactive: true, title: 'Card' })
    expect(html).toContain('aria-label')
  })
})
```

**Manual Tests**:
1. **Keyboard Navigation**:
   - Tab to interactive cards, verify focus indicator visible
   - Tab through multiple action buttons in order
   - Press Enter on card link, verify navigation

2. **Screen Reader Testing** (VoiceOver, NVDA, JAWS):
   - Card heading announces at proper level
   - Image alt text announced
   - Interactive card announces as link/button
   - Multiple actions announced individually

3. **Heading Hierarchy**:
   - Use heading order inspector
   - Verify h2 → h3 → h4 progression

### Functional Testing

**RSpec Component Tests**:
```ruby
RSpec.describe Card, type: :component do
  describe "rendering" do
    it "renders vertical layout" do
      result = render_inline(Card.new(
        layout: :vertical,
        image: "photo.jpg",
        title: "Title"
      )) { "Content" }

      expect(result.css("article").to_html).to include("overflow-hidden")
      expect(result.css("img").attr("src").value).to eq("photo.jpg")
      expect(result.css("h3").text).to eq("Title")
    end

    it "renders horizontal layout" do
      result = render_inline(Card.new(layout: :horizontal, image: "photo.jpg"))
      expect(result.css("article").attr("class")).to include("flex")
    end

    it "renders overlay layout" do
      result = render_inline(Card.new(layout: :overlay, image: "photo.jpg"))
      expect(result.css("article").attr("class")).to include("relative")
      expect(result.css("div.absolute.inset-0").count).to eq(1)
    end

    it "applies size padding" do
      result = render_inline(Card.new(size: :lg))
      expect(result.css("div.p-8").count).to be >= 1
    end

    it "applies border and shadow" do
      result = render_inline(Card.new(bordered: true, shadow: :sm))
      expect(result.css("article").attr("class")).to include("border")
      expect(result.css("article").attr("class")).to include("shadow-sm")
    end
  end
end
```

### Edge Cases to Verify

1. **Long Titles**: Verify text wrapping and truncation
2. **No Image**: Verify layout without image
3. **Multiple Actions**: Verify spacing and alignment
4. **Responsive Images**: Verify image aspect ratio on different screens
5. **Overlay Text Contrast**: Verify text readable on images
6. **Empty Content**: Verify card with only title or only image

---

## Implementation Checklist

### Development

- [ ] Create SIZES constant with all size variants (5 sizes)
- [ ] Create IMAGE_HEIGHTS constant for image sizing (3 sizes)
- [ ] Create IMAGE_WIDTHS constant for horizontal layout (3 sizes)
- [ ] Implement base_classes method
- [ ] Implement layout_classes method
- [ ] Implement border_shadow_classes method
- [ ] Implement interactive_classes method
- [ ] Update template with vertical layout
- [ ] Update template with horizontal layout
- [ ] Update template with overlay layout
- [ ] Add image handling with sizing classes
- [ ] Add title rendering with proper heading level
- [ ] Add actions section with flex layout

### Testing

- [ ] Write unit tests for vertical layout
- [ ] Write unit tests for horizontal layout
- [ ] Write unit tests for overlay layout
- [ ] Write unit tests for size variants
- [ ] Write unit tests for border/shadow combinations
- [ ] Write unit tests for interactive state
- [ ] Write accessibility tests (axe-core)
- [ ] Perform manual keyboard navigation testing
- [ ] Perform manual screen reader testing
- [ ] Verify heading hierarchy
- [ ] Capture visual regression screenshots

### Documentation

- [ ] Update component README with new API
- [ ] Add Storybook stories for all layouts
- [ ] Document breaking changes
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
