module RailsComponents
  module Components
    class FormSelect
      attr_reader :name, :value, :options, :prompt, :size, :disabled, :required,
                  :error, :object, :attribute, :html_options, :label

      def initialize(
        name: nil,
        value: nil,
        options: [],
        prompt: nil,
        size: nil,
        disabled: false,
        required: false,
        error: false,
        object: nil,
        attribute: nil,
        label: nil,
        html_options: {},
        **kwargs
      )
        # Raise error if multiple parameter is passed
        if kwargs.key?(:multiple)
          raise ArgumentError, "FormSelect component only supports single selection. Use another component for multiple selection."
        end
        @name = name
        @value = value
        @options = options
        @prompt = prompt
        @size = size
        @disabled = disabled
        @required = required
        @error = error
        @object = object
        @attribute = attribute
        @label = label
        @html_options = html_options
      end

      def css_classes
        classes = [ "select", "select-bordered" ]

        # Add size class
        classes << "select-#{size}" if size

        # Add error class
        classes << "select-error" if error?

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

        # Add basic attributes if present
        attributes[:name] = name if name

        # Add boolean attributes
        attributes[:disabled] = true if disabled
        attributes[:required] = true if required

        # Add accessibility attributes
        attributes[:"aria-required"] = true if required
        if error?
          attributes[:"aria-invalid"] = true
          attributes[:"aria-describedby"] = "#{field_id}_errors" if field_id
        end

        # Always add ID for label association and accessibility
        attributes[:id] = field_id if field_id

        # Merge any additional HTML attributes from html_options
        html_options.each do |key, value|
          unless [ :class, "class", :name, :disabled, :required ].include?(key)
            attributes[key] = value
          end
        end

        attributes
      end

      def error?
        return true if @error

        return false unless object && attribute

        object.respond_to?(:errors) && object.errors[attribute]&.any?
      end

      def show_label?
        label != false && (label.present? || name.present?)
      end

      def label_text
        case label
        when String
          label
        when Hash
          label[:text] || label["text"] || humanized_name
        else
          humanized_name
        end
      end

      def label_class
        base_class = "label"
        if label.is_a?(Hash)
          custom_class = label[:class] || label["class"]
          base_class += " #{custom_class}" if custom_class
        end
        base_class
      end

      def label_text_class
        classes = [ "label-text", "text-base" ]
        if label.is_a?(Hash)
          custom_class = label[:class] || label["class"]
          classes << custom_class if custom_class
        end
        classes.join(" ")
      end

      def field_id
        name&.gsub(/\[|\]/, "_")&.gsub(/__+/, "_")&.gsub(/_$/, "")
      end

      def error_id
        "#{field_id}_errors" if field_id
      end

      def error_messages
        return [] unless error?

        if object && attribute && object.respond_to?(:errors)
          object.errors[attribute] || []
        else
          []
        end
      end

      private

      def humanized_name
        return "".dup unless name
        name.to_s.gsub(/\[.*\]/, "").humanize
      end
    end
  end
end
