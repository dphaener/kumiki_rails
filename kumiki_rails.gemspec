require_relative "lib/kumiki/version"

Gem::Specification.new do |spec|
  spec.name        = "kumiki_rails"
  spec.version     = Kumiki::VERSION
  spec.authors     = [ "Darin Haener" ]
  spec.email       = [ "darin.haener@hey.com" ]
  spec.homepage    = "https://github.com/darinhaener/kumiki_rails"
  spec.summary     = "組木 Kumiki Rails - Modular UI components that fit together perfectly"
  spec.description = "Kumiki (組木) is a Rails engine providing interlocking UI components inspired by traditional Japanese wooden puzzles. Built with ViewComponent, Tailwind CSS, and DaisyUI, each component is crafted to fit seamlessly into your Rails application. Includes form builders, interactive elements, and follows Rails conventions."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/darinhaener/kumiki_rails"
  spec.metadata["changelog_uri"] = "https://github.com/darinhaener/kumiki_rails/blob/main/CHANGELOG.md"

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
