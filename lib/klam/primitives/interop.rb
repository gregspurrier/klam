module Klam
  module Primitives
    # Primitives for interoperation with the host Ruby environment.
    # These are not official KLambda primitives.
    module Interop
      def ruby_send(obj, method_name, *args)
        obj.send(method_name, *args)
      end
      alias_method :"ruby.send", :ruby_send
      remove_method :ruby_send

      if RUBY_VERSION < '2.'
        def ruby_const(name)
          parts = name.to_s.split('::')
          parts.shift if parts.first.empty?
          parts.reduce(::Module) do |m, x|
            m.const_get(x)
          end
        end
      else
        def ruby_const(name)
          ::Module.const_get(name)
        end
      end

      alias_method :"ruby.const", :ruby_const
      remove_method :ruby_const

      def ruby_syntax(mode)
        case mode
        when :+
          @compiler.enable_ruby_interop_syntax!
        when :-
          @compiler.disable_ruby_interop_syntax!
        else
          ::Kernel.raise 'ruby.syntax expects a + or -'
        end
      end
      alias_method :"ruby.syntax", :ruby_syntax
      remove_method :ruby_syntax


      def ruby_syntax?
        @compiler.ruby_interop_syntax_enabled?
      end
      alias_method :"ruby.syntax?", :ruby_syntax?
      remove_method :ruby_syntax?
    end
  end
end
