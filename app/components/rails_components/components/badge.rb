module RailsComponents
  module Components
    class Badge
      attr_reader :text, :variant, :size, :style, :icon_left, :icon_right, :html_options

      def initialize(
        text: "",
        variant: nil,
        size: nil,
        style: nil,
        icon_left: nil,
        icon_right: nil,
        html_options: {}
      )
        @text = text
        @variant = variant
        @size = size
        @style = style
        @icon_left = icon_left
        @icon_right = icon_right
        @html_options = html_options
      end

      def css_classes
        classes = [ "badge" ]

        # Add variant class
        classes << "badge-#{variant}" if variant

        # Add size class
        classes << "badge-#{size}" if size

        # Add style modifier class
        classes << "badge-#{style}" if style

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
          class: css_classes
        )

        attributes
      end
    end
  end
end
