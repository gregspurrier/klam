module Klam
  class Constant
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def to_s
      name
    end

    def ==(other)
      other.kind_of?(Constant) && name == other.name
    end

    def hash
      name.hash
    end
  end
end
