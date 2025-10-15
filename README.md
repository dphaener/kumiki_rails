# Kumiki Rails 組木

> **組木** (kumiki) - Traditional Japanese interlocking wooden puzzles where each piece fits together perfectly without nails or glue

[![Gem Version](https://badge.fury.io/rb/kumiki_rails.svg)](https://badge.fury.io/rb/kumiki_rails)
[![CI Status](https://github.com/darinhaener/kumiki_rails/workflows/CI/badge.svg)](https://github.com/darinhaener/kumiki_rails/actions)

**Modular UI components that fit together seamlessly in your Rails application**

Just like traditional kumiki wooden puzzles, each component is crafted to interlock perfectly - no forcing, no glue, just elegant design. Built with Tailwind CSS and DaisyUI on Rails 8+.

[🐛 Report Bug](https://github.com/darinhaener/kumiki_rails/issues) | [💡 Request Feature](https://github.com/darinhaener/kumiki_rails/issues)

---

## Why Kumiki Rails?

- **13 Crafted Components** - Buttons, forms, modals, toasts, badges, cards - each designed to fit together
- **Zero Configuration** - Works out of the box with Rails 8 and Tailwind CSS
- **The Rails Way** - Follows Rails conventions, no complex build steps
- **Accessible by Default** - Built with accessibility in mind, keyboard navigation included
- **Hotwire Native** - Stimulus controllers for interactive components baked in

## Philosophy

Kumiki (組木) refers to traditional Japanese wooden puzzles where pieces interlock without fasteners. Each piece is precisely crafted with attention to detail, and when combined, they form something greater than the sum of their parts.

This is how we think about UI components:
- **Precision crafted** - Each component is carefully designed with clear boundaries
- **Interlocking design** - Components work together seamlessly
- **No force required** - Simple, intuitive APIs that feel natural
- **Built to last** - Stable, well-tested, production-ready

## Quick Start

### 1. Install

Add to your Gemfile:

```ruby
gem "kumiki_rails"
```

Then run:

```bash
bundle install
bin/rails generate kumiki:install
```

The install generator will:
- Create an initializer at `config/initializers/kumiki.rb`
- Configure your Tailwind config to include engine component paths
- Set up Stimulus controller imports in your importmap
- Copy the DaisyUI plugin configuration

### 2. Use Components

```erb
<%# In your views %>
<%= button "Click Me", variant: "primary" %>

<%= badge "New", variant: "success" %>

<%= card title: "Welcome" do %>
  <p>This is a card with DaisyUI styling!</p>
<% end %>
```

### 3. Use the Form Builder

```erb
<%= form_with model: @user do |f| %>
  <%= f.text_field :name, label: "Full Name" %>
  <%= f.email_field :email, required: true %>
  <%= f.select :role, ["Admin", "User"], label: "Role" %>
  <%= f.submit "Save User" %>
<% end %>
```

All form fields automatically:
- Include proper labels
- Display validation errors
- Apply DaisyUI styling
- Support accessibility attributes

### 4. Enjoy

All components are styled with DaisyUI and work seamlessly with Turbo and Stimulus.

## The Component Collection

### UI Components

- **[Button](#button)** - Styled buttons with multiple variants and states
- **[Badge](#badge)** - Status indicators and tags
- **[Card](#card)** - Content containers with title and actions
- **[Modal](#modal)** - Accessible dialog overlays
- **[Toast](#toast)** - Temporary notifications that auto-dismiss

### Form Components

- **[Text Input](#text-input)** - Single-line text fields with labels and errors
- **[Textarea](#textarea)** - Multi-line text input
- **[Select](#select)** - Dropdown menus
- **[Checkbox](#checkbox)** - Boolean selections
- **[Radio](#radio)** - Mutually exclusive options
- **[Date Picker](#date-picker)** - Date selection inputs
- **[File Input](#file-input)** - File upload fields

---

## Component Reference

### Button

Create styled buttons with multiple variants, sizes, and states.

```erb
<%# Primary button %>
<%= button "Save", variant: "primary" %>

<%# Secondary button %>
<%= button "Cancel", variant: "secondary" %>

<%# Ghost button %>
<%= button "Details", variant: "ghost" %>

<%# With custom classes %>
<%= button "Submit", variant: "primary", class: "w-full" %>

<%# Disabled button %>
<%= button "Processing", variant: "primary", disabled: true %>

<%# Loading state %>
<%= button "Saving", variant: "primary", loading: true %>
```

**Parameters:**
- `text` (String, required): Button label text
- `variant` (String): Color variant - `"primary"`, `"secondary"`, `"accent"`, `"ghost"`, `"link"`, `"info"`, `"success"`, `"warning"`, `"error"`
- `size` (String): Button size - `"xs"`, `"sm"`, `"md"`, `"lg"`
- `type` (String): HTML button type - `"button"` (default), `"submit"`, `"reset"`
- `disabled` (Boolean): Disable the button
- `loading` (Boolean): Show loading spinner
- `class` (String): Additional CSS classes
- `html_options` (Hash): Additional HTML attributes

### Badge

Display status indicators, tags, or labels.

```erb
<%# Basic badge %>
<%= badge "New" %>

<%# Colored variants %>
<%= badge "Success", variant: "success" %>
<%= badge "Warning", variant: "warning" %>
<%= badge "Error", variant: "error" %>
<%= badge "Info", variant: "info" %>

<%# Different sizes %>
<%= badge "Small", size: "sm" %>
<%= badge "Large", size: "lg" %>

<%# Outline style %>
<%= badge "Outline", variant: "primary", outline: true %>
```

**Parameters:**
- `text` (String, required): Badge text
- `variant` (String): Color variant - `"primary"`, `"secondary"`, `"accent"`, `"ghost"`, `"info"`, `"success"`, `"warning"`, `"error"`
- `size` (String): Size - `"sm"`, `"md"`, `"lg"`
- `outline` (Boolean): Use outline style
- `class` (String): Additional CSS classes

### Card

Container component for grouping related content.

```erb
<%# Basic card %>
<%= card title: "Card Title" do %>
  <p>Your content here</p>
<% end %>

<%# Card with actions %>
<%= card title: "Product", actions: true do %>
  <p>Product description</p>
  <div class="card-actions">
    <%= button "Buy Now", variant: "primary" %>
  </div>
<% end %>

<%# Compact card %>
<%= card title: "Compact", compact: true do %>
  <p>Smaller padding</p>
<% end %>
```

**Parameters:**
- `title` (String): Card title
- `actions` (Boolean): Include actions section
- `compact` (Boolean): Use compact padding
- `class` (String): Additional CSS classes
- Block content: The card body content

### Toast

Display temporary notification messages (requires Stimulus).

```erb
<%# Success toast %>
<%= toast "Changes saved successfully!", type: "success" %>

<%# Error toast %>
<%= toast "An error occurred", type: "error" %>

<%# Info toast %>
<%= toast "New update available", type: "notice" %>

<%# Auto-dismissing toast (5 seconds default) %>
<%= toast "Processing...", type: "notice", auto_dismiss_delay: 5000 %>

<%# With title and custom delay %>
<%= toast message: "Task completed", title: "Success", type: "success", auto_dismiss_delay: 3000 %>
```

**Parameters:**
- `message` (String, required): Toast message (can be positional first argument)
- `type` (String): Type - `"notice"`, `"success"`, `"error"`, `"warning"` (default: `"notice"`)
- `title` (String): Optional toast title
- `dismissible` (Boolean): Show close button (default: `true`)
- `auto_dismiss_delay` (Integer): Auto-hide delay in milliseconds (default: `5000`)

### Modal

Create accessible modal dialogs (requires Stimulus).

```erb
<%# Basic modal %>
<%= modal id: "my-modal", title: "Confirm Action" do %>
  <p>Are you sure you want to continue?</p>
  <div class="modal-action">
    <%= button "Cancel", variant: "ghost" %>
    <%= button "Confirm", variant: "primary" %>
  </div>
<% end %>
```

**Parameters:**
- `id` (String, required): Unique modal identifier
- `title` (String): Modal title
- `size` (String): Modal size - `"sm"`, `"md"`, `"lg"`
- `class` (String): Additional CSS classes
- Block content: The modal body content

---

## Form Builder

Kumiki Rails includes a powerful form builder that extends `ActionView::Helpers::FormBuilder` with styled inputs.

### Text Input

```erb
<%= form_with model: @user do |f| %>
  <%= f.text_field :username, label: "Username", placeholder: "Enter username" %>
  <%= f.email_field :email, label: "Email", required: true %>
  <%= f.password_field :password, label: "Password" %>
<% end %>
```

**Options:**
- `label` (String): Custom label text (defaults to humanized attribute name)
- `placeholder` (String): Input placeholder
- `required` (Boolean): Mark field as required
- `help_text` (String): Help text below input
- All standard Rails form helper options

### Textarea

```erb
<%= f.text_area :bio, label: "Biography", rows: 5, placeholder: "Tell us about yourself" %>
```

### Select

```erb
<%# Array of options %>
<%= f.select :role, ["Admin", "User", "Guest"], label: "Role" %>

<%# With prompt %>
<%= f.select :country, Country.all.pluck(:name, :id),
             label: "Country",
             prompt: "Select a country" %>
```

### Checkbox

```erb
<%= f.check_box :terms_accepted, label: "I accept the terms and conditions" %>
<%= f.check_box :newsletter, label: "Subscribe to newsletter" %>
```

### Radio Buttons

```erb
<%= f.radio_button :plan, "free", label: "Free Plan" %>
<%= f.radio_button :plan, "pro", label: "Pro Plan" %>
<%= f.radio_button :plan, "enterprise", label: "Enterprise Plan" %>
```

### Date Picker

```erb
<%= f.date_field :birth_date, label: "Date of Birth" %>
<%= f.date_field :start_date, label: "Start Date", min: Date.today %>
```

### File Input

```erb
<%= f.file_field :avatar, label: "Profile Picture", accept: "image/*" %>
<%= f.file_field :document, label: "Upload Document", accept: ".pdf,.doc,.docx" %>
```

### Error Handling

All form fields automatically display validation errors:

```erb
<%# If @user has errors on :email %>
<%= f.email_field :email, label: "Email" %>
<%# Will display error message in red below the input %>
```

---

## Configuration

Create or edit `config/initializers/kumiki.rb`:

```ruby
Kumiki.configure do |config|
  # Use as default form builder for all forms
  config.use_as_default_form_builder = true

  # Enable component preview system (default: true in development)
  config.enable_preview = Rails.env.development?
end
```

### Default Form Builder

When enabled, all `form_with` and `form_for` calls will automatically use the Kumiki form builder:

```ruby
# config/initializers/kumiki.rb
Kumiki.configure do |config|
  config.use_as_default_form_builder = true
end
```

Alternatively, specify the builder per form:

```erb
<%= form_with model: @user, builder: Kumiki::ApplicationFormBuilder do |f| %>
  <%= f.text_field :name %>
<% end %>
```

### Component Preview System

Access interactive component previews during development:

1. Enable in config (enabled by default in development):
```ruby
config.enable_preview = true
```

2. Mount the preview routes in `config/routes.rb`:
```ruby
Rails.application.routes.draw do
  mount Kumiki::Engine => "/kumiki" if Rails.env.development?
end
```

3. Visit `http://localhost:3000/kumiki/design/preview` to browse all components

---

## Customization

### Custom Themes

Kumiki Rails uses DaisyUI for theming. Configure themes in your Tailwind config:

```javascript
// tailwind.config.js
module.exports = {
  plugins: [
    require('./app/assets/javascripts/daisyui.js')({
      themes: ["light", "dark", "cupcake", "cyberpunk"],
      darkTheme: "dark",
    })
  ]
}
```

**Available themes:** `light`, `dark`, `cupcake`, `bumblebee`, `emerald`, `corporate`, `synthwave`, `retro`, `cyberpunk`, `valentine`, `halloween`, `garden`, `forest`, `aqua`, `lofi`, `pastel`, `fantasy`, `wireframe`, `black`, `luxury`, `dracula`, `cmyk`, `autumn`, `business`, `acid`, `lemonade`, `night`, `coffee`, `winter`

### Overriding Component Views

To customize a component's HTML:

1. Copy the component view from the engine to your app:
```bash
mkdir -p app/views/kumiki/components
cp $(bundle show kumiki_rails)/app/views/kumiki/components/button.html.erb \
   app/views/kumiki/components/
```

2. Edit the view in your app - Rails will use your version instead of the engine's

### Custom Component Styles

Override DaisyUI component styles in your application's CSS:

```css
/* app/assets/stylesheets/application.tailwind.css */

/* Custom button styles */
.btn-primary {
  @apply bg-gradient-to-r from-purple-500 to-pink-500;
}

/* Custom card styles */
.card {
  @apply shadow-xl;
}
```

### Extending the Form Builder

Add custom form field methods:

```ruby
# config/initializers/kumiki.rb
module Kumiki
  class ApplicationFormBuilder
    def price_field(method, options = {})
      text_field(method, options.merge(
        placeholder: "$0.00",
        class: "input input-bordered"
      ))
    end
  end
end
```

Use in forms:
```erb
<%= f.price_field :amount, label: "Price" %>
```

---

## Troubleshooting

### Component styles not applying

**Problem:** Tailwind CSS is not configured to include engine paths.

**Solution:**
1. Verify `bin/rails generate kumiki:install` ran successfully
2. Check `config/tailwind.config.js` includes these paths:
   ```javascript
   content: [
     './app/components/kumiki/**/*.{rb,erb,html}',
     './app/javascript/kumiki/**/*.js',
     // ... your other paths
   ]
   ```
3. Rebuild Tailwind CSS: `bin/rails tailwindcss:build`
4. Restart your Rails server

### Stimulus controllers not found

**Problem:** Importmap not configured correctly or Stimulus not loaded.

**Solution:**
1. Verify `config/importmap.rb` includes Kumiki pins:
   ```ruby
   pin_all_from Kumiki::Engine.root.join("app/javascript/kumiki/controllers"),
                under: "controllers/kumiki",
                to: "kumiki/controllers"
   ```
2. Check `app/javascript/application.js` imports controllers:
   ```javascript
   import "controllers/kumiki"
   ```
3. Verify in browser console: `window.Stimulus`
4. Restart Rails server and clear browser cache

### DaisyUI styles not working

**Problem:** DaisyUI plugin not properly configured.

**Solution:**
1. Ensure `app/assets/javascripts/daisyui.js` exists
2. Verify `tailwind.config.js` includes the plugin:
   ```javascript
   plugins: [
     require('./app/assets/javascripts/daisyui.js')()
   ]
   ```
3. Rebuild Tailwind: `bin/rails tailwindcss:build`

---

## Requirements

- **Ruby** >= 3.2.0
- **Rails** >= 8.0.0
- **Tailwind CSS** (via `tailwindcss-rails` gem)
- **Stimulus** (via `stimulus-rails` gem)
- **Importmap** (via `importmap-rails` gem) - Required for Stimulus controllers

### Verified Compatibility

| Ruby Version | Rails Version | Status |
|--------------|---------------|--------|
| 3.2.x        | 8.0.x         | ✅ Tested |
| 3.3.x        | 8.0.x         | ✅ Tested |
| 3.2.x        | 8.1.x         | ✅ Tested |
| 3.3.x        | 8.1.x         | ✅ Tested |

---

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

**Key principles:**
- Follow Rails conventions
- Write tests first (TDD)
- Components should "fit together" - consider how they interact
- Documentation is as important as code

## License

The gem is available as open source under the terms of the [MIT License](LICENSE).

## Acknowledgments

Kumiki Rails is built on the shoulders of giants:

- [Ruby on Rails](https://rubyonrails.org) - The amazing web framework
- [Tailwind CSS](https://tailwindcss.com) - Utility-first CSS framework
- [DaisyUI](https://daisyui.com) - Tailwind CSS component library
- [Hotwire](https://hotwired.dev) - Modern web application framework
- [ViewComponent](https://viewcomponent.org) - Inspiration for component architecture

Special thanks to the Rails community for continuous inspiration.

## Support

- 📖 [Documentation](https://github.com/darinhaener/kumiki_rails)
- 🐛 [Issue Tracker](https://github.com/darinhaener/kumiki_rails/issues)
- 💬 [Discussions](https://github.com/darinhaener/kumiki_rails/discussions)

---

**組木 Kumiki Rails** - Components that fit together perfectly

_Crafted with care for the Rails community_
