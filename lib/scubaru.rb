require 'scubaru/logging'

require 'scubaru/middleware'
require 'scubaru/subscriber'

module Scubaru
  extend Scubaru::Logging

  include ActiveSupport::Configurable

  config_accessor :middleware do
    true
  end

  config_accessor :subscriber do
    true
  end

end

require 'scubaru/railtie'
