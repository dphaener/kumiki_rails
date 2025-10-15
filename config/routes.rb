Kumiki::Engine.routes.draw do
  # Preview routes - only enabled if configured
  if Kumiki.configuration.enable_preview
    namespace :design do
      get "preview", to: "preview#index"
    end
  end
end
