# Form Input Component Migration Guide

**Component**: Form Input
**DaisyUI Baseline**: [DaisyUI Input](https://daisyui.com/components/input/)
**HyperUI Target**: [HyperUI Form Inputs](https://www.hyperui.dev/components/marketing/forms)
**Migration Complexity**: Easy
**Last Updated**: 2025-11-19

---

## Overview

The Form Input component renders text input fields with labels, helper text, error messages, and various decorations (icons, buttons). Current DaisyUI implementation has strong accessibility foundation with explicit label association and ARIA attributes. Migration to HyperUI maintains these patterns with utility-first styling.

**Migration Complexity**: Easy - Strong baseline, clear mapping, no breaking changes required.

---

## Variant Analysis

### DaisyUI Variants

```html
<!-- Sizes -->
<input class="input input-xs">
<input class="input input-sm">
<input class="input input-md">
<input class="input input-lg">

<!-- Bordered -->
<input class="input input-bordered">

<!-- Ghost (no background) -->
<input class="input input-ghost">
```

### HyperUI Target

```html
<!-- Standard Input -->
<input class="block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500">

<!-- With Sizes -->
<input class="... p-2 text-sm">  <!-- Small -->
<input class="... p-3 text-sm">  <!-- Medium -->
<input class="... p-4 text-base"> <!-- Large -->

<!-- Error State -->
<input class="... border-red-600 focus:border-red-500 focus:ring-red-500" aria-invalid="true">

<!-- Disabled State -->
<input class="... cursor-not-allowed bg-gray-100 text-gray-400" disabled>
```

---

## HTML Structure Comparison

### Current DaisyUI

```erb
<div class="form-control">
  <label class="label" for="email">
    <span class="label-text">Email</span>
  </label>
  <input type="email" id="email" class="input input-bordered" />
</div>
```

### HyperUI Target

```html
<div class="form-group">
  <label for="email" class="block text-sm font-medium text-gray-700">
    Email Address
    <span class="text-red-600" aria-label="required">*</span>
  </label>
  <input
    type="email"
    id="email"
    name="email"
    aria-required="true"
    aria-invalid="false"
    aria-describedby="email-hint email-error"
    class="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-blue-500 focus:ring-blue-500"
  />
  <p id="email-hint" class="mt-1 text-sm text-gray-500">
    We'll never share your email.
  </p>
  <p id="email-error" class="mt-1 text-sm text-red-600" role="alert" hidden>
    Please enter a valid email.
  </p>
</div>
```

---

## Accessibility Requirements

### ARIA Attributes Required

```ruby
# Always include
attributes[:id] = field_id

# When required
attributes[:"aria-required"] = "true" if required

# When error
attributes[:"aria-invalid"] = "true" if error?

# Link to helper text and errors
describedby = []
describedby << "#{field_id}-hint" if hint
describedby << "#{field_id}-error" if error?
attributes[:"aria-describedby"] = describedby.join(" ") if describedby.any?
```

### Keyboard Navigation

**Native HTML behavior** - no additional implementation required:
- **Tab**: Focus field
- **Shift+Tab**: Focus previous field
- **Arrow keys**: Move cursor within text
- **Home/End**: Jump to start/end of text

---

## HTML Patterns Used

### Pattern 1: Label-Input Wrapper

```html
<div class="form-group">
  <label for="field-id" class="block text-sm font-medium text-gray-700">Label</label>
  <input id="field-id" class="mt-1 block w-full..." />
</div>
```

### Pattern 2: Input State Classes

```ruby
def input_classes
  classes = ["block", "w-full", "rounded-md", "shadow-sm"]

  if error?
    classes += ["border-red-600", "focus:border-red-500", "focus:ring-red-500"]
  elsif disabled
    classes += ["border-gray-300", "bg-gray-100", "text-gray-400", "cursor-not-allowed"]
  else
    classes += ["border-gray-300", "focus:border-blue-500", "focus:ring-blue-500"]
  end

  classes << size_class
  classes.join(" ")
end

def size_class
  {
    sm: "p-2 text-sm",
    md: "p-3 text-sm",
    lg: "p-4 text-base"
  }[size] || "p-3 text-sm"
end
```

### Pattern 3: With Leading Icon

```html
<div class="relative mt-1">
  <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
    <svg class="h-5 w-5 text-gray-400" aria-hidden="true" focusable="false">
      <!-- Icon -->
    </svg>
  </div>
  <input class="block w-full pl-10 ..." />
</div>
```

---

## Migration Guide

### Update Component Class

```ruby
class FormInput < Kumiki::Component
  option :type, default: -> { :text }
  option :name
  option :value, default: -> { nil }
  option :placeholder, default: -> { nil }
  option :label
  option :hint, default: -> { nil }
  option :error, default: -> { nil }
  option :required, default: -> { false }
  option :disabled, default: -> { false }
  option :size, default: -> { :md }
  option :icon, default: -> { nil }

  def input_classes
    classes = ["block", "w-full", "rounded-md", "shadow-sm"]
    classes += state_classes
    classes << size_class
    classes << "pl-10" if icon
    classes.join(" ")
  end

  def label_classes
    "block text-sm font-medium text-gray-700"
  end

  def hint_classes
    "mt-1 text-sm text-gray-500"
  end

  def error_classes
    "mt-1 text-sm text-red-600"
  end

  def field_id
    @field_id ||= "#{name}-#{SecureRandom.hex(4)}"
  end

  def error?
    error.present?
  end

  def aria_attributes
    attrs = {}
    attrs[:"aria-required"] = "true" if required
    attrs[:"aria-invalid"] = "true" if error?

    describedby = []
    describedby << "#{field_id}-hint" if hint
    describedby << "#{field_id}-error" if error?
    attrs[:"aria-describedby"] = describedby.join(" ") if describedby.any?

    attrs
  end

  private

  def state_classes
    if error?
      ["border-red-600", "focus:border-red-500", "focus:ring-red-500"]
    elsif disabled
      ["border-gray-300", "bg-gray-100", "text-gray-400", "cursor-not-allowed"]
    else
      ["border-gray-300", "focus:border-blue-500", "focus:ring-blue-500"]
    end
  end

  def size_class
    {
      sm: "p-2 text-sm",
      md: "p-3 text-sm",
      lg: "p-4 text-base"
    }[size] || "p-3 text-sm"
  end
end
```

### Update Template

```erb
<div class="form-group">
  <%= tag.label(for: field_id, class: label_classes) do %>
    <%= label %>
    <% if required %>
      <%= tag.span("*", class: "text-red-600", "aria-label": "required") %>
    <% end %>
  <% end %>

  <% if icon %>
    <div class="relative mt-1">
      <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
        <%= icon %>
      </div>
      <%= input_tag %>
    </div>
  <% else %>
    <%= input_tag %>
  <% end %>

  <% if hint %>
    <%= tag.p(hint, id: "#{field_id}-hint", class: hint_classes) %>
  <% end %>

  <% if error? %>
    <%= tag.p(error, id: "#{field_id}-error", class: error_classes, role: "alert") %>
  <% end %>
</div>

<% def input_tag %>
  <%= tag.input(
    type: type,
    id: field_id,
    name: name,
    value: value,
    placeholder: placeholder,
    disabled: disabled,
    required: required,
    class: input_classes,
    **aria_attributes
  ) %>
<% end %>
```

---

## Testing Considerations

### RSpec Tests

```ruby
RSpec.describe FormInput, type: :component do
  it "renders with label" do
    result = render_inline(FormInput.new(name: "email", label: "Email"))
    expect(result.css("label").text).to include("Email")
  end

  it "includes required indicator" do
    result = render_inline(FormInput.new(name: "email", label: "Email", required: true))
    expect(result.css('[aria-label="required"]').count).to eq(1)
    expect(result.css('input[aria-required="true"]').count).to eq(1)
  end

  it "applies error state" do
    result = render_inline(FormInput.new(name: "email", error: "Invalid"))
    expect(result.css('input[aria-invalid="true"]').count).to eq(1)
    expect(result.css('.text-red-600').text).to include("Invalid")
  end

  it "links helper text via aria-describedby" do
    result = render_inline(FormInput.new(name: "email", hint: "Help text"))
    input = result.css("input").first
    expect(input["aria-describedby"]).to include("-hint")
  end
end
```

---

## Implementation Checklist

- [ ] Implement input_classes method with state logic
- [ ] Implement label_classes, hint_classes, error_classes
- [ ] Implement aria_attributes method
- [ ] Add icon support with pl-10 padding
- [ ] Update template with HyperUI structure
- [ ] Write unit tests for all states
- [ ] Test accessibility with screen reader
- [ ] Visual regression testing

**Status**: Ready for Implementation
**Estimated Effort**: 1 day
**Priority**: High (foundational component)
