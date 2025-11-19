# kumiki_rails - Sekkei Development Guidelines

Auto-generated from Sekkei initialization. Last updated: 2025-11-19

**Project**: kumiki_rails
**Mission**: software_development
**AI Assistant**: claude

## Sekkei Workflow

This project follows specification-driven development:

1. **/sekkei.specify** - Create feature specifications in `sekkei-specs/`
2. **/sekkei.plan** - Generate implementation plans with architecture decisions
3. **/sekkei.tasks** - Break down features into work packages and subtasks
4. **/sekkei.implement** - Execute tasks using generated prompts
5. **/sekkei.review** - Review completed work for quality
6. **/sekkei.accept** - Validate and merge features

### Workflow Details

**Specification Phase**:
- Define WHAT (functionality) and WHY (value) without HOW (implementation)
- Focus on user scenarios and acceptance criteria
- Document requirements, assumptions, and constraints
- Output: `sekkei-specs/###-feature/spec.md`

**Planning Phase**:
- Design architecture and technical approach
- Make technology and pattern decisions
- Document rationale with evidence
- Output: `plan.md`, `contracts/`, optional `research.md`

**Task Breakdown**:
- Decompose into independently testable work packages
- Create detailed prompts for each work package
- Define dependencies and execution order
- Output: `tasks.md` and `tasks/planned/WP##-*.md`

**Implementation**:
- Follow Kanban workflow: planned → doing → for_review → done
- Move work package prompts through lanes as you progress
- Commit after each lane transition
- Output: Working code, passing tests

## File Structure

```
kumiki_rails/
├── .sekkei/
│   ├── templates/           # Markdown templates for workflows
│   ├── scripts/             # Workflow automation scripts
│   │   ├── bash/            # Bash workflow scripts
│   │   └── powershell/      # PowerShell workflow scripts
│   └── memory/
│       └── constitution.md  # Project principles
├── sekkei-specs/            # Feature specifications
│   └── ###-feature/
│       ├── spec.md          # Feature specification
│       ├── plan.md          # Implementation plan
│       ├── tasks.md         # Work breakdown
│       ├── contracts/       # API contracts and interfaces
│       ├── research/        # Technical research (optional)
│       │   ├── evidence-log.csv
│       │   └── source-register.csv
│       └── tasks/           # Kanban lanes
│           ├── planned/     # Ready to start
│           ├── doing/       # In progress
│           ├── for_review/  # Awaiting review
│           └── done/        # Complete
├── .claude/commands/        # Claude Code slash commands
└── .worktrees/              # Git worktrees for parallel features
```

## Development Guidelines

### Software Development Standards

- **Test-Driven Development**: Write tests before implementation
- **Comprehensive Testing**: Unit, integration, and end-to-end tests
- **Documentation**: Document public APIs and complex logic
- **Semantic Versioning**: Follow semver for releases
- **Atomic Commits**: Keep commits focused and well-described
- **Code Review**: All work packages reviewed before merging

### Git Workflow

- **Feature Branches**: One branch per feature (e.g., `003-feature-name`)
- **Worktrees**: Use `.worktrees/` for parallel development
- **Commit Messages**: Clear, descriptive, with context
- **Lane Transitions**: Commit when moving work packages between lanes
- **Pull Requests**: Review before merging to main

### Task Management

Work packages follow this lifecycle:

1. **planned** - Work package prompt created, ready to start
2. **doing** - Implementation in progress
3. **for_review** - Implementation complete, awaiting validation
4. **done** - Reviewed and accepted

Move prompts between lanes by relocating the markdown file:
```bash
# Start work package
mv tasks/planned/WP01-name.md tasks/doing/

# Complete work package
mv tasks/doing/WP01-name.md tasks/for_review/

# Accept after review
mv tasks/for_review/WP01-name.md tasks/done/
```

## Common Commands

### Bash

```bash
# Create new feature
.sekkei/scripts/bash/setup-spec.sh "feature-name"

# Generate plan
.sekkei/scripts/bash/setup-plan.sh "###-feature-name"

# Break down tasks
.sekkei/scripts/bash/setup-tasks.sh "###-feature-name"

# Start implementation
.sekkei/scripts/bash/setup-implement.sh "###-feature-name"

# Update agent context
.sekkei/scripts/bash/update-agent-context.sh
```

