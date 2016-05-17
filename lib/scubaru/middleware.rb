module Scubaru
  class Middleware
    include ActiveSupport::Configurable

    # Which urls should we change the log level for?
    config_accessor :blacklist do
      [
        { pattern: %r|^/assets/.*$|, method: nil }
      ]
    end

    # What should we change the log level to for the request if it matches
    config_accessor :log_level do
      Logger::ERROR
    end

    def initialize app
      @app = app
    end

    def call request
      headers = ActionDispatch::Http::Headers.new request
      return @app.call request unless blacklisted? headers

      old_level = Rails.logger.level
      Rails.logger.level = Scubaru::Middleware.log_level

      #msg = ["LET THEM DRINK TEA!!!!"]
      #res = [418, {"Content-Length" => msg.length.to_s}, msg]
      res = @app.call request

      Rails.logger.level = old_level

      res
    end

    protected

    def blacklisted? headers
      Scubaru::Middleware.blacklist.any? do |matchers|
        next false unless matchers[:pattern].match(headers["Path-Info"]).present?
        next true if matchers[:method].blank?
        matchers[:method] == headers["Request-Method"]
      end
    end
  end
end
