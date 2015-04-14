module Scubaru
  class Subscriber

    BlacklistItem = Struct.new(:pattern) do
      def match? method
        method.starts_with? pattern
      end
    end

  end
end