### Git Commands

```bash
# List active feature worktrees
git worktree list

# Create new worktree for feature
git worktree add .worktrees/###-feature-name ###-feature-name

# Remove worktree after merging
git worktree remove .worktrees/###-feature-name
```

## Constitution

Project-specific principles and standards are defined in `.sekkei/memory/constitution.md`.

**Core Principles** (Updated 2025-11-19):
1. **Accessibility First**: WCAG 2.1 AA compliance is non-negotiable
2. **Semantic API, Utility Implementation**: Semantic props map to Tailwind utilities internally
3. **Progressive Enhancement**: Components work without JavaScript where possible
4. **Documentation-Driven Development**: Specifications before implementation (Sekkei workflow)
5. **Consistent Variant System**: Standard color/size/style options across all components

**Architecture Standards**:
- Ruby component architecture (inspired by ViewComponent)
- Tailwind CSS utility-first approach (no custom CSS)
- Stimulus controllers for JavaScript enhancements
- Native HTML elements preferred over custom implementations

**Code Style**:
- Ruby: Follow standard style guide, use `option` DSL for props
- ERB: Keep templates focused on structure, logic in component methods
- JavaScript: Stimulus conventions (camelCase), document controller API

**Testing Requirements**:
- Minimum 90% coverage for component classes
- 100% coverage for critical accessibility paths (ARIA, keyboard, error states)
- Unit, integration, and accessibility tests required
- Manual testing: keyboard navigation, screen reader, color contrast

Use `/sekkei.constitution` to update these as the project evolves.

## Context Updates

This file should be updated when:
- New architectural patterns are introduced
- Project conventions change
- New workflows or commands are added
- Testing or quality standards are updated

Run `.sekkei/scripts/{bash|powershell}/update-agent-context.{sh|ps1}` to refresh this context.

---

<!-- MANUAL ADDITIONS START -->
<!-- Add project-specific context below this line -->

## Component Library Standards

### Kumiki Rails Component Architecture

Kumiki Rails is a Ruby component library for building UI components with these design principles:

1. **Semantic API with Utility Implementation**
   - Public API uses semantic props: `color: :primary`, `size: :lg`, `style: :filled`
   - Internal implementation generates Tailwind utility classes
   - Allows custom class injection via `class:` option

2. **Accessibility First (WCAG 2.1 AA)**
   - All components meet WCAG 2.1 Level AA standards
   - Keyboard navigation fully supported (Tab, Shift+Tab, Enter, Escape, Arrow keys)
   - ARIA attributes managed automatically
   - Screen reader tested (VoiceOver, NVDA)
   - Focus management explicit for modals and complex interactions

3. **Progressive Enhancement**
   - Components work without JavaScript where possible
   - Stimulus controllers enhance functionality, don't enable it
   - Native HTML elements preferred (dialog, select, input)

4. **Consistent Variant System**
   - Standard options: `color`, `size`, `style` (where applicable)
   - Semantic colors: neutral, primary, secondary, accent, info, success, warning, error
   - Size scale: xs, sm, md, lg, xl
   - Style variants: filled, outline, ghost, soft, link, dash

5. **HyperUI-Inspired Design**
   - Utility-first Tailwind CSS composition
   - Modern, flexible component styling
   - No CSS framework dependency (pure Tailwind)

### Component Migration Context

The library is currently migrating from DaisyUI to HyperUI-based components (Feature 001):

**Status**: Analysis phase complete (WP07 validation passed), ready for implementation

**Documentation Location**: `sekkei-specs/001-hyperui-component-migration/`

**Key Documents**:
- `component-mapping.md` - DaisyUI → HyperUI mapping for all 13 components
- `accessibility-analysis.md` - WCAG 2.1 AA requirements and gap analysis
- `html-patterns.md` - Reusable structural patterns and conventions
- `variant-comparison.md` - Color/size/style variant mappings
- `migration-guide.md` - Implementation strategy and phasing
- `components/*.md` - 13 component-specific migration guides
- `validation-report.md` - WP07 quality validation (ALL SUCCESS CRITERIA PASSED)

