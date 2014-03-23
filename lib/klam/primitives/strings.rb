module Klam
  module Primitives
    module Strings
      def pos(str, n)
        if n < 0 || n >= str.length
          raise ::Klam::Error, "index out of bounds: #{n}"
        end
        str[n]
      end

      def tlstr(str)
        if str.empty?
          raise ::Klam::Error, 'attempted to take tail of empty string'
        end
        str[1..-1]
      end

      def cn(s1, s2)
        s1 + s2
      end

      def str(x)
        case x
        when String
          '"' + x + '"'
        when Symbol
          x.to_s
        when Numeric
          x.to_s
        when TrueClass, FalseClass
          x.to_s
        when Proc
          x.to_s
        when IO
          x.to_s
        else
          raise ::Klam::Error, "str applied to non-atomic type: #{x.class}"
        end
      end

      def string?(x)
        x.kind_of?(String)
      end

      def n_to_string(n)
        '' << n
      end
      alias_method :"n->string", :n_to_string
      remove_method :n_to_string

      def string_to_n(str)
        str.ord
      end
      alias_method :"string->n", :string_to_n
      remove_method :string_to_n
    end
  end
end
