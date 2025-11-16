# Phase 0: Foundation & Setup

> **Duration:** 2 weeks
> **Goal:** Establish design system, architecture patterns, and development infrastructure
> **Prerequisites:** None
> **Deliverables:** Design system, base architecture, HyperUI analysis

---

## Overview

Phase 0 is the most critical phase of the migration. All subsequent work depends on the foundation established here. We're defining the design system, architectural patterns, and tooling that will guide the implementation of 70+ components.

**Key Success Criteria:**

- ✅ Comprehensive design token system documented
- ✅ Base component architecture implemented
- ✅ HyperUI patterns analyzed and documented
- ✅ Development environment ready for component migration

---

## Epic 0.1: Design System Foundation

**Objective:** Create a comprehensive design system that unifies 250+ HyperUI components

### Why This Matters

HyperUI is a collection of copy-paste snippets, not a cohesive design system. Without establishing our own design tokens, we'll end up with:

- Inconsistent spacing (some components use `p-4`, others use `p-6` for the same concept)
- Inconsistent colors (different shades of blue across components)
- Inconsistent sizing (button sizes won't match input sizes)

### Tickets

#### [DESIGN-001] Audit HyperUI component catalog and categorize by type

**Estimate:** 2 days
**Priority:** High

**Description:**
Systematically browse through all HyperUI components and create a categorized inventory. This will help us understand the full scope and identify patterns.

**Acceptance Criteria:**

- [ ] Spreadsheet or document listing all HyperUI components
- [ ] Components categorized by type (Application UI, Marketing, Forms, etc.)
- [ ] Complexity rating for each component (Simple, Medium, Complex)
- [ ] Notes on unique features or patterns
- [ ] Initial assessment of which components map to our Phase 1 components

**Implementation Notes:**

- Visit <https://www.hyperui.dev/>
- Browse each category systematically
- Take screenshots of interesting patterns
- Document any components that use JavaScript/interactivity
- Note any accessibility features

**Deliverable:** `docs/migration/HYPERUI_COMPONENT_INVENTORY.md`

---

#### [DESIGN-002] Extract and standardize color palette from HyperUI snippets

**Estimate:** 2 days
**Priority:** High
**Depends on:** [DESIGN-001]

**Description:**
Analyze HyperUI components to identify common color usage patterns. Define a semantic color system that works across all components.

**Acceptance Criteria:**

- [ ] Primary color scale defined (50-900)
- [ ] Secondary color scale defined
- [ ] Semantic colors defined (success, error, warning, info)
- [ ] Neutral/gray scale defined
- [ ] Color usage guidelines documented (when to use primary vs secondary)
- [ ] Dark mode considerations documented (if applicable)

**Implementation Notes:**

- Review HyperUI's use of Tailwind default colors
- Look for patterns: which colors for buttons, which for backgrounds, which for text
- Consider accessibility (WCAG AA contrast ratios)
- Define semantic naming: `primary-500`, `success-600`, etc.

**Suggested Color System (Tailwind v4):**

```css
@theme {
  /* Primary Color Scale (OKLCH format) */
  --color-primary-50: oklch(0.98 0.02 250);
  --color-primary-100: oklch(0.95 0.04 250);
  --color-primary-200: oklch(0.9 0.08 250);
  --color-primary-300: oklch(0.82 0.12 250);
  --color-primary-400: oklch(0.72 0.16 250);
  --color-primary-500: oklch(0.62 0.2 250);
  --color-primary-600: oklch(0.52 0.2 250);
  --color-primary-700: oklch(0.42 0.18 250);
  --color-primary-800: oklch(0.32 0.14 250);
  --color-primary-900: oklch(0.22 0.1 250);

  /* Repeat for secondary, success, error, warning, info, neutral */
  --color-secondary-500: oklch(0.62 0.2 180);
  --color-success-500: oklch(0.65 0.18 145);
  --color-error-500: oklch(0.6 0.22 25);
  --color-warning-500: oklch(0.75 0.15 85);
  --color-info-500: oklch(0.65 0.15 230);
  --color-neutral-500: oklch(0.5 0 0);
}
```

**Deliverable:** Section in `docs/DESIGN_SYSTEM.md`

---

#### [DESIGN-003] Define size scale system (xs, sm, md, lg, xl, 2xl)

**Estimate:** 1 day
**Priority:** High
**Depends on:** [DESIGN-001]

**Description:**
Create a consistent size scale that applies across all components (buttons, inputs, badges, etc.).

**Acceptance Criteria:**

- [ ] Size scale defined for heights (xs through 2xl)
- [ ] Padding scale defined for each size
- [ ] Font size scale defined for each size
- [ ] Size naming conventions documented
- [ ] Usage guidelines (when to use md vs lg)

**Implementation Notes:**

- Map to Tailwind's spacing scale where possible
- Ensure sizes are proportional and harmonious
- Consider touch targets (minimum 44x44px for mobile)

**Suggested Size Scale:**

```
xs:  h-8,  px-2,  text-xs
sm:  h-9,  px-3,  text-sm
md:  h-10, px-4,  text-base  (default)
lg:  h-11, px-6,  text-lg
xl:  h-12, px-8,  text-xl
2xl: h-14, px-10, text-2xl
```

**Deliverable:** Section in `docs/DESIGN_SYSTEM.md`

---

#### [DESIGN-004] Define spacing scale system (padding, margin, gaps)

**Estimate:** 1 day
**Priority:** High

**Description:**
Establish consistent spacing rules for component internal padding, margins, and gaps between elements.

**Acceptance Criteria:**

- [ ] Internal padding rules defined (card padding, modal padding, etc.)
- [ ] Margin/gap rules defined (spacing between form fields, etc.)
- [ ] Responsive spacing rules (mobile vs desktop)
- [ ] Spacing usage guidelines documented

**Implementation Notes:**

- Use Tailwind's default spacing scale (0, 1, 2, 3, 4, 6, 8, 12, 16, etc.)
- Define semantic spacing: "tight", "normal", "loose"
- Document when to use padding vs margin

**Deliverable:** Section in `docs/DESIGN_SYSTEM.md`

---

#### [DESIGN-005] Define typography scale (text sizes, weights, line heights)

**Estimate:** 1 day
**Priority:** Medium

**Description:**
Create a typography system for headings, body text, labels, and helper text.

**Acceptance Criteria:**

- [ ] Font family stack defined
- [ ] Heading scale defined (h1-h6)
- [ ] Body text sizes defined (sm, base, lg)
- [ ] Font weights defined (normal, medium, semibold, bold)
- [ ] Line heights defined for each text size
- [ ] Letter spacing rules (if needed)

**Implementation Notes:**

- HyperUI uses default Tailwind typography
- Consider using system font stack for performance
- Ensure good readability (line height 1.5-1.6 for body text)

**Deliverable:** Section in `docs/DESIGN_SYSTEM.md`

---

#### [DESIGN-006] Document border radius, shadow, and effect standards

**Estimate:** 1 day
**Priority:** Medium

**Description:**
Define consistent border radius and shadow usage across components.

**Acceptance Criteria:**

- [ ] Border radius scale defined (none, sm, md, lg, full)
- [ ] Shadow scale defined (sm, md, lg, xl)
- [ ] Usage guidelines (when to use shadows, which radius for which component)
- [ ] Transition/animation standards (duration, easing)

**Suggested Standards:**

```
Border Radius:
- none: 0
- sm:   0.125rem (2px)
- md:   0.375rem (6px)  (default for most components)
- lg:   0.5rem   (8px)
- xl:   0.75rem  (12px)
- full: 9999px   (pills, circular badges)

Shadows:
- sm:  Use for subtle elevation (dropdowns)
- md:  Use for cards, modals
- lg:  Use for prominent elements (popovers)
- xl:  Use sparingly for major emphasis
```

**Deliverable:** Section in `docs/DESIGN_SYSTEM.md`

---

#### [DESIGN-007] Create component variant taxonomy (solid, outline, ghost, etc.)

**Estimate:** 2 days
**Priority:** High
**Depends on:** [DESIGN-001], [DESIGN-002]

**Description:**
Define a consistent variant naming system that applies across all components.

**Acceptance Criteria:**

- [ ] Variant types defined and named (solid, outline, ghost, gradient, soft, etc.)
- [ ] Visual style defined for each variant
- [ ] Usage guidelines (when to use each variant)
- [ ] Variant naming conventions documented
- [ ] Examples of each variant

**Suggested Variants:**

```
- solid:    Filled background, solid color (primary action)
- outline:  Border only, transparent background (secondary action)
- ghost:    No border, hover effect only (tertiary action)
- gradient: Gradient background (special/premium actions)
- soft:     Light background, no border (info displays)
- link:     Text only, underline on hover (inline actions)
```

**Implementation Notes:**

- Ensure variants work with all color options (primary, secondary, etc.)
- Define how variants interact with states (hover, active, disabled)

**Deliverable:** Section in `docs/DESIGN_SYSTEM.md`

---

#### [DESIGN-008] Create Tailwind v4 theme with HyperUI-inspired design tokens

**Estimate:** 2 days
**Priority:** High
**Depends on:** [DESIGN-002] through [DESIGN-007]

**Description:**
Implement all design decisions using Tailwind v4's new CSS-first `@theme` directive as a single source of truth.

**Acceptance Criteria:**

- [ ] Main CSS file updated with `@theme` block
- [ ] Colors configured using CSS variables
- [ ] Spacing scale configured (if customized)
- [ ] Typography configured
- [ ] Border radius configured
- [ ] Shadows configured
- [ ] Breakpoints configured (if customized)
- [ ] Config tested (build succeeds, tokens accessible as CSS variables)
- [ ] Documentation referencing the theme configuration

**Implementation Notes:**

- Tailwind v4 uses CSS-first configuration with the `@theme` directive
- All customizations go in your main CSS file where you import Tailwind
- CSS variables automatically generate from `@theme` values
- Use OKLCH color space for modern, perceptually uniform colors
- **Remove `tailwind.config.js` entirely** - not needed in v4
- Namespace conventions: `--color-*`, `--font-*`, `--spacing-*`, `--breakpoint-*`

**Example Theme Configuration:**

```css
/* app/assets/stylesheets/kumiki/application.css */
@import "tailwindcss";

@theme {
  /* Color Palette - Using OKLCH for perceptually uniform colors */
  --color-primary-50: oklch(0.98 0.02 250);
  --color-primary-100: oklch(0.95 0.04 250);
  --color-primary-200: oklch(0.9 0.08 250);
  --color-primary-300: oklch(0.82 0.12 250);
  --color-primary-400: oklch(0.72 0.16 250);
  --color-primary-500: oklch(0.62 0.2 250);
  --color-primary-600: oklch(0.52 0.2 250);
  --color-primary-700: oklch(0.42 0.18 250);
  --color-primary-800: oklch(0.32 0.14 250);
  --color-primary-900: oklch(0.22 0.1 250);

  --color-secondary-50: oklch(0.98 0.02 180);
  --color-secondary-100: oklch(0.95 0.04 180);
  /* ... secondary scale ... */

  --color-success-500: oklch(0.65 0.18 145);
  --color-error-500: oklch(0.6 0.22 25);
  --color-warning-500: oklch(0.75 0.15 85);
  --color-info-500: oklch(0.65 0.15 230);

  /* Typography */
  --font-display: "Satoshi", "Inter", system-ui, sans-serif;
  --font-body: "Inter", system-ui, sans-serif;
  --font-mono: "Fira Code", "Consolas", monospace;

  /* Custom Breakpoints (if needed beyond defaults) */
  --breakpoint-3xl: 1920px;

  /* Custom Spacing (if extending beyond Tailwind defaults) */
  --spacing-18: 4.5rem;
  --spacing-88: 22rem;

  /* Border Radius */
  --radius-button: 0.375rem;
  --radius-card: 0.5rem;
  --radius-input: 0.375rem;

  /* Shadows */
  --shadow-card: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);
  --shadow-modal: 0 20px 25px -5px rgb(0 0 0 / 0.1),
    0 8px 10px -6px rgb(0 0 0 / 0.1);

  /* Animations/Easing */
  --ease-fluid: cubic-bezier(0.3, 0, 0, 1);
  --ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

/* Custom utilities using theme variables */
.btn-primary {
  background-color: var(--color-primary-600);
  color: white;
  border-radius: var(--radius-button);
  box-shadow: var(--shadow-card);
  transition: all 0.2s var(--ease-fluid);
}

.btn-primary:hover {
  background-color: var(--color-primary-700);
}
```

**Benefits of CSS-First Approach:**

- Design tokens accessible as CSS variables anywhere (JavaScript, inline styles)
- Zero-config setup (automatic content detection)
- Better IDE support and autocomplete
- Runtime access to theme values
- Smaller configuration surface area

**Deliverable:** Updated `app/assets/stylesheets/kumiki/application.css` with `@theme` block

---

### Epic 0.1 Deliverables

- ✅ `docs/DESIGN_SYSTEM.md` - Complete design system documentation
- ✅ `docs/migration/HYPERUI_COMPONENT_INVENTORY.md` - Component catalog
- ✅ `app/assets/stylesheets/kumiki/application.css` with `@theme` block containing all design tokens

---

## Epic 0.2: Architecture & Tooling Setup

**Objective:** Set up development environment and establish component architecture patterns

### Why This Matters

Without a solid architectural foundation, we'll end up with:

- Duplicated code across components
- Inconsistent component APIs
- Hard-to-maintain component classes
- Difficult testing

### Tickets

#### [ARCH-001] Create long-lived feature branch

**Estimate:** 0.5 days
**Priority:** High

**Description:**
Create a feature branch for all v2.0 work to isolate changes from main branch.

**Acceptance Criteria:**

- [ ] Branch created from latest main
- [ ] Branch protection rules configured (if using GitHub)
- [ ] Team members aware of branch strategy
- [ ] Initial commit message references migration plan

**Implementation Notes:**

```bash
git checkout main
git pull origin main
git checkout -b <your-feature-branch-name>
git push -u origin <your-feature-branch-name>
```

**Deliverable:** Feature branch in Git

---

#### [ARCH-002] Remove DaisyUI dependencies and prepare for Tailwind v4

**Estimate:** 1 day
**Priority:** High
**Depends on:** [ARCH-001]

**Description:**
Clean up all DaisyUI references and prepare codebase for Tailwind v4's CSS-first configuration.

**Acceptance Criteria:**

- [ ] DaisyUI npm package removed (if present)
- [ ] `config/tailwind.config.js` **completely removed**
- [ ] DaisyUI imports removed from CSS files
- [ ] `lib/generators/kumiki/install/templates/daisyui.js` removed or archived
- [ ] Tailwind build succeeds without DaisyUI
- [ ] No DaisyUI classes remain in component files (expected to break things)
- [ ] Prepare CSS file for `@theme` directive

**Files to Update:**

- `package.json` - Remove DaisyUI dependency
- **DELETE:** `config/tailwind.config.js` - Not used in Tailwind v4
- `app/assets/stylesheets/kumiki/application.css` - Remove DaisyUI imports, prepare for `@import "tailwindcss"`
- **DELETE:** `lib/generators/kumiki/install/templates/daisyui.js`

**Implementation Notes:**

- Components will break after this step (expected)
- This is why we work in a feature branch
- Run `bundle exec rspec` to confirm tests fail as expected
- Tailwind v4 uses CSS-only configuration - no JavaScript config file needed

**Deliverable:** Clean codebase without DaisyUI, ready for Tailwind v4

---

#### [ARCH-003] Upgrade to Tailwind CSS v4 (HyperUI requirement)

**Estimate:** 2 days
**Priority:** High
**Depends on:** [ARCH-002]

**Description:**
Upgrade Tailwind CSS to v4 to match HyperUI's requirements and adopt the new CSS-first configuration approach.

**Acceptance Criteria:**

- [ ] Tailwind CSS v4 installed via npm/yarn
- [ ] Main CSS file updated with `@import "tailwindcss"`
- [ ] Zero-config setup verified (automatic content detection working)
- [ ] Build process updated and working
- [ ] All Tailwind utilities work as expected
- [ ] CSS variables from `@theme` accessible in templates
- [ ] Documentation updated with v4 references

**Installation Steps:**

```bash
# Install Tailwind CSS v4
npm install tailwindcss@next @tailwindcss/postcss@next

# Or with yarn
yarn add tailwindcss@next @tailwindcss/postcss@next
```

**CSS File Setup:**

```css
/* app/assets/stylesheets/kumiki/application.css */
@import "tailwindcss";

/* Theme configuration will be added in DESIGN-008 */
@theme {
  /* Design tokens go here */
}
```

**Implementation Notes:**

- Tailwind v4 uses **CSS-first configuration** - no `tailwind.config.js` at all
- The `@import "tailwindcss"` directive replaces the old `@tailwind` directives
- Automatic content detection means you don't need to specify `content` paths
- CSS variables from `@theme` are automatically available everywhere
- Use the official Tailwind upgrade tool if available: `npx @tailwindcss/upgrade@next`
- Reference: <https://tailwindcss.com/blog/tailwindcss-v4>

**Key v4 Changes:**

- **Zero-config:** No `tailwind.config.js` file - everything in CSS
- **CSS-first:** Configuration via `@theme` directive in CSS
- **Automatic detection:** Content paths auto-detected
- **Native CSS variables:** All theme values exposed as `--` prefixed variables
- **OKLCH colors:** New default color space (perceptually uniform)
- **Faster builds:** Oxide engine improvements

**Testing v4 Installation:**

```bash
# Build Tailwind
bin/rails tailwindcss:build

# Verify CSS variables are available
# Check generated CSS contains your @theme values
cat public/builds/kumiki.css | grep -- "--color-"
```

**Potential Issues:**

- Some v3 utilities may have changed (check migration guide)
- Custom plugins may need updates
- Build tool integration may need adjustment
- PostCSS config may need updating

**Deliverable:** Tailwind CSS v4 running with CSS-first configuration

---

#### [ARCH-004] Configure Tailwind content scanning for Ruby component classes

**Estimate:** 1 day
**Priority:** Critical
**Depends on:** [ARCH-003]

**Description:**
Configure Tailwind CSS to scan Ruby component class files for dynamic class names. This is critical because Tailwind's JIT compiler only includes classes it can find in source files. Without proper configuration, dynamically-built classes in Ruby components won't be included in the compiled CSS.

**The Problem:**

When building classes dynamically in Ruby components like this:
```ruby
def variant_classes
  case @variant
    when :solid then "bg-#{@color}-600 text-white"
    when :outline then "border-2 border-#{@color}-600 text-#{@color}-600"
  end
end
```

Tailwind's content scanner won't see the complete class names (like `bg-primary-600`, `border-secondary-600`) because they're constructed with string interpolation. This means those classes won't be included in the final CSS.

**Acceptance Criteria:**

- [ ] Tailwind configured to scan all Ruby component files
- [ ] Content paths include `app/components/**/*.rb` (engine component files)
- [ ] Content paths include `app/views/**/*.erb` (template files)
- [ ] Documentation on writing Tailwind-safe class names in Ruby components
- [ ] Safelist approach documented for truly dynamic classes
- [ ] Build verified to include all component classes

**Solution Approaches:**

**Approach 1: Use complete class names (RECOMMENDED)**

Write classes without interpolation so Tailwind can see them:

```ruby
def variant_classes
  {
    solid: {
      primary: "bg-primary-600 text-white hover:bg-primary-700",
      secondary: "bg-secondary-600 text-white hover:bg-secondary-700"
    },
    outline: {
      primary: "border-2 border-primary-600 text-primary-600 hover:bg-primary-50",
      secondary: "border-2 border-secondary-600 text-secondary-600 hover:bg-secondary-50"
    }
  }[@variant][@color]
end
```

**Approach 2: Safelist for dynamic classes**

If you must use interpolation, safelist the patterns in your CSS:

```css
/* app/assets/stylesheets/kumiki/application.css */
@import "tailwindcss";

@theme {
  /* theme tokens */
}

/* Safelist dynamic component classes */
@source "../../../app/components/**/*.rb";
```

Or use Tailwind v4's `@source` directive to explicitly tell Tailwind where to scan.

**Implementation Notes:**

- **Critical:** Tailwind must see complete class names at build time
- String interpolation breaks Tailwind's content scanner
- Use lookup tables/maps instead of string interpolation for variants
- Document this pattern for all contributors
- Add linting/tests to catch interpolated Tailwind classes

**Content Configuration:**

In Tailwind v4, use the `@source` directive in your CSS:

```css
/* app/assets/stylesheets/kumiki/application.css */
@import "tailwindcss";

/* Scan engine component files */
@source "../../../app/components/**/*.rb";
@source "../../../app/views/**/*.erb";
@source "../../../app/helpers/**/*.rb";

@theme {
  /* theme configuration */
}
```

**Testing:**

```bash
# Build Tailwind
bin/rails tailwindcss:build

# Check that component classes are included
# Example: Search for a specific component class
cat public/builds/kumiki.css | grep "bg-primary-600"

# Verify all color variants are present
cat public/builds/kumiki.css | grep -E "bg-(primary|secondary|success|error|warning|info)-[0-9]+"
```

**Documentation to Create:**

Add section in `docs/COMPONENT_ARCHITECTURE.md`:
- ✅ "Writing Tailwind-Safe Component Classes"
- ✅ "Why String Interpolation Breaks Tailwind"
- ✅ "Variant Lookup Pattern (Best Practice)"
- ✅ "When and How to Use Safelist"

**Deliverable:** Tailwind properly configured to scan and include all component classes

---

#### [ARCH-005] Create base component class architecture (`Kumiki::BaseComponent`)

**Estimate:** 3 days
**Priority:** High

**Description:**
Design and implement an abstract base component class that all Kumiki components inherit from.

**Acceptance Criteria:**

- [ ] `app/components/kumiki/base_component.rb` created
- [ ] Common functionality extracted (class composition, slot handling, etc.)
- [ ] Documentation for base component API
- [ ] Helper methods for common patterns (variant building, size handling)
- [ ] Tests for base component

**Suggested Implementation:**

```ruby
# app/components/kumiki/base_component.rb
module Kumiki
  class BaseComponent
    # Common initialization
    def initialize(**options)
      @options = options
    end

    private

    # Build CSS classes from component options
    def build_classes(*base_classes)
      classes = base_classes.flatten.compact
      classes << variant_classes if respond_to?(:variant_classes, true)
      classes << size_classes if respond_to?(:size_classes, true)
      classes << state_classes if respond_to?(:state_classes, true)
      classes << @options[:class] if @options[:class]
      classes.join(' ')
    end

    # Extract HTML attributes
    def html_attributes
      @options.except(:variant, :size, :color, :class, :disabled, :loading)
    end

    # Merge custom HTML options
    def merge_html_options(defaults = {})
      defaults.merge(html_attributes)
    end
  end
end
```

**Implementation Notes:**

- Include helpers for common patterns (building classes, handling states)

**Deliverable:** `app/components/kumiki/base_component.rb`

---

#### [ARCH-006] Design and document component class composition patterns

**Estimate:** 2 days
**Priority:** High
**Depends on:** [ARCH-005]

**Description:**
Document the patterns for how component classes should be structured.

**Acceptance Criteria:**

- [ ] Class structure pattern documented
- [ ] Variant handling pattern documented
- [ ] State management pattern documented
- [ ] Slot pattern documented (for complex components like Card, Modal)
- [ ] Examples of simple and complex components

**Documentation Should Include:**

- How to add a new variant
- How to handle conditional rendering
- How to compose classes efficiently
- How to handle boolean props (disabled, loading, etc.)
- How to integrate with Rails form builders

**Deliverable:** Section in `docs/COMPONENT_ARCHITECTURE.md`

---

#### [ARCH-007] Design and document slot-based content patterns

**Estimate:** 2 days
**Priority:** Medium
**Depends on:** [ARCH-005]

**Description:**
Define how components with multiple content areas (Card with header/body/footer, Modal with title/content/actions) should be implemented.

**Acceptance Criteria:**

- [ ] Slot pattern defined (block-based approach)
- [ ] Examples of slot-based components
- [ ] API design for slots documented
- [ ] Testing patterns for slots documented

**Example Approaches:**

**Block-based with helper methods**

```ruby
<%= card do |c| %>
  <%= c.header { "Title" } %>
  <%= c.body { "Content" } %>
  <%= c.footer { "Actions" } %>
<% end %>
```

**Deliverable:** Section in `docs/COMPONENT_ARCHITECTURE.md`

---

#### [ARCH-008] Create component ejection generator

**Estimate:** 2 days
**Priority:** Medium

**Description:**
Create a Rails generator to copy (eject) Kumiki engine components into the host Rails application for customization. This allows users to override/customize any component while keeping the engine's default components working out of the box.

**Acceptance Criteria:**

- [ ] Generator created: `bin/rails generate kumiki:eject COMPONENT_NAME`
- [ ] Generator copies component class from engine to `app/components/kumiki/components/`
- [ ] Generator copies component template from engine to `app/views/kumiki/components/`
- [ ] Generator copies component preview from engine to `spec/components/previews/kumiki/` (if exists)
- [ ] Generator shows confirmation message with files copied
- [ ] Documentation for using the ejection generator
- [ ] Ejected components take precedence over engine components (Rails load path)

**Example Usage:**

```bash
bin/rails generate kumiki:eject button
# Copies from engine to host app:
# - app/components/kumiki/components/button.rb
# - app/views/kumiki/components/button.html.erb
# - spec/components/previews/kumiki/button_preview.rb
#
# User can now modify these files to customize the button component
```

**Implementation Notes:**

- Components work out of the box from the mounted engine (no ejection needed)
- Ejection is optional - only for users who want to customize
- Rails load path prioritizes host app over engine, so ejected components automatically override

**Deliverable:** `lib/generators/kumiki/eject/eject_generator.rb`

---

#### [ARCH-009] Set up component preview system for design review

**Estimate:** 2 days
**Priority:** High

**Description:**
Set up the component preview system for reviewing new HyperUI components during development. Each component must be reviewed in the preview system before acceptance.

**Acceptance Criteria:**

- [ ] Preview system accessible at `/kumiki/design/preview` or similar route
- [ ] Preview system can render components without errors
- [ ] Preview layout works with Tailwind v4
- [ ] Easy to add new component previews (preview class per component)
- [ ] Preview shows all component variants, sizes, and states
- [ ] Preview is responsive and can be tested at different breakpoints
- [ ] Documentation for creating preview classes

**Implementation Notes:**

- Clean up any old DaisyUI preview references
- Ensure preview works with Tailwind v4 CSS
- Each component should have a preview class showing all variations
- Preview system is the design review gate - no component is "done" until reviewed in preview

**Example Preview Structure:**

```ruby
# spec/components/previews/kumiki/button_preview.rb
module Kumiki
  class ButtonPreview < PreviewBase
    def default
      render_component Kumiki::Components::Button.new(variant: :primary) do
        "Click me"
      end
    end

    def all_variants
      # Show primary, secondary, outline, ghost, etc.
    end

    def all_sizes
      # Show xs, sm, md, lg, xl
    end

    def states
      # Show disabled, loading, etc.
    end
  end
end
```

**Deliverable:** Working preview system with documentation

---

#### [ARCH-010] Document component API design guidelines

**Estimate:** 2 days
**Priority:** High
**Depends on:** [ARCH-005], [ARCH-006], [ARCH-007]

**Description:**
Create comprehensive guidelines for designing component APIs to ensure consistency across all 70+ components.

**Acceptance Criteria:**

- [ ] Naming conventions documented (variant, color, size, etc.)
- [ ] Required vs optional props guidelines
- [ ] Boolean prop guidelines (disabled vs disabled: true)
- [ ] Block/content handling guidelines
- [ ] Accessibility prop requirements documented
- [ ] Examples of good and bad API design

**Guidelines Should Cover:**

- Consistent prop naming (`variant` not `style`, `color` not `theme`)
- How to handle size (`:xs, :sm, :md, :lg, :xl`)
- How to handle color (`:primary, :secondary, :success, etc.`)
- When to use symbols vs strings
- Default values
- Required props

**Deliverable:** `docs/COMPONENT_API_GUIDELINES.md`

---

### Epic 0.2 Deliverables

- ✅ Feature branch created
- ✅ Clean codebase (no DaisyUI)
- ✅ Tailwind CSS v4 installed
- ✅ `app/components/kumiki/base_component.rb`
- ✅ `lib/generators/kumiki/eject/eject_generator.rb` (for ejecting components to host app)
- ✅ `docs/COMPONENT_ARCHITECTURE.md`
- ✅ `docs/COMPONENT_API_GUIDELINES.md`

---

## Epic 0.3: HyperUI Component Analysis

**Objective:** Deep analysis of HyperUI patterns to inform implementation

### Why This Matters

Before writing any code, we need to understand:

- How HyperUI components are structured
- What accessibility patterns they use
- Which components need JavaScript
- How to map DaisyUI features to HyperUI

### Tickets

#### [ANALYSIS-001] Map existing 13 components to HyperUI equivalents (1:1 analysis)

**Estimate:** 3 days
**Priority:** High
**Depends on:** [DESIGN-001]

**Description:**
For each of the 13 existing DaisyUI components, find the equivalent HyperUI component and document the differences.

**Acceptance Criteria:**

- [ ] Analysis document created for all 13 components
- [ ] HyperUI equivalent identified for each component
- [ ] Feature comparison (what exists in DaisyUI but not HyperUI, and vice versa)
- [ ] HTML structure comparison
- [ ] Class differences documented
- [ ] Migration complexity rated (Easy, Medium, Hard)

**Components to Analyze:**

1. Button → HyperUI Buttons
2. Badge → HyperUI Badges
3. Card → HyperUI Cards
4. Modal → HyperUI Modals
5. Toast → HyperUI Toasts (or Alerts)
6. FormInput → HyperUI Inputs
7. FormSelect → HyperUI Selects
8. FormTextarea → HyperUI Textareas
9. FormCheckbox → HyperUI Checkboxes
10. FormRadio → HyperUI Radio Groups
11. FormFileInput → HyperUI File Uploaders
12. FormDatePicker → HyperUI Inputs (date type)
13. FormError → Custom (no direct equivalent)

**Deliverable:** `docs/COMPONENT_MAPPING.md`

---

#### [ANALYSIS-002] Document HyperUI accessibility patterns (ARIA, keyboard nav)

**Estimate:** 2 days
**Priority:** High

**Description:**
Analyze HyperUI components for accessibility features and document best practices.

**Acceptance Criteria:**

- [ ] ARIA attribute usage documented
- [ ] Keyboard navigation patterns documented
- [ ] Focus management patterns documented
- [ ] Screen reader considerations documented
- [ ] Accessibility gaps identified (areas where HyperUI is lacking)
- [ ] Accessibility improvements plan (what we need to add)

**Implementation Notes:**

- Test HyperUI components with keyboard only
- Test with screen reader (VoiceOver or NVDA)
- Check for proper ARIA roles, labels, and states
- HyperUI may not be fully accessible; we may need to enhance

**Deliverable:** Section in `docs/HYPERUI_ANALYSIS.md`

---

#### [ANALYSIS-003] Identify HyperUI interactive components requiring Stimulus

**Estimate:** 1 day
**Priority:** Medium

**Description:**
Identify which components need JavaScript behavior and plan Stimulus controller requirements.

**Acceptance Criteria:**

- [ ] List of components requiring JavaScript
- [ ] Behavior description for each interactive component
- [ ] Stimulus controller plan (new controllers needed, existing controllers to update)
- [ ] Alternative approaches considered (Alpine.js vs Stimulus)

**Components Likely Needing JS:**

- Modal (open/close, focus trap, ESC key)
- Toast (auto-dismiss, animations)
- Dropdown (open/close, click outside)
- Tabs (tab switching, keyboard nav)
- Accordion (expand/collapse)
- File Upload (drag-drop, preview)

**Deliverable:** Section in `docs/HYPERUI_ANALYSIS.md`

---

#### [ANALYSIS-004] Extract common HTML structures and patterns

**Estimate:** 2 days
**Priority:** Medium
**Depends on:** [ANALYSIS-001]

**Description:**
Identify recurring HTML patterns in HyperUI components that can be templatized.

**Acceptance Criteria:**

- [ ] Common wrapper patterns documented
- [ ] Common layout patterns documented (flex, grid usage)
- [ ] Common state patterns documented (hover, focus, disabled)
- [ ] Pattern library created for reference

**Example Patterns:**

- Input wrapper: `<div class="..."><label>...</label><input>...</input><span class="error">...</span></div>`
- Button structure: `<button class="..."><span>Icon</span><span>Text</span></button>`
- Card structure: `<div class="card"><div class="card-header">...</div><div class="card-body">...</div></div>`

**Deliverable:** Section in `docs/HYPERUI_ANALYSIS.md`

---

#### [ANALYSIS-005] Document variant differences between DaisyUI and HyperUI

**Estimate:** 2 days
**Priority:** High
**Depends on:** [ANALYSIS-001]

**Description:**
Create a comprehensive comparison of variants available in DaisyUI vs HyperUI.

**Acceptance Criteria:**

- [ ] DaisyUI variant list documented
- [ ] HyperUI variant list documented
- [ ] Gap analysis (variants that exist in DaisyUI but not HyperUI)
- [ ] New variants in HyperUI (not in DaisyUI)
- [ ] Migration recommendations (how to handle missing variants)

**Example:**

- DaisyUI Button variants: primary, secondary, accent, ghost, link, info, success, warning, error
- HyperUI Button variants: solid, outline, gradient, ghost, link
- Gap: DaisyUI has semantic color variants built-in; HyperUI is more generic

**Deliverable:** Section in `docs/HYPERUI_ANALYSIS.md`

---

#### [ANALYSIS-006] Create migration mapping guide (old API → new API)

**Estimate:** 2 days
**Priority:** High
**Depends on:** [ANALYSIS-001], [ANALYSIS-005]

**Description:**
Create a reference guide showing how to migrate from DaisyUI-based API to HyperUI-based API.

**Acceptance Criteria:**

- [ ] Before/after examples for all 13 components
- [ ] Prop mapping documented (old prop name → new prop name)
- [ ] Breaking changes highlighted
- [ ] Deprecation warnings planned (if applicable)
- [ ] Migration script considerations

**Example Mapping:**

```ruby
# Before (DaisyUI v1)
<%= button(variant: :primary, size: :lg) { "Save" } %>

# After (HyperUI v2)
<%= button(variant: :solid, color: :primary, size: :lg) { "Save" } %>
```

**Deliverable:** `docs/BREAKING_CHANGES.md`

---

### Epic 0.3 Deliverables

- ✅ `docs/COMPONENT_MAPPING.md` - DaisyUI → HyperUI component mapping
- ✅ `docs/HYPERUI_ANALYSIS.md` - Comprehensive HyperUI analysis
- ✅ `docs/BREAKING_CHANGES.md` - API migration guide

---

## Phase 0 Success Checklist

Before moving to Phase 1, ensure:

- [ ] All Phase 0 tickets completed
- [ ] Design system documented and Tailwind config updated
- [ ] Base component architecture implemented and tested
- [ ] Component ejection generator working (allows users to customize components)
- [ ] HyperUI components analyzed and documented
- [ ] Team alignment on approach and architecture
- [ ] Preview environment ready for new components

---

## Phase 0 Timeline

**Week 1:**

- Epic 0.1: Design System Foundation (all tickets)
- Epic 0.2: ARCH-001, ARCH-002, ARCH-003

**Week 2:**

- Epic 0.2: ARCH-004 through ARCH-010
- Epic 0.3: All analysis tickets

**Total:** 2 weeks

---

## Next Phase

Once Phase 0 is complete, proceed to **Phase 1: Core Component Migration** where we'll migrate all 13 existing components from DaisyUI to HyperUI.

📄 See: `docs/migration/PHASE_1_CORE_COMPONENTS.md`
