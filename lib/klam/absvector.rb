module Klam
  class Absvector < Array
    attr_reader :upper_limit

    def initialize(n, val = nil)
      super(n, val)
      @upper_limit = n
    end
  end
end
