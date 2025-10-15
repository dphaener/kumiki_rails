require "kumiki/version"
require "kumiki/engine"

module Kumiki
  class Configuration
    attr_accessor :use_as_default_form_builder, :enable_preview

    def initialize
      @use_as_default_form_builder = false
      @enable_preview = Rails.env.development? || Rails.env.test?
    end
  end

  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset_configuration!
      @configuration = Configuration.new
    end
  end
end
