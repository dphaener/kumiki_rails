# Asset Pipeline Integration Setup

This document describes the asset pipeline integration, importmap configuration, and Tailwind CSS setup for the rails_components engine.

## Overview

The rails_components engine is configured to provide JavaScript (via Stimulus) and CSS (via Tailwind CSS) assets to host applications. This setup follows Rails 8 conventions using:

- **Propshaft** for asset pipeline
- **Importmap** for JavaScript module management
- **Stimulus** for JavaScript controllers
- **Tailwind CSS 4.0+** for styling
- **DaisyUI** (prepared for integration)

## Architecture

### Engine Structure

```
rails_components/
├── app/
│   ├── assets/
│   │   └── stylesheets/
│   │       └── rails_components/
│   │           └── application.css    # Main engine stylesheet with Tailwind
│   ├── javascript/
│   │   └── rails_components/
│   │       ├── index.js              # Main entry point
│   │       └── controllers/          # Stimulus controllers
│   │           ├── application.js    # Stimulus application
│   │           ├── index.js          # Controller registration
│   │           ├── auto_dismiss_controller.js
│   │           ├── dismiss_controller.js
│   │           ├── hello_controller.js
│   │           └── slide_controller.js
│   └── components/                    # ViewComponent-based UI components
└── config/
    ├── importmap.rb                  # Engine importmap configuration
    └── tailwind.config.js            # Tailwind CSS configuration

```

### Dummy App Structure (for testing)

```
spec/dummy/
├── app/
│   ├── assets/
│   │   └── stylesheets/
│   │       └── application.css       # Dummy app styles with Tailwind
│   ├── javascript/
│   │   ├── application.js            # Main entry point
│   │   └── controllers/              # Dummy app controllers
│   └── views/
│       └── layouts/
│           └── application.html.erb  # Includes engine assets
└── config/
    ├── importmap.rb                  # Dummy app importmap
    └── initializers/
        └── assets.rb                 # Asset precompilation config
```

## Configuration Details

### 1. Engine Configuration (lib/rails_components/engine.rb)

The engine initializers configure asset loading and importmap integration:

```ruby
# Load engine assets into the host application
initializer "rails_components.assets" do |app|
  # Add engine assets to the asset pipeline
  app.config.assets.paths << root.join("app/assets/stylesheets")
  app.config.assets.paths << root.join("app/assets/images")
  app.config.assets.paths << root.join("app/javascript")

  # Precompile engine assets
  app.config.assets.precompile += %w[
    rails_components/application.css
  ]
end

# Configure importmap for the engine
initializer "rails_components.importmap", before: "importmap" do |app|
  # Load the engine's importmap configuration
  if defined?(Importmap)
    app.config.importmap.paths << root.join("config/importmap.rb")
    app.config.importmap.cache_sweepers << root.join("app/javascript")
  end
end
```

### 2. Importmap Configuration

#### Engine Importmap (config/importmap.rb)

```ruby
# Pin Hotwire dependencies
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Pin all Stimulus controllers from the engine
pin_all_from RailsComponents::Engine.root.join("app/javascript/rails_components/controllers"),
             under: "controllers/rails_components",
             to: "rails_components/controllers"
```

#### Dummy App Importmap (spec/dummy/config/importmap.rb)

```ruby
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
```

### 3. Tailwind CSS Configuration

#### Engine Stylesheet (app/assets/stylesheets/rails_components/application.css)

The engine stylesheet includes:

1. **Tailwind CSS imports** using the new `@import "tailwindcss"` syntax (Tailwind 4.0+)
2. **Source directives** to tell Tailwind where to scan for classes:
   ```css
   @source "../../components/rails_components/components";
   @source "../../views/rails_components";
   @source "../../helpers/rails_components";
   @source "../../javascript/rails_components";
   ```
3. **Component-specific utility classes** with `rc-` prefix:
   - `.rc-form-input` - Input styling with focus states
   - `.rc-form-error` - Error message styling
   - `.rc-button` - Button base styles
   - `.rc-card` - Card container and sections
   - `.rc-badge` - Badge component styles

4. **DaisyUI placeholder** for future integration

#### Tailwind Configuration (config/tailwind.config.js)

Defines content paths and custom theme colors:
- Primary, Error, Success, Warning color palettes
- Component scanning paths
- Plugin placeholder for DaisyUI

### 4. Stimulus Controllers

All Stimulus controllers are namespaced with `rails-components--` prefix to avoid conflicts:

```javascript
// Usage in views:
<div data-controller="rails-components--hello">
  <!-- Controller content -->
</div>
```

Available controllers:
- `rails-components--hello` - Example controller
- `rails-components--dismiss` - Dismissible elements
- `rails-components--auto-dismiss` - Auto-dismissing alerts
- `rails-components--slide` - Slide animations

### 5. Dummy App Integration

The dummy app demonstrates proper integration:

#### Layout (spec/dummy/app/views/layouts/application.html.erb)

