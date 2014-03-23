module Klam
  module Primitives
    # All of the boolean operations are special forms, but if, and, and or
    # are also available as normal functions to facilitate partial application.
    # When partially applied, they are no longer short circuiting.
    module BooleanOperations
      def _if(a, b, c)
        a ? b : c
      end
      alias_method :'if', :_if
      remove_method :_if

      def and(a, b)
        a && b
      end

      def or(a, b)
        a || b
      end
    end
  end
end
