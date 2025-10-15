# Pin npm packages by running ./bin/importmap

# Hotwire's SPA-like page accelerator
pin "@hotwired/turbo-rails", to: "turbo.min.js"

# Hotwire's modest JavaScript framework
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Pin all Stimulus controllers from the engine
pin_all_from RailsComponents::Engine.root.join("app/javascript/rails_components/controllers"),
             under: "controllers/rails_components",
             to: "rails_components/controllers"
