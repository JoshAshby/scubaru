module Scubaru
  module Logging

    # Logging instance for just Lytic to use
    def logger
      @logger ||= _new_logger
    end

    private
    def _new_logger
      logger = Logger.new("#{ Rails.root }/log/scubaru.log")
      logger.level = Logger::INFO
      logger
    end

  end
end
