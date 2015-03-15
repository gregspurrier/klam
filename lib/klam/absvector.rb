module Klam
  class Absvector
    attr_reader :size, :array

    def initialize(n, fill = nil)
      @size = n
      @array = Array.new(n, fill)
    end

    def [](i)
      if i < 0 || i >= @size
        raise Klam::Error, "index out of bounds: #{i}"
      end
      @array[i]
    end

    def store(i, x)
      if i < 0 || i >= @size
        raise Klam::Error, "index out of bounds: #{i}"
      end
      @array[i] = x
      self
    end

    # In Shen, the data types that are implemented on top of absvectors
    # use index 0 for auxilliary information. To ease interop scenarios,
    # to_a and each are overridden to skip the first slot.
    def each(&blk)
      to_a.each(&blk)
    end

    def to_a
      @array[1..-1]
    end

    def ==(other)
      other.kind_of?(Klam::Absvector) && other.size == @size &&
        other.array == @array
    end

    def hash
      @array.hash
    end
  end
end
