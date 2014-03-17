module Klam
  module Primitives
    module Lists
      # Cons cells are represented as three-place arrays. The first element contains
      # the head. The second element contains the tail. The third element
      # contains a type tag that is used to differentiate cons cells from
      # absvectors.
      #
      # This representation has two advantages over using a user-defined Cons
      # class:
      #   1. Its performance is better
      #   2. It can be read directly by the Ruby reader
      EMPTY_LIST = nil
      CONS_TAG = ":[CONS]"

      def cons(head, tail)
        [head, tail, CONS_TAG]
      end

      def hd(l)
        l[0]
      end

      def tl(l)
        l[1]
      end

      def cons?(l)
        l.instance_of?(Array) && l[2] == CONS_TAG
      end
    end
  end
end
