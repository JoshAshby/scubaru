require 'scubaru/logging'

require 'scubaru/middleware'
require 'scubaru/subscriber'

require 'scubaru/test_debugger'

module Scubaru
  extend Scubaru::Logging
end

require 'scubaru/railtie'
