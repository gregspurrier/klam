module Klam
  module Primitives
    module Arithmetic
      def +(a, b)
        a + b
      end

      def -(a, b)
        a - b
      end

      def *(a, b)
        a * b
      end

      def /(a, b)
        # Kl does not make a distinction between integers and reals.  Dividing
        # the integer 3 by the interger 2 must yield 1.5 rather than 1.  We'd
        # like to keep things in integers as much as possible, so we coerce a
        # to a float only if integer division is not possible.
        if a.kind_of?(Integer) && b.kind_of?(Integer) && a.remainder(b) != 0
          a = a.to_f
        end

        a / b
      end

      def <(a, b)
        a < b
      end

      def >(a, b)
        a > b
      end

      def <=(a, b)
        a <= b
      end

      def >=(a, b)
        a >= b
      end

      def number?(a)
        a.kind_of?(Numeric)
      end
    end
  end
end
