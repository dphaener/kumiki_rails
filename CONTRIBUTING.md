# Contributing to Rails Components

First off, thank you for considering contributing to Rails Components! It's people like you that make Rails Components such a great tool for the Rails community.

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to [darin.haener@hey.com](mailto:darin.haener@hey.com).

## How Can I Contribute?

### Reporting Bugs

This section guides you through submitting a bug report for Rails Components. Following these guidelines helps maintainers and the community understand your report, reproduce the behavior, and find related reports.

**Before Submitting A Bug Report:**

- Check the [troubleshooting section](README.md#troubleshooting) in the README
- Search the [issue tracker](https://github.com/darinhaener/kumiki_rails/issues) to see if the problem has already been reported
- If you find a closed issue that seems to describe the same problem, open a new issue and include a link to the original issue

**How Do I Submit A Good Bug Report?**

Bugs are tracked as [GitHub issues](https://github.com/darinhaener/kumiki_rails/issues). Create an issue and provide the following information by filling out [the bug report template](.github/ISSUE_TEMPLATE/bug_report.md):

- **Use a clear and descriptive title** for the issue
- **Describe the exact steps to reproduce the problem** with as many details as possible
- **Provide specific examples** to demonstrate the steps
- **Describe the behavior you observed** and what you expected to see
- **Include your environment details**:
  - Rails version (`rails -v`)
  - Ruby version (`ruby -v`)
  - Kumiki gem version
  - Tailwind CSS version
  - Browser and version (if frontend issue)
- **Include error messages and stack traces** if applicable
- **Attach screenshots or GIFs** if they help demonstrate the problem

### Suggesting Features

This section guides you through submitting a feature request for Rails Components, including completely new components and minor improvements to existing functionality.

**Before Submitting A Feature Request:**

- Check if there's already [a component](README.md#components) that provides that functionality
- Search the [issue tracker](https://github.com/darinhaener/kumiki_rails/issues) to see if the enhancement has already been suggested
- Consider whether your idea fits with the scope and aims of the project

**How Do I Submit A Good Feature Request?**

Feature requests are tracked as [GitHub issues](https://github.com/darinhaener/kumiki_rails/issues). Create an issue using [the feature request template](.github/ISSUE_TEMPLATE/feature_request.md) and provide the following information:

- **Use a clear and descriptive title** for the issue
- **Provide a detailed description** of the suggested feature
- **Explain why this feature would be useful** to most Rails Components users
- **List any alternative solutions** you've considered
- **Provide examples** of how the feature would be used
- **Include mockups or code examples** if applicable

### Submitting Pull Requests

**Good First Issues:**

Want to contribute but don't know where to start? Look for issues labeled [`good first issue`](https://github.com/darinhaener/kumiki_rails/labels/good%20first%20issue) or [`help wanted`](https://github.com/darinhaener/kumiki_rails/labels/help%20wanted).

**Pull Request Process:**

1. **Fork the repository** and create your branch from `main`:
   ```bash
   git checkout -b feature/my-new-feature
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Make your changes**:
   - Write clean, readable code following the existing style
   - Add tests for new functionality
   - Update documentation if needed
   - Keep commits focused and atomic

4. **Run the test suite** to ensure all tests pass:
   ```bash
   bundle exec rspec
   ```

5. **Run Rubocop** to ensure code style compliance:
   ```bash
   bundle exec rubocop
   ```

   Auto-fix style issues when possible:
   ```bash
   bundle exec rubocop -a
   ```

6. **Update the CHANGELOG.md** if your changes are user-facing:
   - Add an entry under `[Unreleased]` section
   - Follow the format: `- [Component] Description (#PR_NUMBER)`
   - Example: `- [Button] Add support for icon-only buttons (#42)`

7. **Commit your changes** using conventional commit messages:
   ```bash
   git commit -m "feat(button): add icon-only variant"
   git commit -m "fix(form): correct error message display"
   git commit -m "docs(readme): clarify installation steps"
   ```

   Commit message prefixes:
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation changes
   - `style`: Code style changes (formatting, etc.)
   - `refactor`: Code refactoring
   - `test`: Adding or updating tests
   - `chore`: Build process or tooling changes

8. **Push to your fork** and submit a pull request:
   ```bash
   git push origin feature/my-new-feature
   ```

9. **Fill out the pull request template** with all requested information

10. **Wait for review**:
    - A maintainer will review your PR
    - Make any requested changes
    - Once approved, your PR will be merged!

## Development Setup

### Prerequisites

- Ruby >= 3.2.0
- Rails >= 8.0.0
- Bundler
- Git

### Setting Up Your Development Environment

1. **Clone your fork**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/kumiki_rails.git
   cd kumiki_rails
   ```

2. **Install dependencies**:
   ```bash
   bundle install
   ```

3. **Run the test suite**:
   ```bash
   bundle exec rspec
   ```

4. **Run Rubocop**:
   ```bash
   bundle exec rubocop
   ```

### Running Tests

We use RSpec for testing. All new features and bug fixes should include tests.

**Run all tests:**
```bash
bundle exec rspec
```

**Run a specific test file:**
```bash
bundle exec rspec spec/components/button_spec.rb
```

**Run tests with coverage:**
```bash
COVERAGE=true bundle exec rspec
```

### Code Style

We follow the [Ruby Style Guide](https://rubystyle.guide/) and enforce it with Rubocop.

**Check code style:**
```bash
bundle exec rubocop
```

**Auto-fix issues:**
```bash
bundle exec rubocop -a
```

**Configuration:**
Rubocop rules are defined in `.rubocop.yml`. If you believe a rule should be changed, open an issue to discuss it.

## Component Development Guidelines

### Creating a New Component

When adding a new component, follow these steps:

1. **Create the component class** in `app/components/kumiki_rails/components/`:
   ```ruby
   module Kumiki
     module Components
       class MyComponent
         # Include YARD documentation
         # Define initialize and other methods
       end
     end
   end
   ```

2. **Create the component view** in `app/components/kumiki_rails/components/`:
   ```erb
   <%# my_component.html.erb %>
   ```

3. **Create the component helper** in `app/helpers/kumiki_rails/`:
   ```ruby
   module Kumiki
     module ComponentHelper
       def my_component(...)
         render partial: 'kumiki_rails/components/my_component', locals: { component: MyComponent.new(...) }
       end
     end
   end
   ```

4. **Write comprehensive tests** in `spec/components/`:
   ```ruby
   # spec/components/my_component_spec.rb
   RSpec.describe Kumiki::Components::MyComponent do
     # Test initialization, rendering, options, edge cases
   end
   ```

5. **Add YARD documentation** to all public methods

6. **Update the README** with usage examples

7. **Add to CHANGELOG** under `[Unreleased]`

### Component Best Practices

- **Follow Rails conventions**: Use Rails helpers and patterns
- **DaisyUI first**: Use DaisyUI classes when available
- **Accessibility**: Include proper ARIA attributes and keyboard navigation
- **Customizable**: Accept options for common customizations
- **Well-documented**: Include YARD docs and usage examples
- **Tested**: Maintain 100% test coverage
- **Stimulus when needed**: Use Stimulus controllers for interactive behavior

## Documentation Guidelines

### README Updates

When updating the README:

- Keep examples simple and copy-paste ready
- Include common use cases
- Update the component list if adding/removing components
- Keep the quick start guide under 10 minutes

### YARD Documentation

All public methods must have YARD documentation:

```ruby
# Brief description of what the method does.
#
# @example Basic usage
#   my_component(text: "Hello")
#
# @example With options
#   my_component(text: "Hello", variant: "primary", size: "lg")
#
# @param text [String] the display text (required)
# @param variant [String, nil] the color variant
# @param size [String, nil] the size variant
# @return [void]
def initialize(text:, variant: nil, size: nil)
  # ...
end
```

### Changelog

Follow [Keep a Changelog](https://keepachangelog.com/) format:

- Group changes under `Added`, `Changed`, `Deprecated`, `Removed`, `Fixed`, `Security`
- Keep entries concise but descriptive
- Link to PR numbers when applicable
- Update `[Unreleased]` section, not version sections

## Git Commit Guidelines

We follow conventional commit messages for clarity and automated changelog generation.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Type:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Tooling, configs, etc.

**Scope:**
Component or area of change (optional):
- `button`, `badge`, `form`, `modal`, etc.
- `ci`, `docs`, `deps`, etc.

**Examples:**
```
feat(button): add icon-only variant

Add support for buttons with only an icon and no text.
Includes proper aria-label for accessibility.

Closes #123
```

```
fix(form): correct error message positioning

Error messages now appear below the input field instead
of overlapping with the label.

Fixes #456
```

## Testing Guidelines

### Test Coverage

We aim for 100% test coverage. All new code must include tests.

**Check coverage:**
```bash
COVERAGE=true bundle exec rspec
open coverage/index.html
```

### Test Structure

Organize tests logically:

```ruby
RSpec.describe Kumiki::Components::Button do
  describe "#initialize" do
    it "sets default values" do
      # ...
    end

    it "accepts custom options" do
      # ...
    end
  end

  describe "#css_classes" do
    context "with variant" do
      it "includes variant class" do
        # ...
      end
    end

    context "without variant" do
      it "uses default classes" do
        # ...
      end
    end
  end
end
```

### Test Best Practices

- **Test behavior, not implementation**
- **Use descriptive test names** that explain what's being tested
- **One assertion per test** when possible
- **Use contexts** to group related tests
- **Test edge cases** and error conditions
- **Keep tests fast** - avoid unnecessary setup

## Release Process (Maintainers Only)

### Prerequisites

Before creating a release, ensure you have:

1. **RubyGems API Key**: Obtain from https://rubygems.org/profile/api_keys
2. **GitHub Repository Secret**: Add `RUBYGEMS_API_KEY` to repository secrets at:
   - Settings → Secrets and variables → Actions → New repository secret
   - Name: `RUBYGEMS_API_KEY`
   - Value: Your RubyGems API key

### Creating a Release

Follow these steps to create a new release:

1. **Update the version** in `lib/kumiki_rails/version.rb`:
   ```ruby
   module Kumiki
     VERSION = "0.2.0"  # Update version number
   end
   ```

2. **Update CHANGELOG.md**:
   - Move entries from `[Unreleased]` section to a new version section
   - Add release date
   - Update version comparison links at bottom

   ```markdown
   ## [Unreleased]

   ## [0.2.0] - 2025-11-15
   ### Added
   - New feature...
   ```

3. **Commit the changes**:
   ```bash
   git add lib/kumiki_rails/version.rb CHANGELOG.md
   git commit -m "Bump version to 0.2.0"
   git push origin main
   ```

4. **Create a GitHub Release**:
   ```bash
   # Using GitHub CLI
   gh release create v0.2.0 \
     --title "v0.2.0" \
     --notes "See CHANGELOG.md for full details"

   # Or manually via GitHub web interface:
   # - Go to Releases → Draft a new release
   # - Tag version: v0.2.0
   # - Release title: v0.2.0
   # - Description: Copy from CHANGELOG.md
   # - Publish release
   ```

5. **Automated Publishing**:
   - GitHub Actions will automatically:
     - Run tests and linting
     - Build the gem
     - Publish to RubyGems.org
   - Monitor the workflow: https://github.com/darinhaener/kumiki_rails/actions

6. **Verify the Release**:
   ```bash
   # Check RubyGems.org
   gem list kumiki_rails -r

   # Test installation
   gem install kumiki_rails
   ```

### Release Checklist

Before creating a release, verify:

- [ ] All tests passing: `bundle exec rspec`
- [ ] All linting passing: `bundle exec rubocop`
- [ ] CHANGELOG.md updated with all changes
- [ ] Version number updated in `lib/kumiki_rails/version.rb`
- [ ] README.md examples tested with current version
- [ ] No TODO or FIXME comments in production code
- [ ] Documentation updated for any API changes
- [ ] Breaking changes clearly documented
- [ ] Migration guide provided (if needed)

### Versioning Strategy

This project follows [Semantic Versioning](https://semver.org/):

- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (0.1.0 → 0.2.0): New features, backwards compatible
- **PATCH** (0.1.0 → 0.1.1): Bug fixes, backwards compatible

For pre-1.0 releases:
- **0.x.0**: May include breaking changes (document carefully)
- **0.0.x**: Experimental, unstable API

## Questions?

Feel free to open an issue with your question, or reach out to the maintainers:

- Email: [darin.haener@hey.com](mailto:darin.haener@hey.com)
- GitHub Discussions: [kumiki_rails/discussions](https://github.com/darinhaener/kumiki_rails/discussions)

## License

By contributing to Rails Components, you agree that your contributions will be licensed under the MIT License.

## Thank You!

Your contributions to open source, large or small, make projects like this possible. Thank you for taking the time to contribute!
