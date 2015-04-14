module Scubaru
  class Railtie < Rails::Railtie

    initializer :scubaru do |application|
      if Scubaru::Middleware.enable
        application.middleware.insert_before Rack::Sendfile, Scubaru::Middleware
      end

      if Scubaru::Subscriber.enable
        Scubaru::Subscriber.attach_to_all
      end
    end

  end
end
