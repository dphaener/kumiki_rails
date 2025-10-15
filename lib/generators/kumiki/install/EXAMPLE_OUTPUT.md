# RailsComponents Install Generator - Example Output

This document shows example output from running the install generator with various options.

## Basic Installation

```bash
$ bin/rails generate kumiki:install
```

### Output:

```
Setting up Stimulus controllers...
Updated app/javascript/application.js with RailsComponents controllers
Copying DaisyUI plugin configuration...
Created app/assets/javascripts/daisyui.js
Updating Tailwind configuration...
Updated config/tailwind.config.js to include RailsComponents paths
Updating importmap configuration...
Added RailsComponents controller pins to importmap
      create  config/initializers/kumiki.rb

================================================================================
RailsComponents has been installed successfully!
================================================================================

Installation Summary:
  ✓ Created config/initializers/kumiki.rb
  ✓ Copied DaisyUI plugin to app/assets/javascripts/daisyui.js
  ✓ Updated importmap.rb with RailsComponents controller pins
  ✓ Updated Stimulus application.js with controller imports
  ✓ Updated Tailwind config with engine component paths

Configuration:
  ○ Form builder available (not default)
  ✓ Preview system enabled

Next Steps:
1. Restart your Rails server to load the new configuration
2. Run asset pipeline to compile JavaScript and CSS:
     bin/dev (if using Procfile.dev)

3. Verify Stimulus controllers are loaded:
     Open browser console and check for: window.Stimulus

Component Usage Examples:
  Buttons:
    <%= button 'Click me', variant: :primary %>
    <%= button 'Delete', variant: :error, outline: true %>

  Badges:
    <%= badge 'New', variant: :success %>
    <%= badge 'Beta', variant: :warning, size: :lg %>

  Cards:
    <%= card title: 'Card Title' do %>
      Card content here
    <% end %>

  Alerts (with Stimulus):
    <%= alert 'Success message', variant: :success, dismissible: true %>

Form Builder (Available):
  Option 1 - Use builder parameter:
    <%= form_with model: @user, builder: RailsComponents::ApplicationFormBuilder do |f| %>
      <%= f.text_field :name %>
    <% end %>

  Option 2 - Enable as default in config/initializers/kumiki.rb:
    config.use_as_default_form_builder = true

Preview System:
  Access component previews at: /rails/components
  Create previews in: test/components/previews/ or spec/components/previews/

Tailwind Customization:
  Configure DaisyUI themes in your Tailwind config:
    plugins: [
      require('./app/assets/javascripts/daisyui.js')({ themes: ['light', 'dark'] })
    ]

Documentation & Resources:
  GitHub: https://github.com/darinhaener/kumiki
  DaisyUI Docs: https://daisyui.com/
  Stimulus Handbook: https://stimulus.hotwired.dev/

Troubleshooting:
  If components don't render correctly:
    1. Ensure Tailwind is processing engine paths (check Tailwind config)
    2. Verify importmap pins are loaded (check browser console)
    3. Clear browser cache and restart Rails server
    4. Run: bin/rails assets:clobber && bin/rails assets:precompile

================================================================================
Happy building with RailsComponents!
================================================================================
```

## Installation with Form Builder Enabled

```bash
$ bin/rails generate kumiki:install --form-builder
```

### Key Differences:

- `config/initializers/kumiki.rb` will have `config.use_as_default_form_builder = true`
- Post-install message shows form builder as enabled
- Example usage reflects default form builder configuration

### Configuration Output:

```
Configuration:
  ✓ Form builder enabled as default
  ✓ Preview system enabled
```

### Form Builder Example:

```
Form Builder (Enabled as Default):
  <%= form_with model: @user do |f| %>
    <%= f.text_field :name, label: 'Full Name' %>
    <%= f.email_field :email, required: true %>
    <%= f.submit 'Save' %>
  <% end %>
```

## Installation with Preview System Disabled

```bash
$ bin/rails generate kumiki:install --no-preview-system
```

### Key Differences:

- `config/initializers/kumiki.rb` will have `config.enable_preview_system = false`
- Preview system section not shown in post-install message

### Configuration Output:

```
Configuration:
  ○ Form builder available (not default)
  ○ Preview system disabled
```

## Installation with Multiple Options

```bash
$ bin/rails generate kumiki:install --form-builder --no-preview-system
```

### Configuration Output:

```
Configuration:
  ✓ Form builder enabled as default
  ○ Preview system disabled
```

## Files Created/Modified

### Created Files:

1. **config/initializers/kumiki.rb**
   - Configuration for RailsComponents
   - Form builder settings
   - Preview system settings

2. **app/assets/javascripts/daisyui.js**
   - DaisyUI plugin bundle
   - Theme configuration support

3. **app/javascript/application.js** (if it doesn't exist)
   - Stimulus setup
   - Controller imports

### Modified Files:

1. **config/importmap.rb**
   ```ruby
   # RailsComponents Controllers
   pin_all_from RailsComponents::Engine.root.join("app/javascript/kumiki/controllers"),
                under: "controllers/kumiki",
                to: "kumiki/controllers"
   ```

2. **config/tailwind.config.js** (or detected variant)
   ```javascript
   content: [
     './app/components/kumiki/**/*.{rb,erb,html}',
     './app/javascript/kumiki/**/*.js',
     // ... existing paths
   ]
   ```

3. **app/javascript/application.js** (if exists)
   ```javascript
   // Import RailsComponents Stimulus controllers
   import "controllers/kumiki"
   ```

## Idempotency

The generator is idempotent and can be run multiple times safely:

```bash
$ bin/rails generate kumiki:install
# First run: Creates/updates files

$ bin/rails generate kumiki:install
# Second run: Skips existing configurations

Stimulus application already includes RailsComponents controllers
Tailwind config already includes RailsComponents paths
Importmap already contains RailsComponents pins
```

## Error Handling

### Tailwind Config Not Found:

```
Updating Tailwind configuration...
Could not find Tailwind config. Checked:
  - config/tailwind.config.js
  - tailwind.config.js
  - config/tailwind.config.mjs
  - tailwind.config.mjs

Please manually add RailsComponents paths to your Tailwind content array:
  './app/components/kumiki/**/*.{rb,erb,html}'
  './app/javascript/kumiki/**/*.js'
```

### No Importmap:

The generator silently skips importmap configuration if `config/importmap.rb` doesn't exist, as the application might be using a different JavaScript bundler (Webpack, esbuild, etc.).
