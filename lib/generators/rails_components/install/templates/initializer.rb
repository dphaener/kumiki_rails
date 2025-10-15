# RailsComponents Configuration
# For more information, see: https://github.com/darinhaener/rails_components

RailsComponents.configure do |config|
  # Set to true to use RailsComponents form builder as the default for all forms
  # When enabled, all form_with calls will automatically use RailsComponents::ApplicationFormBuilder
  # config.use_as_default_form_builder = false

  # Enable component preview system (default: enabled in development/test)
  # Access previews at /rails_components/design/preview when enabled
  # config.enable_preview = Rails.env.development? || Rails.env.test?

  # Future configuration options:
  # - Component theme customization
  # - Default variant/size settings
  # - Custom CSS class prefixes
  # - Animation preferences
end
