module Klam
  module CompilationStages
    # Simplify Boolean Operations
    #
    # Kl defines four special forms for boolean operations: if, or, and, and
    # cond. Having if or cond alone is sufficient for implementing the complete
    # set. This compilation stages recasts or, and, and cond in terms of if.
    module SimplifyBooleanOperations
      def simplify_boolean_operations(sexp)
        if sexp.instance_of?(Array)
          case sexp[0]
          when :and
            simplify_and(sexp)
          when :cond
            simplify_cond(sexp)
          when :or
            simplify_or(sexp)
          else
            sexp.map { |form| simplify_boolean_operations(form) }
          end
        else
          sexp
        end
      end

    private

      def simplify_and(sexp)
        # Only convert the fully-applied case
        if sexp.length == 3
          _, expr1, expr2 = sexp
          expr1 = simplify_boolean_operations(expr1)
          expr2 = simplify_boolean_operations(expr2)

          [:if, expr1, expr2, false]
        else
          sexp.map { |form| simplify_boolean_operations(form) }
        end
      end

      def simplify_cond(sexp)
        # Cond expressions are of the form:
        #   (cond (Test1 Expr1) ... (TestN ExprN))
        clauses = sexp[1..-1]
        simplify_cond_clauses(clauses)
      end

      def simplify_cond_clauses(clauses)
        if clauses.empty?
          # An error is raised if none of the clauses match.
          [:"simple-error", 'cond failure']
        else
          test, expr = clauses[0]
          [:if, test, expr, simplify_cond_clauses(clauses[1..-1])]
        end
      end

      def simplify_or(sexp)
        # Only convert the fully-applied case
        if sexp.length == 3
          _, expr1, expr2 = sexp
          expr1 = simplify_boolean_operations(expr1)
          expr2 = simplify_boolean_operations(expr2)

          [:if, expr1, true, expr2]
        else
          sexp.map { |form| simplify_boolean_operations(form) }
        end
      end
    end
  end
end
