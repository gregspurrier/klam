module Klam
  module CompilationStages
    # Convert Self Tail Calls To Loops
    #
    # The Shen specification requires that self tail calls be optimized.  This
    # stage transforms defuns containing self tail calls into a loop/recur form
    # akin to Clojure's loop/recur. The code emitter knows how to handle these
    # synthetic special forms.
    #
    # For example, this code with tail calls:
    #
    #   (defun fact-iter (N Accum)
    #     (if (= N 0)
    #       Accum
    #       (fact-iter (- N 1) (* N Accum))))
    #
    # is converted to:
    #
    #   (defun fact-iter (N Accum)
    #     ([LOOP]
    #       (if (= N 0)
    #         Accum
    #         ([RECUR] (N Accum) ((- N 1) (* N Accum))))))
    #
    # The variable names are carried along with their new binding expressions
    # in the [RECUR] form so that they can be rebound before looping.
    #
    # Note that this rebinding of variables causes a wrinkle with respect to
    # closures created as part of the recursive call. Those closures should
    # close over the value at the point of recursion rather than the ultimate
    # values after rebinding. To solve this, another sythetic primitive,
    # [FIX-VARS], is used to wrap these cases and the emitted Ruby code
    # samples those variables.
    #
    # This compilation stage must come _after_ SimplifyBooleanOperations and
    # ConvertFreezesToLambdas.
    module ConvertSelfTailCallsToLoops
      def convert_self_tail_calls_to_loops(sexp)
        # Self tail calls can only be found in functions defined by defun.
        # defun is only allowed at the top level, so there's no need to
        # walk the tree if this form is not a defun.
        if sexp.kind_of?(Array) && sexp[0] == :defun
          _, name, params, body = sexp
          if contains_self_tail_calls?(body, name)
            insert_loop_and_recur_into_defun(sexp)
          else
            sexp
          end
        else
          sexp
        end
      end

    private

      def contains_self_tail_calls?(body, name)
        if body.instance_of?(Array)
          case body[0]
          when name
            true
          when :if
            _, _, true_expr, false_expr = body
            contains_self_tail_calls?(true_expr, name) ||
              contais_self_tail_calls?(false_expr, name)
          when :let
            contains_self_tail_calls?(body[3])
          else
            false
          end
        else
          false
        end
      end

      def insert_loop_and_recur_into_defun(form)
        rator, name, params, body = form
        body_with_loop = [:"[LOOP]", insert_recur_into_expr(body, name, params)]
        [rator, name, params, body_with_loop]
      end

      def insert_recur_into_expr(sexp, name, params)
        if sexp.instance_of?(Array)
          case sexp[0]
          when name
            [:"[RECUR]", params, fix_vars_if_necessary(sexp[1..-1], params)]
          when :if
            rator, test_expr, true_expr, false_expr = sexp
            [rator,
             test_expr,
             insert_recur_into_expr(true_expr, name, params),
             insert_recur_into_expr(false_expr, name, params)]
          when :let
            rator, var, val_expr, body_expr = sexp
            [rator,
             var,
             val_expr,
             insert_recur_into_expr(body_expr, name, params)]
          else
            sexp
          end
        else
          sexp
        end
      end

      def fix_vars_if_necessary(sexps, params)
        sexps.map do |sexp|
          # This is a bit over-aggressive. It could be optimized to only
          # protect in cases that params are free in the lambda expressions.
          if contains_lambda?(sexp)
            [:"[FIX-VARS]", params, sexp]
          else
            sexp
          end
        end
      end

      def contains_lambda?(sexp)
        if sexp.instance_of?(Array)
          if sexp[0] == :lambda
            true
          else
            sexp.any? { |form| contains_lambda?(form) }
          end
        else
          false
        end
      end
    end
  end
end
