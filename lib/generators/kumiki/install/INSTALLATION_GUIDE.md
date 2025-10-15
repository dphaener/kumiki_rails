# RailsComponents Installation Guide

This guide provides detailed instructions for installing and configuring RailsComponents in your Rails application.

## Prerequisites

Before installing RailsComponents, ensure your Rails application has:

1. **Rails 8.0+** installed
2. **Tailwind CSS 4.0+** configured (via tailwindcss-rails gem)
3. **Stimulus** and **Turbo** installed
4. **Importmap** configured (default in Rails 8)

## Quick Start

```bash
bin/rails generate kumiki:install
```

This command will:
- Create configuration initializer
- Set up Stimulus controller integration
- Configure importmap for engine controllers
- Update Tailwind configuration
- Copy DaisyUI plugin

## Installation Options

### Option 1: Default Installation

```bash
bin/rails generate kumiki:install
```

Creates a basic setup with:
- Form builder available (not default)
- Preview system enabled

### Option 2: With Default Form Builder

```bash
bin/rails generate kumiki:install --form-builder
```

Automatically configures RailsComponents form builder as the default for all forms.

### Option 3: Without Preview System

```bash
bin/rails generate kumiki:install --no-preview-system
```

Disables the component preview system (useful for production-only setups).

### Option 4: Custom Configuration

```bash
bin/rails generate kumiki:install --form-builder --no-preview-system
```

Combine options based on your needs.

## What Gets Installed

### Created Files

#### 1. config/initializers/kumiki.rb
Configuration file for customizing RailsComponents behavior.

```ruby
RailsComponents.configure do |config|
  # Form builder configuration
  config.use_as_default_form_builder = false

  # Preview system configuration
  config.enable_preview_system = Rails.env.development? || Rails.env.test?

  # Future configuration options available here
end
```

#### 2. app/assets/javascripts/daisyui.js
DaisyUI plugin bundle for Tailwind CSS theme support.

#### 3. app/javascript/application.js (if not exists)
Stimulus application setup with RailsComponents controllers imported.

```javascript
import "@hotwired/turbo-rails"
import "controllers"
import "controllers/kumiki"
```

### Modified Files

#### 1. config/importmap.rb
Adds pins for RailsComponents Stimulus controllers.

```ruby
# RailsComponents Controllers
pin_all_from RailsComponents::Engine.root.join("app/javascript/kumiki/controllers"),
             under: "controllers/kumiki",
             to: "kumiki/controllers"
```

#### 2. config/tailwind.config.js
Includes engine component paths in the Tailwind content array.

```javascript
content: [
  './app/components/kumiki/**/*.{rb,erb,html}',
  './app/javascript/kumiki/**/*.js',
  // ... your existing paths
]
```

#### 3. app/javascript/application.js (if exists)
Adds import statement for RailsComponents controllers.

```javascript
// Import RailsComponents Stimulus controllers
import "controllers/kumiki"
```

## Post-Installation Steps

### 1. Restart Your Server

```bash
# Stop your current server and restart
bin/dev
# or
bin/rails server
```

### 2. Verify Installation

Open your browser console and check:

```javascript
console.log(window.Stimulus)
// Should show Stimulus application with registered controllers
```

### 3. Configure DaisyUI (Optional)

Update your `config/tailwind.config.js` to use DaisyUI themes:

```javascript
export default {
  content: [
    './app/components/kumiki/**/*.{rb,erb,html}',
    './app/javascript/kumiki/**/*.js',
    './app/views/**/*.{erb,html}',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
  ],
  plugins: [
    require('./app/assets/javascripts/daisyui.js')({
      themes: ['light', 'dark', 'cupcake', 'cyberpunk'],
      darkTheme: 'dark',
      base: true,
      styled: true,
      utils: true,
    })
  ]
}
```

### 4. Test Components

Create a test view to verify components render correctly:

```erb
<!-- app/views/pages/test.html.erb -->
<div class="p-8 space-y-4">
  <h1>RailsComponents Test</h1>

  <%= button "Primary Button", variant: :primary %>
  <%= badge "New", variant: :success %>

  <%= card title: "Test Card" do %>
    <p>This is a test card to verify RailsComponents is working.</p>
  <% end %>

  <%= alert "Test alert", variant: :info, dismissible: true %>
</div>
```

## Configuration Options

### Form Builder Configuration

#### As Default (Automatic)

```ruby
# config/initializers/kumiki.rb
config.use_as_default_form_builder = true
```

All forms automatically use RailsComponents form builder:

```erb
<%= form_with model: @user do |f| %>
  <%= f.text_field :name %>
  <%= f.email_field :email %>
<% end %>
```

#### Per-Form (Manual)

```erb
<%= form_with model: @user, builder: RailsComponents::ApplicationFormBuilder do |f| %>
  <%= f.text_field :name %>
  <%= f.email_field :email %>
<% end %>
```

### Preview System Configuration

```ruby
# config/initializers/kumiki.rb
config.enable_preview_system = true
```

