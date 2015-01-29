module Klam
  class Cons
    include Enumerable
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

    def each
      x = self
      until x == Klam::Primitives::Lists::EMPTY_LIST
        yield x.hd
        x = x.tl
      end
    end
  end
end
