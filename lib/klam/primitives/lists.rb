module Klam
  module Primitives
    module Lists
      EMPTY_LIST = nil

      def cons(head, tail)
        ::Klam::Cons.new(head, tail)
      end

      def hd(l)
        l.hd
      end

      def tl(l)
        l.tl
      end

      def cons?(l)
        l.instance_of?(::Klam::Cons)
      end
    end
  end
end
