# Phase 1: Core Component Migration

> **Duration:** 4-6 weeks
> **Goal:** Migrate all 13 existing components from DaisyUI to HyperUI
> **Prerequisites:** Phase 0 complete
> **Deliverables:** 13 migrated components, updated form builder, helper methods

---

## Overview

Phase 1 is where we migrate all existing Kumiki components from DaisyUI to HyperUI. This phase establishes the patterns that will be used in Phases 2 and 3.

**Migration Order:**
1. **UI Primitives** (Button, Badge, Card) - Stateless components to establish patterns
2. **Interactive Components** (Modal, Toast) - Components with JavaScript behavior
3. **Form Components** (Inputs, Select, Textarea, Checkbox, Radio, File, Date, Error) - Complex form integration
4. **Form Builder** - Update to use new component APIs
5. **Helper Methods** - Update and standardize

**Key Success Criteria:**
- ✅ All 13 components migrated with HyperUI styling
- ✅ Form builder works with new components
- ✅ All tests passing
- ✅ Preview system showcasing all variants
- ✅ **All components reviewed and approved in preview system before acceptance**

**Design Review Process:**
Each component has a preview ticket that includes design review as an acceptance criterion. No component is considered "done" until:
1. Preview page created showing all variants, sizes, and states
2. Component reviewed in preview system (visual design, responsiveness, accessibility)
3. Component approved and matches HyperUI design intent

---

## Epic 1.1: UI Primitives (Week 1-2)

**Objective:** Migrate stateless, non-interactive components first to establish patterns

---

### Component: Button

**Current State:** Uses DaisyUI classes (`btn`, `btn-primary`, `btn-lg`, etc.)
**Target State:** HyperUI-styled button with new variant system

#### [BTN-001] Research HyperUI button variants and extract HTML patterns

**Estimate:** 0.5 days
**Priority:** High

**Description:**
Browse HyperUI button examples, screenshot variants, and document HTML structure.

**Acceptance Criteria:**
- [ ] All HyperUI button variants identified and documented
- [ ] HTML structure documented
- [ ] Class patterns extracted
- [ ] Hover/focus/active states documented
- [ ] Accessibility attributes noted

**HyperUI Reference:** https://www.hyperui.dev/components/marketing/buttons

**Deliverable:** Notes in `docs/components/BUTTON_ANALYSIS.md`

---

#### [BTN-002] Design new button component API (props, variants, sizes)

**Estimate:** 1 day
**Priority:** High
**Depends on:** [BTN-001]

**Description:**
Design the new Button component API following the guidelines from Phase 0.

**Acceptance Criteria:**
- [ ] API designed and documented
- [ ] Props defined (text, variant, color, size, loading, disabled, icon_left, icon_right)
- [ ] Variants defined (solid, outline, ghost, gradient, link)
- [ ] Colors defined (primary, secondary, success, error, warning, info, neutral)
- [ ] Sizes defined (xs, sm, md, lg, xl)
- [ ] Default values specified
- [ ] Examples written

**Proposed API:**
```ruby
button(
  text: "Save Changes",
  variant: :solid,        # :solid, :outline, :ghost, :gradient, :link
  color: :primary,        # :primary, :secondary, :success, :error, :warning, :info, :neutral
  size: :md,              # :xs, :sm, :md, :lg, :xl
  loading: false,         # boolean
  disabled: false,        # boolean
  icon_left: nil,         # icon name or HTML
  icon_right: nil,        # icon name or HTML
  type: :button,          # :button, :submit, :reset
  class: nil,             # additional CSS classes
  **html_options          # id, data attributes, etc.
)
```

**Deliverable:** API documented in ticket or component doc

---

#### [BTN-003] Implement `Kumiki::Components::Button` class with variant composition

**Estimate:** 2 days
**Priority:** High
**Depends on:** [BTN-002]

**Description:**
Implement the Button component class with variant, color, and size logic.

**Acceptance Criteria:**
- [ ] Component class created
- [ ] Inherits from `BaseComponent`
- [ ] Variant composition logic implemented
- [ ] Color application logic implemented
- [ ] Size logic implemented
- [ ] State handling (loading, disabled) implemented
- [ ] Icon positioning logic implemented
- [ ] Class building method works correctly

