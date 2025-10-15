module Kumiki
  module Components
    class Modal
      attr_reader :id, :html_options

      def initialize(id: nil, html_options: {})
        @html_options = html_options || {}
        @id = determine_id(id)
      end

      def css_classes
        classes = [ "modal", "modal-open" ]

        # Merge with custom classes from html_options
        custom_classes = html_options[:class] || html_options["class"]
        if custom_classes
          if custom_classes.is_a?(Array)
            classes.concat(custom_classes.compact.reject(&:empty?))
          else
            classes.concat(custom_classes.to_s.split.reject(&:empty?))
          end
        end

        classes.join(" ")
      end

      def html_attributes
        attributes = html_options.except(:class, "class", :id, "id").merge(
          id: id,
          class: css_classes
        )

        # Add data attributes for Stimulus controller
        attributes["data-controller"] = "rails-components--dismiss"
        attributes["open"] = true  # Always open when rendered

        attributes
      end

      private

      def determine_id(id_param)
        # Priority: id parameter > html_options[:id] > html_options["id"] > generated
        return id_param.to_s if id_param && !id_param.to_s.strip.empty?

        html_id = html_options[:id] || html_options["id"]
        return html_id.to_s if html_id && !html_id.to_s.strip.empty?

        generate_unique_id
      end

      def generate_unique_id
        "modal-#{SecureRandom.hex(6)}"
      end
    end
  end
end
