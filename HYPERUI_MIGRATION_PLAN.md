# HyperUI Migration Plan - Kumiki Rails v0.2.0

> **Project:** Migrate from DaisyUI to HyperUI component library
> **Version:** 0.2.0
> **Timeline:** 16-20 weeks (4-5 months)
> **Status:** Planning Phase

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Migration Strategy](#migration-strategy)
3. [Phase 0: Foundation & Setup](#phase-0-foundation--setup)
4. [Phase 1: Core Component Migration](#phase-1-core-component-migration)
5. [Phase 2: New HyperUI Components - Application UI](#phase-2-new-hyperui-components---application-ui)
6. [Phase 3: Documentation & Release](#phase-3-documentation--release)
7. [Work Ticket Categories](#work-ticket-categories)
8. [Success Metrics](#success-metrics)
9. [Risk Mitigation](#risk-mitigation)

---

## Executive Summary

### What We're Doing

Completely rebuilding Kumiki Rails from DaisyUI-based components to HyperUI-based components, transforming it from a 13-component library to a comprehensive 250+ component UI toolkit.

### Why

- **Modern Design:** HyperUI provides more contemporary, visually appealing component designs
- **Component Variety:** Expanding from 13 to 250+ components covers marketing, e-commerce, and application UI needs
- **Copy-Paste Architecture:** Greater control over implementation without relying on Tailwind plugins
- **Bundle Size:** Better tree-shaking and smaller production bundles

### Key Decisions

- ✅ **Breaking Change:** v0.2.0 major version bump
- ✅ **API Redesign:** New component APIs to match HyperUI patterns
- ✅ **Hybrid Approach:** HyperUI HTML templates + Ruby composition layer
- ✅ **Drop Incompatible Features:** DaisyUI-specific features that don't map to HyperUI
- ✅ **Simultaneous Migration:** All 13 components migrated together
- ✅ **Comprehensive Expansion:** Add all applicable HyperUI components

### Timeline Overview

| Phase     | Duration        | Components         | Key Deliverables                              |
| --------- | --------------- | ------------------ | --------------------------------------------- |
| Phase 0   | 2 weeks         | N/A                | Design system, architecture, tooling          |
| Phase 1   | 4-6 weeks       | 13 core            | Migrated components, form builder             |
| Phase 2   | 6-8 weeks       | ~17 app UI         | Application components (tables, tabs, etc.)   |
| Phase 3   | 2 weeks         | N/A                | Documentation, migration guide, release       |
| **TOTAL** | **12-18 weeks** | **~30 components** | **v0.2.0 Release**                            |

---

## Migration Strategy

### Architectural Approach

```
┌─────────────────────────────────────────────────────────────┐
│                    HyperUI HTML Snippets                     │
│              (250+ copy-paste components)                    │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│               Analysis & Pattern Extraction                  │
│  • Identify common variants (colors, sizes, styles)         │
│  • Extract design tokens (spacing, colors, typography)       │
│  • Standardize accessibility patterns                       │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                Ruby Component Classes                        │
│  • Configurable props (variant, size, color, etc.)          │
│  • Class composition logic                                   │
│  • Accessibility attributes                                  │
│  • Error handling                                            │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│                ERB Component Templates                       │
│  • HyperUI-inspired HTML structure                          │
│  • Dynamic class application                                │
│  • Slot-based composition                                   │
└───────────────────────┬─────────────────────────────────────┘
                        │
                        ▼
┌─────────────────────────────────────────────────────────────┐
│              Stimulus Controllers (if needed)                │
│  • Interactive behavior (modals, dropdowns, etc.)           │
│  • Hotwire integration                                      │
└─────────────────────────────────────────────────────────────┘
```

### Component API Design Philosophy

**Before (DaisyUI):**

```ruby
<%= button(variant: :primary, size: :lg, loading: true) { "Save" } %>
```

**After (HyperUI - New API):**

```ruby
<%= button(
  text: "Save",
  variant: :solid,        # :solid, :outline, :ghost, :gradient
  color: :primary,        # :primary, :secondary, :success, :error
  size: :lg,              # :xs, :sm, :md, :lg, :xl
  loading: true
) %>
```

**Key Changes:**

- More explicit naming (`variant` splits into `variant` + `color`)
- Better extensibility (new variants don't conflict with existing ones)
- Clearer separation of concerns (style vs size vs state)

---

## Phase 0: Foundation & Setup

**Duration:** 2 weeks
**Goal:** Establish design system, architecture patterns, and development infrastructure

### Epic 0.1: Design System Foundation

**Objective:** Create a comprehensive design system that unifies 250+ HyperUI components

#### Tickets

- **[DESIGN-001]** Audit HyperUI component catalog and categorize by type
- **[DESIGN-002]** Extract and standardize color palette from HyperUI snippets
- **[DESIGN-003]** Define size scale system (xs, sm, md, lg, xl, 2xl)
- **[DESIGN-004]** Define spacing scale system (padding, margin, gaps)
- **[DESIGN-005]** Define typography scale (text sizes, weights, line heights)
- **[DESIGN-006]** Document border radius, shadow, and effect standards
- **[DESIGN-007]** Create component variant taxonomy (solid, outline, ghost, etc.)
- **[DESIGN-008]** Create Tailwind config with HyperUI-inspired design tokens

**Deliverables:**

- `docs/DESIGN_SYSTEM.md` - Comprehensive design token documentation
- Updated `app/assets/stylesheets/kumiki/application.css` with `@theme` block (Tailwind v4 CSS-first configuration)
- Color palette guide with semantic naming (primary-50 through primary-900)

---

### Epic 0.2: Architecture & Tooling Setup

**Objective:** Set up development environment and establish component architecture patterns

#### Tickets

- **[ARCH-001]** Create long-lived feature branch
- **[ARCH-002]** Remove DaisyUI dependencies from package.json and Tailwind config
- **[ARCH-003]** Upgrade to Tailwind CSS v4 (HyperUI requirement)
- **[ARCH-004]** Create base component class architecture (`Kumiki::BaseComponent`)
- **[ARCH-005]** Design and document component class composition patterns
- **[ARCH-006]** Design and document slot-based content patterns
- **[ARCH-007]** Create component generator script for boilerplate
- **[ARCH-008]** Set up parallel preview environment for v2 components
- **[ARCH-009]** Document component API design guidelines

**Deliverables:**

- Feature branch with no DaisyUI references
- Tailwind CSS v4 installed with CSS-first `@theme` configuration
- `app/components/kumiki/base_component.rb` - Abstract base class
- `lib/generators/kumiki/component/component_generator.rb` - Component scaffold generator
- `docs/COMPONENT_ARCHITECTURE.md` - Architecture documentation

---

### Epic 0.3: HyperUI Component Analysis

**Objective:** Deep analysis of HyperUI patterns to inform implementation

#### Tickets

- **[ANALYSIS-001]** Map existing 13 components to HyperUI equivalents (1:1 analysis)
- **[ANALYSIS-002]** Document HyperUI accessibility patterns (ARIA, keyboard nav)
- **[ANALYSIS-003]** Identify HyperUI interactive components requiring Stimulus
- **[ANALYSIS-004]** Extract common HTML structures and patterns
- **[ANALYSIS-005]** Document variant differences between DaisyUI and HyperUI
- **[ANALYSIS-006]** Create migration mapping guide (old API → new API)

**Deliverables:**

- `docs/HYPERUI_ANALYSIS.md` - Component-by-component analysis
- `docs/COMPONENT_MAPPING.md` - DaisyUI → HyperUI feature mapping
- `docs/BREAKING_CHANGES.md` - Comprehensive breaking change list

---

## Phase 1: Core Component Migration

**Duration:** 4-6 weeks
**Goal:** Migrate all 13 existing components from DaisyUI to HyperUI

### Epic 1.1: UI Primitives (Week 1-2)

**Objective:** Migrate stateless, non-interactive components first to establish patterns

#### Component: Button

**Tickets:**

- **[BTN-001]** Research HyperUI button variants and extract HTML patterns
- **[BTN-002]** Design new button component API (props, variants, sizes)
- **[BTN-003]** Implement `Kumiki::Components::Button` class with variant composition
- **[BTN-004]** Create `button.html.erb` template with HyperUI structure
- **[BTN-005]** Implement loading state with custom spinner (DaisyUI replacement)
- **[BTN-006]** Implement icon support (left/right positioning)
- **[BTN-007]** Write comprehensive RSpec tests for all variants
- **[BTN-008]** Update preview system with all button variants
- **[BTN-009]** Update `button` helper method

**Acceptance Criteria:**

- Supports variants: `:solid`, `:outline`, `:ghost`, `:gradient`, `:link`
- Supports colors: `:primary`, `:secondary`, `:success`, `:error`, `:warning`, `:info`
- Supports sizes: `:xs`, `:sm`, `:md`, `:lg`, `:xl`
- Supports states: `loading`, `disabled`, `active`
- Supports icons: `icon_left`, `icon_right`
- 100% test coverage
- Accessible (ARIA labels, keyboard navigation)

---

#### Component: Badge

**Tickets:**

- **[BADGE-001]** Research HyperUI badge variants and extract patterns
- **[BADGE-002]** Design badge component API
- **[BADGE-003]** Implement `Kumiki::Components::Badge` class
- **[BADGE-004]** Create `badge.html.erb` template
- **[BADGE-005]** Implement icon decoration support (left/right icons)
- **[BADGE-006]** Write RSpec tests
- **[BADGE-007]** Update preview system
- **[BADGE-008]** Update `badge` helper method

**Acceptance Criteria:**

- Supports variants: `:solid`, `:outline`, `:soft`, `:pill`
- Supports colors: `:primary`, `:secondary`, `:success`, `:error`, `:warning`, `:info`, `:neutral`
- Supports sizes: `:xs`, `:sm`, `:md`, `:lg`
- Supports icon decorations
- 100% test coverage

---

#### Component: Card

**Tickets:**

- **[CARD-001]** Research HyperUI card layouts and extract patterns
- **[CARD-002]** Design card component API with slot support
- **[CARD-003]** Implement `Kumiki::Components::Card` class
- **[CARD-004]** Create `card.html.erb` template with header/body/footer slots
- **[CARD-005]** Implement border and shadow variants
- **[CARD-006]** Write RSpec tests including slot rendering
- **[CARD-007]** Update preview system with diverse card examples
- **[CARD-008]** Update `card` helper method

**Acceptance Criteria:**

- Supports slot-based composition: `header`, `body`, `footer`
- Supports variants: `:bordered`, `:shadow`, `:elevated`, `:flat`
- Supports shadow sizes: `:sm`, `:md`, `:lg`, `:xl`
- Compact mode support
- 100% test coverage

---

### Epic 1.2: Interactive Components (Week 2-3)

**Objective:** Migrate components with JavaScript behavior

#### Component: Modal

**Tickets:**

- **[MODAL-001]** Research HyperUI modal patterns and JavaScript requirements
- **[MODAL-002]** Design modal component API
- **[MODAL-003]** Implement `Kumiki::Components::Modal` class
- **[MODAL-004]** Create `modal.html.erb` template with HyperUI structure
- **[MODAL-005]** Update or create Stimulus controller for modal behavior
- **[MODAL-006]** Implement backdrop (overlay) variants
- **[MODAL-007]** Implement size variants (sm, md, lg, xl, fullscreen)
- **[MODAL-008]** Implement accessibility (focus trap, ESC key, ARIA)
- **[MODAL-009]** Write RSpec tests + Stimulus controller tests
- **[MODAL-010]** Update preview with interactive modal examples
- **[MODAL-011]** Update `modal` helper method

**Acceptance Criteria:**

- Uses `<dialog>` element with HyperUI styling
- Supports sizes: `:sm`, `:md`, `:lg`, `:xl`, `:fullscreen`
- Backdrop variants: `:blur`, `:dark`, `:light`
- ESC key closes modal
- Focus trap when open
- Scrollable content for long modals
- Stimulus controller handles open/close
- 100% test coverage

---

#### Component: Toast

**Tickets:**

- **[TOAST-001]** Research HyperUI toast/alert patterns
- **[TOAST-002]** Design toast component API with positioning
- **[TOAST-003]** Implement `Kumiki::Components::Toast` class
- **[TOAST-004]** Create `toast.html.erb` template with HyperUI structure
- **[TOAST-005]** Rebuild auto-dismiss Stimulus controller
- **[TOAST-006]** Implement positioning system (top-left, top-right, bottom-left, bottom-right, top-center, bottom-center)
- **[TOAST-007]** Implement slide/fade animations
- **[TOAST-008]** Implement stacking for multiple toasts
- **[TOAST-009]** Write RSpec tests + Stimulus controller tests
- **[TOAST-010]** Update preview with toast examples in all positions
- **[TOAST-011]** Update `toast` helper method

**Acceptance Criteria:**

- Supports types: `:success`, `:error`, `:warning`, `:info`, `:notice`
- Supports positions: 6 position options
- Auto-dismiss with configurable delay
- Manual dismiss button
- Smooth animations (slide in/out or fade)
- Toast stacking/queuing
- Icon support per type
- 100% test coverage

---

### Epic 1.3: Form Components - Inputs (Week 3-4)

**Objective:** Migrate text-based form inputs

#### Component: FormInput

**Tickets:**

- **[INPUT-001]** Research HyperUI input styles and variants
- **[INPUT-002]** Design form input component API
- **[INPUT-003]** Implement `Kumiki::Components::FormInput` class
- **[INPUT-004]** Create `form_input.html.erb` template with HyperUI structure
- **[INPUT-005]** Implement input types support (text, email, password, number, tel, url, search, date, time, datetime-local)
- **[INPUT-006]** Implement error state styling and error message display
- **[INPUT-007]** Implement hint/help text support
- **[INPUT-008]** Implement label positioning (top, left, inline)
- **[INPUT-009]** Implement addon support (prefix/suffix icons or text)
- **[INPUT-010]** Implement size variants (xs, sm, md, lg, xl)
- **[INPUT-011]** Write comprehensive RSpec tests (all types, states, variants)
- **[INPUT-012]** Update preview with diverse input examples
- **[INPUT-013]** Update `form_input` helper method

**Acceptance Criteria:**

- Supports all standard HTML5 input types
- Error state with validation message display
- Hint text below input
- Label with required indicator
- Addon/prefix/suffix support
- Sizes: `:xs`, `:sm`, `:md`, `:lg`, `:xl`
- Disabled and readonly states
- Accessible (aria-describedby, aria-invalid, etc.)

- 100% test coverage

---

#### Component: FormTextarea

**Tickets:**

- **[TEXTAREA-001]** Research HyperUI textarea patterns
- **[TEXTAREA-002]** Design textarea component API
- **[TEXTAREA-003]** Implement `Kumiki::Components::FormTextarea` class
- **[TEXTAREA-004]** Create `form_textarea.html.erb` template
- **[TEXTAREA-005]** Implement row/col configuration
- **[TEXTAREA-006]** Implement resize behavior (none, vertical, horizontal, both)
- **[TEXTAREA-007]** Implement auto-grow functionality (optional)
- **[TEXTAREA-008]** Implement character counter (optional)
- **[TEXTAREA-009]** Write RSpec tests
- **[TEXTAREA-010]** Update preview
- **[TEXTAREA-011]** Update `form_textarea` helper method

**Acceptance Criteria:**

- Configurable rows and cols
- Resize options
- Character counter with max length
- Auto-grow option
- Error state support
- 100% test coverage

---

#### Component: FormSelect

**Tickets:**

- **[SELECT-001]** Research HyperUI select dropdown patterns
- **[SELECT-002]** Design select component API
- **[SELECT-003]** Implement `Kumiki::Components::FormSelect` class
- **[SELECT-004]** Create `form_select.html.erb` template
- **[SELECT-005]** Implement native select vs custom dropdown decision
- **[SELECT-006]** Implement option groups support
- **[SELECT-007]** Implement prompt option
- **[SELECT-008]** Write RSpec tests
- **[SELECT-009]** Update preview
- **[SELECT-010]** Update `form_select` helper method

**Acceptance Criteria:**

- Works with Rails collections and arrays
- Prompt/placeholder option
- Option groups support
- Error state support
- Multiple select support
- 100% test coverage

---

### Epic 1.4: Form Components - Choices (Week 4-5)

**Objective:** Migrate checkbox, radio, and file inputs

#### Component: FormCheckbox

**Tickets:**

- **[CHECKBOX-001]** Research HyperUI checkbox patterns
- **[CHECKBOX-002]** Design checkbox component API
- **[CHECKBOX-003]** Implement `Kumiki::Components::FormCheckbox` class
- **[CHECKBOX-004]** Create `form_checkbox.html.erb` template
- **[CHECKBOX-005]** Implement layout variants (inline, stacked)
- **[CHECKBOX-006]** Implement custom checkbox styling vs native
- **[CHECKBOX-007]** Implement indeterminate state
- **[CHECKBOX-008]** Write RSpec tests
- **[CHECKBOX-009]** Update preview
- **[CHECKBOX-010]** Update `form_checkbox` helper method

**Acceptance Criteria:**

- Inline and stacked layouts
- Custom styled checkbox
- Indeterminate state support
- Error state support
- Disabled state
- 100% test coverage

---

#### Component: FormRadio

**Tickets:**

- **[RADIO-001]** Research HyperUI radio button patterns
- **[RADIO-002]** Design radio component API (individual + group)
- **[RADIO-003]** Implement `Kumiki::Components::FormRadio` class
- **[RADIO-004]** Create `form_radio.html.erb` template
- **[RADIO-005]** Implement radio group layout (inline, stacked, grid)
- **[RADIO-006]** Implement card-style radio options (optional)
- **[RADIO-007]** Write RSpec tests
- **[RADIO-008]** Update preview
- **[RADIO-009]** Update `form_radio` helper method

**Acceptance Criteria:**

- Individual radio buttons
- Radio group component
- Layout variants: inline, stacked, grid
- Card-style radio options
- Error state support
- 100% test coverage

---

#### Component: FormFileInput

**Tickets:**

- **[FILE-001]** Research HyperUI file uploader patterns
- **[FILE-002]** Design file input component API (basic vs drag-drop)
- **[FILE-003]** Implement `Kumiki::Components::FormFileInput` class (basic version)
- **[FILE-004]** Create `form_file_input.html.erb` template
- **[FILE-005]** Implement file type validation display
- **[FILE-006]** Implement file size display
- **[FILE-007]** Implement preview for images (optional)
- **[FILE-008]** Implement drag-and-drop zone (optional - separate variant)
- **[FILE-009]** Write RSpec tests
- **[FILE-010]** Update preview
- **[FILE-011]** Update `form_file_input` helper method

**Acceptance Criteria:**

- Basic file input with custom styling
- Accept attribute support (file type restrictions)
- Multiple file support
- File preview for images (optional)
- Drag-and-drop variant (optional)
- Error state support
- 100% test coverage

**Note:** Drag-and-drop file upload is a complex feature that may warrant its own separate component in Phase 2.

---

#### Component: FormDatePicker

**Tickets:**

- **[DATE-001]** Research HyperUI date input patterns
- **[DATE-002]** Design date picker component API
- **[DATE-003]** Implement `Kumiki::Components::FormDatePicker` class
- **[DATE-004]** Create `form_date_picker.html.erb` template (native HTML5 date input with HyperUI styling)
- **[DATE-005]** Write RSpec tests
- **[DATE-006]** Update preview
- **[DATE-007]** Update `form_date_picker` helper method

**Acceptance Criteria:**

- Uses native `<input type="date">` with custom styling
- Min/max date support
- Error state support
- 100% test coverage

**Note:** Custom JavaScript date picker (like Flatpickr) can be added in Phase 2 as a separate component.

---

#### Component: FormError

**Tickets:**

- **[ERROR-001]** Design form error display component (no direct HyperUI equivalent)
- **[ERROR-002]** Implement `Kumiki::Components::FormError` class
- **[ERROR-003]** Create `form_error.html.erb` template
- **[ERROR-004]** Implement error message list formatting
- **[ERROR-005]** Implement inline error vs summary error display
- **[ERROR-006]** Write RSpec tests
- **[ERROR-007]** Update preview
- **[ERROR-008]** Update `form_error` helper method

**Acceptance Criteria:**

- Display Rails validation errors
- Inline error (below field) variant
- Error summary (top of form) variant
- Icon support
- Accessible (aria-live, role="alert")
- 100% test coverage

---

### Epic 1.5: Form Builder Rebuild (Week 5-6)

**Objective:** Update form builder to use new component APIs

#### Tickets

- **[BUILDER-001]** Update `ApplicationFormBuilder` to delegate to new component APIs
- **[BUILDER-002]** Update `text_field` method to use new `FormInput` component
- **[BUILDER-003]** Update `email_field`, `password_field`, `number_field`, etc. to use `FormInput`
- **[BUILDER-004]** Update `text_area` method to use new `FormTextarea` component
- **[BUILDER-005]** Update `select` method to use new `FormSelect` component
- **[BUILDER-006]** Update `check_box` method to use new `FormCheckbox` component
- **[BUILDER-007]** Update `radio_button` method to use new `FormRadio` component
- **[BUILDER-008]** Update `file_field` method to use new `FormFileInput` component
- **[BUILDER-009]** Update `date_field` method to use new `FormDatePicker` component
- **[BUILDER-010]** Update error handling to use new `FormError` component
- **[BUILDER-011]** Write comprehensive integration tests with Rails models
- **[BUILDER-012]** Test validation error display across all field types
- **[BUILDER-013]** Update form builder preview

**Acceptance Criteria:**

- All form field methods work with new components
- Validation errors display correctly
- Required fields marked properly
- Accessible form markup
- 100% test coverage for form builder
- Integration tests with real ActiveRecord models

---

### Epic 1.6: Helper Methods & API (Week 6)

**Objective:** Update component helper methods and ensure API consistency

#### Tickets

- **[HELPER-001]** Update `component_helper.rb` with all new method signatures
- **[HELPER-002]** Create deprecation warnings for old DaisyUI method signatures (optional)
- **[HELPER-003]** Document new helper method APIs
- **[HELPER-004]** Write helper method tests
- **[HELPER-005]** Create API consistency validator (ensure all components follow same patterns)

**Deliverables:**

- Updated `app/helpers/kumiki/component_helper.rb`
- Comprehensive helper documentation

---

## Phase 2: New HyperUI Components - Application UI

**Duration:** 6-8 weeks
**Goal:** Add essential application UI components from HyperUI catalog

### Epic 2.1: Data Display Components (Week 7-9)

**Objective:** Add components for displaying tabular and structured data

#### Component: Table

**Tickets:**

- **[TABLE-001]** Research HyperUI table variants and patterns
- **[TABLE-002]** Design table component API (headers, rows, cells, sorting, etc.)
- **[TABLE-003]** Implement `Kumiki::Components::Table` class with slot-based API
- **[TABLE-004]** Create `table.html.erb` template
- **[TABLE-005]** Implement table variants (striped, bordered, hoverable, compact)
- **[TABLE-006]** Implement responsive table (horizontal scroll, stack on mobile)
- **[TABLE-007]** Implement sortable columns (visual indicators only, sorting logic separate)
- **[TABLE-008]** Implement selectable rows (checkbox column)
- **[TABLE-009]** Implement sticky header
- **[TABLE-010]** Write RSpec tests
- **[TABLE-011]** Update preview with complex table examples
- **[TABLE-012]** Create `table` helper method

**Acceptance Criteria:**

- Slot-based API: header, body, row, cell
- Variants: striped, bordered, hoverable, compact, responsive
- Sticky header support
- Sortable column indicators
- Selectable rows with checkboxes
- Mobile-responsive patterns
- 100% test coverage

---

#### Component: Pagination

**Tickets:**

- **[PAGINATION-001]** Research HyperUI pagination patterns
- **[PAGINATION-002]** Design pagination component API
- **[PAGINATION-003]** Implement `Kumiki::Components::Pagination` class
- **[PAGINATION-004]** Create `pagination.html.erb` template
- **[PAGINATION-005]** Implement page number display with ellipsis for large page counts
- **[PAGINATION-006]** Implement prev/next navigation
- **[PAGINATION-007]** Implement first/last page links
- **[PAGINATION-008]** Integrate with Rails `will_paginate` or `kaminari` (adapter pattern)
- **[PAGINATION-009]** Write RSpec tests
- **[PAGINATION-010]** Update preview
- **[PAGINATION-011]** Create `pagination` helper method

**Acceptance Criteria:**

- Works with Kaminari and will_paginate
- Responsive design (fewer page numbers on mobile)
- Accessible (ARIA labels, keyboard nav)
- Configurable page window size
- 100% test coverage

---

#### Component: Stats

**Tickets:**

- **[STATS-001]** Research HyperUI stats/metrics display patterns
- **[STATS-002]** Design stats component API
- **[STATS-003]** Implement `Kumiki::Components::Stats` class
- **[STATS-004]** Create `stats.html.erb` template
- **[STATS-005]** Implement layout variants (horizontal, vertical, grid)
- **[STATS-006]** Implement stat card with title, value, change indicator, icon
- **[STATS-007]** Write RSpec tests
- **[STATS-008]** Update preview
- **[STATS-009]** Create `stats` helper method

**Acceptance Criteria:**

- Individual stat component + stats group
- Value formatting support (currency, percentage, number)
- Trend indicators (up/down arrows with colors)
- Icon support
- Multiple layout options
- 100% test coverage

---

#### Component: Empty States

**Tickets:**

- **[EMPTY-001]** Research HyperUI empty state patterns
- **[EMPTY-002]** Design empty state component API
- **[EMPTY-003]** Implement `Kumiki::Components::EmptyState` class
- **[EMPTY-004]** Create `empty_state.html.erb` template
- **[EMPTY-005]** Implement variants (no data, no results, no access, error state)
- **[EMPTY-006]** Implement with icon, title, description, and action button slots
- **[EMPTY-007]** Write RSpec tests
- **[EMPTY-008]** Update preview
- **[EMPTY-009]** Create `empty_state` helper method

**Acceptance Criteria:**

- Slot-based: icon, title, description, actions
- Contextual variants (no data, search results, permissions, errors)
- Action button support
- 100% test coverage

---

### Epic 2.2: Navigation Components (Week 9-11)

**Objective:** Add navigation and organizational components

#### Component: Tabs

**Tickets:**

- **[TABS-001]** Research HyperUI tabs patterns
- **[TABS-002]** Design tabs component API (tab navigation + panels)
- **[TABS-003]** Implement `Kumiki::Components::Tabs` class
- **[TABS-004]** Create `tabs.html.erb` template
- **[TABS-005]** Implement Stimulus controller for tab switching
- **[TABS-006]** Implement tab variants (underlined, bordered, pills, cards)
- **[TABS-007]** Implement vertical tabs layout
- **[TABS-008]** Implement keyboard navigation (arrow keys)
- **[TABS-009]** Write RSpec tests + Stimulus tests
- **[TABS-010]** Update preview
- **[TABS-011]** Create `tabs` helper method

**Acceptance Criteria:**

- Tab navigation with active state
- Tab panels with show/hide
- Variants: underlined, bordered, pills, cards
- Keyboard navigation
- Accessible (ARIA tabs pattern)
- Turbo frame integration (optional)
- 100% test coverage

---

#### Component: Breadcrumbs

**Tickets:**

- **[BREADCRUMB-001]** Research HyperUI breadcrumb patterns
- **[BREADCRUMB-002]** Design breadcrumb component API
- **[BREADCRUMB-003]** Implement `Kumiki::Components::Breadcrumbs` class
- **[BREADCRUMB-004]** Create `breadcrumbs.html.erb` template
- **[BREADCRUMB-005]** Implement with icon separators (/, >, chevron, etc.)
- **[BREADCRUMB-006]** Implement current page highlighting
- **[BREADCRUMB-007]** Implement collapsible breadcrumbs for long paths
- **[BREADCRUMB-008]** Write RSpec tests
- **[BREADCRUMB-009]** Update preview
- **[BREADCRUMB-010]** Create `breadcrumbs` helper method

**Acceptance Criteria:**

- Array-based or block-based API
- Customizable separators
- Current page non-link
- Accessible (aria-label, aria-current)
- Responsive (collapse on mobile)
- 100% test coverage

---

#### Component: Accordions

**Tickets:**

- **[ACCORDION-001]** Research HyperUI accordion patterns
- **[ACCORDION-002]** Design accordion component API
- **[ACCORDION-003]** Implement `Kumiki::Components::Accordion` class
- **[ACCORDION-004]** Create `accordion.html.erb` template
- **[ACCORDION-005]** Implement Stimulus controller for expand/collapse
- **[ACCORDION-006]** Implement single vs multiple open items
- **[ACCORDION-007]** Implement default open/closed state
- **[ACCORDION-008]** Implement smooth animations
- **[ACCORDION-009]** Write RSpec tests + Stimulus tests
- **[ACCORDION-010]** Update preview
- **[ACCORDION-011]** Create `accordion` helper method

**Acceptance Criteria:**

- Slot-based: item with header and content
- Single open vs multiple open modes
- Smooth expand/collapse animations
- Icon indicators (chevron rotation)
- Keyboard navigation
- Accessible (ARIA accordion pattern)
- 100% test coverage

---

#### Component: Dropdowns

**Tickets:**

- **[DROPDOWN-001]** Research HyperUI dropdown patterns
- **[DROPDOWN-002]** Design dropdown component API (trigger + menu)
- **[DROPDOWN-003]** Implement `Kumiki::Components::Dropdown` class
- **[DROPDOWN-004]** Create `dropdown.html.erb` template
- **[DROPDOWN-005]** Implement Stimulus controller for open/close behavior
- **[DROPDOWN-006]** Implement positioning (bottom-left, bottom-right, top-left, top-right)
- **[DROPDOWN-007]** Implement click outside to close
- **[DROPDOWN-008]** Implement keyboard navigation (arrow keys, ESC)
- **[DROPDOWN-009]** Write RSpec tests + Stimulus tests
- **[DROPDOWN-010]** Update preview
- **[DROPDOWN-011]** Create `dropdown` helper method

**Acceptance Criteria:**

- Trigger + menu slot-based API
- Positioning options
- Click outside closes
- ESC key closes
- Keyboard navigation through items
- Accessible (ARIA menu pattern)
- 100% test coverage

---

### Epic 2.3: Feedback Components (Week 11-13)

**Objective:** Add user feedback and status indicators

#### Component: Progress Bars

**Tickets:**

- **[PROGRESS-001]** Research HyperUI progress bar patterns
- **[PROGRESS-002]** Design progress component API
- **[PROGRESS-003]** Implement `Kumiki::Components::Progress` class
- **[PROGRESS-004]** Create `progress.html.erb` template
- **[PROGRESS-005]** Implement variants (bar, circle/radial, with label, indeterminate)
- **[PROGRESS-006]** Implement color variants (success, error, warning, info)
- **[PROGRESS-007]** Implement size variants
- **[PROGRESS-008]** Implement animated progress
- **[PROGRESS-009]** Write RSpec tests
- **[PROGRESS-010]** Update preview
- **[PROGRESS-011]** Create `progress` helper method

**Acceptance Criteria:**

- Linear progress bar
- Circular/radial progress (optional)
- Percentage label display
- Indeterminate/loading state
- Color variants
- Accessible (role="progressbar", aria-valuenow)
- 100% test coverage

---

#### Component: Loaders/Spinners

**Tickets:**

- **[LOADER-001]** Research HyperUI loader/spinner patterns
- **[LOADER-002]** Design loader component API
- **[LOADER-003]** Implement `Kumiki::Components::Loader` class
- **[LOADER-004]** Create `loader.html.erb` template
- **[LOADER-005]** Implement spinner variants (circle, dots, bars, pulse)
- **[LOADER-006]** Implement size variants
- **[LOADER-007]** Implement color variants
- **[LOADER-008]** Implement fullscreen overlay loader
- **[LOADER-009]** Write RSpec tests
- **[LOADER-010]** Update preview
- **[LOADER-011]** Create `loader` helper method

**Acceptance Criteria:**

- Multiple spinner styles (circle, dots, bars)
- Size variants
- Color variants
- Inline vs overlay variants
- Loading text support
- Accessible (aria-busy, aria-live)
- 100% test coverage

---

#### Component: Toggles/Switches

**Tickets:**

- **[TOGGLE-001]** Research HyperUI toggle/switch patterns
- **[TOGGLE-002]** Design toggle component API
- **[TOGGLE-003]** Implement `Kumiki::Components::Toggle` class
- **[TOGGLE-004]** Create `toggle.html.erb` template
- **[TOGGLE-005]** Implement switch variants (default, with icons, with labels)
- **[TOGGLE-006]** Implement size variants
- **[TOGGLE-007]** Implement color variants
- **[TOGGLE-008]** Implement disabled state
- **[TOGGLE-009]** Write RSpec tests
- **[TOGGLE-010]** Update preview
- **[TOGGLE-011]** Create `toggle` helper method

**Acceptance Criteria:**

- Switch UI (not checkbox style)
- On/off states with labels
- Icon indicators (optional)
- Size and color variants
- Disabled state
- Accessible (role="switch")
- 100% test coverage

---

### Epic 2.4: Additional Application UI (Week 13-14)

**Objective:** Add remaining high-value application components

#### Components in this Epic

- **Dividers** - Simple component for section separation
- **Steps** - Step indicator for multi-step processes
- **Timelines** - Event timeline display
- **Button Groups** - Grouped button layouts
- **Filters** - Filter controls for data views
- **Quantity Input** - Number input with +/- buttons

**Note:** Each component follows similar ticket structure as above. Grouping into one epic due to simpler implementation.

#### Consolidated Tickets

- **[APPUI-001]** Implement Dividers component
- **[APPUI-002]** Implement Steps component
- **[APPUI-003]** Implement Timelines component
- **[APPUI-004]** Implement Button Groups component
- **[APPUI-005]** Implement Filters component
- **[APPUI-006]** Implement Quantity Input component
- **[APPUI-007]** Write tests for all Epic 2.4 components
- **[APPUI-008]** Update preview for all Epic 2.4 components

---

## Phase 3: Documentation & Release

**Duration:** 2 weeks
**Goal:** Comprehensive documentation, migration guide, and v0.2.0 release
**Prerequisites:** Phases 0-2 complete

For detailed breakdown of all tickets, see: `docs/migration/PHASE_3_RELEASE.md`

### Epic 3.1: Documentation (Week 15)

**Objective:** Create comprehensive documentation for v0.2.0

### Epic 3.2: Testing & QA (Week 15-16)

**Objective:** Comprehensive testing across browsers, devices, and accessibility

### Epic 3.3: Release Preparation (Week 16)

**Objective:** Version bump, gem build, publishing, announcements

---

## ~~Phase 3: New HyperUI Components - Marketing~~ (REMOVED)

> **Note:** Marketing components (headers, footers, pricing, CTAs, etc.) have been descoped from v0.2.0. Focus is on core UI and application components only. Marketing components may be added in future releases (v0.3.0+).

---

## ~~Original Phase 3: Marketing Components~~ (ARCHIVED)

<details>
<summary>Click to expand archived marketing component plans</summary>

## Phase 3: New HyperUI Components - Marketing (ARCHIVED)

**Duration:** 4-6 weeks
**Goal:** Add marketing and website-focused components from HyperUI

### Epic 3.1: Layout Components (Week 15-16)

**Objective:** Add structural marketing page components

#### Component: Headers

**Tickets:**

- **[HEADER-001]** Research HyperUI header/navigation patterns
- **[HEADER-002]** Design header component API (logo, nav items, CTA, mobile menu)
- **[HEADER-003]** Implement `Kumiki::Components::Header` class
- **[HEADER-004]** Create `header.html.erb` template
- **[HEADER-005]** Implement responsive mobile menu (hamburger → drawer)
- **[HEADER-006]** Implement Stimulus controller for mobile menu toggle
- **[HEADER-007]** Implement sticky header variant
- **[HEADER-008]** Implement transparent header variant
- **[HEADER-009]** Implement dropdown navigation items
- **[HEADER-010]** Write RSpec tests + Stimulus tests
- **[HEADER-011]** Update preview
- **[HEADER-012]** Create `header` helper method

**Acceptance Criteria:**

- Slot-based: logo, nav items, CTA buttons
- Mobile responsive with hamburger menu
- Sticky header support
- Transparent variant (for hero sections)
- Dropdown nav items
- Accessible (ARIA navigation)
- 100% test coverage

---

#### Component: Footers

**Tickets:**

- **[FOOTER-001]** Research HyperUI footer patterns
- **[FOOTER-002]** Design footer component API (columns, links, social, newsletter)
- **[FOOTER-003]** Implement `Kumiki::Components::Footer` class
- **[FOOTER-004]** Create `footer.html.erb` template
- **[FOOTER-005]** Implement multi-column layout (2, 3, 4 columns)
- **[FOOTER-006]** Implement social media icon links
- **[FOOTER-007]** Implement newsletter signup section (optional slot)
- **[FOOTER-008]** Implement copyright/legal section
- **[FOOTER-009]** Write RSpec tests
- **[FOOTER-010]** Update preview
- **[FOOTER-011]** Create `footer` helper method

**Acceptance Criteria:**

- Slot-based: logo, link columns, social links, newsletter, legal
- Responsive (stack columns on mobile)
- Social media icons
- 100% test coverage

---

### Epic 3.2: Content Components (Week 16-18)

**Objective:** Add marketing content display components

#### Component: Pricing Tables

**Tickets:**

- **[PRICING-001]** Research HyperUI pricing patterns
- **[PRICING-002]** Design pricing component API (tiers, features, CTA)
- **[PRICING-003]** Implement `Kumiki::Components::Pricing` class
- **[PRICING-004]** Create `pricing.html.erb` template
- **[PRICING-005]** Implement pricing card (individual tier)
- **[PRICING-006]** Implement pricing grid (multiple tiers)
- **[PRICING-007]** Implement featured/highlighted tier
- **[PRICING-008]** Implement billing toggle (monthly/yearly)
- **[PRICING-009]** Implement feature comparison table variant
- **[PRICING-010]** Write RSpec tests
- **[PRICING-011]** Update preview
- **[PRICING-012]** Create `pricing` helper method

**Acceptance Criteria:**

- Individual pricing card component
- Pricing grid (2-4 tiers)
- Featured tier highlighting
- Billing period toggle
- Feature list with checkmarks
- CTA button integration
- 100% test coverage

---

#### Component: CTAs (Call to Action)

**Tickets:**

- **[CTA-001]** Research HyperUI CTA patterns
- **[CTA-002]** Design CTA component API
- **[CTA-003]** Implement `Kumiki::Components::Cta` class
- **[CTA-004]** Create `cta.html.erb` template
- **[CTA-005]** Implement variants (hero, inline, section, banner)
- **[CTA-006]** Implement with background image support
- **[CTA-007]** Implement centered vs left-aligned layouts
- **[CTA-008]** Write RSpec tests
- **[CTA-009]** Update preview
- **[CTA-010]** Create `cta` helper method

**Acceptance Criteria:**

- Hero CTA (large, centered)
- Inline CTA (within content)
- Section CTA (full-width section)
- Banner CTA (top/bottom of page)
- Background image/gradient support
- Multiple button support
- 100% test coverage

---

#### Component: Feature Grids

**Tickets:**

- **[FEATURE-001]** Research HyperUI feature grid patterns
- **[FEATURE-002]** Design feature grid component API
- **[FEATURE-003]** Implement `Kumiki::Components::FeatureGrid` class
- **[FEATURE-004]** Create `feature_grid.html.erb` template
- **[FEATURE-005]** Implement grid layouts (2-col, 3-col, 4-col)
- **[FEATURE-006]** Implement feature item (icon, title, description)
- **[FEATURE-007]** Implement icon variants (background circle, outline, etc.)
- **[FEATURE-008]** Write RSpec tests
- **[FEATURE-009]** Update preview
- **[FEATURE-010]** Create `feature_grid` helper method

**Acceptance Criteria:**

- Grid with 2, 3, or 4 columns
- Feature item: icon, title, description
- Icon styling variants
- Responsive (stack on mobile)
- 100% test coverage

---

#### Component: FAQs

**Tickets:**

- **[FAQ-001]** Research HyperUI FAQ patterns
- **[FAQ-002]** Design FAQ component API (similar to accordion)
- **[FAQ-003]** Implement `Kumiki::Components::Faq` class (may extend Accordion)
- **[FAQ-004]** Create `faq.html.erb` template
- **[FAQ-005]** Implement FAQ-specific styling (question/answer structure)
- **[FAQ-006]** Implement 2-column layout option
- **[FAQ-007]** Write RSpec tests
- **[FAQ-008]** Update preview
- **[FAQ-009]** Create `faq` helper method

**Acceptance Criteria:**

- Question/answer structure
- Accordion-style expand/collapse
- Single column or 2-column layout
- Schema.org markup for SEO (optional)
- 100% test coverage

---

### Epic 3.3: E-commerce & Social (Week 18-20)

**Objective:** Add e-commerce and social proof components

#### Components in this Epic

- **Product Cards** - Product display cards with image, title, price, CTA
- **Blog Cards** - Blog post preview cards
- **Newsletter Signup** - Email capture form component
- **Testimonials/Social Proof** - Customer testimonial display
- **Logo Clouds** - Partner/client logo grids
- **Contact Forms** - Pre-styled contact form layouts

**Consolidated Tickets:**

- **[ECOM-001]** Implement Product Cards component
- **[ECOM-002]** Implement Blog Cards component
- **[ECOM-003]** Implement Newsletter Signup component
- **[ECOM-004]** Implement Testimonials component
- **[ECOM-005]** Implement Logo Clouds component
- **[ECOM-006]** Implement Contact Forms component
- **[ECOM-007]** Write tests for all Epic 3.3 components
- **[ECOM-008]** Update preview for all Epic 3.3 components

</details>

---

## ~~Original Phase 4: Documentation & Release~~ (NOW PHASE 3)

> **Note:** This content has been moved to Phase 3. See `docs/migration/PHASE_3_RELEASE.md` for the full detailed breakdown.

### Epic 4.1: Documentation (Week 21)

**Objective:** Create comprehensive documentation for v2.0

#### Tickets

- **[DOCS-001]** Update README.md with v2.0 component list and examples
- **[DOCS-002]** Create comprehensive MIGRATION_GUIDE.md (v1 → v2)
- **[DOCS-003]** Update CHANGELOG.md with all v2.0 changes
- **[DOCS-004]** Create COMPONENT_API_REFERENCE.md (all components, props, examples)
- **[DOCS-005]** Update design system documentation (DESIGN_SYSTEM.md)
- **[DOCS-006]** Update CONTRIBUTING.md with v2 component patterns
- **[DOCS-007]** Create upgrade checklist for v1 users
- **[DOCS-008]** Document all breaking changes with before/after code examples
- **[DOCS-009]** Create video walkthrough or GIF demos (optional)
- **[DOCS-010]** Update preview system with comprehensive examples

**Deliverables:**

- Updated README.md
- MIGRATION_GUIDE.md with step-by-step upgrade instructions
- CHANGELOG.md with comprehensive v2.0 notes
- COMPONENT_API_REFERENCE.md (single source of truth for all APIs)

---

### Epic 4.2: Testing & QA (Week 21-22)

**Objective:** Comprehensive testing before release

#### Tickets

- **[QA-001]** Run full RSpec test suite and ensure 100% passing
- **[QA-002]** Manual QA of all components in preview system
- **[QA-003]** Accessibility audit (WCAG 2.1 AA compliance)
- **[QA-004]** Cross-browser testing (Chrome, Firefox, Safari, Edge)
- **[QA-005]** Responsive testing (mobile, tablet, desktop breakpoints)
- **[QA-006]** Keyboard navigation testing (all interactive components)
- **[QA-007]** Screen reader testing (VoiceOver, NVDA)
- **[QA-008]** Form validation testing (all form components)
- **[QA-009]** Stimulus controller testing (modals, toasts, tabs, etc.)
- **[QA-010]** Performance testing (bundle size, component render speed)

**Acceptance Criteria:**

- All tests passing
- No accessibility violations
- Works in all major browsers
- Fully responsive
- Keyboard navigable
- Screen reader compatible

---

### Epic 4.3: Release Preparation (Week 22)

**Objective:** Prepare for v2.0.0 release

#### Tickets

- **[RELEASE-001]** Bump version to 2.0.0 in gemspec
- **[RELEASE-002]** Update dependencies in gemspec
- **[RELEASE-003]** Final review of all public APIs
- **[RELEASE-004]** Create Git tag for v2.0.0
- **[RELEASE-005]** Merge feature branch to main
- **[RELEASE-006]** Build and publish gem to RubyGems
- **[RELEASE-007]** Create GitHub release with release notes
- **[RELEASE-008]** Write release announcement blog post (optional)
- **[RELEASE-009]** Share release on social media, Reddit, Hacker News (optional)
- **[RELEASE-010]** Monitor for issues and create hotfix plan

**Deliverables:**

- Published gem on RubyGems: kumiki_rails v2.0.0
- GitHub release with comprehensive notes
- Release announcement

---

## Work Ticket Categories

When breaking down this plan into individual work tickets, use these categories:

### Ticket Types

1. **[DESIGN]** - Design system, patterns, and UX decisions
2. **[ARCH]** - Architecture, infrastructure, and tooling
3. **[ANALYSIS]** - Research, investigation, and planning
4. **[COMPONENT]** - Component implementation (prefix with component name: BTN, BADGE, etc.)
5. **[BUILDER]** - Form builder updates
6. **[HELPER]** - Helper method updates
7. **[DOCS]** - Documentation
8. **[QA]** - Testing and quality assurance
9. **[RELEASE]** - Release preparation and publishing

### Ticket Template

```markdown
## [CATEGORY-###] Ticket Title

**Epic:** Epic Name
**Phase:** Phase #
**Estimate:** X days
**Priority:** High / Medium / Low

### Description

Brief description of the work to be done.

### Acceptance Criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

### Dependencies

- Depends on: [TICKET-###]
- Blocks: [TICKET-###]

### Implementation Notes

- Note 1
- Note 2

### Testing Requirements

- Unit tests
- Integration tests
- Manual QA checklist

### Documentation

- What docs need updating?
```

---

## Success Metrics

### Quantitative Metrics

- **Component Count:** 13 → 70+ components (538% increase)
- **Test Coverage:** Maintain 100% code coverage
- **Bundle Size:** Reduce by ~30% (no DaisyUI plugin overhead)
- **Accessibility Score:** WCAG 2.1 AA compliance (100%)
- **Documentation:** 100% of components documented with examples

### Qualitative Metrics

- **Developer Experience:** Intuitive, consistent APIs across all components
- **Design Consistency:** Unified visual language across all components
- **Accessibility:** Keyboard navigable, screen reader friendly
- **Performance:** Fast component render times, minimal JavaScript

---

## Risk Mitigation

### High-Risk Areas

#### 1. API Design Inconsistency

**Risk:** With 70+ components, API inconsistencies will emerge
**Mitigation:**

- Create strict API design guidelines in Phase 0
- Code review checklist enforcing consistency
- Automated linting for component prop naming
- Regular API audits

#### 2. Scope Creep

**Risk:** 250+ HyperUI components is tempting, may try to add too much
**Mitigation:**

- Stick to prioritized tier list
- Time-box each component implementation
- Phase 2 & 3 components can ship in minor releases after v2.0

#### 3. Accessibility Gaps

**Risk:** Copy-pasting HyperUI HTML may miss accessibility requirements
**Mitigation:**

- Accessibility review for every component
- Automated a11y testing in CI
- Manual screen reader testing
- WCAG 2.1 AA compliance checklist

#### 4. Testing Gaps

**Risk:** Hard to achieve 100% coverage with 70+ components
**Mitigation:**

- Test-first development (TDD)
- Automated coverage reporting
- Required test coverage for PR merges
- Component-specific test templates

#### 5. Documentation Debt

**Risk:** Easy to ship code without documentation
**Mitigation:**

- Documentation is part of "Definition of Done"
- Preview system must include all variants
- API reference auto-generated from code where possible

---

## Next Steps

1. **Review this plan** - Gather feedback from stakeholders
2. **Create tickets** - Break down epics into individual tickets in your project management tool
3. **Set up project board** - Organize tickets into sprints/milestones
4. **Assign Phase 0 work** - Start with design system and architecture
5. **Kick off!** - Begin Phase 0 work

---

## Appendix: Component Prioritization Matrix

### Phase 1 (Must Have - v2.0.0 Launch)

✅ All 13 existing components (migration required)

### Phase 2 (Should Have - v2.0.0 Launch)

✅ Tables, Pagination, Tabs, Accordions, Dropdowns, Breadcrumbs, Progress, Loaders, Toggles, Empty States, Stats

### Phase 3 (Nice to Have - v2.1+ releases)

⚠️ Headers, Footers, Pricing, CTAs, Feature Grids, FAQs, Product Cards, Blog Cards, Testimonials, Newsletter, Contact Forms

### Future Phases (Advanced Components)

🔮 Advanced file upload (drag-drop), Custom date picker (Flatpickr), Data visualization, Advanced tables (sorting, filtering), Multi-select, Autocomplete, Rich text editor, Image cropper, Charts, Calendars

---

**Document Version:** 1.0
**Last Updated:** 2025-11-15
**Status:** Ready for Ticket Breakdown
