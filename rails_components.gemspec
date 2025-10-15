require_relative "lib/rails_components/version"

Gem::Specification.new do |spec|
  spec.name        = "rails_components"
  spec.version     = RailsComponents::VERSION
  spec.authors     = [ "Darin Haener" ]
  spec.email       = [ "darin.haener@hey.com" ]
  spec.homepage    = "https://github.com/darinhaener/rails_components"
  spec.summary     = "Production-ready UI components for Rails 8+ applications"
  spec.description = "A Rails engine providing modern, accessible UI components with Tailwind CSS and DaisyUI styling, including form builders and interactive elements that follow Rails conventions."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/darinhaener/rails_components"
  spec.metadata["changelog_uri"] = "https://github.com/darinhaener/rails_components/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # Ruby version requirement
  spec.required_ruby_version = ">= 3.2.0"

  # Runtime dependencies
  spec.add_dependency "rails", ">= 8.0.0"
  spec.add_dependency "tailwindcss-rails", ">= 4.0.0"
  spec.add_dependency "stimulus-rails", ">= 1.0"
  spec.add_dependency "turbo-rails", ">= 2.0"
  spec.add_dependency "importmap-rails", ">= 1.0"
  spec.add_dependency "propshaft", ">= 0.8.0"
end