Access component previews at: `http://localhost:3000/rails/components`

Create previews in: `test/components/previews/` or `spec/components/previews/`

## Stimulus Controllers

RailsComponents includes several Stimulus controllers:

### Available Controllers

1. **rails-components--dismiss**
   - Dismiss/remove elements from DOM
   - Usage: `data-controller="rails-components--dismiss"`

2. **rails-components--auto-dismiss**
   - Automatically dismiss after timeout
   - Usage: `data-controller="rails-components--auto-dismiss" data-rails-components--auto-dismiss-delay-value="3000"`

3. **rails-components--slide**
   - Slide animations
   - Usage: `data-controller="rails-components--slide"`

4. **rails-components--hello**
   - Example/demo controller
   - Usage: `data-controller="rails-components--hello"`

### Controller Registration

Controllers are automatically registered with the `rails-components--` prefix to avoid naming conflicts with your application controllers.

## Tailwind Configuration

### Content Paths

Ensure your Tailwind configuration includes:

```javascript
content: [
  './app/components/kumiki/**/*.{rb,erb,html}',
  './app/javascript/kumiki/**/*.js',
]
```

These paths ensure Tailwind processes all RailsComponents styles.

### Custom Themes

Configure custom colors and variants in your Tailwind config:

```javascript
theme: {
  extend: {
    colors: {
      primary: {
        DEFAULT: '#3b82f6',
        // ... custom shades
      },
    },
  },
}
```

## Troubleshooting

### Components Not Rendering Correctly

**Issue**: Components appear unstyled or broken.

**Solutions**:
1. Verify Tailwind is processing engine paths
2. Clear browser cache
3. Restart Rails server
4. Run: `bin/rails assets:clobber && bin/rails assets:precompile`

### Stimulus Controllers Not Working

**Issue**: Interactive features (dismiss, auto-dismiss) don't work.

**Solutions**:
1. Check browser console for JavaScript errors
2. Verify importmap pins are loaded
3. Check `window.Stimulus` in browser console
4. Ensure `app/javascript/application.js` imports controllers

### Tailwind Config Not Found

**Issue**: Generator can't find Tailwind configuration.

**Solution**: Manually add paths to your Tailwind config:

```javascript
content: [
  './app/components/kumiki/**/*.{rb,erb,html}',
  './app/javascript/kumiki/**/*.js',
]
```

### Importmap Issues

**Issue**: Controllers not loading via importmap.

**Solution**: Verify importmap configuration:

```bash
bin/rails importmap:audit
```

Check that RailsComponents paths are included.

### DaisyUI Plugin Not Working

**Issue**: DaisyUI themes/utilities not available.

**Solution**: Ensure plugin is required in Tailwind config:

```javascript
plugins: [
  require('./app/assets/javascripts/daisyui.js')()
]
```

## Uninstallation

To remove RailsComponents:

1. Remove configuration:
   ```bash
   rm config/initializers/kumiki.rb
   ```

2. Remove DaisyUI plugin:
   ```bash
   rm app/assets/javascripts/daisyui.js
   ```

3. Remove importmap pins:
   - Remove RailsComponents section from `config/importmap.rb`

4. Remove Tailwind paths:
   - Remove RailsComponents paths from Tailwind config

5. Remove Stimulus imports:
   - Remove `import "controllers/kumiki"` from `app/javascript/application.js`

6. Remove gem:
   ```ruby
   # Gemfile
   # gem "kumiki"
   ```

7. Run bundle:
   ```bash
   bundle install
   ```

## Advanced Configuration

### Custom Component Paths

If you want to override component templates, create custom components in:

```
app/components/
  my_custom_button_component.rb
  my_custom_button_component.html.erb
```

### Custom Stimulus Controllers

Create custom controllers that extend RailsComponents controllers:

```javascript
// app/javascript/controllers/my_dismiss_controller.js
import DismissController from "controllers/kumiki/dismiss_controller"

export default class extends DismissController {
  connect() {
    super.connect()
    // Custom logic
  }
}
```

### Production Considerations

1. **Precompile Assets**: Ensure assets are precompiled in production
   ```bash
   RAILS_ENV=production bin/rails assets:precompile
   ```

2. **CDN Configuration**: If using a CDN, ensure engine assets are included

3. **Cache Busting**: Verify asset fingerprinting is enabled

4. **Performance**: Consider disabling preview system in production:
   ```ruby
   config.enable_preview_system = false
   ```

## Next Steps

After installation:

1. Explore component documentation
2. Create custom components
3. Build interactive forms with form builder
4. Use component previews for development
5. Customize themes with DaisyUI

## Resources

- **GitHub**: https://github.com/darinhaener/kumiki
- **DaisyUI Documentation**: https://daisyui.com/
- **Stimulus Handbook**: https://stimulus.hotwired.dev/
- **Tailwind CSS**: https://tailwindcss.com/

## Support

For issues, questions, or contributions:
- Open an issue on GitHub
- Check existing documentation
- Review example applications
