module Scubaru
  class Subscriber
    include ActiveSupport::Configurable

    config_accessor :accessor do
      -> (asn_event) { asn_event }
    end

    # What notification patterns do we not want to log?
    config_accessor :blacklist do
      [
        %r|action_|,
        %r|active_|,
        %r|railtie|
      ]
    end

    config_accessor :fqn_direction do
      :reverse
    end

    config_accessor :delimiter do
      '.'
    end

    def self.attach_to_all
      ActiveSupport::Notifications.subscribe(/(.*)/, new)
    end

    # Well... This is a bit long... :|
    def call message, *args
      message = message.to_s

      if blacklisted? message
        Scubaru.logger.debug ">> Skipping notification for #{ message.humanize }"
        return
      end

      event = ActiveSupport::Notifications::Event.new(message, *args)

      if event.payload.blank?
        Scubaru.logger.debug "<< Payload is empty for #{ event.name }"
        Scubaru.logger.ap event
        return
      end

      log_event message, event
    end

    protected

    def blacklisted? method
      Scubaru::Subscriber.blacklist.any? do |pattern|
        pattern.match method
      end
    end

    def log_event message, event
      method = message.split Scubaru::Subscriber.delimiter

      case Scubaru::Subscriber.fqn_direction
      when :forward
        namespace = method.shift
      when :reverse
        namespace = method.pop
      end

      payload = Scubaru::Subscriber.accessor[ event.payload ]

      method = method.join '_'
      title = " Event: #{ method.titlecase } Namespace: #{ namespace.titlecase }"

      Scubaru.logger.info "\033[1;31m===============#{ title }===============\033[0m"
      Scubaru.logger.info "Event #{ event.name } took #{ event.duration }ms to complete"
      Scubaru.logger.info "method: #{ method }"
      Scubaru.logger.info "Payload:"
      Scubaru.logger.ap payload, :info
      Scubaru.logger.info "\033[1;31m------------------------------#{ "-" * title.length }\033[0m"
    end
  end
end
