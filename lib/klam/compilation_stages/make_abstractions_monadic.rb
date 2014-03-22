module Klam
  module CompilationStages
    # Make Abstractions Monadic
    #
    # By the time the Ruby code is emitted, we want abstractions to take
    # no more than one parameter. This simplifies code generation and
    # avoids the need for using Proc#curry, which is slow.
    #
    # This stage converts (lambda [X Y] form) to (lambda [X] (lambda [Y] form))
    module MakeAbstractionsMonadic
      def make_abstractions_monadic(sexp)
        if sexp.instance_of?(Array)
          if sexp[0] == :lambda && sexp[1].length > 1
            params = sexp[1]
            [:lambda, [params[0]],
              make_abstractions_monadic([:lambda, params[1..-1], sexp[2]])]
          else
            sexp.map { |form| make_abstractions_monadic(form) }
          end
        else
          sexp
        end
      end
    end
  end
end
