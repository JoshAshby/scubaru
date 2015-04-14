module Scubaru
  class Middleware

    BlacklistItem = Struct.new(:pattern, :method) do
      def match? headers
        unless pattern.match(headers["Path-Info"]).nil?
          res = true
          res = res && method == headers["Request-Method"] unless method.nil?

          res
        end || false
      end
    end

  end
end
