module Scubaru
  class Subscriber

    BlacklistItem = Struct.new(:pattern) do
      def match? method
        ! pattern.match(method).nil?
      end
    end

  end
end