**Implementation Location:** `app/components/kumiki/components/button.rb`

**Example Implementation:**
```ruby
module Kumiki
  module Components
    class Button < BaseComponent
      def initialize(text: nil, variant: :solid, color: :primary, size: :md,
                     loading: false, disabled: false, icon_left: nil, icon_right: nil,
                     type: :button, **options)
        @text = text
        @variant = variant
        @color = color
        @size = size
        @loading = loading
        @disabled = disabled
        @icon_left = icon_left
        @icon_right = icon_right
        @type = type
        super(**options)
      end

      private

      def button_classes
        build_classes(
          base_classes,
          variant_classes,
          size_classes,
          state_classes
        )
      end

      def base_classes
        %w[inline-flex items-center justify-center font-medium transition-colors
           focus:outline-none focus:ring-2 focus:ring-offset-2]
      end

      def variant_classes
        case @variant
        when :solid
          solid_variant_classes
        when :outline
          outline_variant_classes
        when :ghost
          ghost_variant_classes
        when :gradient
          gradient_variant_classes
        when :link
          link_variant_classes
        end
      end

      def solid_variant_classes
        case @color
        when :primary
          %w[bg-primary-600 text-white hover:bg-primary-700 focus:ring-primary-500]
        when :secondary
          %w[bg-secondary-600 text-white hover:bg-secondary-700 focus:ring-secondary-500]
        # ... more colors
        end
      end

      def outline_variant_classes
        case @color
        when :primary
          %w[border-2 border-primary-600 text-primary-600 hover:bg-primary-50 focus:ring-primary-500]
        # ... more colors
        end
      end

      # ... more variant methods

      def size_classes
        case @size
        when :xs
          %w[h-8 px-2 text-xs rounded]
        when :sm
          %w[h-9 px-3 text-sm rounded-md]
        when :md
          %w[h-10 px-4 text-base rounded-md]
        when :lg
          %w[h-11 px-6 text-lg rounded-lg]
        when :xl
          %w[h-12 px-8 text-xl rounded-lg]
        end
      end

      def state_classes
        classes = []
        classes << %w[opacity-50 cursor-not-allowed] if @disabled
        classes << %w[relative] if @loading
        classes
      end
    end
  end
end
```

**Deliverable:** `app/components/kumiki/components/button.rb`

---

#### [BTN-004] Create `button.html.erb` template with HyperUI structure

**Estimate:** 1 day
**Priority:** High
**Depends on:** [BTN-003]

**Description:**
Create the ERB template for rendering the button with icons and loading state.

**Acceptance Criteria:**
- [ ] Template created
- [ ] Icon rendering (left and right) implemented
- [ ] Loading spinner implemented
- [ ] Text rendering
- [ ] Accessibility attributes included
- [ ] Handles block content (alternative to text prop)

**Implementation Location:** `app/views/kumiki/components/button.html.erb`

**Example Template:**
```erb
<button
  type="<%= @type %>"
  class="<%= button_classes %>"
  <%= "disabled" if @disabled || @loading %>
  <%= html_attributes %>
>
  <% if @loading %>
    <span class="absolute inset-0 flex items-center justify-center">
      <%= render_spinner %>
    </span>
    <span class="opacity-0">
  <% end %>

  <%= render_icon(@icon_left) if @icon_left %>

  <% if @text %>
    <span><%= @text %></span>
  <% elsif content? %>
    <%= content %>
  <% end %>

  <%= render_icon(@icon_right) if @icon_right %>

  <% if @loading %>
    </span>
  <% end %>
</button>
```

**Deliverable:** `app/views/kumiki/components/button.html.erb`

---

#### [BTN-005] Implement loading state with custom spinner (DaisyUI replacement)

**Estimate:** 1 day
**Priority:** Medium
**Depends on:** [BTN-004]

**Description:**
Create a custom loading spinner since DaisyUI's `loading` class won't exist.

**Acceptance Criteria:**
- [ ] Spinner SVG or CSS animation created
- [ ] Spinner matches button size
- [ ] Spinner color matches button variant
- [ ] Smooth animation
- [ ] Button remains clickable area (no layout shift)

**Implementation Options:**

**Option 1: SVG Spinner**
```erb
<svg class="animate-spin h-5 w-5" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
</svg>
```

