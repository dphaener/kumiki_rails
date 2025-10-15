module RailsComponents
  module Components
    class FormFileInput
      attr_reader :name, :accept, :multiple, :disabled, :required, :size,
                  :error, :object, :attribute, :html_options, :label

      def initialize(
        name: nil,
        accept: nil,
        multiple: false,
        disabled: false,
        required: false,
        size: nil,
        error: false,
        object: nil,
        attribute: nil,
        label: nil,
        html_options: {}
      )
        @name = name
        @accept = accept
        @multiple = multiple
        @disabled = disabled
        @required = required
        @size = size
        @error = error
        @object = object
        @attribute = attribute
        @label = label
        @html_options = html_options
      end

      def css_classes
        classes = [ "file-input" ]

        # Get custom classes first to check for ghost variant and duplicates
        custom_classes = html_options[:class] || html_options["class"]
        custom_class_array = []
        if custom_classes
          if custom_classes.is_a?(Array)
            custom_class_array = custom_classes
          else
            custom_class_array = custom_classes.split
          end
        end

        # Add file-input-bordered by default, unless ghost variant is present
        # Ghost variants should not have bordered class
        has_ghost_variant = custom_class_array.any? { |cls| cls.include?("file-input-ghost") }

        unless has_ghost_variant
          # Only add file-input-bordered if it's not already in custom classes
          unless custom_class_array.include?("file-input-bordered")
            classes << "file-input-bordered"
          end
        end

        # Add size class
        classes << "file-input-#{size}" if size

        # Add error class
        classes << "file-input-error" if error?

        # Merge with custom classes, avoiding duplicates
        custom_class_array.each do |cls|
          classes << cls unless classes.include?(cls)
        end

        classes.join(" ")
      end

      def html_attributes
        attributes = html_options.except(:class, "class").merge(
          type: "file",
          class: css_classes
        )

        # Add basic attributes if present
        attributes[:name] = name if name
        attributes[:accept] = accept if accept

        # Add boolean attributes
        attributes[:multiple] = true if multiple
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
          unless [ :class, "class", :type, :name, :accept, :multiple, :disabled, :required ].include?(key)
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

      private

      def humanized_name
        return "".dup unless name
        name.to_s.gsub(/\[.*\]/, "").humanize
      end
    end
  end
end
