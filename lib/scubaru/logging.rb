require 'awesome_print'

module Scubaru
  module Logging
    include ActiveSupport::Configurable

    config_accessor :log_name do
      'log/scubaru.log'
    end

    # Logging instance for just Lytic to use
    def logger
      @logger ||= _new_logger
    end

    private
    def _new_logger
      logger = Logger.new("#{ Rails.root }/#{ Scubaru::Logging.log_name }")
      logger.level = Logger::INFO
      logger
    end

  end
end
