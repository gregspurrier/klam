module Klam
  module CompilationStages
    module ConvertFreezesToLambdas
      def convert_freezes_to_lambdas(sexp)
        if sexp.instance_of?(Array)
          if sexp[0] == :freeze
            [:lambda, [], convert_freezes_to_lambdas(sexp[1])]
          else
            sexp.map { |form| convert_freezes_to_lambdas(form) }
          end
        else
          sexp
        end
      end
    end
  end
end
