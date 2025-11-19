# Phase 2: New HyperUI Components - Application UI

> **Duration:** 6-8 weeks
> **Goal:** Add essential application UI components from HyperUI catalog
> **Prerequisites:** Phase 1 complete
> **Deliverables:** ~35 new application UI components

---

## Overview

Phase 2 expands Kumiki with application-focused components from HyperUI. These are components typically used in dashboards, admin panels, and data-heavy applications.

**Component Categories:**
1. **Data Display** (Tables, Pagination, Stats, Empty States)
2. **Navigation** (Tabs, Breadcrumbs, Accordions, Dropdowns)
3. **Feedback** (Progress Bars, Loaders, Toggles)
4. **Additional UI** (Dividers, Steps, Timelines, Button Groups, Filters, Quantity Input)

**Key Success Criteria:**
- ✅ ~35 new components implemented
- ✅ All components follow Phase 1 architecture patterns
- ✅ 100% test coverage
- ✅ Full documentation and previews
- ✅ **All components reviewed and approved in preview system before acceptance**

**Design Review Process:**
Each component has a preview ticket that includes design review as an acceptance criterion. No component is considered "done" until:
1. Preview page created showing all variants and states
2. Component reviewed in preview system (visual design, responsiveness, accessibility)
3. Component approved and matches HyperUI design intent

---

## Epic 2.1: Data Display Components (Week 7-9)

**Objective:** Add components for displaying tabular and structured data

### Component: Table

**Complexity:** High (most complex component in Phase 2)
**Tickets:** [TABLE-001] through [TABLE-012] (12 tickets)

#### Key Features:
- Slot-based API (header, body, row, cell)
- Variants: striped, bordered, hoverable, compact, responsive
- Sticky header support
- Sortable column indicators (visual only, sorting logic separate)
- Selectable rows with checkboxes
- Mobile-responsive patterns (horizontal scroll or stacked)

#### Proposed API:
```ruby
table(striped: false, bordered: true, hoverable: true, compact: false) do |t|
  t.header do |h|
    h.cell("Name", sortable: true)
    h.cell("Email")
    h.cell("Role")
    h.cell("Actions", class: "text-right")
  end

  t.body do |b|
    @users.each do |user|
      b.row(selectable: true, data: { id: user.id }) do |r|
        r.cell(user.name)
        r.cell(user.email)
        r.cell(badge(user.role, color: :primary))
        r.cell do
          button("Edit", variant: :ghost, size: :sm)
        end
      end
    end
  end
end
```

#### Implementation Tickets:
- **[TABLE-001]** Research HyperUI table variants and patterns (1 day)
- **[TABLE-002]** Design table component API (headers, rows, cells, sorting, etc.) (2 days)
- **[TABLE-003]** Implement `Kumiki::Components::Table` class with slot-based API (3 days)
- **[TABLE-004]** Create `table.html.erb` template (2 days)
- **[TABLE-005]** Implement table variants (striped, bordered, hoverable, compact) (2 days)
- **[TABLE-006]** Implement responsive table (horizontal scroll, stack on mobile) (2 days)
- **[TABLE-007]** Implement sortable columns (visual indicators only) (1 day)
- **[TABLE-008]** Implement selectable rows (checkbox column) (2 days)
- **[TABLE-009]** Implement sticky header (1 day)
- **[TABLE-010]** Write RSpec tests (3 days)
- **[TABLE-011]** Update preview with complex table examples (1 day)
- **[TABLE-012]** Create `table` helper method (0.5 days)

**Total Estimate:** ~20 days (3-4 weeks)

---

### Component: Pagination

**Complexity:** Medium
**Tickets:** [PAGINATION-001] through [PAGINATION-011] (11 tickets)

#### Key Features:
- Page number display with ellipsis for large page counts
- Prev/next navigation
- First/last page links
- Integration with Rails pagination gems (Kaminari, will_paginate)
- Responsive design (fewer page numbers on mobile)

#### Proposed API:
```ruby
pagination(
  current_page: 5,
  total_pages: 20,
  url: -> (page) { users_path(page: page) },
  window: 2,               # Pages before/after current
  show_first_last: true,
  show_prev_next: true
)

# Or with Kaminari/will_paginate integration:
pagination(@users)
```

**Total Estimate:** ~10 days (2 weeks)

---

### Component: Stats

**Complexity:** Low-Medium
**Tickets:** [STATS-001] through [STATS-009] (9 tickets)

#### Key Features:
- Individual stat component
- Stats group/grid
- Value formatting support (currency, percentage, number)
- Trend indicators (up/down arrows with colors)
- Icon support

