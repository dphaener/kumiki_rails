module RailsComponents
  module Components
    class Card
      attr_reader :bordered, :shadow, :color, :html_options

      def initialize(
        bordered: false,
        shadow: nil,
        color: "bg-base-100",
        html_options: {}
      )
        @bordered = bordered
        @shadow = shadow
        @color = color
        @html_options = html_options
      end

      def css_classes
        classes = [ "card" ]

        # Add border class
        classes << "card-border" if bordered

        # Add shadow class
        classes << "shadow-#{shadow}" if shadow

        # Add color class
        classes << color if color

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
        html_options.except(:class, "class").merge(
          class: css_classes
        )
      end
    end
  end
end
