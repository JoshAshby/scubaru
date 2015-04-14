require 'scubaru/lister'
require 'scubaru/subscriber/blacklist_item'

module Scubaru
  class Subscriber
    include ActiveSupport::Configurable

    config_accessor :enable do
      true
    end

    # What notification patterns do we not want to log?
    config_accessor :blacklist do
      Scubaru::Lister.new(items: [
        Scubaru::Subscriber::BlacklistItem.new(%r|action_|),
        Scubaru::Subscriber::BlacklistItem.new(%r|active_|),
        Scubaru::Subscriber::BlacklistItem.new(%r|railtie|)
      ])
    end

    config_accessor :direction do
      :forward
    end

    config_accessor :delimiter do
      '.'
    end

    def self.attach_to_all
      ActiveSupport::Notifications.subscribe /.*/, new
    end

    def call message, *args
      message = message.to_s

      if Scubaru::Subscriber.blacklist.match? message
        Scubaru.logger.debug "Skipping notification for #{ message.humanize }" and return
      end

      if Scubaru::Subscriber.direction == :forward
        method = message.split(Scubaru::Subscriber.delimiter, 2)[1]
      else
        method = message.reverse.split(Scubaru::Subscriber.delimiter, 2)[1].reverse
      end

      method.gsub! Scubaru::Subscriber.delimiter, '_'

      send method, ActiveSupport::Notifications::Event.new(message, *args)
    end

    def method_missing method, event=nil
      method = method.to_s

      if event.blank?
        Scubaru.logger.debug "Args didn't have an event in them for methodod #{ method }"
        Scubaru.logger.ap event
        return nil
      end

      namespace = event.name.split('.').first.to_s

      title = " Event: #{ namespace.humanize } - #{ method.humanize } "

      Scubaru.logger.info "\033[1;31m===============#{ title }===============\033[0m"
      Scubaru.logger.info "Event #{ event.name } took #{ event.duration }ms to complete"
      Scubaru.logger.info "method: #{ method }"
      Scubaru.logger.info "Payload:"
      Scubaru.logger.ap event.payload, :info
      Scubaru.logger.info "\033[1;31m------------------------------#{ "-" * title.length }\033[0m"
    end

  end
end
