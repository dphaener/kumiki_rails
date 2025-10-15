# Rails Components JavaScript

This directory contains the Stimulus controllers and JavaScript modules for the rails_components engine.

## Directory Structure

```
app/javascript/rails_components/
├── index.js                      # Main entry point
└── controllers/
    ├── application.js            # Stimulus application setup
    ├── index.js                  # Controller registration
    ├── auto_dismiss_controller.js
    ├── dismiss_controller.js
    ├── hello_controller.js
    └── slide_controller.js
```

## Stimulus Controllers

All controllers are registered with the `rails-components--` prefix to avoid naming conflicts with host application controllers.

### Available Controllers

1. **auto-dismiss** (`rails-components--auto-dismiss`)
   - Automatically dismisses elements after a configurable delay
   - Default: 5 seconds
   - Supports custom animations
   - Usage: `data-controller="rails-components--auto-dismiss"`

2. **dismiss** (`rails-components--dismiss`)
   - Manually dismiss elements with optional animations
   - Supports multiple dismiss targets
   - Usage: `data-controller="rails-components--dismiss"`

3. **slide** (`rails-components--slide`)
   - Slide elements in/out with configurable CSS classes
   - Toggle, reset, and check state methods
   - Usage: `data-controller="rails-components--slide"`

4. **hello** (`rails-components--hello`)
   - Example controller for testing
   - Usage: `data-controller="rails-components--hello"`

## Usage in Host Application

To use these controllers in your Rails application, you need to import them in your application's JavaScript entry point:

```javascript
// In your app/javascript/application.js or app/javascript/controllers/index.js
import "rails_components"
```

## Controller Namespace

All controllers use the `rails-components--` prefix to prevent conflicts:

```erb
<!-- In your views -->
<div data-controller="rails-components--dismiss">
  <button data-action="click->rails-components--dismiss#dismiss">
    Close
  </button>
</div>
```

## Adding New Controllers

1. Create your controller file in `app/javascript/rails_components/controllers/`
2. Import it in `controllers/index.js`
3. Register it with the `rails-components--` prefix
4. Update this README with controller documentation
