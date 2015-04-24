require 'scubaru/lister'
require 'scubaru/middleware/blacklist_item'

module Scubaru
  class Middleware
    include ActiveSupport::Configurable

    config_accessor :enable do
      false
    end

    # Which urls should we change the log level for?
    config_accessor :blacklist do
      Scubaru::Lister.new(items: [
        Scubaru::Middleware::BlacklistItem.new(%r|^/assets/.*$|, nil)
      ])
    end

    # What should we change the log level to for the request if it matches
    config_accessor :log_level do
      Logger::ERROR
    end

    def initialize app
      @app = app
    end

    def call request
      return @app.call request unless Scubaru::Middleware.enable

      headers = ActionDispatch::Http::Headers.new request

      if Scubaru::Middleware.blacklist.match? headers
        old_level = Rails.logger.level
        Rails.logger.level = Scubaru::Middleware.log_level

        #msg = ["LET THEM DRINK TEA!!!!"]
        #res = [418, {"Content-Length" => msg.length.to_s}, msg]
        res = @app.call request

        Rails.logger.level = old_level
      else
        res = @app.call request
      end

      res
    end

  end
end
