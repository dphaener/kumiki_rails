module RailsComponents
  class Engine < ::Rails::Engine
    isolate_namespace RailsComponents

    # Configure generators to use RSpec
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end

    # Auto-include ComponentHelper in all views
    initializer "rails_components.include_helpers" do
      ActiveSupport.on_load(:action_view) do
        include RailsComponents::ComponentHelper
      end
    end

    # Configure Zeitwerk for Components namespace
    initializer "rails_components.components_namespace" do |app|
      unless app.config.eager_load_namespaces.include?(RailsComponents)
        app.config.eager_load_namespaces << RailsComponents
      end
    end

    # Load engine assets into the host application
    initializer "rails_components.assets" do |app|
      # Add engine assets to the asset pipeline
      app.config.assets.paths << root.join("app/assets/stylesheets")
      app.config.assets.paths << root.join("app/assets/images")
      app.config.assets.paths << root.join("app/javascript")

      # Precompile engine assets
      app.config.assets.precompile += %w[
        rails_components/application.css
      ]
    end

    # Configure importmap for the engine
    initializer "rails_components.importmap", before: "importmap" do |app|
      # Load the engine's importmap configuration
      if defined?(Importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")

        # Ensure engine JavaScript is available to importmap
        app.config.importmap.cache_sweepers << root.join("app/javascript")
      end
    end

    # Conditionally set default form builder if configured
    initializer "rails_components.form_builder", after: :load_config_initializers do |app|
      if RailsComponents.configuration.use_as_default_form_builder
        app.config.action_view.default_form_builder = RailsComponents::ApplicationFormBuilder
      end
    end
  end
end
