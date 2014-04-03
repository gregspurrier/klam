module Klam
  module Primitives
    module Vectors
      ABSVEC_TAG = :"[ABSVEC]"

      def absvector(n)
        vec = Array.new(n + 1)
        vec[-1] = ABSVEC_TAG
        vec
      end

      def absvec_store(vec, n, val)
        raise ::Klam::Error, "#{vec} is not a vector" unless absvector?(vec)
        if n < 0 || n >= (vec.length - 1)
          raise ::Klam::Error, "index out of bounds: #{n}"
        end
        vec[n] = val
        vec
      end
      alias_method :"address->", :absvec_store
      remove_method :absvec_store

      def absvec_read(vec, n)
        raise ::Klam::Error, "#{vec} is not a vector" unless absvector?(vec)
        if n < 0 || n >= (vec.length - 1)
          raise ::Klam::Error, "index out of bounds: #{n}"
        end
        vec[n]
      end
      alias_method :"<-address", :absvec_read
      remove_method :absvec_read

      def absvector?(v)
        v.instance_of?(Array) && v[-1] == ABSVEC_TAG
      end
    end
  end
end
