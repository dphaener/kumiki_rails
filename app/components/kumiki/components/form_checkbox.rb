module Kumiki
  module Components
    class FormCheckbox
      attr_reader :name, :value, :label, :checked, :disabled, :required, :size,
                  :error, :object, :attribute, :html_options

      def initialize(
        name: nil,
        value: nil,
        label: nil,
        checked: false,
        disabled: false,
        required: false,
        size: nil,
        error: false,
        object: nil,
        attribute: nil,
        html_options: {}
      )
        @name = name
        @value = value
        @label = label
        @checked = checked
        @disabled = disabled
        @required = required
        @size = size
        @error = error
        @object = object
        @attribute = attribute
        @html_options = html_options
      end

      def css_classes
        classes = [ "checkbox" ]

        # Add size class
        classes << "checkbox-#{size}" if size

        # Add error class
        classes << "checkbox-error" if error?

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
          type: "checkbox",
          class: css_classes
        )

        # Add basic attributes if present
        attributes[:name] = name if name
        attributes[:value] = value if value

        # Add boolean attributes - handle falsy values properly
        attributes[:checked] = true if checked_value?
        attributes[:disabled] = true if disabled
        attributes[:required] = true if required

        # Add accessibility attributes
        attributes[:"aria-required"] = true if required
        attributes[:"aria-invalid"] = true if error?

        # Always add ID for label association
        attributes[:id] = field_id if field_id

        # Merge any additional HTML attributes from html_options
        html_options.each do |key, value|
          unless [ :class, "class", :type, :name, :value, :checked, :disabled, :required ].include?(key)
            attributes[key] = value
          end
        end

        attributes
      end

      def field_id
        name&.gsub(/\[|\]/, "_")&.gsub(/__+/, "_")&.gsub(/_$/, "")
      end

      def error?
        return true if @error

        return false unless object && attribute

        object.respond_to?(:errors) && object.errors[attribute]&.any?
      end

      private

      def checked_value?
        return false if checked.nil? || checked == false
        return false if checked.to_s.match?(/\A(0|false|off|no|)\z/i)
        true
      end
    end
  end
end
