# Migration Guide: DaisyUI to HyperUI Component Migration

**Document Version**: 1.0
**Created**: 2025-11-19
**Status**: Strategic Planning Document
**Target**: Kumiki Rails v0.2.0

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Migration Strategy](#migration-strategy)
3. [Component Prioritization](#component-prioritization)
4. [Common Migration Patterns](#common-migration-patterns)
5. [Testing Recommendations](#testing-recommendations)
6. [Rollback Considerations](#rollback-considerations)
7. [Timeline Estimate](#timeline-estimate)
8. [Risk Mitigation](#risk-mitigation)
9. [Next Steps](#next-steps)

---

## 1. Executive Summary

### 1.1 Overview

This guide provides a comprehensive, actionable roadmap for migrating Kumiki Rails from DaisyUI-based components to HyperUI-based components. The migration affects **13 components** and represents a shift from semantic CSS classes to utility-first Tailwind composition.

### 1.2 Key Findings

**Overall Migration Outlook**: ✅ **FAVORABLE**

- **11 of 13 components** have direct or adapted HyperUI equivalents
- **2 components** (FormDatePicker, FormError) require custom implementation using HyperUI patterns
- **Strong accessibility foundation** in current DaisyUI implementation can be maintained
- **No breaking API changes required** - semantic props can map to utility classes internally

### 1.3 Complexity Distribution

| Complexity | Count | Components |
|------------|-------|------------|
| **Easy** | 8 | Button, Badge, Card, FormInput, FormSelect, FormTextarea, FormCheckbox, FormRadio |
| **Medium** | 3 | Modal, Toast, FormFileInput |
| **Hard** | 2 | FormDatePicker, FormError (custom) |

**Recommendation**: Start with easy components to establish patterns, progress to medium, tackle hard components last.

### 1.4 Timeline Estimate

- **Total Effort**: 6-7 weeks (30-35 business days)
- **Phase 1 (Foundation)**: 1 week
- **Phase 2 (Easy Components)**: 2 weeks
- **Phase 3 (Medium Components)**: 1.5 weeks
- **Phase 4 (Hard Components)**: 1 week
- **Phase 5 (Accessibility & Testing)**: 1.5 weeks

### 1.5 Critical Success Factors

1. ✅ **Maintain WCAG 2.1 AA compliance** throughout migration
2. ✅ **Preserve existing API** - no breaking changes to component props
3. ✅ **Establish reusable patterns** early for consistency across components
4. ✅ **Test accessibility continuously** - don't defer to end
5. ✅ **Document migration patterns** for team reference

### 1.6 Risk Assessment

| Risk Level | Count | Description |
|------------|-------|-------------|
| **Low** | 8 | Easy components with clear HyperUI equivalents |
| **Medium** | 3 | Interactive components requiring JavaScript enhancements |
| **High** | 2 | Custom components requiring significant implementation |

**Overall Project Risk**: **MEDIUM** - Majority of components are low risk, but JavaScript accessibility features (focus trap, announcements) require careful implementation.

---

## 2. Migration Strategy

### 2.1 Overall Approach: Component-by-Component

**Chosen Strategy**: Incremental, component-by-component migration with continuous testing

**Rationale**:
- Allows validation of patterns before scaling
- Reduces risk of widespread issues
- Enables early feedback and course correction
- Maintains working components throughout migration
- Supports incremental releases (alpha/beta)

**Rejected Alternatives**:
- ❌ **Big-bang migration**: Too risky, harder to debug issues
- ❌ **Dual-mode support**: Unnecessary complexity, no external users yet
- ❌ **Automated conversion**: Components require manual accessibility enhancements

### 2.2 Release Strategy

**Option A: Big-Bang Release (v0.2.0)**

**Pros**:
- Clean break, all components consistent
- Single migration guide for consumers
- No in-between state to maintain

**Cons**:
- Higher risk per release
- Longer time to first feedback
- More coordination needed
- Harder to isolate issues

**Option B: Incremental Release (Recommended)**

**Phased Release Plan**:
1. **v0.2.0-alpha.1**: Foundation + Easy components (Button, Badge, Card)
2. **v0.2.0-alpha.2**: Easy form components (Input, Select, Textarea, Checkbox, Radio)
3. **v0.2.0-beta.1**: Medium components (Modal, Toast, FormFileInput)
4. **v0.2.0-beta.2**: Hard components (FormDatePicker, FormError) + accessibility fixes
5. **v0.2.0**: Final release with full test coverage and documentation

**Pros**:
- Lower risk per release
- Earlier validation of migration approach
- Feedback incorporated before final release
- Team can course-correct mid-migration

**Cons**:
- More release overhead
- Managing multiple pre-release versions
- Temporary inconsistency between components

**Recommendation**: ✅ **Option B (Incremental Release)** for lower risk and earlier validation

### 2.3 Version Control Strategy

**Git Workflow**:

```bash
# Feature branch for migration
git checkout -b feature/hyperui-migration

# Create worktree for isolated work
git worktree add .worktrees/001-hyperui-component-migration 001-hyperui-component-migration

# Commit after each component migration
git commit -m "Migrate Button component to HyperUI patterns"

# Merge to main after testing
git checkout main
git merge feature/hyperui-migration
```

**Branching Strategy**:
- Main branch: `main` (production-ready code)
- Feature branch: `feature/hyperui-migration` (all migration work)
- Component branches (optional): `feature/hyperui-button`, `feature/hyperui-modal`, etc.

**Commit Strategy**:
- Commit after each component migration
- Commit after accessibility enhancements
- Commit after test additions
- Use descriptive commit messages with context

### 2.4 Feature Flags (Optional)

**Not Recommended**: Library has no external consumers yet, feature flags add unnecessary complexity.

**If Needed Later**:
```ruby
# config/initializers/kumiki.rb
Kumiki.configure do |config|
  config.component_system = :hyperui  # or :daisyui
end
```

### 2.5 Documentation Strategy

**Migration Documentation**:
1. **Component-specific guides**: Before/after examples for each component
2. **API mapping guide**: DaisyUI props → HyperUI equivalent
3. **Breaking changes log**: Document any API changes (aim for zero)
4. **Design token documentation**: Color, spacing, typography decisions
5. **Accessibility guide**: New ARIA patterns and keyboard support

**Update Locations**:
- `README.md`: Update examples to HyperUI patterns
- `CHANGELOG.md`: Document v0.2.0 changes
- `CLAUDE.md`: Update agent context with new patterns
- Component documentation: Update each component's usage examples

---

## 3. Component Prioritization

### 3.1 Migration Order: Complexity-Based

**Principle**: Start with easy components to establish patterns, progress to harder components.

### 3.2 Phase 1: Foundation (Week 1)

**Goal**: Establish core patterns and infrastructure before component migration

**Tasks**:
1. Create `Kumiki::Theme` module for semantic → Tailwind color mapping
2. Implement `Kumiki::Patterns` concern for reusable HTML patterns
3. Create `Kumiki::UtilityBuilder` for class string generation
4. Establish size scale constants across components
5. Document pattern usage guidelines

**Deliverables**:
- `lib/kumiki/theme.rb` - Color mapping system
- `lib/kumiki/patterns.rb` - Reusable pattern modules
- `lib/kumiki/utility_builder.rb` - Class string builder
- Pattern documentation in `docs/patterns/`

**Success Criteria**:
- Color mapping tested with all semantic colors
- Pattern helpers validated with example components
- UtilityBuilder generates correct class strings
- Team trained on new pattern system

**Estimated Effort**: 5 days

---

### 3.3 Phase 2: Easy Components (Weeks 2-3)

**Goal**: Migrate straightforward components to establish workflow

#### Batch 1: Presentational Components (Week 2, Days 1-3)

**Components**: Button, Badge, Card

**Rationale**:
- No JavaScript requirements
- Simple HTML structures
- Establish variant mapping patterns
- Build confidence with quick wins

**Migration Tasks per Component**:
1. Read existing DaisyUI component code
2. Map semantic props to HyperUI utility combinations
3. Implement color/size/style variant mappings
4. Update component template with HyperUI classes
5. Write/update component tests
6. Create before/after documentation
7. Test accessibility (keyboard, screen reader, contrast)

**Example Migration: Button**

**Before (DaisyUI)**:
```ruby
class Button < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :md }
  option :style, default: -> { :filled }

  def button_classes
    ["btn", "btn-#{color}", "btn-#{size}", style_class].join(" ")
  end
end
```

**After (HyperUI)**:
```ruby
class Button < Kumiki::Component
  include Kumiki::Patterns

  option :color, default: -> { :primary }
  option :size, default: -> { :md }
  option :style, default: -> { :filled }

  def button_classes
    UtilityBuilder.new
      .add("inline-flex items-center gap-2 rounded-md font-medium transition-colors")
      .add(SIZES[size])
      .add(COLORS.dig(color, style))
      .add(button_state_classes(color: color, variant: style))
      .build
  end

  COLORS = {
    primary: {
      filled: "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500",
      outline: "border border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white",
      soft: "bg-blue-100 text-blue-700 hover:bg-blue-200",
      ghost: "text-blue-600 hover:bg-blue-100"
    },
    # ... more colors
  }.freeze

  SIZES = {
    xs: "px-2 py-1 text-xs",
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-sm",
    lg: "px-6 py-3 text-base",
    xl: "px-8 py-4 text-lg"
  }.freeze
end
```

**Success Criteria per Component**:
- ✅ All DaisyUI variants have HyperUI equivalents
- ✅ No API breaking changes
- ✅ All tests passing
- ✅ Accessibility maintained (WCAG 2.1 AA)
- ✅ Before/after documentation complete

**Estimated Effort**: 3 days (1 day per component)

#### Batch 2: Form Input Components (Week 2, Days 4-5 + Week 3, Days 1-3)

**Components**: FormInput, FormSelect, FormTextarea, FormCheckbox, FormRadio

**Rationale**:
- Similar patterns across all form components
- No JavaScript requirements (native HTML)
- Accessibility patterns already strong
- Build on Batch 1 learnings

**Migration Tasks per Component**:
1. Map field wrapper patterns from `html-patterns.md`
2. Implement label-input association patterns
3. Update error state handling
4. Enhance `aria-describedby` to include hints (not just errors)
5. Update component tests
6. Create before/after documentation
7. Test form validation flows

**Common Pattern: Form Field Wrapper**

```ruby
module Kumiki
  module Patterns
    module FormField
      def field_wrapper_classes
        "form-group"
      end

      def label_classes(required: false)
        "block text-sm font-medium text-gray-700"
      end

      def input_classes(error: false, disabled: false, size: :md)
        classes = ["block", "w-full", "rounded-md", "shadow-sm"]

        if error
          classes += ["border-red-600", "focus:border-red-500", "focus:ring-red-500"]
        elsif disabled
          classes += ["border-gray-300", "bg-gray-100", "text-gray-400", "cursor-not-allowed"]
        else
          classes += ["border-gray-300", "focus:border-blue-500", "focus:ring-blue-500"]
        end

        classes << spacing_for_size(size)
        classes.join(" ")
      end
    end
  end
end
```

**Success Criteria per Component**:
- ✅ Label association maintained
- ✅ Error states properly indicated (visual + ARIA)
- ✅ Helper text linked via `aria-describedby`
- ✅ Keyboard navigation functional
- ✅ Screen reader announces field labels, states, errors

**Special Considerations**:
- **FormCheckbox & FormRadio**: Use fieldset/legend for groups (WCAG 1.3.1)
- **FormSelect**: Recommend native `<select>` over custom dropdown

**Estimated Effort**: 5 days (1 day per component)

---

### 3.4 Phase 3: Medium Components (Weeks 4-5)

**Goal**: Migrate interactive components requiring JavaScript enhancements

#### Component 1: Modal (Week 4, Days 1-3)

**Complexity**: Medium
**JavaScript Requirements**: Focus trap, keyboard navigation, focus return

**Migration Tasks**:
1. Evaluate native `<dialog>` vs custom div-based approach
2. Implement focus trap Stimulus controller
3. Add ESC key handler
4. Implement focus return on close
5. Add ARIA attributes (`aria-labelledby`, `aria-describedby`)
6. Update positioning utilities
7. Test keyboard-only navigation
8. Test screen reader announcements

**Recommended Approach**: Use native `<dialog>` element

**Rationale**:
- Built-in ESC key support
- Better browser accessibility
- Less JavaScript required
- Backdrop dismissal built-in

**Stimulus Controller Pattern**:

```javascript
// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  connect() {
    this.previousFocus = document.activeElement
    this.setupFocusTrap()
  }

  open() {
    this.dialogTarget.showModal()
    this.setInitialFocus()
  }

  close() {
    this.dialogTarget.close()
    if (this.previousFocus && this.previousFocus.focus) {
      this.previousFocus.focus()
    }
  }

  setInitialFocus() {
    const firstFocusable = this.dialogTarget.querySelector(
      'button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
    )

    if (firstFocusable) {
      firstFocusable.focus()
    } else {
      this.dialogTarget.setAttribute('tabindex', '-1')
      this.dialogTarget.focus()
    }
  }

  setupFocusTrap() {
    this.dialogTarget.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        this.close()
      }

      if (e.key === 'Tab') {
        this.trapFocus(e)
      }
    })
  }

  trapFocus(event) {
    const focusableElements = Array.from(
      this.dialogTarget.querySelectorAll(
        'button:not([disabled]), [href], input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
      )
    )

    const firstElement = focusableElements[0]
    const lastElement = focusableElements[focusableElements.length - 1]

    if (event.shiftKey && document.activeElement === firstElement) {
      event.preventDefault()
      lastElement.focus()
    } else if (!event.shiftKey && document.activeElement === lastElement) {
      event.preventDefault()
      firstElement.focus()
    }
  }
}
```

**Success Criteria**:
- ✅ Focus trapped within modal (Tab cycles through elements)
- ✅ ESC key closes modal
- ✅ Focus returns to trigger element on close
- ✅ First focusable element focused on open
- ✅ `aria-labelledby` and `aria-describedby` implemented
- ✅ Screen reader announces modal role and title
- ✅ Keyboard-only navigation fully functional

**Estimated Effort**: 3 days

#### Component 2: Toast (Week 4, Days 4-5)

**Complexity**: Medium
**JavaScript Requirements**: Role-based announcements, auto-dismiss, keyboard dismissal

**Migration Tasks**:
1. Implement role selection logic (`role="alert"` vs `role="status"`)
2. Implement `aria-live` level selection (`assertive` vs `polite`)
3. Ensure toast doesn't steal focus
4. Add keyboard-accessible close button
5. Implement auto-dismiss with timer
6. Add positioning utilities
7. Test screen reader announcements
8. Test keyboard dismissal

**Key Pattern: Role Selection**

```ruby
class Toast < Kumiki::Component
  option :type, default: -> { :info }

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
end
```

**Success Criteria**:
- ✅ Error toasts use `role="alert"` with `aria-live="assertive"`
- ✅ Info toasts use `role="status"` with `aria-live="polite"`
- ✅ Toast does NOT steal focus from current element
- ✅ Close button is keyboard accessible
- ✅ Screen reader announces toast content
- ✅ Auto-dismiss does not interfere with keyboard navigation

**Estimated Effort**: 2 days

#### Component 3: FormFileInput (Week 5, Days 1-2)

**Complexity**: Medium
**JavaScript Requirements**: File selection announcement, drag-and-drop (optional)

**Migration Tasks**:
1. Style native file input with HyperUI utilities
2. Add `aria-live` status region for file selection
3. Implement file selection announcement
4. (Optional) Add drag-and-drop zone with keyboard accessibility
5. Test keyboard accessibility
6. Test screen reader announces selected files

**Basic Pattern: Native File Input**

```html
<div class="form-group">
  <label for="file-input" class="block text-sm font-medium text-gray-700">
    Upload document
    <span class="text-red-600" aria-label="required">*</span>
  </label>

  <input
    type="file"
    id="file-input"
    name="document"
    accept=".pdf,.doc,.docx"
    aria-required="true"
    aria-describedby="file-hint file-status"
    class="block w-full text-sm text-gray-500 file:mr-4 file:py-2 file:px-4 file:rounded-md file:border-0 file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
  />

  <p id="file-hint" class="mt-1 text-sm text-gray-500">
    Accepted formats: PDF, DOC, DOCX. Maximum size: 10MB.
  </p>

  <div id="file-status" aria-live="polite" aria-atomic="true" class="mt-1 text-sm text-gray-700">
    <!-- Dynamic status updates after file selection -->
  </div>
</div>
```

**Success Criteria**:
- ✅ File selection announced to screen readers
- ✅ Status region updates with selected file(s)
- ✅ Keyboard accessible (native input behavior)
- ✅ Clear error messages for invalid files

**Estimated Effort**: 2 days

**Total Phase 3 Effort**: 7 days

---

### 3.5 Phase 4: Hard Components (Week 6)

**Goal**: Implement custom components with significant complexity

#### Component 1: FormDatePicker (Days 1-3)

**Complexity**: Hard
**Challenge**: No direct HyperUI equivalent, complex accessibility requirements

**Recommended Strategy**: Use native `<input type="date">`

**Rationale**:
- Browser-native accessibility
- Built-in keyboard navigation
- Localized date formats
- Mobile-optimized
- Zero JavaScript required
- WCAG compliant out of the box

**Implementation**:

```ruby
class FormDatePicker < Kumiki::Component
  include Kumiki::Patterns::FormField

  option :min_date, default: -> { nil }
  option :max_date, default: -> { nil }
  option :error, default: -> { false }

  def input_attributes
    {
      type: "date",
      id: field_id,
      name: name,
      min: min_date,
      max: max_date,
      "aria-required": required,
      "aria-invalid": error?,
      "aria-describedby": describedby_ids,
      class: input_classes(error: error?)
    }
  end
end
```

**Alternative: Custom Date Picker**

**Only if business requirement demands custom UI**:
- Integrate third-party library (e.g., Flatpickr)
- Style with HyperUI utilities
- Wrap with Stimulus controller
- Implement full ARIA grid pattern
- **Estimated effort**: 2-3 weeks for full accessibility

**Decision**: ✅ Use native `<input type="date">` unless specific business need

**Success Criteria**:
- ✅ Native date input with HyperUI styling
- ✅ Min/max date constraints
- ✅ Keyboard accessible (native behavior)
- ✅ Screen reader announces date format and constraints
- ✅ Mobile date picker works correctly

**Estimated Effort**: 3 days (native), 15 days (custom)

#### Component 2: FormError (Days 4-5)

**Complexity**: Hard (Custom)
**Challenge**: No direct HyperUI equivalent, needs multiple display styles

**Implementation Strategy**: Build using HyperUI typography + color patterns

**Required Styles**:
1. **Inline error**: Simple text below field
2. **Icon error**: Icon + text
3. **Alert error**: Bordered box with icon and text

**Pattern Implementation**:

```ruby
class FormError < Kumiki::Component
  option :style, default: -> { :inline }  # :inline, :icon, :alert
  option :color, default: -> { :error }   # :error, :warning, :info

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

  def error_classes
    [
      STYLES[style],
      COLORS.dig(color, style),
      "mt-1"
    ].join(" ")
  end

  def aria_attributes
    {
      id: error_id,
      role: "alert",
      "aria-live": live_level,
      "aria-atomic": "true"
    }
  end

  private

  def live_level
    color == :error ? "assertive" : "polite"
  end
end
```

**Success Criteria**:
- ✅ Three display styles implemented (inline, icon, alert)
- ✅ Multiple color variants (error, warning, info)
- ✅ Proper ARIA attributes (`role="alert"`, `aria-live`)
- ✅ Screen reader announces errors
- ✅ Icon has `aria-hidden="true"`
- ✅ 4.5:1 contrast ratio for all color combinations

**Estimated Effort**: 2 days

**Total Phase 4 Effort**: 5 days

---

### 3.6 Phase 5: Accessibility & Testing (Week 7)

**Goal**: Ensure WCAG 2.1 AA compliance and comprehensive testing

**Tasks**:
1. **Accessibility Enhancements** (Days 1-2)
   - Implement focus trap for Modal (if not already done)
   - Add focus return logic for all dialogs
   - Enhance loading state announcements
   - Add character counter for Textarea (optional)
   - Verify all ARIA attributes

2. **Keyboard Testing** (Day 3)
   - Test all components with keyboard-only navigation
   - Verify Tab order is logical
   - Verify all interactive elements focusable
   - Verify focus indicators visible
   - Test ESC key handlers

3. **Screen Reader Testing** (Day 4)
   - Test with VoiceOver (macOS)
   - Test with NVDA (Windows)
   - Verify announcements for all interactive elements
   - Verify form validation announcements
   - Verify modal/toast announcements

4. **Color Contrast Testing** (Day 5)
   - Test all color combinations with WebAIM Contrast Checker
   - Verify 4.5:1 ratio for text
   - Verify 3:1 ratio for UI components
   - Adjust colors if necessary
   - Document approved color palettes

5. **Visual Regression Testing** (Optional)
   - Capture screenshots of all components
   - Compare before/after visual appearance
   - Verify no unintended visual changes
   - Document intentional visual updates

6. **Integration Testing** (Days 6-7)
   - Test form submission flows
   - Test modal open/close flows
   - Test toast notification stacking
   - Test responsive behavior
   - Test browser compatibility (Chrome, Firefox, Safari, Edge)

**Total Phase 5 Effort**: 7 days

---

## 4. Common Migration Patterns

### 4.1 Semantic Color Mapping

**Pattern**: Map DaisyUI semantic colors to Tailwind color scales

**Implementation**:

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

    def self.tailwind_color(semantic_color)
      SEMANTIC_COLORS[semantic_color] || "gray"
    end

    def self.color_classes(semantic_color, variant: :filled, shade: 600)
      tw_color = tailwind_color(semantic_color)

      case variant
      when :filled
        "bg-#{tw_color}-#{shade} text-white hover:bg-#{tw_color}-#{shade + 100}"
      when :outline
        "border border-#{tw_color}-#{shade} text-#{tw_color}-#{shade} hover:bg-#{tw_color}-#{shade} hover:text-white"
      when :soft
        "bg-#{tw_color}-100 text-#{tw_color}-700 hover:bg-#{tw_color}-200"
      when :ghost
        "text-#{tw_color}-#{shade} hover:bg-#{tw_color}-100"
      end
    end
  end
end
```

**Usage**:

```ruby
class Button < Kumiki::Component
  def color_classes
    Kumiki::Theme.color_classes(color, variant: style)
  end
end
```

---

### 4.2 Variant Prop Mapping

**Pattern**: Maintain DaisyUI semantic variant props, map to HyperUI utility combinations

**Before (DaisyUI)**:
```erb
<%= render Button.new(color: :primary, size: :lg, style: :outline) do %>
  Click Me
<% end %>
```

**After (HyperUI)** - Same API, different implementation:
```ruby
class Button < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :lg }
  option :style, default: -> { :outline }

  COLORS = {
    primary: {
      filled: "bg-blue-600 text-white hover:bg-blue-700",
      outline: "border border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white",
      # ...
    },
    # ...
  }.freeze

  SIZES = {
    xs: "px-2 py-1 text-xs",
    sm: "px-3 py-1.5 text-sm",
    md: "px-4 py-2 text-sm",
    lg: "px-6 py-3 text-base",
    xl: "px-8 py-4 text-lg"
  }.freeze

  def button_classes
    [
      "inline-flex items-center gap-2 rounded-md font-medium transition-colors",
      SIZES[size],
      COLORS.dig(color, style)
    ].join(" ")
  end
end
```

**Key Principle**: No API changes - consumers use same props, internal implementation changes

---

### 4.3 Tailwind Class Composition

**Pattern**: Build class strings using UtilityBuilder for consistency

**Implementation**:

```ruby
# lib/kumiki/utility_builder.rb
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

    def build
      @classes.uniq.join(" ")
    end
  end
end
```

**Usage**:

```ruby
def button_classes
  UtilityBuilder.new
    .add("inline-flex items-center gap-2 rounded-md font-medium")
    .add(size_classes)
    .add(color_classes)
    .add(state_classes)
    .build
end
```

---

### 4.4 ARIA Attribute Additions

**Pattern**: Enhance components with ARIA attributes for accessibility

**Critical ARIA Patterns**:

1. **Form Fields**:
```ruby
attributes[:"aria-required"] = true if required
attributes[:"aria-invalid"] = true if error?
attributes[:"aria-describedby"] = describedby_ids if describedby_ids.any?
```

2. **Modal**:
```ruby
attributes[:role] = "dialog"
attributes[:"aria-modal"] = "true"
attributes[:"aria-labelledby"] = "#{id}_title"
attributes[:"aria-describedby"] = "#{id}_description"
```

3. **Toast**:
```ruby
attributes[:role] = type.to_s.in?(%w[error danger warning]) ? "alert" : "status"
attributes[:"aria-live"] = type.to_s.in?(%w[error danger]) ? "assertive" : "polite"
attributes[:"aria-atomic"] = "true"
```

4. **Button Loading State**:
```ruby
if loading
  attributes[:"aria-busy"] = "true"
  attributes[:disabled] = true
end
```

---

### 4.5 Stimulus Controller Setup

**Pattern**: Add Stimulus controllers for interactive behavior

**Modal Controller**:

```javascript
// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dialog"]

  open() {
    this.previousFocus = document.activeElement
    this.dialogTarget.showModal()
    this.setInitialFocus()
  }

  close() {
    this.dialogTarget.close()
    this.restoreFocus()
  }

  setInitialFocus() {
    const firstFocusable = this.dialogTarget.querySelector('[autofocus], button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])')
    firstFocusable?.focus() || this.dialogTarget.focus()
  }

  restoreFocus() {
    this.previousFocus?.focus()
  }
}
```

**Toast Controller**:

```javascript
// app/javascript/controllers/toast_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    autoDismiss: { type: Boolean, default: true },
    duration: { type: Number, default: 5000 }
  }

  connect() {
    if (this.autoDismissValue) {
      this.timeout = setTimeout(() => this.dismiss(), this.durationValue)
    }
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  dismiss() {
    this.element.remove()
  }
}
```

---

## 5. Testing Recommendations

### 5.1 Unit Testing

**Test Coverage Goals**: 90%+ for component logic

**Test Structure per Component**:

```ruby
# spec/components/kumiki/button_spec.rb
RSpec.describe Kumiki::Button, type: :component do
  describe "color variants" do
    it "renders primary filled button classes" do
      button = described_class.new(color: :primary, style: :filled)
      expect(button.button_classes).to include("bg-blue-600", "text-white", "hover:bg-blue-700")
    end

    it "renders primary outline button classes" do
      button = described_class.new(color: :primary, style: :outline)
      expect(button.button_classes).to include("border", "border-blue-600", "text-blue-600")
    end
  end

  describe "size variants" do
    it "renders small button classes" do
      button = described_class.new(size: :sm)
      expect(button.button_classes).to include("px-3", "py-1.5", "text-sm")
    end

    it "renders large button classes" do
      button = described_class.new(size: :lg)
      expect(button.button_classes).to include("px-6", "py-3", "text-base")
    end
  end

  describe "state variants" do
    it "renders disabled state" do
      button = described_class.new(disabled: true)
      expect(button.html_attributes[:disabled]).to be true
      expect(button.button_classes).to include("cursor-not-allowed")
    end

    it "renders loading state" do
      button = described_class.new(loading: true)
      expect(button.html_attributes[:"aria-busy"]).to eq("true")
      expect(button.html_attributes[:disabled]).to be true
    end
  end
end
```

---

### 5.2 Accessibility Testing

**Tools**:
- **axe DevTools**: Chrome/Firefox extension for automated scanning
- **Lighthouse**: Built into Chrome DevTools
- **pa11y**: CI integration for automated checks

**Manual Testing Checklist**:

#### Keyboard-Only Navigation
- [ ] All interactive elements focusable via Tab
- [ ] Focus order is logical
- [ ] Focus indicators visible at all times
- [ ] ESC key closes modals and dropdowns
- [ ] Enter/Space activates buttons
- [ ] Arrow keys navigate radio groups

#### Screen Reader Testing (VoiceOver, NVDA)
- [ ] Form labels announced with fields
- [ ] Error messages announced
- [ ] Required fields indicated
- [ ] Modal role and title announced
- [ ] Toast notifications announced
- [ ] Button states (loading, pressed) announced

#### Color Contrast
- [ ] All text meets 4.5:1 contrast ratio
- [ ] Large text meets 3:1 contrast ratio
- [ ] UI components meet 3:1 contrast ratio
- [ ] Focus indicators meet 3:1 contrast ratio

**Automated Testing Integration**:

```ruby
# spec/system/accessibility_spec.rb
RSpec.describe "Accessibility", type: :system, js: true do
  it "has no axe violations on button page" do
    visit components_button_path
    expect(page).to be_axe_clean
  end

  it "has no axe violations on form page" do
    visit components_form_path
    expect(page).to be_axe_clean
  end
end
```

---

### 5.3 Visual Regression Testing

**Tool**: Percy (https://percy.io/) or Chromatic (https://www.chromatic.com/)

**Test Strategy**:
1. Capture screenshots of all component variants
2. Compare against baseline (DaisyUI version)
3. Review visual changes for intentionality
4. Approve changes or fix regressions

**Example Configuration**:

```ruby
# spec/visual_regression/button_spec.rb
RSpec.describe "Button Visual Regression", type: :system, js: true do
  it "matches button variants" do
    visit storybook_button_path

    Percy.snapshot(page, name: "Button - All Variants")
  end

  it "matches button states" do
    visit storybook_button_states_path

    Percy.snapshot(page, name: "Button - States (default, hover, focus, disabled)")
  end
end
```

---

### 5.4 Integration Testing

**Test Scenarios**:

1. **Form Submission Flow**:
   - User fills out form
   - Validation errors appear
   - User corrects errors
   - Form submits successfully
   - Success toast appears

2. **Modal Interaction**:
   - User clicks button to open modal
   - Modal opens and focuses first element
   - User interacts with modal content
   - User presses ESC to close
   - Focus returns to trigger button

3. **Toast Notification**:
   - Action triggers toast
   - Toast appears with correct type (error/success)
   - User dismisses toast
   - Multiple toasts stack correctly

**Example Test**:

```ruby
# spec/system/form_validation_spec.rb
RSpec.describe "Form Validation", type: :system, js: true do
  it "displays errors and focuses first invalid field" do
    visit new_user_path

    fill_in "Email", with: "invalid-email"
    fill_in "Password", with: "short"
    click_button "Sign Up"

    expect(page).to have_css('[aria-invalid="true"]', count: 2)
    expect(page).to have_css('[role="alert"]', text: "Please enter a valid email address")

    # Verify focus on first invalid field
    expect(page).to have_selector(':focus', id: 'user_email')
  end
end
```

---

## 6. Rollback Considerations

### 6.1 Pre-Migration Backup

**Create Git Tag Before Migration**:

```bash
# Tag current state
git tag v0.1.x-pre-hyperui-migration
git push origin v0.1.x-pre-hyperui-migration

# Can rollback with:
git checkout v0.1.x-pre-hyperui-migration
```

---

### 6.2 Rollback Strategy

**If Critical Issues Discovered**:

1. **Revert Git Commits**:
```bash
# Revert specific commit
git revert <commit-hash>

# Revert range of commits
git revert <start-commit>..<end-commit>

# Reset to previous tag (destructive)
git reset --hard v0.1.x-pre-hyperui-migration
```

2. **Cherry-Pick Fixes**:
```bash
# If some components are good, cherry-pick those commits
git cherry-pick <good-commit-hash>
```

3. **Feature Flag Approach** (if implemented):
```ruby
# config/initializers/kumiki.rb
Kumiki.configure do |config|
  config.component_system = :daisyui  # Rollback to DaisyUI
end
```

---

### 6.3 Dual-Mode Support (Not Recommended)

**Only if External Consumers Exist**:

```ruby
module Kumiki
  class Component
    def component_system
      Kumiki.configuration.component_system || :hyperui
    end

    def button_classes
      case component_system
      when :daisyui
        daisyui_button_classes
      when :hyperui
        hyperui_button_classes
      end
    end

    private

    def daisyui_button_classes
      ["btn", "btn-#{color}", "btn-#{size}"].join(" ")
    end

    def hyperui_button_classes
      UtilityBuilder.new
        .add("inline-flex items-center gap-2 rounded-md")
        .add(COLORS.dig(color, style))
        .build
    end
  end
end
```

**Why Not Recommended**:
- Adds complexity
- Doubles testing surface
- No external consumers yet
- Makes codebase harder to maintain

---

## 7. Timeline Estimate

### 7.1 Detailed Schedule

| Phase | Duration | Components | Key Deliverables |
|-------|----------|------------|------------------|
| **Phase 1: Foundation** | 1 week (5 days) | - | Theme system, Patterns, UtilityBuilder |
| **Phase 2: Easy Components** | 2 weeks (10 days) | Button, Badge, Card, FormInput, FormSelect, FormTextarea, FormCheckbox, FormRadio | 8 migrated components |
| **Phase 3: Medium Components** | 1.5 weeks (7 days) | Modal, Toast, FormFileInput | 3 migrated components, Stimulus controllers |
| **Phase 4: Hard Components** | 1 week (5 days) | FormDatePicker, FormError | 2 custom components |
| **Phase 5: Accessibility & Testing** | 1.5 weeks (7 days) | All components | WCAG compliance, test coverage |

**Total Timeline**: **7 weeks (35 business days)**

---

### 7.2 Effort Estimates per Component

| Component | Complexity | Estimated Days | Breakdown |
|-----------|------------|----------------|-----------|
| **Foundation** | - | 5 | Theme (2) + Patterns (2) + UtilityBuilder (1) |
| **Button** | Easy | 1 | Variant mapping (0.5) + Testing (0.5) |
| **Badge** | Easy | 1 | Variant mapping (0.5) + Testing (0.5) |
| **Card** | Easy | 1 | Layout patterns (0.5) + Testing (0.5) |
| **FormInput** | Easy | 1 | Field patterns (0.5) + Testing (0.5) |
| **FormSelect** | Easy | 1 | Field patterns (0.5) + Testing (0.5) |
| **FormTextarea** | Easy | 1 | Field patterns (0.5) + Testing (0.5) |
| **FormCheckbox** | Easy | 1 | Fieldset patterns (0.5) + Testing (0.5) |
| **FormRadio** | Easy | 1 | Fieldset patterns (0.5) + Testing (0.5) |
| **Modal** | Medium | 3 | Stimulus controller (1.5) + ARIA (0.5) + Testing (1) |
| **Toast** | Medium | 2 | Role logic (0.5) + Stimulus (0.5) + Testing (1) |
| **FormFileInput** | Medium | 2 | Status region (1) + Testing (1) |
| **FormDatePicker** | Hard | 3 | Native input (1) + Min/max (1) + Testing (1) |
| **FormError** | Hard | 2 | Style variants (1) + Testing (1) |
| **Accessibility** | - | 7 | Focus trap (2) + Keyboard (1) + Screen reader (2) + Contrast (1) + Integration (1) |

**Total**: 34 days (rounded to 35 for buffer)

---

### 7.3 Milestone Schedule

**Week 1**:
- ✅ Foundation complete
- ✅ Theme system operational
- ✅ Patterns documented

**Week 2**:
- ✅ Button, Badge, Card migrated
- ✅ Initial testing patterns established

**Week 3**:
- ✅ FormInput, FormSelect, FormTextarea migrated
- ✅ FormCheckbox, FormRadio migrated (with fieldset grouping)

**Week 4**:
- ✅ Modal migrated with focus trap
- ✅ Toast migrated with role selection

**Week 5**:
- ✅ FormFileInput migrated
- ✅ All easy + medium components complete

**Week 6**:
- ✅ FormDatePicker migrated (native approach)
- ✅ FormError custom component complete

**Week 7**:
- ✅ Accessibility enhancements complete
- ✅ Full test coverage
- ✅ Documentation updated
- ✅ Ready for v0.2.0 release

---

## 8. Risk Mitigation

### 8.1 Risk Matrix

| Risk | Probability | Impact | Severity | Mitigation |
|------|-------------|--------|----------|------------|
| **Accessibility regression** | Medium | High | **Critical** | Continuous testing, axe integration, manual screen reader testing |
| **JavaScript focus trap bugs** | Medium | High | **Critical** | Use native `<dialog>` where possible, thorough keyboard testing |
| **Color contrast failures** | Low | Medium | **Moderate** | Early contrast testing, documented color palettes |
| **API breaking changes** | Low | High | **Critical** | Maintain semantic prop API, internal mapping only |
| **Timeline overrun** | Medium | Medium | **Moderate** | Prioritize critical components, buffer time in schedule |
| **Team knowledge gaps** | Low | Medium | **Moderate** | Pair programming, documentation, pattern libraries |

---

### 8.2 Critical Risks & Mitigation Strategies

#### Risk 1: Accessibility Regression

**Scenario**: Migration introduces WCAG violations, breaks keyboard navigation or screen reader support

**Mitigation**:
1. ✅ **Continuous testing**: Run axe DevTools after every component migration
2. ✅ **Keyboard-first development**: Test with keyboard-only navigation during development, not after
3. ✅ **Screen reader validation**: Test with VoiceOver/NVDA every 2-3 components
4. ✅ **Accessibility checklist**: Use component-specific checklists from `accessibility-analysis.md`
5. ✅ **Early focus trap implementation**: Tackle Modal focus trap in Phase 3, not Phase 5

**Acceptance Criteria**:
- Zero critical axe violations
- All components keyboard accessible
- All dynamic content announced to screen readers
- WCAG 2.1 AA compliance verified

---

#### Risk 2: JavaScript Focus Trap Bugs

**Scenario**: Modal focus trap fails, users get stuck or focus escapes

**Mitigation**:
1. ✅ **Use native `<dialog>` element**: Built-in ESC key support, better browser accessibility
2. ✅ **Reference WAI-ARIA patterns**: Follow [Dialog (Modal) Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/) exactly
3. ✅ **Test edge cases**:
   - Modal with no focusable elements
   - Nested modals (if supported)
   - Rapid open/close cycles
   - Browser back button while modal open
4. ✅ **Peer review**: Have another developer review Stimulus controller code
5. ✅ **Add integration tests**: Automated tests for focus trap behavior

**Fallback Plan**:
- If custom focus trap proves too complex, use library like `focus-trap` (https://github.com/focus-trap/focus-trap)

---

#### Risk 3: Timeline Overrun

**Scenario**: Migration takes longer than 7 weeks, delaying v0.2.0 release

**Mitigation**:
1. ✅ **Buffer time**: 7-week estimate includes 10% buffer
2. ✅ **Prioritize critical path**: Easy components first, can ship alpha with partial migration
3. ✅ **Incremental releases**: Ship v0.2.0-alpha.1 after Phase 2 for early feedback
4. ✅ **Defer non-critical enhancements**: Character counter, autocomplete, inputmode can be post-launch
5. ✅ **Daily standup**: Track progress, identify blockers early

**Contingency Plan**:
- If timeline slips, defer FormDatePicker and FormError to v0.2.1
- Ship v0.2.0 with 11 migrated components, add remaining 2 in patch release

---

### 8.3 Quality Gates

**Gate 1: After Phase 1 (Foundation)**
- [ ] Theme system tested with all semantic colors
- [ ] Pattern helpers validated with example components
- [ ] UtilityBuilder generates correct class strings
- [ ] Team trained on new pattern system

**Gate 2: After Phase 2 (Easy Components)**
- [ ] 8 components migrated and tested
- [ ] No accessibility regressions
- [ ] All unit tests passing
- [ ] Before/after documentation complete

**Gate 3: After Phase 3 (Medium Components)**
- [ ] Modal focus trap working correctly
- [ ] Toast announcements validated with screen reader
- [ ] File input selection announced
- [ ] All Stimulus controllers tested

**Gate 4: Before Release (Phase 5)**
- [ ] Zero critical axe violations
- [ ] 90%+ test coverage
- [ ] WCAG 2.1 AA compliance verified
- [ ] Documentation updated
- [ ] CHANGELOG complete
- [ ] Migration guide published

---

## 9. Next Steps

### 9.1 Immediate Actions

**Week 0 (Pre-Migration Setup)**:

1. **Review & Approval** (Day 1):
   - [ ] Review this migration guide with team
   - [ ] Approve timeline and resource allocation
   - [ ] Assign developers to migration tasks
   - [ ] Schedule weekly progress check-ins

2. **Environment Setup** (Day 2):
   - [ ] Create feature branch: `feature/hyperui-migration`
   - [ ] Create worktree: `.worktrees/001-hyperui-component-migration`
   - [ ] Set up testing tools (axe DevTools, Percy/Chromatic)
   - [ ] Configure CI for accessibility tests

3. **Documentation Prep** (Day 3):
   - [ ] Create `docs/migration/` directory
   - [ ] Copy component-mapping.md as reference
   - [ ] Set up component migration tracking sheet
   - [ ] Create template for before/after docs

4. **Team Training** (Days 4-5):
   - [ ] Review HyperUI component patterns
   - [ ] Walkthrough UtilityBuilder usage
   - [ ] Practice keyboard-only navigation testing
   - [ ] Screen reader basics (VoiceOver/NVDA)

---

### 9.2 Phase 1 Kickoff

**Week 1 (Foundation)**:

**Day 1: Theme System**
- [ ] Create `lib/kumiki/theme.rb`
- [ ] Implement semantic → Tailwind color mapping
- [ ] Add color_classes helper method
- [ ] Write unit tests for Theme module

**Day 2: Theme System (continued)**
- [ ] Test all semantic colors with all variants
- [ ] Document color mapping decisions
- [ ] Create color palette reference in docs

**Day 3: Patterns Module**
- [ ] Create `lib/kumiki/patterns/` directory
- [ ] Implement Container pattern helper
- [ ] Implement FlexLayout pattern helper
- [ ] Implement Spacing pattern helper

**Day 4: Patterns Module (continued)**
- [ ] Implement FormField pattern helper
- [ ] Implement InteractiveStates pattern helper
- [ ] Write unit tests for all pattern helpers

**Day 5: UtilityBuilder**
- [ ] Create `lib/kumiki/utility_builder.rb`
- [ ] Implement add, spacing, flex methods
- [ ] Implement build method with deduplication
- [ ] Write unit tests
- [ ] Document usage examples

---

### 9.3 Success Criteria

**Project Success** = All criteria met:

1. ✅ **All 13 components migrated** to HyperUI patterns
2. ✅ **Zero breaking API changes** - existing component usage unchanged
3. ✅ **WCAG 2.1 AA compliance maintained** - no accessibility regressions
4. ✅ **90%+ test coverage** - unit, integration, accessibility tests
5. ✅ **Complete documentation** - migration guide, API docs, before/after examples
6. ✅ **v0.2.0 released on schedule** - within 7 weeks

---

### 9.4 Communication Plan

**Weekly Progress Updates**:
- Every Friday: Share progress report with team
- Every Monday: Review blockers and adjust plan if needed

**Progress Report Template**:
```markdown
## Migration Progress Report - Week X

**Completed This Week**:
- [x] Component 1 migrated and tested
- [x] Component 2 migrated and tested

**In Progress**:
- [ ] Component 3 migration (80% complete)

**Blockers**:
- Issue with focus trap on Modal - need peer review

**Next Week Plan**:
- Complete Component 3 migration
- Start Component 4 and 5 migrations
- Run first round of screen reader testing

**On Track for 7-week timeline**: Yes / No / At Risk
```

---

### 9.5 Post-Migration Tasks

**After v0.2.0 Release**:

1. **Retrospective** (Week 8, Day 1):
   - [ ] What went well?
   - [ ] What could be improved?
   - [ ] Lessons learned for future migrations
   - [ ] Update this migration guide with learnings

2. **Documentation Updates** (Week 8, Days 2-3):
   - [ ] Update README with HyperUI examples
   - [ ] Publish migration guide for consumers (when applicable)
   - [ ] Update CLAUDE.md with new patterns
   - [ ] Create Storybook examples (optional)

3. **Performance Optimization** (Week 8, Days 4-5):
   - [ ] Benchmark component render times
   - [ ] Optimize class string generation if needed
   - [ ] Minimize CSS bundle size
   - [ ] Document performance metrics

4. **Future Enhancements** (Post-v0.2.0):
   - [ ] Add autocomplete attributes to form fields
   - [ ] Add inputmode attributes for mobile
   - [ ] Add character counter to Textarea
   - [ ] Consider custom date picker (if business need arises)

---

## Appendix A: Quick Reference Checklists

### Component Migration Checklist

Use this checklist for each component:

- [ ] **Read existing component code** - Understand current implementation
- [ ] **Map variants to HyperUI utilities** - Create COLORS, SIZES, STYLES constants
- [ ] **Implement UtilityBuilder usage** - Generate class strings
- [ ] **Update component template** - Replace DaisyUI classes with utilities
- [ ] **Add/update ARIA attributes** - Ensure accessibility
- [ ] **Write/update component tests** - Unit tests for all variants
- [ ] **Test keyboard navigation** - Tab, Enter, Space, ESC
- [ ] **Test screen reader** - VoiceOver or NVDA
- [ ] **Test color contrast** - WebAIM Contrast Checker
- [ ] **Create before/after documentation** - Code examples
- [ ] **Update CHANGELOG** - Document changes
- [ ] **Commit with descriptive message** - Include component name

---

### Accessibility Testing Checklist

Use this checklist for accessibility validation:

**Keyboard Testing**:
- [ ] All interactive elements focusable via Tab
- [ ] Focus order is logical
- [ ] Focus indicators visible at all times
- [ ] ESC key closes modals/dropdowns
- [ ] Enter/Space activates buttons
- [ ] Arrow keys navigate radio groups

**Screen Reader Testing**:
- [ ] Form labels announced with fields
- [ ] Error messages announced
- [ ] Required fields indicated
- [ ] Modal role and title announced
- [ ] Toast notifications announced
- [ ] Button states announced

**Color Contrast**:
- [ ] All text meets 4.5:1 ratio
- [ ] Large text meets 3:1 ratio
- [ ] UI components meet 3:1 ratio
- [ ] Focus indicators meet 3:1 ratio

**ARIA Validation**:
- [ ] All form fields have labels
- [ ] Required fields have `aria-required`
- [ ] Invalid fields have `aria-invalid`
- [ ] Error messages linked via `aria-describedby`
- [ ] Modals have `role="dialog"` and `aria-modal="true"`
- [ ] Toasts have `role="alert"` or `role="status"`

---

## Appendix B: Resources

### Documentation
- **HyperUI Components**: https://www.hyperui.dev/
- **DaisyUI Components**: https://daisyui.com/components/
- **Tailwind CSS Docs**: https://tailwindcss.com/docs
- **WAI-ARIA Authoring Practices**: https://www.w3.org/WAI/ARIA/apg/

### Testing Tools
- **axe DevTools**: https://www.deque.com/axe/devtools/
- **WebAIM Contrast Checker**: https://webaim.org/resources/contrastchecker/
- **WAVE Browser Extension**: https://wave.webaim.org/extension/
- **Lighthouse**: Chrome DevTools → Lighthouse tab

### Screen Readers
- **VoiceOver (macOS)**: System Preferences → Accessibility → VoiceOver
- **NVDA (Windows)**: https://www.nvaccess.org/
- **JAWS (Windows)**: https://www.freedomscientific.com/products/software/jaws/

---

**End of Migration Guide**

**Document Status**: ✅ Complete and Ready for Team Review
**Next Action**: Schedule migration kickoff meeting with team
**Estimated Start Date**: [To be determined]
**Estimated Completion**: [Start Date + 7 weeks]
