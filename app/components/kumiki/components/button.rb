module Kumiki
  module Components
    class Button
      attr_reader :text, :type, :variant, :size, :style, :shape, :icon_left, :icon_right,
                  :loading, :disabled, :active, :html_options

      def initialize(
        text: "",
        type: "button",
        variant: nil,
        size: nil,
        style: nil,
        shape: nil,
        icon_left: nil,
        icon_right: nil,
        loading: false,
        disabled: false,
        active: false,
        html_options: {}
      )
        @text = text
        @type = type
        @variant = variant
        @size = size
        @style = style
        @shape = shape
        @icon_left = icon_left
        @icon_right = icon_right
        @loading = loading
        @disabled = disabled
        @active = active
        @html_options = html_options
      end

      def css_classes
        classes = [ "btn" ]

        # Add variant class
        classes << "btn-#{variant}" if variant

        # Add size class
        classes << "btn-#{size}" if size

        # Add style modifier class
        classes << "btn-#{style}" if style

        # Add shape modifier class
        classes << "btn-#{shape}" if shape

        # Add state classes
        classes << "loading" if loading
        classes << "btn-disabled" if disabled
        classes << "btn-active" if active

        # Merge with custom classes from html_options
        custom_classes = html_options[:class] || html_options["class"]
        if custom_classes
          if custom_classes.is_a?(Array)
            classes.concat(custom_classes)
          else
            classes.concat(custom_classes.split)
          end
        end

        classes.join(" ")
      end

      def html_attributes
        attributes = html_options.except(:class, "class").merge(
          type: type,
          class: css_classes
        )

        # Add disabled attribute if disabled or loading
        attributes[:disabled] = true if disabled || loading

        attributes
      end
    end
  end
end
