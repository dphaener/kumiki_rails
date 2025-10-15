require "rails/generators/base"

module RailsComponents
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Installs RailsComponents and generates configuration files"

      class_option :form_builder, type: :boolean, default: false,
                   desc: "Set RailsComponents form builder as default"
      class_option :preview_system, type: :boolean, default: true,
                   desc: "Enable component preview system"

      def check_dependencies
        return if defined?(Tailwind)

        say "Warning: Tailwind CSS not detected. Please ensure tailwindcss-rails gem is installed.", :yellow
      end

      def create_initializer
        template "initializer.rb", "config/initializers/rails_components.rb"
      end

      def configure_form_builder
        return unless options[:form_builder]

        inject_into_file "config/initializers/rails_components.rb",
                         after: "RailsComponents.configure do |config|\n" do
          "  config.use_as_default_form_builder = true\n"
        end
      end

      def configure_preview_system
        inject_into_file "config/initializers/rails_components.rb",
                         after: "RailsComponents.configure do |config|\n" do
          "  config.enable_preview = #{options[:preview_system]}\n"
        end
      end

      def setup_stimulus_controllers
        say "Setting up Stimulus controllers...", :cyan

        # Create application.js if it doesn't exist
        unless File.exist?("app/javascript/application.js")
          template "application.js", "app/javascript/application.js"
          say "Created app/javascript/application.js", :green
        else
          update_stimulus_application
        end
      end

      def copy_daisyui_plugin
        say "Copying DaisyUI plugin configuration...", :cyan
        template "daisyui.js", "app/assets/javascripts/daisyui.js"
        say "Created app/assets/javascripts/daisyui.js", :green
      end

      def update_tailwind_config
        say "Updating Tailwind configuration...", :cyan

        tailwind_config_path = detect_tailwind_config

        if tailwind_config_path
          inject_engine_paths_to_tailwind(tailwind_config_path)
        else
          say "Could not find Tailwind config. Checked:", :yellow
          say "  - config/tailwind.config.js", :yellow
          say "  - tailwind.config.js", :yellow
          say "  - config/tailwind.config.mjs", :yellow
          say "  - tailwind.config.mjs", :yellow
          say "\nPlease manually add RailsComponents paths to your Tailwind content array:", :yellow
          say "  './app/components/rails_components/**/*.{rb,erb,html}'", :yellow
          say "  './app/javascript/rails_components/**/*.js'", :yellow
        end
      end

      def add_importmap_pins
        return unless File.exist?("config/importmap.rb")

        say "Updating importmap configuration...", :cyan

        # Check if already pinned to avoid duplicates
        importmap_content = File.read("config/importmap.rb")

        unless importmap_content.include?("controllers/rails_components")
          append_to_file "config/importmap.rb" do
            "\n# RailsComponents Controllers\npin_all_from RailsComponents::Engine.root.join(\"app/javascript/rails_components/controllers\"),\n             under: \"controllers/rails_components\",\n             to: \"rails_components/controllers\"\n"
          end
          say "Added RailsComponents controller pins to importmap", :green
        else
          say "Importmap already contains RailsComponents pins", :yellow
        end
      end

      private

      def update_stimulus_application
        application_js = File.read("app/javascript/application.js")

        # Check if rails_components controllers are already imported
        if application_js.include?("rails_components")
          say "Stimulus application already includes RailsComponents controllers", :yellow
          return
        end

        # Add import for rails_components controllers
        import_statement = "\n// Import RailsComponents Stimulus controllers\nimport \"controllers/rails_components\"\n"

        # Try to insert after the last import statement
        if application_js =~ /^import .+$/
          insert_into_file "app/javascript/application.js",
                           import_statement,
                           after: /^import .+\n/
        else
          # If no imports, add at the beginning
          prepend_to_file "app/javascript/application.js", import_statement
        end

        say "Updated app/javascript/application.js with RailsComponents controllers", :green
      end

      def detect_tailwind_config
        possible_paths = [
          "config/tailwind.config.js",
          "tailwind.config.js",
          "config/tailwind.config.mjs",
          "tailwind.config.mjs"
        ]

        possible_paths.find { |path| File.exist?(path) }
      end

      def inject_engine_paths_to_tailwind(config_path)
        config_content = File.read(config_path)

        # Paths to inject
        engine_paths = [
          "'./app/components/rails_components/**/*.{rb,erb,html}'",
          "'./app/javascript/rails_components/**/*.js'"
        ]

        # Check if paths already exist
        if config_content.include?("rails_components")
          say "Tailwind config already includes RailsComponents paths", :yellow
          return
        end

        # Try to inject after content: [
        if config_content =~ /content:\s*\[/
          inject_into_file config_path,
                           after: /content:\s*\[\n/ do
            engine_paths.map { |path| "    #{path},\n" }.join
          end
          say "Updated #{config_path} to include RailsComponents paths", :green
        else
          say "Could not automatically update #{config_path}.", :yellow
          say "Please manually add these paths to your content array:", :yellow
          engine_paths.each { |path| say "  #{path}", :yellow }
        end
      end

      def show_post_install_message
        say "\n"
        say "=" * 80, :green
        say "RailsComponents has been installed successfully!", :green
        say "=" * 80, :green
        say "\n"

        # Summary of what was installed
        say "Installation Summary:", :cyan
        say "  ✓ Created config/initializers/rails_components.rb"
        say "  ✓ Copied DaisyUI plugin to app/assets/javascripts/daisyui.js"
        say "  ✓ Updated importmap.rb with RailsComponents controller pins"
        say "  ✓ Updated Stimulus application.js with controller imports"
        say "  ✓ Updated Tailwind config with engine component paths"
        say "\n"

        # Configuration status
        say "Configuration:", :cyan
        if options[:form_builder]
          say "  ✓ Form builder enabled as default"
        else
          say "  ○ Form builder available (not default)"
        end

        if options[:preview_system]
          say "  ✓ Preview system enabled"
        else
          say "  ○ Preview system disabled"
        end
        say "\n"

        # Next steps
        say "Next Steps:", :cyan
        say "1. Restart your Rails server to load the new configuration"
        say "2. Run asset pipeline to compile JavaScript and CSS:"
        say "     bin/rails assets:precompile" if Rails.env.production?
        say "     bin/dev (if using Procfile.dev)"
        say "\n"
        say "3. Verify Stimulus controllers are loaded:"
        say "     Open browser console and check for: window.Stimulus"
        say "\n"

        # Component usage examples
        say "Component Usage Examples:", :cyan
        say "  Buttons:"
        say "    <%= button 'Click me', variant: :primary %>"
        say "    <%= button 'Delete', variant: :error, outline: true %>"
        say "\n"
        say "  Badges:"
        say "    <%= badge 'New', variant: :success %>"
        say "    <%= badge 'Beta', variant: :warning, size: :lg %>"
        say "\n"
        say "  Cards:"
        say "    <%= card title: 'Card Title' do %>"
        say "      Card content here"
        say "    <% end %>"
        say "\n"
        say "  Alerts (with Stimulus):"
        say "    <%= alert 'Success message', variant: :success, dismissible: true %>"
        say "\n"

        # Form builder info
        if options[:form_builder]
          say "Form Builder (Enabled as Default):", :cyan
          say "  <%= form_with model: @user do |f| %>"
          say "    <%= f.text_field :name, label: 'Full Name' %>"
          say "    <%= f.email_field :email, required: true %>"
          say "    <%= f.submit 'Save' %>"
          say "  <% end %>"
        else
          say "Form Builder (Available):", :cyan
          say "  Option 1 - Use builder parameter:"
          say "    <%= form_with model: @user, builder: RailsComponents::ApplicationFormBuilder do |f| %>"
          say "      <%= f.text_field :name %>"
          say "    <% end %>"
          say "\n"
          say "  Option 2 - Enable as default in config/initializers/rails_components.rb:"
          say "    config.use_as_default_form_builder = true"
        end
        say "\n"

        # Preview system info
        if options[:preview_system]
          say "Preview System:", :cyan
          say "  Access component previews at: /rails/components"
          say "  Create previews in: test/components/previews/ or spec/components/previews/"
          say "\n"
        end

        # Tailwind customization
        say "Tailwind Customization:", :cyan
        say "  Configure DaisyUI themes in your Tailwind config:"
        say "    plugins: ["
        say "      require('./app/assets/javascripts/daisyui.js')({ themes: ['light', 'dark'] })"
        say "    ]"
        say "\n"

        # Documentation and resources
        say "Documentation & Resources:", :cyan
        say "  GitHub: https://github.com/darinhaener/rails_components"
        say "  DaisyUI Docs: https://daisyui.com/"
        say "  Stimulus Handbook: https://stimulus.hotwired.dev/"
        say "\n"

        # Troubleshooting
        say "Troubleshooting:", :cyan
        say "  If components don't render correctly:"
        say "    1. Ensure Tailwind is processing engine paths (check Tailwind config)"
        say "    2. Verify importmap pins are loaded (check browser console)"
        say "    3. Clear browser cache and restart Rails server"
        say "    4. Run: bin/rails assets:clobber && bin/rails assets:precompile"
        say "\n"

        say "=" * 80, :green
        say "Happy building with RailsComponents!", :green
        say "=" * 80, :green
        say "\n"
      end
    end
  end
end
