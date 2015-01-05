module Klam
  module Primitives
    module Vectors
      def absvector(n)
        ::Klam::Absvector.new(n)
      end

      def absvec_store(vec, n, val)
        vec.store(n, val)
      end
      alias_method :"address->", :absvec_store
      remove_method :absvec_store

      def absvec_read(vec, n)
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
