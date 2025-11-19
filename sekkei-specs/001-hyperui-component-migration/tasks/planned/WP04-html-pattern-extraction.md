---
work_package_id: WP04
title: "HTML Pattern Extraction"
subtasks: [T028, T029, T030, T031, T032, T033, T034]
lane: planned
priority: P2
estimated_effort: "2-3 hours"
dependencies: [WP01]
history:
  - action: created
    date: 2025-11-19
    lane: planned
---

# Work Package: HTML Pattern Extraction

## Objective

Create `html-patterns.md` documenting reusable HTML structural patterns from HyperUI components. Extract common wrapper patterns, layout patterns, state patterns, and Tailwind CSS conventions that can be reused across multiple components.

**Deliverable**: `sekkei-specs/001-hyperui-component-migration/html-patterns.md`

## Context

Rather than treating each component in isolation, identify common patterns used across 3+ components. This enables consistent implementation and reduces duplication. Focus on structural patterns, not component-specific details.

**Pattern Categories** (need at least 3 per SC-007):
1. **Wrapper patterns**: Structural nesting (form field: label + input + error)
2. **Layout patterns**: Flexbox and grid conventions
3. **State patterns**: Interactive states (hover, focus, disabled, active)
4. **Structure patterns**: Semantic HTML usage

## Detailed Guidance

### Phase 1: Analyze Structural Patterns (T028-T030) [PARALLEL]

**T028: Form field wrapper patterns**

Analyze HyperUI form components (input, select, textarea) for common structure:

**Typical form field pattern**:
```html
<div class="[wrapper classes]">
  <label for="field-id" class="[label classes]">Label Text</label>
  <input id="field-id" class="[input classes]" />
  <span class="[error classes]" id="field-error">Error message</span>
  <span class="[help classes]">Help text</span>
</div>
```

Document:
- Wrapper element and classes
- Label positioning and classes
- Input classes
- Error message pattern
- Help text pattern
- Which components use this pattern

**T029: Card/container patterns**

Analyze HyperUI card examples for common structure:

**Typical card pattern**:
```html
<div class="[outer wrapper]">
  <div class="[header]">Header content</div>
  <div class="[body]">Body content</div>
  <div class="[footer]">Footer content</div>
</div>
```

Document:
- Wrapper classes
- Header/body/footer structure
- Padding/spacing conventions
- Which components use this pattern

**T030: Modal/dialog patterns**

Analyze HyperUI modal examples for common structure:

**Typical modal pattern**:
```html
<div class="[overlay]" aria-hidden="true">
  <div class="[dialog wrapper]" role="dialog" aria-modal="true">
    <div class="[dialog header]">...</div>
    <div class="[dialog body]">...</div>
    <div class="[dialog footer]">...</div>
  </div>
</div>
```

Document:
- Overlay structure and classes
- Dialog positioning
- Header/body/footer structure
- Close button placement

### Phase 2: Analyze Layout Patterns (T031) [PARALLEL]

**T031: Layout patterns**

Look across HyperUI components for common layout approaches:

**Flexbox patterns**:
- Horizontal spacing: `flex gap-2`, `flex gap-4`
- Vertical stacking: `flex flex-col gap-4`
- Alignment: `flex items-center`, `flex justify-between`
- Responsive: `flex flex-col md:flex-row`

**Grid patterns**:
- Form layouts: `grid grid-cols-1 md:grid-cols-2 gap-4`
- Card grids: `grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6`

**Spacing conventions**:
- Small gaps: `gap-1`, `gap-2` (4px, 8px)
- Medium gaps: `gap-4`, `gap-6` (16px, 24px)
- Large gaps: `gap-8`, `gap-12` (32px, 48px)

Document patterns with examples and which components use them.

### Phase 3: Analyze State Patterns (T032) [PARALLEL]

**T032: State patterns**

Look across HyperUI components for state handling:

**Hover states**:
- `hover:bg-gray-100` (subtle hover for interactive elements)
- `hover:bg-blue-700` (darker shade for buttons)
- `hover:underline` (links)

**Focus states**:
- `focus:outline-none focus:ring-2 focus:ring-blue-500` (accessible focus indicator)
- `focus:border-blue-500` (input focus)

**Disabled states**:
- `disabled:opacity-50 disabled:cursor-not-allowed`
- `disabled:bg-gray-100`

**Active states**:
- `active:bg-blue-800` (button press)

**Error states**:
- `border-red-500 text-red-600` (invalid input)

Document which patterns are used consistently and which components apply them.

### Phase 4: Extract Tailwind Conventions (T033)

**T033: Tailwind class conventions**

Identify consistent Tailwind usage patterns:

