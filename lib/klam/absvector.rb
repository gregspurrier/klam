module Klam
  class Absvector < Array
    def [](i)
      if i < 0 || i >= size
        raise Klam::Error, "index out of bounds: #{i}"
      end
      super(i)
    end

    def []=(i, x)
      if i < 0 || i >= size
        raise Klam::Error, "index out of bounds: #{i}"
      end
      super(i, x)
    end

    def store(i, x)
      self[i] = x
      self
    end

    # In Shen, the data types that are implemented on top of absvectors
    # use index 0 for auxilliary information. To ease interop scenarios,
    # to_a and each are overridden to skip the first slot.
    def each(&blk)
      to_a.each(&blk)
    end

    def to_a
      a = super
      a.shift
      a
    end
  end
end
