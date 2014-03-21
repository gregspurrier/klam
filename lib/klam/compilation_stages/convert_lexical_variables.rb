module Klam
  module CompilationStages
    # Convert Lexical Variables
    #
    # Lexically bound variable names are symbols in Kl. In Ruby, variable and
    # parameter names are represented differently than symbol literals.  The
    # latter are indicated with a leading ':' (e.g., :foo) and allow an
    # extended set of characters when using the :"foo-bar" literal syntax.
    # Ruby variables have no such provision for using additional characters.
    #
    # Therefore, if lexical variables remain as symbols, the emission of Ruby
    # code for symbols would be complicated by the need to differentiate
    # between symbol literals and lexical variables and to transform Kl
    # variable names to legal Ruby variable names. Instead, this stage converts
    # lexical variables to instances of Klam::Variable. This is essentially
    # alpha conversion and the names of Klam::Variable are generated to be
    # locally unique and using only allowed Ruby variable names.
    #
    # Alpha conversion also avoids potential problems when the let primitive is
    # used to re-bind an already bound lexical var.
    module ConvertLexicalVariables
      def convert_lexical_variables(sexp)
        convert_lexical_vars(sexp, {})
      end

    private

      def convert_lexical_vars(sexp, var_map)
        if sexp.instance_of? Array
          case sexp[0]
          when :defun
            convert_lexical_vars_defun(sexp, var_map)
          when :let
            convert_lexical_vars_let(sexp, var_map)
          else
            sexp.map { |form| convert_lexical_vars(form, var_map) }
          end
        else
          var_map[sexp] || sexp
        end
      end

      def convert_lexical_vars_defun(sexp, var_map)
        rator, name, params, expr = sexp
        var_map = extend_var_map(var_map, params)

        params = params.map { |p| var_map[p] }
        expr = convert_lexical_vars(expr, var_map)
        [rator, name, params, expr]
      end

      def convert_lexical_vars_let(sexp, var_map)
        rator, var_sym, value_expr, expr = sexp
        extended_var_map = extend_var_map(var_map, [var_sym])

        value_expr = convert_lexical_vars(value_expr, var_map)
        expr = convert_lexical_vars(expr, extended_var_map)
        [rator, extended_var_map[var_sym], value_expr, expr]
      end

      def extend_var_map(var_map, syms)
        new_var_map = Hash.new { |_, k| var_map[k] }
        syms.each { |sym| new_var_map[sym] = fresh_variable }
        new_var_map
      end
    end
  end
end
