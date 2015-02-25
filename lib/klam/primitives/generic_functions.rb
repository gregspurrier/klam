module Klam
  module Primitives
    module GenericFunctions
      def equal(a, b)
        a == b
      end
      alias_method :"=", :equal
      remove_method :equal

      def eval_kl(form)
        ::Kernel.puts form.inspect if value(:"*dump-kl*")
        code = @compiler.compile(form)
        ::Kernel.puts code if value(:"*dump-rb*")
        instance_eval code
      end
      alias_method :"eval-kl", :eval_kl
      remove_method :eval_kl
    end
  end
end
