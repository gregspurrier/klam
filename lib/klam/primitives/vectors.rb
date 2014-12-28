module Klam
  module Primitives
    module Vectors
      def absvector(n)
        ::Array.new(n)
      end

      def absvec_store(vec, n, val)
        vec[n] = val
        vec
      end
      alias_method :"address->", :absvec_store
      remove_method :absvec_store

      def absvec_read(vec, n)
        vec[n]
      end
      alias_method :"<-address", :absvec_read
      remove_method :absvec_read

      def absvector?(v)
        v.instance_of?(::Array)
      end
    end
  end
end