**Spacing**:
- Padding: `px-4 py-2` (horizontal + vertical)
- Margin: `mb-4`, `mt-6`
- Gap: `gap-4` (flexbox/grid spacing)

**Colors**:
- Primary actions: `bg-blue-600 text-white`
- Secondary actions: `bg-gray-200 text-gray-800`
- Destructive: `bg-red-600 text-white`
- Success: `bg-green-600 text-white`

**Typography**:
- Sizes: `text-sm`, `text-base`, `text-lg`
- Weight: `font-medium`, `font-semibold`
- Leading: `leading-tight`, `leading-normal`

**Borders**:
- Radius: `rounded`, `rounded-md`, `rounded-lg`
- Width: `border`, `border-2`
- Color: `border-gray-300`

**Shadows**:
- Subtle: `shadow-sm`
- Standard: `shadow-md`
- Prominent: `shadow-lg`

### Phase 5: Create Deliverable (T034)

**T034: Write html-patterns.md**

Structure:

```markdown
# HTML Patterns: HyperUI Components

## Overview

[Summary of patterns discovered - how many categories, most common patterns]

## Pattern Catalog

### Form Field Wrapper Pattern

**Category**: Wrapper
**Used by**: FormInput, FormSelect, FormTextarea, FormCheckbox, FormRadio, FormFileInput, FormDatePicker
**Description**: Standard structure for form fields with label, input, error, and help text

**Structure**:
```html
[Example HTML]
```

**Classes Breakdown**:
- Wrapper: [list classes and their purpose]
- Label: [list classes]
- Input: [list classes]
- Error: [list classes]

**Variations**:
- [Note any variations across components]

---

[Repeat for each pattern discovered]

## Layout Patterns

### Flexbox Horizontal Layout

**Description**: [Purpose]
**Example**:
```html
<div class="flex items-center gap-4">
  ...
</div>
```
**Used by**: [Component list]
**Spacing conventions**: [gap-2, gap-4, gap-6 usage]

---

[Repeat for each layout pattern]

## State Patterns

### Hover States

**Approach**: Tailwind `hover:` variant
**Common patterns**:
- Buttons: `hover:bg-{color}-700` (darken)
- Links: `hover:underline`
- Cards: `hover:shadow-lg`

**Used by**: [Component list]

---

[Repeat for each state type]

## Tailwind CSS Conventions

### Spacing Scale

**Padding**: `px-{n} py-{n}` where n ∈ {1,2,3,4,6,8}
**Common combinations**:
- Small: `px-2 py-1`
- Medium: `px-4 py-2`
- Large: `px-6 py-3`

### Color Palette

**Semantic mappings** (recommendations):
- Primary: `bg-blue-600`
- Secondary: `bg-gray-600`
- Success: `bg-green-600`
- Warning: `bg-yellow-500`
- Error/Danger: `bg-red-600`
- Info: `bg-cyan-600`

### Typography Combinations

[Document common text-size + font-weight + leading combinations]

## Pattern Usage Matrix

| Pattern | Button | Badge | Card | Modal | Toast | Forms |
|---------|--------|-------|------|-------|-------|-------|
| Form wrapper | - | - | - | - | - | Yes |
| Flexbox layout | Yes | Yes | Yes | Yes | Yes | Yes |
| Hover states | Yes | - | Yes | - | - | - |
[etc.]

## Implementation Recommendations

1. **Use patterns consistently**: [Guidance]
2. **Adapt patterns carefully**: [When to deviate]
3. **Component composition**: [How patterns combine]

## References

- HyperUI Components: https://www.hyperui.dev/
- Tailwind CSS Utilities: https://tailwindcss.com/docs
```

## Definition of Done

- [ ] At least 3 pattern categories documented (wrapper, layout, state minimum)
- [ ] Each pattern has example HTML and class breakdown
- [ ] Tailwind conventions extracted and documented
- [ ] Pattern usage matrix shows which components use which patterns
- [ ] `html-patterns.md` created in feature directory
- [ ] Independent test executed successfully

## Success Criteria Addressed

- ✅ SC-007: Common HTML patterns documented for at least 3 categories
- ✅ FR-013: Common wrapper patterns documented
- ✅ FR-014: Common layout patterns documented
- ✅ FR-015: Common state patterns documented

## Testing Strategy

**Independent Test**:
1. Select 3 random HyperUI components
2. Verify their HTML structures match documented patterns
3. Verify Tailwind class conventions are consistently applied in examples

## Notes

- Focus on patterns used across 3+ components (not component-specific)
- This informs consistent implementation in WP05 (component deep-dives)
- Patterns discovered here should become project standards (noted for constitution update in WP07)