**Option 2: CSS Spinner**
```css
@keyframes spin {
  to { transform: rotate(360deg); }
}
.spinner {
  border: 2px solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spin 0.75s linear infinite;
}
```

**Deliverable:** Spinner implementation in template or partial

---

#### [BTN-006] Implement icon support (left/right positioning)

**Estimate:** 0.5 days
**Priority:** Medium
**Depends on:** [BTN-004]

**Description:**
Add support for icons on left or right side of button text.

**Acceptance Criteria:**
- [ ] Icons render on left side when `icon_left` provided
- [ ] Icons render on right side when `icon_right` provided
- [ ] Proper spacing between icon and text
- [ ] Icons scale with button size
- [ ] Supports icon-only buttons (no text)

**Implementation Notes:**
- Use `gap-2` for spacing between icon and text
- Icon size should match text size (relative to button size)
- Support both SVG strings and icon component references

**Deliverable:** Icon rendering in template

---

#### [BTN-007] Write comprehensive RSpec tests for all variants

**Estimate:** 2 days
**Priority:** High
**Depends on:** [BTN-003], [BTN-004]

**Description:**
Write thorough tests covering all button variants, sizes, colors, and states.

**Acceptance Criteria:**
- [ ] Tests for all variants (solid, outline, ghost, gradient, link)
- [ ] Tests for all colors (primary, secondary, success, error, warning, info, neutral)
- [ ] Tests for all sizes (xs, sm, md, lg, xl)
- [ ] Tests for loading state
- [ ] Tests for disabled state
- [ ] Tests for icon rendering (left, right, both, none)
- [ ] Tests for custom HTML attributes
- [ ] 100% code coverage for Button component

**Implementation Location:** `spec/components/kumiki/components/button_spec.rb`

**Example Tests:**
```ruby
RSpec.describe Kumiki::Components::Button do
  describe "variants" do
    it "renders solid variant with primary color" do
      component = described_class.new(text: "Save", variant: :solid, color: :primary)
      expect(component.button_classes).to include("bg-primary-600", "text-white")
    end

    it "renders outline variant with secondary color" do
      component = described_class.new(text: "Cancel", variant: :outline, color: :secondary)
      expect(component.button_classes).to include("border-2", "border-secondary-600")
    end
  end

  describe "sizes" do
    it "renders xs size" do
      component = described_class.new(text: "Small", size: :xs)
      expect(component.button_classes).to include("h-8", "px-2", "text-xs")
    end
  end

  describe "states" do
    it "renders disabled state" do
      component = described_class.new(text: "Disabled", disabled: true)
      expect(component.button_classes).to include("opacity-50", "cursor-not-allowed")
    end

    it "renders loading state" do
      component = described_class.new(text: "Loading", loading: true)
      render_inline(component)
      expect(page).to have_css(".spinner, svg.animate-spin")
    end
  end

  describe "icons" do
    it "renders left icon" do
      component = described_class.new(text: "Save", icon_left: "<svg>...</svg>")
      render_inline(component)
      expect(page).to have_css("svg + span")
    end
  end
end
```

**Deliverable:** `spec/components/kumiki/components/button_spec.rb`

---

#### [BTN-008] Create preview page and complete design review

**Estimate:** 1 day
**Priority:** High
**Depends on:** [BTN-007]

**Description:**
Create a comprehensive preview page showing all button variants, sizes, and states. Component must be reviewed and approved in the preview system before being considered complete.

**Acceptance Criteria:**
- [ ] Preview page accessible at `/kumiki/design/preview/button`
- [ ] All variants displayed
- [ ] All sizes displayed
- [ ] All colors displayed
- [ ] All states displayed (normal, hover, disabled, loading)
- [ ] Code snippets shown for each example
- [ ] Preview is visually organized and easy to navigate
- [ ] **Design review completed and approved** (component matches HyperUI design, responsive, accessible)

**Implementation Location:** Preview controller/views

**Deliverable:** Button preview page + approved design review

---

#### [BTN-009] Update `button` helper method

**Estimate:** 0.5 days
**Priority:** High
**Depends on:** [BTN-003]

**Description:**
Update the `button` helper method in `component_helper.rb` to use the new Button component.

