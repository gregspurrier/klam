module Klam
  module CompilationStages
    module ConstantizeConstructedConstants
      def constantize_constructed_constants(sexp)
        constant_bindings = []
        converted_sexp = extract_constructed_constants(sexp, constant_bindings)
        if constant_bindings.empty?
          sexp
        else
          bind_constants(converted_sexp, constant_bindings)
        end
      end

    private

      def extract_constructed_constants(sexp, constant_bindings)
        if sexp.kind_of?(Array)
          if sexp.size == 3 && sexp[0] == :cons
            hd_expr = extract_constructed_constants(sexp[1], constant_bindings)
            tl_expr = extract_constructed_constants(sexp[2], constant_bindings)
            converted_cons = [:cons, hd_expr, tl_expr]
            if constant?(hd_expr) && constant?(tl_expr)
              const = fresh_constant
              constant_bindings << [const, converted_cons]
              const
            else
              converted_cons
            end
          else
            sexp.map do |expr|
              extract_constructed_constants(expr, constant_bindings)
            end
          end
        else
          sexp
        end
      end

      def bind_constants(sexp, bindings)
        if sexp.kind_of?(Array) && sexp[0] == :defun
          sexp[0] = :"[DEFUN-CLOSURE]"
        end

        until bindings.empty?
          binding = bindings.pop
          sexp = [:let, binding[0], binding[1], sexp]
        end
        sexp
      end

      def constant?(sexp)
        case sexp
        when FalseClass, TrueClass, String, Symbol, Numeric, Klam::Constant
          true
        when []
          true
        else
          false
        end
      end
    end
  end
end
