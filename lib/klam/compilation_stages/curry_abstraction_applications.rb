module Klam
  module CompilationStages
    # Curry Abstraction Applications
    #
    # This stage converts all applications of abstractions (i.e., any
    # application that does not have a symbol in rator position) to
    # a curried form in which only one argument is applied at a time.
    # For example:
    #
    #   ((foo) 1 2 3)
    #
    # becomes:
    #
    #   ((((foo) 1) 2) 3)
    module CurryAbstractionApplications
      def curry_abstraction_applications(sexp)
        if sexp.instance_of?(Array)
          if !sexp[0].instance_of?(Symbol) && sexp.length > 2
            [curry_abstraction_applications(sexp[0..-2]),
             curry_abstraction_applications(sexp[-1])]
          elsif sexp[0] == :defun
            sexp[0,3] +
              sexp[3..-1].map { |form| curry_abstraction_applications(form) }
          else
            sexp.map { |form| curry_abstraction_applications(form) }
          end
        else
          sexp
        end
      end
    end
  end
end
