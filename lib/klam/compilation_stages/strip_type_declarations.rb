module Klam
  module CompilationStages
    # Strip Type Declarations
    #
    # The Kl type primitive is provided to pass type hints from the Shen
    # compiler to the Kl compiler. Klam does not make use of them, so they are
    # removed in this stage to simplify the s-expression and avoid having to
    # take the type primitive into account when optimizing self tail calls.
    module StripTypeDeclarations
      def strip_type_declarations(sexp)
        if sexp.instance_of?(Array)
          if sexp[0] == :type
            _, form, _ = sexp
            strip_type_declarations(form)
          else
            sexp.map { |form| strip_type_declarations(form) }
          end
        else
          sexp
        end
      end
    end
  end
end
