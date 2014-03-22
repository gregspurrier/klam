module Klam
  module CompilationStages
    module ConvertPartialApplicationsToLambdas
      def convert_partial_applications_to_lambdas(sexp)
        if sexp.instance_of?(Array)
          rator = sexp[0]
          if rator.kind_of?(Symbol)
            rands = sexp[1..-1]
            converted_rands = rands.map do |rand|
              convert_partial_applications_to_lambdas(rand)
            end

            rator_arity = arity(rator)
            if rator_arity == -1 || rator_arity == rands.length
              converted_rands.unshift(rator)
            elsif rator_arity > rands.length
              # Partial application
              vars = (rator_arity - rands.length).times.map { fresh_variable }
              [:lambda, vars, [rator] + converted_rands + vars]
            else
              # Uncurrying
              now_rands = rands[0...rator_arity]
              deferred_rands = rands[rator_arity..-1]
              [[rator] + now_rands, *deferred_rands]
            end
          else
            sexp.map { |form| convert_partial_applications_to_lambdas(form) }
          end
        else
          sexp
        end
      end
    end
  end
end
