module Scubaru
  class Railtie < Rails::Railtie

    initializer :scubaru do |application|
      application.middleware.insert_before Rack::Sendfile, Scubaru::Middleware

      Scubaru::Subscriber.attach_to_all
    end

  end
end
