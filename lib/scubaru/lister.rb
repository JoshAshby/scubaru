module Scubaru
  # Represents a generic blacklist. Items should be instances of an object
  # with a `match?` method, and should return true or false.
  #
  # @example
  #   blist = Blacklist.new(items: [
  #     BlacklistItem.new(/^hi$/)
  #   ])
  #
  #   blist.match? "hi"
  #   => true
  class Lister

    def initialize items: []
      @items = items
    end

    def match? *args
      @items.select{ |item| item.match? *args }.any?
    end

  end

end
