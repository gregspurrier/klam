module Klam
  module Primitives
    # Primitives for interoperation with the host Ruby environment.
    # These are not official KLambda primitives.
    module Interop
      def rb_send(obj, method_name, *args)
        obj.send(method_name, *args)
      end
      alias_method :"rb-send", :rb_send
      remove_method :rb_send

      def rb_const(name)
        ::Module.const_get(name)
      end
      alias_method :"rb-const", :rb_const
      remove_method :rb_const
    end
  end
end
