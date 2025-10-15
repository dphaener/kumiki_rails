module RailsComponents
  module Components
    class Toast
      attr_reader :type, :title, :message, :dismissible, :auto_dismiss_delay, :html_options

      def initialize(
        type: "notice",
        title: nil,
        message: "",
        dismissible: true,
        auto_dismiss_delay: 5000,
        html_options: {}
      )
        @type = type
        @title = title
        @message = message
        @dismissible = dismissible
        @auto_dismiss_delay = auto_dismiss_delay
        @html_options = html_options
      end

      def css_classes
        classes = [ "alert", "bg-white", "shadow-lg", "border-l-4" ]

        # Add type-specific border color
        case type.to_s
        when "notice", "success"
          classes << "border-l-green-500"
        when "error", "danger"
          classes << "border-l-red-500"
        when "warning"
          classes << "border-l-yellow-500"
        else
          classes << "border-l-blue-500"
        end

        # Add animation and positioning classes
        classes << "slide-in-right"
        classes << "fixed"
        classes << "top-4"
        classes << "right-4"
        classes << "z-50"
        classes << "max-w-sm"
        classes << "rounded-lg"

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
          class: css_classes,
          role: "alert"
        )

        # Add data attribute for dismissible functionality
        if dismissible
          attributes["data-dismissible"] = "true"
        end

        # Add data attributes for auto-dismiss functionality
        if auto_dismiss_delay && auto_dismiss_delay > 0
          attributes["data-auto-dismiss-delay"] = auto_dismiss_delay
        end

        attributes
      end

      def icon
        case type.to_s
        when "notice", "success"
          '<svg class="w-5 h-5 text-green-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.236 4.53L7.53 10.53a.75.75 0 00-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z" clip-rule="evenodd" />
        </svg>'.html_safe
        when "error", "danger"
          '<svg class="w-5 h-5 text-red-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
          <path fill-rule="evenodd" d="M8.485 2.495c.673-1.167 2.357-1.167 3.03 0l6.28 10.875c.673 1.167-.17 2.625-1.516 2.625H3.72c-1.347 0-2.189-1.458-1.515-2.625L8.485 2.495zM10 5a.75.75 0 01.75.75v3.5a.75.75 0 01-1.5 0v-3.5A.75.75 0 0110 5zm0 9a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
        </svg>'.html_safe
        when "warning"
          '<svg class="w-5 h-5 text-yellow-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
          <path fill-rule="evenodd" d="M8.485 2.495c.673-1.167 2.357-1.167 3.03 0l6.28 10.875c.673 1.167-.17 2.625-1.516 2.625H3.72c-1.347 0-2.189-1.458-1.515-2.625L8.485 2.495zM10 5a.75.75 0 01.75.75v3.5a.75.75 0 01-1.5 0v-3.5A.75.75 0 0110 5zm0 9a1 1 0 100-2 1 1 0 000 2z" clip-rule="evenodd" />
        </svg>'.html_safe
        else
          '<svg class="w-5 h-5 text-blue-500" fill="currentColor" viewBox="0 0 20 20" aria-hidden="true">
          <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a.75.75 0 000 1.5h.253a.25.25 0 01.244.304l-.459 2.066A1.75 1.75 0 0010.747 15H11a.75.75 0 000-1.5h-.253a.25.25 0 01-.244-.304l.459-2.066A1.75 1.75 0 009.253 9H9z" clip-rule="evenodd" />
        </svg>'.html_safe
        end
      end
    end
  end
end