**Acceptance Criteria:**
- [ ] Helper method updated
- [ ] Method signature matches new API
- [ ] Backward compatibility considered (deprecation warning if needed)
- [ ] Documentation updated

**Implementation Location:** `app/helpers/kumiki/component_helper.rb`

**Example:**
```ruby
def button(text = nil, variant: :solid, color: :primary, size: :md, **options, &block)
  component = Kumiki::Components::Button.new(
    text: text,
    variant: variant,
    color: color,
    size: size,
    **options
  )
  render(component, &block)
end
```

**Deliverable:** Updated helper method

---

### Component: Badge

**Current State:** Uses DaisyUI classes (`badge`, `badge-primary`, `badge-lg`, etc.)
**Target State:** HyperUI-styled badge with new variant system

#### [BADGE-001] Research HyperUI badge variants and extract patterns

**Estimate:** 0.5 days
**Priority:** High

**Description:**
Browse HyperUI badge examples and document patterns.

**Acceptance Criteria:**
- [ ] All HyperUI badge variants identified
- [ ] HTML structure documented
- [ ] Class patterns extracted
- [ ] Icon placement patterns noted

**HyperUI Reference:** https://www.hyperui.dev/components/application-ui/badges

**Deliverable:** Notes in `docs/components/BADGE_ANALYSIS.md`

---

#### [BADGE-002] Design badge component API

**Estimate:** 0.5 days
**Priority:** High
**Depends on:** [BADGE-001]

**Description:**
Design the new Badge component API.

**Proposed API:**
```ruby
badge(
  text: "New",
  variant: :solid,        # :solid, :outline, :soft, :pill
  color: :primary,        # :primary, :secondary, :success, :error, :warning, :info, :neutral
  size: :md,              # :xs, :sm, :md, :lg
  icon_left: nil,
  icon_right: nil,
  class: nil,
  **html_options
)
```

**Deliverable:** API documented

---

#### [BADGE-003] Implement `Kumiki::Components::Badge` class

**Estimate:** 1 day
**Priority:** High
**Depends on:** [BADGE-002]

**Implementation Location:** `app/components/kumiki/components/badge.rb`

**Deliverable:** Badge component class

---

#### [BADGE-004] Create `badge.html.erb` template

**Estimate:** 0.5 days
**Priority:** High
**Depends on:** [BADGE-003]

**Implementation Location:** `app/views/kumiki/components/badge.html.erb`

**Deliverable:** Badge template

---

#### [BADGE-005] Implement icon decoration support (left/right icons)

**Estimate:** 0.5 days
**Priority:** Low
**Depends on:** [BADGE-004]

**Deliverable:** Icon support in badge

---

#### [BADGE-006] Write RSpec tests

**Estimate:** 1 day
**Priority:** High
**Depends on:** [BADGE-004]

**Implementation Location:** `spec/components/kumiki/components/badge_spec.rb`

**Deliverable:** Badge tests

---

#### [BADGE-007] Update preview system

**Estimate:** 0.5 days
**Priority:** Medium
**Depends on:** [BADGE-006]

**Deliverable:** Badge preview page

---

#### [BADGE-008] Update `badge` helper method

**Estimate:** 0.5 days
**Priority:** High
**Depends on:** [BADGE-003]

**Implementation Location:** `app/helpers/kumiki/component_helper.rb`

**Deliverable:** Updated helper method

---

### Component: Card

**Current State:** Uses DaisyUI classes (`card`, `card-bordered`, etc.)
**Target State:** HyperUI-styled card with slot-based composition

#### [CARD-001] Research HyperUI card layouts and extract patterns

**Estimate:** 0.5 days
**Priority:** High

**HyperUI Reference:** https://www.hyperui.dev/components/marketing/cards

**Deliverable:** Notes in `docs/components/CARD_ANALYSIS.md`

---

#### [CARD-002] Design card component API with slot support

**Estimate:** 1 day
**Priority:** High
**Depends on:** [CARD-001]

**Proposed API:**
```ruby
card(bordered: true, shadow: :md, class: nil, **html_options) do |c|
  c.header { "Card Title" }
  c.body { "Card content..." }
  c.footer { "Card actions..." }
end
```

**Deliverable:** API documented

