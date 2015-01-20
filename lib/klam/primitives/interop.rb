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

      if RUBY_VERSION < '2.'
        def rb_const(name)
          parts = name.to_s.split('::')
          parts.shift if parts.first.empty?
          parts.reduce(::Module) do |m, x|
            m.const_get(x)
          end
        end
      else
        def rb_const(name)
          ::Module.const_get(name)
        end
      end

      alias_method :"rb-const", :rb_const
      remove_method :rb_const

      def rb(mode)
        case mode
        when :+
          @compiler.enable_ruby_interop_syntax!
        when :-
          @compiler.disable_ruby_interop_syntax!
        else
          ::Kernel.raise 'rb expects a + or -'
        end
      end

      def rb?
        @compiler.ruby_interop_syntax_enabled?
      end
    end
  end
end
