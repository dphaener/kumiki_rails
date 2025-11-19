---
work_package_id: WP02
title: "Variant Comparison Analysis"
subtasks: [T011, T012, T013, T014, T015, T016, T017]
lane: done
priority: P1
estimated_effort: "3-4 hours"
dependencies: [WP01]
history:
  - action: created
    date: 2025-11-19
    lane: planned
---

# Work Package: Variant Comparison Analysis

## Objective

Create comprehensive `variant-comparison.md` document comparing variant availability between DaisyUI and HyperUI across all 13 components. Document gaps (variants in DaisyUI but not HyperUI), new opportunities (variants in HyperUI but not DaisyUI), and provide recommendations for handling missing variants.

**Deliverable**: `sekkei-specs/001-hyperui-component-migration/variant-comparison.md`

## Context

Variants are style variations of components (color, size, style, state). Understanding variant differences is critical for API design decisions. DaisyUI uses semantic variants (primary, secondary, success, error), while HyperUI may use more utility-focused approaches.

**Variant Categories**:
- **Color**: primary, secondary, accent, success, warning, error, info, ghost, link
- **Size**: xs, sm, md, lg, xl
- **Style**: outline, filled, ghost, minimal
- **State**: active, disabled, loading, focus

**Dependencies**: Requires WP01 complete to know which components to analyze and their mapping types.

## Detailed Guidance

### Phase 1: Collect Current DaisyUI Variants (T011)

**T011: List DaisyUI variants from code** [PARALLEL per component]

For each of the 13 components:

1. **Review Kumiki implementation** in `lib/kumiki/components/`
2. **Extract variant API**:
   - Look for `variant:` parameter and its accepted values
   - Look for `size:` parameter and its accepted values
   - Look for state handling (disabled, loading, active)
   - Look for style variations (outline, ghost, filled)

3. **Document in structured format**:
   ```
   Component: Button
   Color variants: :primary, :secondary, :accent, :ghost, :link, :info, :success, :warning, :error
   Size variants: :xs, :sm, :md, :lg
   Style variants: :outline
   State variants: :disabled, :loading
   ```

4. **Categorize each variant** by type (color/size/style/state)

**Key Components with Likely Many Variants**:
- Button (most complex variant system)
- Badge (color variants)
- FormInput/FormSelect/FormTextarea (size, state variants)

**Components with Likely Few/No Variants**:
- Card (structural, not variant-heavy)
- FormError (likely just displays, no variants)

### Phase 2: Research HyperUI Equivalent Variants (T012)

**T012: Research HyperUI variants** [PARALLEL per component]

For each component:

1. **Navigate to HyperUI equivalent** (from WP01 mapping)
2. **Explore available examples**:
   - HyperUI shows multiple visual examples per component
   - Each example may represent a "variant" (even if not explicitly named as such)
3. **Identify variant patterns**:
   - Color variations: Look for different background colors, text colors, border colors
   - Size variations: Look for different padding, text sizes
   - Style variations: Look for outline vs filled, minimal vs bold
   - State variations: Check if examples show hover, focus, disabled states

4. **Document HyperUI variants**:
   ```
   Component: Button (HyperUI)
   Color approaches: Uses Tailwind color utilities (bg-blue-600, bg-red-600, etc.) - not semantic names
   Size approaches: Uses padding utilities (px-3 py-1, px-4 py-2, px-5 py-3)
   Style approaches: Shows outline (border + bg-transparent), filled (bg-color), minimal (text-only)
   State approaches: Uses hover:, focus:, disabled: Tailwind variants
   ```

**Important Note**: HyperUI does NOT use semantic variant names like DaisyUI. Instead, it shows examples with utility classes. Your job is to identify the underlying pattern/philosophy.

### Phase 3: Create Variant Availability Matrix (T013)

**T013: Build comparison matrix**

Create a matrix for each component showing variant availability:

| Variant Name | Variant Type | DaisyUI Available | HyperUI Available | Notes |
|--------------|--------------|-------------------|-------------------|-------|
| primary | color | Yes | Utility-based (bg-blue-600) | Semantic → Utility mapping needed |
| secondary | color | Yes | Utility-based (bg-gray-600) | Semantic → Utility mapping needed |
| success | color | Yes | Utility-based (bg-green-600) | Semantic → Utility mapping needed |
| outline | style | Yes | Yes (border + bg-transparent) | Direct equivalent |
| xs | size | Yes | Utility-based (px-2 py-1 text-xs) | Utility mapping needed |

Create a matrix for each component that has variants (likely 8-10 components).

### Phase 4: Identify Gaps and Opportunities (T014-T015)

**T014: Identify variant gaps**

List variants that exist in DaisyUI but have no clear HyperUI equivalent or pattern:
- **Example Gap**: DaisyUI Button has `:link` variant (button styled as link) - does HyperUI show this pattern?
- **Example Gap**: DaisyUI has `:loading` state variant - does HyperUI demonstrate loading states?

