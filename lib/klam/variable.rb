module Klam
  class Variable
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def to_s
      name
    end

    def ==(other)
      other.kind_of?(Variable) && name == other.name
    end

    def hash
      name.hash
    end
  end
end
