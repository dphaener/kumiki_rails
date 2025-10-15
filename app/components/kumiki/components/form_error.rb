module Kumiki
  module Components
    class FormError
      attr_reader :message, :messages, :object, :attribute, :html_options

      def initialize(
        message: nil,
        messages: nil,
        object: nil,
        attribute: nil,
        html_options: {}
      )
        @message = message
        @messages = messages
        @object = object
        @attribute = attribute
        @html_options = html_options
      end

      def css_classes
        classes = [ "text-error", "text-sm", "mt-1" ]

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

      def has_errors?
        error_messages.any?
      end

      def error_messages
        # Priority: message > messages > object+attribute
        if message && !message.to_s.strip.empty?
          [ message ]
        elsif messages && messages.is_a?(Array)
          messages.reject { |msg| msg.to_s.strip.empty? }
        elsif object && attribute && object.respond_to?(:errors)
          # Use safe navigation to handle nil errors
          return [] unless object.errors

          # Use errors.where to get ActiveModel::Error objects with options
          error_objects = object.errors.where(attribute)

          error_objects.map do |error|
            # Interpolate message with options (e.g., %{count} => 5)
            msg = error.message
            error.options.each do |key, value|
              msg = msg.gsub("%{#{key}}", value.to_s)
            end
            msg
          end
        else
          []
        end
      end
    end
  end
end
