require 'scubaru/lister'
require 'scubaru/subscriber/blacklist_item'

module Scubaru
  class Subscriber
    include ActiveSupport::Configurable

    # What notification patterns do we not want to log?
    config_accessor :blacklist do
      Scubaru::Lister.new(items: [
        Scubaru::Subscriber::BlacklistItem.new("action_"),
        Scubaru::Subscriber::BlacklistItem.new("active_"),
        Scubaru::Subscriber::BlacklistItem.new("railtie")
      ])
    end

    def self.attach_to_all
      ActiveSupport::Notifications.subscribe /^[^!]/, new
    end

    def call message, *args
      method = message.gsub /^.*\./, ''
      send method, ActiveSupport::Notifications::Event.new(message, *args)
    end

    def method_missing method, *args, &block
      method = method.to_s

      if Scubaru::Subscriber.blacklist.match? method
        Scubaru.logger.debug "Skipping notification for #{ method.humanize }"
      else
        event = args.first
        if event
          namespace = event.name.split('.').first.to_s

          title = " Event: #{ namespace.humanize } - #{ method.humanize } "

          Scubaru.logger.info "\033[1;31m===============#{ title }===============\033[0m"
          Scubaru.logger.info "Event #{ event.name } took #{ event.duration }ms to complete"
          Scubaru.logger.info "Payload:"
          Scubaru.logger.ap event.payload, :info
          Scubaru.logger.info "\033[1;31m------------------------------#{ "-" * title.length }\033[0m"
        else
          Scubaru.logger.debug "Args didn't have an event in them for event #{ method.humanize }"
          Scubaru.logger.ap args
        end
      end
    end

  end
end