### Component Development Workflow

When working on Kumiki components:

1. **Check Analysis Documentation**: Review component-specific doc in `sekkei-specs/001-.../components/[component].md`
2. **Follow Accessibility Patterns**: Reference `accessibility-analysis.md` for ARIA requirements
3. **Use HTML Patterns**: Reference `html-patterns.md` for structural conventions
4. **Map Variants**: Reference `variant-comparison.md` for color/size/style mappings
5. **Test Accessibility**: Run keyboard navigation and screen reader tests
6. **Document Changes**: Update component documentation with examples

### Key File Locations

- **Component Source**: `lib/kumiki/components/`
- **Component Views**: `app/views/kumiki/components/`
- **Analysis Docs**: `sekkei-specs/001-hyperui-component-migration/`
- **Constitution**: `.sekkei/memory/constitution.md` (accessibility and API principles)
- **This File**: `CLAUDE.md` (agent context and guidelines)

### Testing Expectations

All components must have:
- Unit tests for prop variations (90% minimum coverage)
- Integration tests for rendering
- Accessibility tests (keyboard, ARIA, color contrast) - 100% coverage for critical paths
- Visual regression tests (when applicable)

### Common Component Patterns

**Button Example**:
```ruby
class Button < Kumiki::Component
  option :color, default: -> { :primary }
  option :size, default: -> { :md }
  option :style, default: -> { :filled }
  option :class, default: -> { "" }

  COLORS = {
    primary: {
      filled: "bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500",
      outline: "border border-blue-600 text-blue-600 hover:bg-blue-600 hover:text-white"
    }
  }.freeze

  def button_classes
    [base_classes, color_classes, size_classes, options[:class]].join(" ")
  end
end
```

**Form Input Example with Accessibility**:
```ruby
class FormInput < Kumiki::Component
  option :error, default: -> { false }
  option :required, default: -> { false }
  option :field_id

  def aria_attributes
    {
      "aria-required": required,
      "aria-invalid": error,
      "aria-describedby": error ? "#{field_id}_error" : nil
    }.compact
  end
end
```

**Modal with Stimulus Controller**:
```html
<dialog data-controller="modal" data-action="keydown->modal#handleKeydown">
  <div class="modal-content">
    <h2 id="modal-title">Modal Title</h2>
    <p id="modal-description">Modal content</p>
    <form method="dialog">
      <button>Close</button>
    </form>
  </div>
</dialog>
```

### Implementation Phases (From Migration Guide)

1. **Phase 1: Foundation** (1 week) - Theme system, variant concern, sizing module
2. **Phase 2: Easy Components** (2 weeks) - Button, Badge, Card, form inputs
3. **Phase 3: Medium Components** (1.5 weeks) - Modal, Toast, FileInput
4. **Phase 4: Hard Components** (1 week) - DatePicker, FormError
5. **Phase 5: Accessibility & Testing** (1.5 weeks) - Priority 1 enhancements, comprehensive testing

### Critical Accessibility Requirements

**From validation-report.md - Priority 1 (Must Do Before Launch)**:
1. Implement Modal focus trap (Stimulus controller with Tab event handling)
2. Implement Modal focus return (store trigger element, restore on close)
3. Add Radio/Checkbox fieldset grouping (wrap in `<fieldset>` with `<legend>`)
4. Enhance Button loading state (add `aria-busy="true"` and visually hidden text)
5. Implement Form error focus management (focus first invalid field on submit)
6. Add File input selection announcement (`aria-live="polite"` status region)
7. Document Date picker strategy (recommend native `<input type="date">`)
8. Enhance Toast role selection (`role="alert"` for errors, `role="status"` for info)

**Total Effort**: 9.5 days for critical accessibility features

### Migration Status Summary

- **Components Analyzed**: 13/13 (100%)
- **Deliverables Created**: 18 documents (5 overview + 13 component-specific)
- **Success Criteria Met**: 12/12 (100%)
- **Functional Requirements**: 26/26 (100%)
- **Quality Rating**: EXCELLENT (5/5 across all categories)
- **Overall Status**: ANALYSIS COMPLETE - READY FOR IMPLEMENTATION

<!-- MANUAL ADDITIONS END -->
