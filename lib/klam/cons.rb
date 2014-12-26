module Klam
  class Cons
    attr_reader :hd, :tl

    def initialize(hd, tl)
      @hd = hd
      @tl = tl
    end

    def ==(other)
      other.instance_of?(Cons) && other.hd == @hd && other.tl == @tl
    end

    def hash
      [@hd, @tl].hash
    end
  end
end
