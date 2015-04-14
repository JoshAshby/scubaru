require 'scubaru/logging'

require 'scubaru/middleware'
require 'scubaru/subscriber'

module Scubaru
  extend Scubaru::Logging
end

require 'scubaru/railtie'