#### Proposed API:
```ruby
stats(layout: :grid, columns: 4) do |s|
  s.stat(
    title: "Total Revenue",
    value: "$45,231.89",
    change: "+20.1%",
    trend: :up,
    icon: "heroicon-currency-dollar"
  )

  s.stat(
    title: "Active Users",
    value: "1,234",
    change: "+15%",
    trend: :up
  )
end
```

**Total Estimate:** ~6 days (1-1.5 weeks)

---

### Component: Empty States

**Complexity:** Low
**Tickets:** [EMPTY-001] through [EMPTY-009] (9 tickets)

#### Key Features:
- Variants for different contexts (no data, no search results, no permissions, error)
- Slots: icon, title, description, actions
- Icon/illustration support

#### Proposed API:
```ruby
empty_state(
  icon: "heroicon-inbox",
  title: "No results found",
  description: "Try adjusting your search or filter to find what you're looking for.",
  variant: :search
) do |e|
  e.actions do
    button("Clear filters", variant: :outline)
  end
end
```

**Total Estimate:** ~5 days (1 week)

---

## Epic 2.2: Navigation Components (Week 9-11)

**Objective:** Add navigation and organizational components

### Component: Tabs

**Complexity:** Medium-High (Stimulus controller required)
**Tickets:** [TABS-001] through [TABS-011] (11 tickets)

#### Key Features:
- Tab navigation with active state
- Tab panels with show/hide behavior
- Variants: underlined, bordered, pills, cards
- Vertical tabs layout
- Keyboard navigation (arrow keys, home/end)
- Turbo frame integration (optional)

#### Proposed API:
```ruby
tabs(variant: :underlined, active: "profile") do |t|
  t.tab("profile", "Profile") do
    # Profile content
  end

  t.tab("settings", "Settings") do
    # Settings content
  end

  t.tab("notifications", "Notifications") do
    # Notifications content
  end
end
```

**Total Estimate:** ~12 days (2-2.5 weeks)

---

### Component: Breadcrumbs

**Complexity:** Low
**Tickets:** [BREADCRUMB-001] through [BREADCRUMB-010] (10 tickets)

#### Key Features:
- Array-based or block-based API
- Customizable separators (/, >, chevron)
- Current page highlighted (non-link)
- Responsive (collapse on mobile with dropdown)

#### Proposed API:
```ruby
# Array-based
breadcrumbs([
  { text: "Home", url: root_path },
  { text: "Products", url: products_path },
  { text: "Electronics" }  # Current page (no url)
], separator: :chevron)

# Block-based
breadcrumbs(separator: :chevron) do |b|
  b.item("Home", root_path)
  b.item("Products", products_path)
  b.item("Electronics")
end
```

**Total Estimate:** ~6 days (1-1.5 weeks)

---

### Component: Accordions

**Complexity:** Medium (Stimulus controller required)
**Tickets:** [ACCORDION-001] through [ACCORDION-011] (11 tickets)

#### Key Features:
- Single open vs multiple open modes
- Default open/closed state
- Smooth expand/collapse animations
- Icon indicators (chevron rotation)
- Keyboard navigation

#### Proposed API:
```ruby
accordion(mode: :single, default_open: "item-1") do |a|
  a.item("item-1", title: "What is your return policy?") do
    "You can return any item within 30 days..."
  end

  a.item("item-2", title: "Do you ship internationally?") do
    "Yes, we ship worldwide..."
  end
end
```

**Total Estimate:** ~12 days (2-2.5 weeks)

---

### Component: Dropdowns

**Complexity:** Medium-High (Stimulus controller required)
**Tickets:** [DROPDOWN-001] through [DROPDOWN-011] (11 tickets)

#### Key Features:
- Trigger + menu slot-based API
- Positioning (bottom-left, bottom-right, top-left, top-right, auto)
- Click outside closes
- ESC key closes
- Keyboard navigation through items (up/down arrows)

#### Proposed API:
```ruby
dropdown(position: :bottom_right) do |d|
  d.trigger do
    button("Options", icon_right: "heroicon-chevron-down")
  end

  d.menu do |m|
    m.item("Edit", url: edit_path)
    m.item("Duplicate", url: duplicate_path)
    m.divider
    m.item("Delete", url: delete_path, method: :delete, class: "text-red-600")
  end
end
```

**Total Estimate:** ~13 days (2-3 weeks)

---

## Epic 2.3: Feedback Components (Week 11-13)

**Objective:** Add user feedback and status indicators

### Component: Progress Bars

**Complexity:** Low-Medium
**Tickets:** [PROGRESS-001] through [PROGRESS-011] (11 tickets)

