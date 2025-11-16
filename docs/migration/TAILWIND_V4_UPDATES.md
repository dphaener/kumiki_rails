# Tailwind v4 Configuration Updates

This document summarizes the changes made to the migration plan to reflect Tailwind CSS v4's new CSS-first configuration approach.

## What Changed

Tailwind CSS v4 (released January 22, 2025) introduced a fundamental shift from JavaScript-based configuration (`tailwind.config.js`) to CSS-first configuration using the `@theme` directive.

## Key Differences: v3 vs v4

### Tailwind v3 (Old Approach)
```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          500: '#3b82f6',
          900: '#1e3a8a'
        }
      }
    }
  }
}
```

### Tailwind v4 (New Approach)
```css
/* app/assets/stylesheets/kumiki/application.css */
@import "tailwindcss";

@theme {
  --color-primary-50: oklch(0.98 0.02 250);
  --color-primary-500: oklch(0.62 0.20 250);
  --color-primary-900: oklch(0.22 0.10 250);
}
```

## Updated Documents

### 1. PHASE_0_FOUNDATION.md

**Ticket [DESIGN-008]:**
- **Before:** "Create Tailwind config with HyperUI-inspired design tokens"
- **After:** "Create Tailwind v4 theme with HyperUI-inspired design tokens"
- Added comprehensive `@theme` directive examples
- Added OKLCH color space examples
- Added CSS variable usage examples
- Noted that `tailwind.config.js` is now optional

**Ticket [ARCH-002]:**
- Updated to mention removing/preparing for v4 config-less approach
- Added note about CSS-first configuration

**Ticket [ARCH-003]:**
- Completely rewritten for Tailwind v4 installation
- Added `@import "tailwindcss"` directive
- Added zero-config explanation
- Added CSS variable testing examples
- Added v4-specific installation commands

**Epic 0.1 Deliverables:**
- Changed from `config/tailwind.config.js` to `app/assets/stylesheets/kumiki/application.css` with `@theme` block

**Epic 0.2 Deliverables:**
- Added "Tailwind CSS v4 installed with CSS-first @theme configuration"

### 2. HYPERUI_MIGRATION_PLAN.md

**Epic 0.1 Deliverables:**
- Updated to reflect `@theme` block in CSS file instead of JavaScript config

**Epic 0.2 Deliverables:**
- Added Tailwind v4 installation note

## Benefits of Tailwind v4 CSS-First Approach

1. **Zero Configuration:** No need to specify content paths; automatic content detection
2. **CSS Variables Everywhere:** All theme values exposed as native CSS custom properties
3. **Runtime Access:** Can use theme values in JavaScript and inline styles
4. **OKLCH Colors:** Perceptually uniform color space for better color consistency
5. **Simpler Setup:** Just `@import "tailwindcss"` and you're done
6. **Better IDE Support:** CSS variables have better autocomplete support
7. **No JavaScript Config:** Completely eliminates `tailwind.config.js`

## Migration Impact

### For Developers:
- Learn `@theme` directive syntax
- Use OKLCH color format instead of hex/rgb
- Understand CSS variable naming conventions (`--color-*`, `--font-*`, etc.)
- **Delete `tailwind.config.js`** - not used in Kumiki v2

### For the Migration:
- Phase 0 tickets updated with v4-specific instructions
- All example code uses `@theme` instead of JavaScript config
- Documentation reflects CSS-first approach throughout

## Resources

- [Tailwind CSS v4 Blog Post](https://tailwindcss.com/blog/tailwindcss-v4)
- [Tailwind CSS v4 Alpha Announcement](https://tailwindcss.com/blog/tailwindcss-v4-alpha)
- [OKLCH Color Picker](https://oklch.com/)

## Example: Complete Kumiki Theme

```css
/* app/assets/stylesheets/kumiki/application.css */
@import "tailwindcss";

@theme {
  /* Primary Color Palette */
  --color-primary-50: oklch(0.98 0.02 250);
  --color-primary-100: oklch(0.95 0.04 250);
  --color-primary-200: oklch(0.90 0.08 250);
  --color-primary-300: oklch(0.82 0.12 250);
  --color-primary-400: oklch(0.72 0.16 250);
  --color-primary-500: oklch(0.62 0.20 250);
  --color-primary-600: oklch(0.52 0.20 250);
  --color-primary-700: oklch(0.42 0.18 250);
  --color-primary-800: oklch(0.32 0.14 250);
  --color-primary-900: oklch(0.22 0.10 250);

  /* Semantic Colors */
  --color-success-500: oklch(0.65 0.18 145);
  --color-error-500: oklch(0.60 0.22 25);
  --color-warning-500: oklch(0.75 0.15 85);
  --color-info-500: oklch(0.65 0.15 230);

  /* Typography */
  --font-display: "Satoshi", "Inter", system-ui, sans-serif;
  --font-body: "Inter", system-ui, sans-serif;

  /* Custom Spacing */
  --spacing-18: 4.5rem;

  /* Border Radius */
  --radius-button: 0.375rem;
  --radius-card: 0.5rem;

  /* Shadows */
  --shadow-card: 0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1);

  /* Custom Breakpoint */
  --breakpoint-3xl: 1920px;

  /* Animations */
  --ease-fluid: cubic-bezier(0.3, 0, 0, 1);
}

/* Custom component utilities using theme variables */
.btn-primary {
  background-color: var(--color-primary-600);
  color: white;
  border-radius: var(--radius-button);
  transition: all 0.2s var(--ease-fluid);
}

.btn-primary:hover {
  background-color: var(--color-primary-700);
}
```

## Usage in Components

With v4's CSS variables, you can now use theme values anywhere:

```erb
<!-- In ERB templates -->
<div style="color: var(--color-primary-500)">Custom color</div>

<!-- In Tailwind classes (automatic) -->
<div class="bg-primary-500 text-white">Uses @theme colors</div>
```

```javascript
// In JavaScript
const primaryColor = getComputedStyle(document.documentElement)
  .getPropertyValue('--color-primary-500');
```

---

**Date Updated:** 2025-11-16
**Updated By:** Migration Plan v1.1
