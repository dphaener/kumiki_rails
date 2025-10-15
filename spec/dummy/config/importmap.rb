# Pin npm packages by running ./bin/importmap

# Hotwire's SPA-like page accelerator
pin "application"

# Hotwire's Turbo
pin "@hotwired/turbo-rails", to: "turbo.min.js"

# Hotwire's Stimulus framework
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# Pin application JavaScript controllers
pin_all_from "app/javascript/controllers", under: "controllers"
