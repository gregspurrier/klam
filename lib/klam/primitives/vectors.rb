module Klam
  module Primitives
    module Vectors
      def absvector(n)
        ::Klam::Absvector.new(n)
      end

      def absvec_store(vec, n, val)
        ::Kernel.raise ::Klam::Error, "#{vec} is not a vector" unless absvector?(vec)
        if n < 0 || n >= vec.upper_limit
          ::Kernel.raise ::Klam::Error, "index out of bounds: #{n}"
        end
        vec[n] = val
        vec
      end
      alias_method :"address->", :absvec_store
      remove_method :absvec_store

      def absvec_read(vec, n)
        ::Kernel.raise ::Klam::Error, "#{vec} is not a vector" unless absvector?(vec)
        if n < 0 || n >= vec.upper_limit
          ::Kernel.raise ::Klam::Error, "index out of bounds: #{n}"
        end
        vec[n]
      end
      alias_method :"<-address", :absvec_read
      remove_method :absvec_read

      def absvector?(v)
        v.instance_of?(::Klam::Absvector)
      end
    end
  end
end
