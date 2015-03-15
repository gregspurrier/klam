module Klam
  class Absvector
    include Enumerable
    attr_reader :size, :array

    def initialize(n_or_array, fill = nil)
      if n_or_array.kind_of?(Array)
        # This is a convenience constructor for making Shen vectors from Ruby
        # Arrays. Shen vectors use 1-based indexing and store the size in
        # slot zero.
        @array = Array.new(n_or_array)
        @array.unshift(@array.size)
      else
        @array = Array.new(n_or_array, fill)
      end
        @size = @array.size
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