```erb
<!-- Dummy app styles -->
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>

<!-- Engine styles -->
<%= stylesheet_link_tag "rails_components/application", "data-turbo-track": "reload" %>

<!-- JavaScript with importmap -->
<%= javascript_importmap_tags %>
```

## Host Application Integration

To use rails_components in a host application:

### 1. Add to Gemfile

```ruby
gem "rails_components"
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Configure Assets in Application Layout

```erb
<!DOCTYPE html>
<html>
  <head>
    <!-- Your app styles -->
    <%= stylesheet_link_tag "application" %>

    <!-- Rails Components engine styles -->
    <%= stylesheet_link_tag "rails_components/application", "data-turbo-track": "reload" %>

    <!-- Importmap JavaScript -->
    <%= javascript_importmap_tags %>
  </head>
  <body>
    <%= yield %>
  </body>
</html>
```

### 4. Use Components

```erb
<%= render RailsComponents::Components::Button.new(variant: :primary) do %>
  Click Me
<% end %>

<div data-controller="rails-components--hello">
  <!-- Stimulus controller content -->
</div>
```

## Tailwind CSS Integration

### Engine Tailwind Classes

The engine provides pre-defined utility classes:

```css
/* Form inputs */
.rc-form-input          /* Base input styling */
.rc-form-input-error    /* Error state styling */
.rc-form-label          /* Label styling */
.rc-form-error          /* Error message styling */
.rc-form-hint           /* Hint text styling */

/* Buttons */
.rc-button              /* Base button styling */

/* Cards */
.rc-card                /* Card container */
.rc-card-header         /* Card header section */
.rc-card-body           /* Card body section */
.rc-card-footer         /* Card footer section */

/* Badges */
.rc-badge               /* Badge styling */
```

### Tailwind in Components

Components can use both Tailwind utility classes and the predefined `rc-*` classes:

```ruby
class MyComponent < ViewComponent::Base
  def call
    content_tag :div, class: "rc-card" do
      content_tag(:div, "Header", class: "rc-card-header") +
      content_tag(:div, "Body", class: "rc-card-body")
    end
  end
end
```

## DaisyUI Integration (Planned)

DaisyUI integration is prepared but not yet active. To enable:

1. Update `config/tailwind.config.js`:
   ```javascript
   plugins: [
     require("daisyui"),
   ],
   ```

2. Uncomment in `app/assets/stylesheets/rails_components/application.css`:
   ```css
   @import "daisyui";
   ```

3. Add DaisyUI to package dependencies if using npm

## Testing Assets

The dummy app (`spec/dummy`) is configured for testing:

```bash
cd spec/dummy
bin/rails server
# Visit http://localhost:3000
```

## Troubleshooting

### Assets Not Loading

1. **Check importmap configuration**: Ensure the engine's importmap.rb is loaded
2. **Verify asset paths**: Check `app.config.assets.paths` in engine.rb
3. **Precompile assets**: Ensure assets are in precompile list
4. **Check layout**: Verify `javascript_importmap_tags` and `stylesheet_link_tag` are present

### Stimulus Controllers Not Found

1. **Check controller naming**: Must use `rails-components--` prefix
2. **Verify importmap pins**: Ensure controllers are pinned correctly
3. **Check JavaScript console**: Look for import errors

### Tailwind Classes Not Working

1. **Check @source directives**: Ensure all component paths are included
2. **Verify Tailwind import**: Must use `@import "tailwindcss"` syntax
3. **Check file locations**: Tailwind scans paths relative to CSS file

## File Summary

### Created/Modified Files

1. **config/importmap.rb** - Engine importmap configuration
2. **config/tailwind.config.js** - Tailwind CSS configuration
3. **lib/rails_components/engine.rb** - Enhanced asset pipeline initializers
4. **app/assets/stylesheets/rails_components/application.css** - Main stylesheet with Tailwind
5. **spec/dummy/config/importmap.rb** - Dummy app importmap
6. **spec/dummy/app/javascript/application.js** - Dummy app JS entry point
7. **spec/dummy/app/javascript/controllers/application.js** - Stimulus application
8. **spec/dummy/app/javascript/controllers/index.js** - Controller registration
9. **spec/dummy/app/views/layouts/application.html.erb** - Updated layout
10. **spec/dummy/app/assets/stylesheets/application.css** - Updated with Tailwind
11. **spec/dummy/config/initializers/assets.rb** - Asset precompilation config

### Existing Files (Already Configured)

1. **app/javascript/rails_components/controllers/*** - Stimulus controllers
2. **app/javascript/rails_components/index.js** - JavaScript entry point
3. **app/javascript/rails_components/controllers/application.js** - Stimulus app

## Next Steps

1. **Test the integration**: Start the dummy app and verify assets load
2. **Add DaisyUI**: When ready, enable DaisyUI integration
3. **Create more controllers**: Add Stimulus controllers as needed
4. **Extend Tailwind config**: Add custom theme colors and utilities
5. **Document components**: Add usage examples for each component
