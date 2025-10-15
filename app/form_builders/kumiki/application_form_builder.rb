module Kumiki
  class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
    # ============================================================================
    # FORM FIELD METHODS - Delegate to Component Helpers
    # ============================================================================

    def text_field(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_input(
        field_name(method),
        type: "text",
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def email_field(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_input(
        field_name(method),
        type: "email",
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def password_field(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_input(
        field_name(method),
        type: "password",
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def number_field(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_input(
        field_name(method),
        type: "number",
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def date_field(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_date_picker(
        field_name(method),
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def time_field(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_input(
        field_name(method),
        type: "time",
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def datetime_local_field(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_input(
        field_name(method),
        type: "datetime-local",
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def file_field(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_file_input(
        field_name(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def select(method, choices = nil, options = {}, html_options = {})
      merged_options = options.merge(html_options)
      component_options, final_html_options = extract_component_and_html_options(method, merged_options)

      @template.form_select(
        field_name(method),
        choices,
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, merged_options),
        html_options: final_html_options,
        **component_options
      )
    end

    def textarea(method, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_textarea(
        field_name(method),
        value: object.try(method),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_checkbox(
        field_name(method),
        value: checked_value,
        checked: (object.try(method) == checked_value),
        object: object,
        attribute: method,
        label: extract_label_text(method, options),
        html_options: html_options,
        **component_options
      )
    end

    def radio_button(method, tag_value, options = {})
      component_options, html_options = extract_component_and_html_options(method, options)

      @template.form_radio(
        field_name(method),
        tag_value,
        checked: (object.try(method) == tag_value),
        object: object,
        attribute: method,
        label: extract_label_text(method, options, default: tag_value.to_s.humanize),
        html_options: html_options,
        **component_options
      )
    end

    def hidden_field(method, options = {})
      # Hidden fields don't need labels or error styling, use Rails' default
      super(method, options)
    end

    private

    # ============================================================================
    # UTILITY METHODS
    # ============================================================================

    def field_name(method)
      "#{object_name}[#{method}]"
    end

    def extract_label_text(method, options, default: nil)
      label_option = options[:label]

      case label_option
      when false
        false
      when String
        label_option
      when Hash
        # Return the full hash to preserve class and other options
        label_option
      else
        generate_label_text(method, default)
      end
    end

    def generate_label_text(method, default_text = nil)
      return default_text if default_text

      # Try I18n lookup first
      model_name = object_name.to_s.gsub(/\[.*\]/, "").to_sym

      i18n_key = "activemodel.attributes.#{model_name}.#{method}"
      translation = I18n.t(i18n_key, default: nil)

      if translation.present?
        return translation
      end

      # Fallback to helpers.label lookup
      i18n_key = "helpers.label.#{model_name}.#{method}"
      translation = I18n.t(i18n_key, default: nil)

      if translation.present?
        return translation
      end

      # Final fallback to humanized method name
      method.to_s.humanize
    end

    def extract_component_and_html_options(method, options)
      # Component-specific options that go directly to the component
      component_options = {}

      # Extract component-supported options
      [ :placeholder, :size, :disabled, :readonly, :required, :error ].each do |key|
        component_options[key] = options[key] if options.key?(key)
      end

      # Everything else goes to html_options for the underlying input
      html_options = options.except(:label, :placeholder, :size, :disabled, :readonly, :required, :error)

      [ component_options, html_options ]
    end
  end
end
