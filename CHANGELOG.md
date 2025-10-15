# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2025-10-14

### Added

#### Components
- **UI Components**:
  - Button component with multiple variants (primary, secondary, accent, ghost, link, info, success, warning, error)
  - Badge component for status indicators and tags with size and outline options
  - Card component for content containers with title and actions support
  - Modal component for accessible dialog overlays
  - Toast component for temporary notifications with auto-dismiss functionality

- **Form Components**:
  - Text input component with label and error handling
  - Textarea component for multi-line text input
  - Select component for dropdown menus
  - Checkbox component for boolean selections
  - Radio button component for mutually exclusive options
  - Date picker component for date selection
  - File input component for file uploads

#### Form Builder
- Custom `ApplicationFormBuilder` extending `ActionView::Helpers::FormBuilder`
- Automatic error message display for all form fields
- DaisyUI styling for all form inputs
- Support for labels, placeholders, help text, and validation
- Option to set as default form builder via configuration

#### Infrastructure
- Rails Engine architecture for easy integration
- Install generator (`rails generate kumiki_rails:install`) with:
  - Automatic Tailwind configuration for engine paths
  - Importmap setup for Stimulus controllers
  - DaisyUI plugin configuration
  - Initializer creation
- Component preview system for development
- Stimulus controllers for interactive components:
  - Auto-dismiss controller for toasts
  - Dismiss controller for closeable elements
  - Slide controller for animations
  - Hello controller (example)

#### Styling & Assets
- Tailwind CSS 4.x integration
- DaisyUI component library integration
- Propshaft asset pipeline support
- Responsive design support
- Dark mode ready with DaisyUI themes

#### Documentation
- Comprehensive README with quick start guide
- Component API documentation
- Troubleshooting guide
- Configuration examples
- Usage examples for all components
- Contributing guidelines
- GitHub issue and PR templates

#### Testing
- Comprehensive RSpec test suite with 646+ examples
- 100% test coverage
- CI/CD pipeline with GitHub Actions
- Rubocop linting configuration

### Requirements

- Ruby >= 3.2.0
- Rails >= 8.0.0
- Tailwind CSS (via tailwindcss-rails gem >= 4.0.0)
- Stimulus (via stimulus-rails gem >= 1.0)
- Turbo (via turbo-rails gem >= 2.0)
- Importmap (via importmap-rails gem >= 1.0)
- Propshaft >= 0.8.0

### Known Limitations

- **Rails Version**: Rails 8.0+ only (no Rails 7 backport in this release)
- **Asset Pipeline**: Importmap required for Stimulus controllers (webpack/esbuild support coming)
- **Preview System**: Requires manual route mounting in host application
- **Browser Support**: Modern browsers only (Chrome 90+, Firefox 88+, Safari 14+, Edge 90+)
- **Mobile**: Touch interactions on some components may need additional testing

### Breaking Changes

- N/A (initial release)

### Migration Notes

This is the first release extracted from the `rails_starter` template. If you're migrating from the template:

1. Remove component files from `app/components/` in your app
2. Remove form builder from `app/forms/` in your app
3. Install the gem: `bundle add kumiki_rails`
4. Run the install generator: `bin/rails generate kumiki_rails:install`
5. Update your views to use the new component helpers
6. Test thoroughly as some component APIs may have changed

## Release Information

### v0.1.0 - Alpha Release

This is an **alpha release** intended for early adopters and testing. While the components are production-ready and well-tested, the API may evolve based on community feedback.

**What's Stable:**
- Core component rendering
- Form builder functionality
- DaisyUI integration
- Rails 8 compatibility

**What May Change:**
- Component method signatures
- Configuration options
- Helper method names
- Install generator behavior

**Feedback Welcome:**
We encourage you to try Rails Components and provide feedback through:
- GitHub Issues: https://github.com/darinhaener/kumiki_rails/issues
- GitHub Discussions: https://github.com/darinhaener/kumiki_rails/discussions

**Roadmap to v1.0.0:**
- Additional components (navbar, dropdown, breadcrumbs, pagination)
- Rails 7 backport support
- Webpack/esbuild asset pipeline support
- Theme customization DSL
- Component generator for creating custom components
- Storybook-style component documentation
- Performance optimizations
- Accessibility audit and improvements

---

[Unreleased]: https://github.com/darinhaener/kumiki_rails/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/darinhaener/kumiki_rails/releases/tag/v0.1.0
