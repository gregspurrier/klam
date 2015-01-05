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
  end
end
