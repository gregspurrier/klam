module Klam
  module Primitives
    module GenericFunctions
      def eval_kl(form)
        compiler = Klam::Compiler.new(self)
        code = compiler.compile(form)
        instance_eval code
      end
      alias_method :"eval-kl", :eval_kl
      remove_method :eval_kl
    end
  end
end
