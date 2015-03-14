module Klam
  class ConstantGenerator
    def initialize
      @index = 0
    end

    def next
      @index += 1
      Klam::Constant.new('__KLAMC_%03d' % @index)
    end
  end
end
