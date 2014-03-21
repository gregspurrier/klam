module Klam
  module CompilationStages
    # Make Abstractions Variadic
    #
    # Kl's lambda special form only accepts a single parameter for the
    # abstraction. It is useful internally, however, to allow abstractions to
    # have zero or more parameters.
    module MakeAbstractionsVariadic
      def make_abstractions_variadic(sexp)
        if sexp.instance_of?(Array)
          if sexp[0] == :lambda
            rator, param, form = sexp
            [rator, [param], make_abstractions_variadic(form)]
          else
            sexp.map { |form| make_abstractions_variadic(form) }
          end
        else
          sexp
        end
      end
    end
  end
end