#### Key Features:
- Linear progress bar
- Circular/radial progress (optional)
- Percentage label display
- Indeterminate/loading state
- Color variants
- Size variants

#### Proposed API:
```ruby
progress(
  value: 65,
  max: 100,
  variant: :linear,        # :linear, :circle
  color: :primary,
  size: :md,
  show_label: true,
  indeterminate: false
)
```

**Total Estimate:** ~7 days (1-1.5 weeks)

---

### Component: Loaders/Spinners

**Complexity:** Low
**Tickets:** [LOADER-001] through [LOADER-011] (11 tickets)

#### Key Features:
- Multiple spinner styles (circle, dots, bars, pulse)
- Size and color variants
- Inline vs overlay variants
- Loading text support

#### Proposed API:
```ruby
loader(
  variant: :circle,        # :circle, :dots, :bars, :pulse
  size: :md,
  color: :primary,
  text: "Loading...",
  overlay: false           # true for fullscreen overlay
)
```

**Total Estimate:** ~6 days (1-1.5 weeks)

---

### Component: Toggles/Switches

**Complexity:** Low-Medium
**Tickets:** [TOGGLE-001] through [TOGGLE-011] (11 tickets)

#### Key Features:
- Switch UI (not checkbox style)
- On/off states with labels
- Icon indicators (optional)
- Size and color variants
- Disabled state

#### Proposed API:
```ruby
toggle(
  name: "notifications",
  checked: true,
  label: "Enable notifications",
  size: :md,
  color: :primary,
  show_icons: true,        # Show checkmark/x icons
  disabled: false
)
```

**Total Estimate:** ~7 days (1-1.5 weeks)

---

## Epic 2.4: Additional Application UI (Week 13-14)

**Objective:** Add remaining high-value application components

### Components in this Epic:

1. **Dividers** - Simple component for section separation
2. **Steps** - Step indicator for multi-step processes
3. **Timelines** - Event timeline display
4. **Button Groups** - Grouped button layouts
5. **Filters** - Filter controls for data views
6. **Quantity Input** - Number input with +/- buttons

**Complexity:** All Low-Medium
**Total Tickets:** ~40 tickets (6-7 tickets per component average)

#### Consolidated Timeline:
- **[APPUI-001]** Implement Dividers component (2 days)
- **[APPUI-002]** Implement Steps component (4 days)
- **[APPUI-003]** Implement Timelines component (5 days)
- **[APPUI-004]** Implement Button Groups component (3 days)
- **[APPUI-005]** Implement Filters component (5 days)
- **[APPUI-006]** Implement Quantity Input component (3 days)
- **[APPUI-007]** Write tests for all Epic 2.4 components (4 days)
- **[APPUI-008]** Update preview for all Epic 2.4 components (2 days)

**Total Estimate:** ~28 days (4-5 weeks)

---

## Phase 2 Component Summary

| Epic | Components | Tickets | Estimated Duration |
|------|------------|---------|-------------------|
| 2.1 Data Display | 4 components (Table, Pagination, Stats, Empty States) | ~40 tickets | 3-4 weeks |
| 2.2 Navigation | 4 components (Tabs, Breadcrumbs, Accordions, Dropdowns) | ~43 tickets | 3-4 weeks |
| 2.3 Feedback | 3 components (Progress, Loaders, Toggles) | ~33 tickets | 2-3 weeks |
| 2.4 Additional UI | 6 components (Dividers, Steps, Timelines, Button Groups, Filters, Quantity) | ~40 tickets | 2 weeks |
| **TOTAL** | **~17 components** | **~156 tickets** | **6-8 weeks** |

---

## Phase 2 Success Checklist

Before moving to Phase 3 (Documentation & Release), ensure:

- [ ] All components implemented and tested
- [ ] All RSpec tests passing (100% coverage)
- [ ] Stimulus controllers working for interactive components
- [ ] Preview system showcasing all components
- [ ] Helper methods created for all components
- [ ] Documentation complete for all components
- [ ] Accessibility audit passed
- [ ] Components follow Phase 1 architecture patterns

---

## Phase 2 Timeline

**Week 7-9:** Epic 2.1 - Data Display Components
**Week 9-11:** Epic 2.2 - Navigation Components
**Week 11-13:** Epic 2.3 - Feedback Components
**Week 13-14:** Epic 2.4 - Additional Application UI

**Total:** 6-8 weeks

---

## Next Phase

Once Phase 2 is complete, proceed to **Phase 3: Documentation & Release** where we'll polish, test, and release Kumiki Rails v0.2.0.

📄 See: `docs/migration/PHASE_3_RELEASE.md`
