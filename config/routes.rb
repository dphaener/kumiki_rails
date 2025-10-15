RailsComponents::Engine.routes.draw do
  # Preview routes - only enabled if configured
  if RailsComponents.configuration.enable_preview
    namespace :design do
      get "preview", to: "preview#index"
    end
  end
end
