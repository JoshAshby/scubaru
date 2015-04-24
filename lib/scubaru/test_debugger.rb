require 'minitest'
require 'minitest/test'

module Scubaru
  module TestDebugger

    def assert test, msg = nil
      begin
        super
      rescue Minitest::Assertion => e
        debugger
      end
    end

  end
end
