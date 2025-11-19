---
description: "Data model for component migration analysis"
---

# Data Model

This document defines the entities and relationships discovered during research for the HyperUI component migration analysis.

## Core Entities

### Component

Represents a UI component that needs to be analyzed and migrated.

**Attributes**:
- `name` (string): Component name (e.g., "Button", "FormInput")
- `category` (enum): Component category - "basic" | "form" | "interactive" | "feedback"
- `daisyui_reference` (string): Reference to current DaisyUI implementation
- `hyperui_reference` (string): Reference to HyperUI equivalent or "N/A"
- `migration_complexity` (enum): "easy" | "medium" | "hard"
- `has_variants` (boolean): Whether the component supports style variants
- `requires_javascript` (boolean): Whether component needs interactive behavior
- `accessibility_critical` (boolean): Whether component has significant a11y requirements

**Relationships**:
- Has many `Variant` (0..*)
- Has many `AccessibilityPattern` (0..*)
- Has one `HTMLPattern` (1)
- Has one `MigrationMapping` (1)

**Instances** (13 total):
1. Button (basic, has_variants, accessibility_critical)
2. Badge (basic, has_variants)
3. Card (basic)
4. Modal (interactive, requires_javascript, accessibility_critical)
5. Toast (feedback, requires_javascript, accessibility_critical)
6. FormInput (form, accessibility_critical)
7. FormSelect (form, requires_javascript, accessibility_critical)
8. FormTextarea (form, accessibility_critical)
9. FormCheckbox (form, accessibility_critical)
10. FormRadio (form, accessibility_critical)
11. FormFileInput (form, requires_javascript, accessibility_critical)
12. FormDatePicker (form, requires_javascript, accessibility_critical)
13. FormError (feedback, accessibility_critical)

---

### Variant

Represents a style variation of a component (e.g., color, size, state).

**Attributes**:
- `name` (string): Variant name (e.g., "primary", "large", "outline")
- `type` (enum): "color" | "size" | "style" | "state"
- `daisyui_available` (boolean): Available in DaisyUI
- `hyperui_available` (boolean): Available in HyperUI
- `custom_implementation_needed` (boolean): Requires custom CSS/classes

**Relationships**:
- Belongs to `Component`

**Examples**:
- Button variants: primary, secondary, accent, ghost, link, outline, sm, md, lg
- FormInput variants: bordered, filled, error, disabled

---

### HTMLPattern

Represents common HTML structure patterns used across components.

**Attributes**:
- `pattern_name` (string): Descriptive name for the pattern
- `category` (enum): "wrapper" | "layout" | "state" | "structure"
- `description` (text): Explanation of the pattern
- `tailwind_classes` (array): Common Tailwind CSS classes used
- `daisyui_example` (text): Example HTML from DaisyUI
- `hyperui_example` (text): Example HTML from HyperUI

**Relationships**:
- Belongs to `Component` (primary component exemplifying this pattern)
- References many `Component` (components that use this pattern)

**Expected Patterns**:
- Form field wrapper (label + input + error span)
- Flexbox layout patterns
- State classes (hover, focus, disabled, active)
- Card/container structure
- Modal overlay + dialog structure

---

### AccessibilityPattern

Represents accessibility requirements and implementations for components.

**Attributes**:
- `pattern_name` (string): Name of a11y pattern (e.g., "Modal Focus Trap")
- `aria_attributes` (array): Required ARIA attributes
- `keyboard_navigation` (text): Keyboard interaction requirements
- `focus_management` (text): Focus handling requirements
- `screen_reader_notes` (text): Screen reader considerations
- `daisyui_implementation` (enum): "complete" | "partial" | "missing"
- `hyperui_implementation` (enum): "complete" | "partial" | "missing" | "unknown"
- `gap_severity` (enum): "critical" | "moderate" | "minor" | "none"

**Relationships**:
- Belongs to `Component`

**Examples**:
- Modal: role="dialog", aria-modal="true", focus trap, ESC key handling
- Button: role="button", accessible name, focus visible
- FormInput: aria-label or label association, aria-invalid, aria-describedby for errors

---

### MigrationMapping

Represents the migration path from DaisyUI to HyperUI for a specific component.

**Attributes**:
- `component_name` (string): Name of component being migrated
- `mapping_type` (enum): "direct" | "adapted" | "custom" | "gap"
- `api_changes` (text): Description of API/prop changes
- `structural_changes` (text): HTML structure differences
- `css_changes` (text): Tailwind class changes
- `before_example` (code): Current DaisyUI implementation example
- `after_example` (code): Proposed HyperUI implementation example
- `migration_notes` (text): Additional migration considerations

**Relationships**:
- Belongs to `Component` (1:1)

---

### StimulusController

Represents JavaScript controllers needed for interactive components.

**Attributes**:
- `controller_name` (string): Stimulus controller name
- `purpose` (text): What behavior the controller provides
- `targets` (array): Stimulus targets needed
- `actions` (array): Stimulus actions/events
- `values` (array): Stimulus values for configuration
- `implementation_status` (enum): "exists" | "needs_update" | "needs_creation"

**Relationships**:
- Serves many `Component` (components using this controller)

**Expected Controllers**:
- Modal controller (open/close, focus trap, backdrop click)
- Toast controller (show/hide, auto-dismiss, positioning)
- Dropdown controller (if Select needs custom UI)
- FilePicker controller (file selection UI)
- DatePicker controller (calendar UI)

---

## Entity Relationships Diagram

```
Component (13 instances)
  ├── has many Variant (0..*)
  ├── has many AccessibilityPattern (0..*)
  ├── has one HTMLPattern (1)
  ├── has one MigrationMapping (1)
  └── uses many StimulusController (0..*)

HTMLPattern
  └── used by many Component

StimulusController
  └── serves many Component
```

---

## Analysis Deliverables Map

This data model supports the following documentation outputs:

| Deliverable | Primary Entities Used |
|-------------|----------------------|
| component-mapping.md | Component, MigrationMapping |
| accessibility-analysis.md | Component, AccessibilityPattern |
| html-patterns.md | HTMLPattern, Component |
| variant-comparison.md | Component, Variant |
| migration-guide.md | Component, MigrationMapping, Variant |
| components/*.md | All entities (component-specific view) |

---

## Data Collection Strategy

For each of the 13 components, the analysis will populate:

1. **Component entity** - Basic metadata and categorization
2. **Variant entities** - All variants in DaisyUI and HyperUI
3. **HTMLPattern entity** - Structural patterns used
4. **AccessibilityPattern entities** - All a11y requirements
5. **MigrationMapping entity** - Complete migration guide
6. **StimulusController entities** - JS requirements (if interactive)

This structured approach ensures comprehensive coverage across all analysis dimensions.