---

#### [CARD-003] Implement `Kumiki::Components::Card` class

**Estimate:** 2 days
**Priority:** High
**Depends on:** [CARD-002]

**Implementation Notes:**
- Implement slot pattern (header, body, footer)
- Handle optional slots (can render card without header or footer)

**Implementation Location:** `app/components/kumiki/components/card.rb`

**Deliverable:** Card component class

---

#### [CARD-004] Create `card.html.erb` template with header/body/footer slots

**Estimate:** 1 day
**Priority:** High
**Depends on:** [CARD-003]

**Implementation Location:** `app/views/kumiki/components/card.html.erb`

**Deliverable:** Card template

---

#### [CARD-005] Implement border and shadow variants

**Estimate:** 0.5 days
**Priority:** Medium
**Depends on:** [CARD-003]

**Deliverable:** Border and shadow logic

---

#### [CARD-006] Write RSpec tests including slot rendering

**Estimate:** 2 days
**Priority:** High
**Depends on:** [CARD-004]

**Implementation Location:** `spec/components/kumiki/components/card_spec.rb`

**Deliverable:** Card tests

---

#### [CARD-007] Update preview system with diverse card examples

**Estimate:** 1 day
**Priority:** Medium
**Depends on:** [CARD-006]

**Deliverable:** Card preview page

---

#### [CARD-008] Update `card` helper method

**Estimate:** 0.5 days
**Priority:** High
**Depends on:** [CARD-003]

**Implementation Location:** `app/helpers/kumiki/component_helper.rb`

**Deliverable:** Updated helper method

---

## Epic 1.2: Interactive Components (Week 2-3)

**Objective:** Migrate components with JavaScript behavior

---

### Component: Modal

**Current State:** Uses DaisyUI modal with `<dialog>` element and Stimulus
**Target State:** HyperUI-styled modal with updated Stimulus controller

#### [MODAL-001] Research HyperUI modal patterns and JavaScript requirements

**Estimate:** 1 day
**Priority:** High

**HyperUI Reference:** https://www.hyperui.dev/components/application-ui/modals

**Deliverable:** Notes in `docs/components/MODAL_ANALYSIS.md`

---

#### [MODAL-002] Design modal component API

**Estimate:** 1 day
**Priority:** High
**Depends on:** [MODAL-001]

**Proposed API:**
```ruby
modal(
  id: "my-modal",
  title: "Confirm Action",
  size: :md,              # :sm, :md, :lg, :xl, :fullscreen
  backdrop: :dark,        # :dark, :light, :blur
  closeable: true,
  class: nil,
  **html_options
) do |m|
  m.header { "Custom header content" }  # optional, overrides title
  m.body { "Modal content..." }
  m.footer { "Modal actions..." }
end
```

**Deliverable:** API documented

---

#### [MODAL-003] Implement `Kumiki::Components::Modal` class

**Estimate:** 2 days
**Priority:** High
**Depends on:** [MODAL-002]

**Implementation Location:** `app/components/kumiki/components/modal.rb`

**Deliverable:** Modal component class

---

#### [MODAL-004] Create `modal.html.erb` template with HyperUI structure

**Estimate:** 1 day
**Priority:** High
**Depends on:** [MODAL-003]

**Implementation Location:** `app/views/kumiki/components/modal.html.erb`

**Deliverable:** Modal template

---

#### [MODAL-005] Update or create Stimulus controller for modal behavior

**Estimate:** 2 days
**Priority:** High
**Depends on:** [MODAL-004]

**Description:**
Update the existing `dismiss_controller.js` or create a new `modal_controller.js` for modal-specific behavior.

**Acceptance Criteria:**
- [ ] Open/close modal functionality
- [ ] ESC key closes modal
- [ ] Click outside closes modal (if closeable)
- [ ] Focus trap when modal is open
- [ ] Return focus to trigger element when closed
- [ ] Prevent body scroll when modal is open

**Implementation Location:** `app/javascript/kumiki/controllers/modal_controller.js`

**Deliverable:** Stimulus controller

---

#### [MODAL-006] Implement backdrop (overlay) variants

**Estimate:** 1 day
**Priority:** Medium
**Depends on:** [MODAL-004]

**Deliverable:** Backdrop styling

