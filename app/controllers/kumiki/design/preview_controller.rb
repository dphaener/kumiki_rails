module Kumiki
  module Design
    class PreviewController < ApplicationController
      before_action :verify_preview_enabled
      before_action :verify_development_environment

      def index
        # All component data will be set up in the view
      end

      private

      def verify_preview_enabled
        unless Kumiki.configuration.enable_preview
          raise ActionController::RoutingError, "Preview is not enabled"
        end
      end

      def verify_development_environment
        unless Rails.env.development? || Rails.env.test?
          raise ActionController::RoutingError, "Preview is only available in development and test environments"
        end
      end
    end
  end
end
