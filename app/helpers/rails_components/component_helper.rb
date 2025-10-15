module RailsComponents
  module ComponentHelper
    def component(path, locals = {}, &block)
      full_path = Pathname.new("rails_components/components") / path

      if block
        content = capture { block.call }

        render(full_path.to_s, locals) { content }
      else
        render(full_path.to_s, locals)
      end
    end

    def button(text = "", **options, &block)
      button_data = RailsComponents::Components::Button.new(text: text, **options)
      component("button", button_data: button_data, &block)
    end

    def card(**options, &block)
      card_data = RailsComponents::Components::Card.new(**options)
      component("card", card_data: card_data, &block)
    end

    def badge(text = "", **options, &block)
      badge_data = RailsComponents::Components::Badge.new(text: text, **options)
      component("badge", badge_data: badge_data, &block)
    end

    # Form Input Components

    def form_input(name, **options)
      form_input_data = RailsComponents::Components::FormInput.new(name: name, **options)
      component("form_input", component_data: form_input_data)
    end

    def form_select(name, options_for_select = [], **options)
      form_select_data = RailsComponents::Components::FormSelect.new(name: name, options: options_for_select, **options)
      component("form_select", component_data: form_select_data)
    end

    def form_textarea(name, **options)
      form_textarea_data = RailsComponents::Components::FormTextarea.new(name: name, **options)
      component("form_textarea", component_data: form_textarea_data)
    end

    def form_checkbox(name, **options)
      form_checkbox_data = RailsComponents::Components::FormCheckbox.new(name: name, **options)
      component("form_checkbox", component_data: form_checkbox_data)
    end

    def form_radio(name, value, **options)
      form_radio_data = RailsComponents::Components::FormRadio.new(name: name, value: value, **options)
      component("form_radio", component_data: form_radio_data)
    end

    def form_date_picker(name, **options)
      form_date_picker_data = RailsComponents::Components::FormDatePicker.new(name: name, **options)
      component("form_date_picker", component_data: form_date_picker_data)
    end

    def form_file_input(name, **options)
      form_file_input_data = RailsComponents::Components::FormFileInput.new(name: name, **options)
      component("form_file_input", component_data: form_file_input_data)
    end

    def form_error(object: nil, attribute: nil, message: nil, messages: nil, **options)
      form_error_data = RailsComponents::Components::FormError.new(object: object, attribute: attribute, message: message, messages: messages, **options)
      component("form_error", component_data: form_error_data)
    end

    # Modal and Toast Components

    def modal(**options, &block)
      modal_data = RailsComponents::Components::Modal.new(**options)
      component("modal", modal_data: modal_data, &block)
    end

    def toast(**options)
      toast_data = RailsComponents::Components::Toast.new(**options)
      component("toast", toast_data: toast_data)
    end
  end
end