---

#### [MODAL-007] Implement size variants (sm, md, lg, xl, fullscreen)

**Estimate:** 1 day
**Priority:** Medium
**Depends on:** [MODAL-003]

**Deliverable:** Size logic

---

#### [MODAL-008] Implement accessibility (focus trap, ESC key, ARIA)

**Estimate:** 2 days
**Priority:** High
**Depends on:** [MODAL-005]

**Acceptance Criteria:**
- [ ] `role="dialog"`
- [ ] `aria-modal="true"`
- [ ] `aria-labelledby` pointing to title
- [ ] Focus trap implemented
- [ ] ESC key closes modal
- [ ] Accessible close button

**Deliverable:** Accessibility features

---

#### [MODAL-009] Write RSpec tests + Stimulus controller tests

**Estimate:** 2 days
**Priority:** High
**Depends on:** [MODAL-008]

**Implementation Location:** `spec/components/kumiki/components/modal_spec.rb`

**Deliverable:** Modal tests

---

#### [MODAL-010] Update preview with interactive modal examples

**Estimate:** 1 day
**Priority:** Medium
**Depends on:** [MODAL-009]

**Deliverable:** Modal preview page

---

#### [MODAL-011] Update `modal` helper method

**Estimate:** 0.5 days
**Priority:** High
**Depends on:** [MODAL-003]

**Implementation Location:** `app/helpers/kumiki/component_helper.rb`

**Deliverable:** Updated helper method

---

### Component: Toast

**Current State:** Uses custom toast with auto-dismiss Stimulus controller
**Target State:** HyperUI-styled toast with positioning system

#### [TOAST-001] Research HyperUI toast/alert patterns

**Estimate:** 1 day
**Priority:** High

**HyperUI Reference:** https://www.hyperui.dev/components/application-ui/toasts

**Deliverable:** Notes in `docs/components/TOAST_ANALYSIS.md`

---

#### [TOAST-002] Design toast component API with positioning

**Estimate:** 1 day
**Priority:** High
**Depends on:** [TOAST-001]

**Proposed API:**
```ruby
toast(
  message: "Changes saved!",
  type: :success,         # :success, :error, :warning, :info, :notice
  position: :top_right,   # :top_left, :top_right, :top_center, :bottom_left, :bottom_right, :bottom_center
  title: nil,
  dismissible: true,
  auto_dismiss_delay: 5000,
  icon: true,
  class: nil,
  **html_options
)
```

**Deliverable:** API documented

---

#### [TOAST-003] Implement `Kumiki::Components::Toast` class

**Estimate:** 2 days
**Priority:** High
**Depends on:** [TOAST-002]

**Implementation Location:** `app/components/kumiki/components/toast.rb`

**Deliverable:** Toast component class

---

#### [TOAST-004] Create `toast.html.erb` template with HyperUI structure

**Estimate:** 1 day
**Priority:** High
**Depends on:** [TOAST-003]

**Implementation Location:** `app/views/kumiki/components/toast.html.erb`

**Deliverable:** Toast template

---

#### [TOAST-005] Rebuild auto-dismiss Stimulus controller

**Estimate:** 1 day
**Priority:** High
**Depends on:** [TOAST-004]

**Implementation Location:** `app/javascript/kumiki/controllers/auto_dismiss_controller.js`

**Deliverable:** Updated auto-dismiss controller

---

#### [TOAST-006] Implement positioning system (6 positions)

**Estimate:** 2 days
**Priority:** High
**Depends on:** [TOAST-003]

**Acceptance Criteria:**
- [ ] Top-left positioning
- [ ] Top-right positioning
- [ ] Top-center positioning
- [ ] Bottom-left positioning
- [ ] Bottom-right positioning
- [ ] Bottom-center positioning
- [ ] Toast container manages multiple toasts at same position

**Deliverable:** Positioning logic

---

#### [TOAST-007] Implement slide/fade animations

**Estimate:** 1 day
**Priority:** Medium
**Depends on:** [TOAST-004]

**Deliverable:** Animation CSS

---

#### [TOAST-008] Implement stacking for multiple toasts

**Estimate:** 2 days
**Priority:** Medium
**Depends on:** [TOAST-006]

