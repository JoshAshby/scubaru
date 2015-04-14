module Scubaru
  class Railtie < Rails::Railtie

    initializer :scubaru do |application|
      if Scubaru.middleware
        application.middleware.insert_before Rack::Sendfile, Scubaru::Middleware
      end

      if Scubaru.subscriber
        Scubaru::Subscriber.attach_to_all
      end
    end

  end
end
