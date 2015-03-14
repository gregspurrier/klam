module Klam
  class VariableGenerator
    def initialize
      @index = 0
    end

    def next
      @index += 1
      Klam::Variable.new('__KLAMV_%03d' % @index)
    end
  end
end