**Description:**
Handle multiple toasts appearing at the same position (stack vertically with spacing).

**Deliverable:** Toast stacking logic

---

#### [TOAST-009] Write RSpec tests + Stimulus controller tests

**Estimate:** 2 days
**Priority:** High
**Depends on:** [TOAST-008]

**Implementation Location:** `spec/components/kumiki/components/toast_spec.rb`

**Deliverable:** Toast tests

---

#### [TOAST-010] Update preview with toast examples in all positions

**Estimate:** 1 day
**Priority:** Medium
**Depends on:** [TOAST-009]

**Deliverable:** Toast preview page

---

#### [TOAST-011] Update `toast` helper method

**Estimate:** 0.5 days
**Priority:** High
**Depends on:** [TOAST-003]

**Implementation Location:** `app/helpers/kumiki/component_helper.rb`

**Deliverable:** Updated helper method

---

## Epic 1.3: Form Components - Inputs (Week 3-4)

**Objective:** Migrate text-based form inputs

**Note:** Due to length, form component tickets follow the same pattern as above. Each component has 8-13 tickets covering research, design, implementation, testing, and preview.

### Components in this Epic:
- FormInput (text, email, password, number, date, time, etc.)
- FormTextarea
- FormSelect

**Total Tickets:** ~35 tickets

See main migration plan document for full ticket breakdown.

---

## Epic 1.4: Form Components - Choices (Week 4-5)

**Objective:** Migrate checkbox, radio, and file inputs

### Components in this Epic:
- FormCheckbox
- FormRadio
- FormFileInput
- FormDatePicker
- FormError

**Total Tickets:** ~40 tickets

See main migration plan document for full ticket breakdown.

---

## Epic 1.5: Form Builder Rebuild (Week 5-6)

**Objective:** Update form builder to use new component APIs

### [BUILDER-001] Update `ApplicationFormBuilder` to delegate to new component APIs

**Estimate:** 2 days
**Priority:** High
**Depends on:** All form component tickets

**Description:**
Update the form builder to use the new HyperUI-based form components.

**Implementation Location:** `app/form_builders/kumiki/application_form_builder.rb`

**Deliverable:** Updated form builder

---

### [BUILDER-002] through [BUILDER-013]

Additional tickets for updating each form field method (text_field, email_field, select, check_box, etc.) and comprehensive integration testing.

See main migration plan document for full ticket breakdown.

---

## Epic 1.6: Helper Methods & API (Week 6)

**Objective:** Update component helper methods and ensure API consistency

### [HELPER-001] Update `component_helper.rb` with all new method signatures

**Estimate:** 2 days
**Priority:** High

**Implementation Location:** `app/helpers/kumiki/component_helper.rb`

**Deliverable:** Updated helper file

---

### [HELPER-002] through [HELPER-005]

Additional tickets for deprecation warnings, documentation, testing, and API consistency validation.

See main migration plan document for full ticket breakdown.

---

## Phase 1 Success Checklist

Before moving to Phase 2, ensure:

- [ ] All 13 components migrated and tested
- [ ] Form builder working with new components
- [ ] All RSpec tests passing (100% coverage)
- [ ] Preview system showcasing all components
- [ ] Helper methods updated and documented
- [ ] No DaisyUI classes remain in component code
- [ ] Stimulus controllers working for interactive components
- [ ] Accessibility audit passed for all components
- [ ] Documentation updated

---

## Phase 1 Timeline

**Week 1:** Epic 1.1 - UI Primitives (Button, Badge, Card)
**Week 2:** Epic 1.2 - Interactive Components (Modal, Toast)
**Week 3-4:** Epic 1.3 - Form Components Inputs (FormInput, FormTextarea, FormSelect)
**Week 4-5:** Epic 1.4 - Form Components Choices (FormCheckbox, FormRadio, FormFile, FormDate, FormError)
**Week 5-6:** Epic 1.5 - Form Builder Rebuild
**Week 6:** Epic 1.6 - Helper Methods & API

**Total:** 4-6 weeks

---

## Next Phase

Once Phase 1 is complete, proceed to **Phase 2: New HyperUI Components - Application UI** where we'll add ~35 new application UI components.

📄 See: `docs/migration/PHASE_2_APPLICATION_UI.md`