For each gap:
1. Document which component is affected
2. Explain the gap (what DaisyUI provides that HyperUI doesn't show)
3. Assess impact (critical for user experience, nice-to-have, rarely used)

**T015: Identify new opportunities**

List patterns/variants in HyperUI that don't exist in current DaisyUI implementation:
- **Example**: HyperUI may show button patterns with icons that DaisyUI doesn't
- **Example**: HyperUI may demonstrate size variants (2xl, 3xl) beyond DaisyUI's range

For each opportunity:
1. Document which component
2. Describe the new pattern
3. Assess value (should we add this to our API? nice-to-have?)

### Phase 5: Document Philosophy Differences (T016)

**T016: Variant philosophy comparison**

Write 2-3 paragraphs explaining the fundamental difference in variant approaches:

**DaisyUI Philosophy**:
- Semantic variant names (primary, success, error map to meaning)
- Pre-defined component classes (btn-primary applies specific colors)
- Abstraction layer over Tailwind
- Easier API but less flexibility

**HyperUI Philosophy**:
- Utility-first approach (direct Tailwind classes: bg-blue-600, px-4, py-2)
- No semantic abstraction layer
- More flexibility, more verbose
- Requires mapping semantic intent to utility classes

**Migration Implications**:
- How will we handle semantic → utility mapping?
- Should we create a semantic layer on top of HyperUI utilities?
- How do we maintain API simplicity while using utility classes?

### Phase 6: Write Recommendations (T017)

**T017: Create variant-comparison.md**

Structure the final deliverable:

```markdown
# Variant Comparison: DaisyUI vs HyperUI

## Overview

[Summary of findings - how many components have variants, philosophy differences, key gaps discovered]

## Variant Philosophy Comparison

[2-3 paragraphs from T016 explaining semantic vs utility approaches]

## Variant Availability by Component

### Button

**DaisyUI Variants**:
- Color: primary, secondary, accent, ghost, link, info, success, warning, error
- Size: xs, sm, md, lg
- Style: outline
- State: disabled, loading

**HyperUI Patterns**:
- Color: Utility-based (bg-blue-600, bg-red-600, etc.)
- Size: Utility-based (px-3 py-1, px-4 py-2, etc.)
- Style: Examples show outline, filled, minimal patterns
- State: Utility-based (hover:, focus:, disabled:)

**Variant Matrix**:
[Include matrix from T013]

**Gaps**:
- [List any gaps from T014]

**New Opportunities**:
- [List any opportunities from T015]

[Repeat for all components with variants]

## Variant Gap Summary

### Critical Gaps
[Gaps that would significantly impact user experience or API usability]

### Minor Gaps
[Gaps that are nice-to-have but not critical]

### Recommendations for Handling Gaps
[How to handle missing variants - custom utility combinations, keeping DaisyUI patterns, etc.]

## New Variant Opportunities

[Should we expose new HyperUI patterns as variants in our API?]

## Migration Recommendations

1. **Semantic Mapping Strategy**: [How to map DaisyUI semantic variants to HyperUI utilities]
2. **API Design Guidance**: [Should we maintain semantic API or expose utilities?]
3. **Variant Prioritization**: [Which variants are most important to preserve?]
4. **Custom Implementation**: [Which gaps require custom utility combinations?]

## References

- DaisyUI Variants: https://daisyui.com/docs/themes/
- HyperUI Examples: https://www.hyperui.dev/
- Tailwind Utilities: https://tailwindcss.com/docs
```

## Definition of Done

- [ ] All 13 components analyzed for DaisyUI variants
- [ ] All 13 components analyzed for HyperUI variant patterns
- [ ] Variant availability matrices created for all components with variants
- [ ] Variant gaps identified and documented
- [ ] New variant opportunities identified and documented
- [ ] Variant philosophy differences explained
- [ ] Recommendations for handling gaps provided
- [ ] `variant-comparison.md` created in feature directory
- [ ] Independent test executed successfully

## Success Criteria Addressed

- ✅ SC-008: Variant comparison documents 100% of DaisyUI variants
- ✅ FR-016: All DaisyUI variants listed
- ✅ FR-017: All HyperUI variants listed
- ✅ FR-018: Variant gaps identified
- ✅ FR-019: New HyperUI variants identified
- ✅ FR-020: Migration recommendations for missing variants

## Testing Strategy

**Independent Test**:
1. Count DaisyUI variants documented - should cover all components
2. Verify HyperUI patterns documented for each component
3. Check that each gap has impact assessment and recommendation
4. Verify recommendations section provides actionable migration guidance

## Risks & Mitigations

**Risk**: HyperUI's utility-first approach makes variant comparison non-obvious
- **Mitigation**: Focus on identifying *patterns* in HyperUI examples rather than named variants. Document the philosophy difference explicitly.

**Risk**: May discover significant gaps that complicate migration
- **Mitigation**: Document all gaps with severity and recommendations. Flag critical gaps for stakeholder decision.

## Notes

- HyperUI doesn't use semantic variant names - you must infer patterns from utility classes
- Focus on commonly used variants (primary, secondary, success, error, sm, md, lg) for detailed analysis
- Rare variants (accent, ghost, link) can have lighter analysis if HyperUI patterns unclear
- This analysis informs API design for the migration - take time to think through semantic → utility mapping


## Activity Log

- **2025-11-19T20:50:53Z** | darinhaener | for_review → done | APPROVED: Deliverable meets all quality standards
- **2025-11-19T16:34:28Z** | darinhaener | doing → for_review | Completed variant comparison analysis with semantic-to-utility mapping strategy
- **2025-11-19T16:30:22Z** | darinhaener | planned → doing | Started variant comparison analysis
