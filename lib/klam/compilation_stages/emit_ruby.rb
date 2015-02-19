module Klam
  module CompilationStages
    # Emit Ruby
    #
    # This is the final stage in the compilation pipeline. It is responsible
    # for converting the compiler's internal representation to a string
    # containing Ruby code that is suitable for execution via instance_eval in
    # the context of a Klam::Environment object.
    #
    # By the time compilation reaches this stage, all of the heavy lifting
    # should be complete. Emitting Ruby is simply a matter of transliterating
    # the simplified s-expression into Ruby.
    module EmitRuby
      include Klam::Template

      PRIMITIVE_TEMPLATES = {
        :+ => [2, '($1 + $2)'],
        :- => [2, '($1 - $2)'],
        :* => [2, '($1 * $2)'],
        :< => [2, '($1 < $2)'],
        :> => [2, '($1 > $2)'],
        :<= => [2, '($1 <= $2)'],
        :>= => [2, '($1 >= $2)'],
        :"=" => [2, '($1 == $2)'],
        :absvector => [1, '::Klam::Absvector.new($1)'],
        :absvector? => [1, '$1.instance_of?(::Klam::Absvector)'],
        :"<-address" => [2, '$1[$2]'],
        :"address->" => [3, '$1.store($2, $3)'],
        :cons => [2, '::Klam::Cons.new($1, $2)'],
        :cons? => [1, '$1.instance_of?(::Klam::Cons)'],
        :hd => [1, '$1.hd'],
        :set => [2, '(@assignments[$1] = $2)'],
        :tl => [1, '$1.tl'],
        :value => [1, '@assignments[$1]']
      }

      def emit_ruby(sexp)
        case sexp
        when Symbol
          emit_symbol(sexp)
        when String
          emit_string(sexp)
        when Klam::Variable, Numeric, true, false
          sexp.to_s
        when Array
          if sexp.empty?
            Klam::Primitives::Lists::EMPTY_LIST.inspect
          else
            emit_compound_form(sexp)
          end
        end
      end

    private

      def emit_compound_form(form)
        # Handle special forms and fall back to normal function application
        case form[0]
        when :defun
          emit_defun(form)
        when :if
          emit_if(form)
        when :lambda
          emit_lambda(form)
        when :let
          emit_let(form)
        when :"trap-error"
          emit_trap_error(form)
        when :do
          emit_do(form)
        when :"[FIX-VARS]"
          emit_fix_vars(form)
        when :"[LOOP]"
          emit_loop(form)
        when :"[RECUR]"
          emit_recur(form)
        else
          if full_primitive_form?(form)
            emit_primitive(form)
          else
            emit_application(form)
          end
        end
      end

      def full_primitive_form?(form)
        num_args, template = PRIMITIVE_TEMPLATES[form[0]]
        num_args && (num_args == form.size - 1)
      end

      def emit_primitive(form)
        _, template = PRIMITIVE_TEMPLATES[form[0]]
        rands_rb = form[1..-1].map { |rand| emit_ruby(rand) }
        render_string(template, *rands_rb)
      end

      def emit_application(form)
        rator = form[0]
        rands = form[1..-1]
        rator_rb = emit_ruby(rator)
        rands_rb = rands.map { |rand| emit_ruby(rand) }

        if rator.kind_of?(Symbol)
          # Application of a function defined in the environment. At this
          # point partial application and currying have been taken care of,
          # so a simple send suffices.
          render_string('__send__($1)', [rator_rb] + rands_rb)
        else
          render_string('__apply($1)', [rator_rb] + rands_rb)
        end
      end

      def emit_defun(form)
        _, name, params, body = form
        name_rb = emit_ruby(name)
        params_rb = params.map { |param| emit_ruby(param) }
        body_rb = emit_ruby(body)

        # Some valid Kl function names (e.g. foo-bar) are not valid when used
        # with Ruby's def syntax. They will work with define_method, but the
        # resulting methods are slower than if they had been defined via def.
        # To maximize performance, methods are defined with def and then
        # renamed to their intended name afterwards.
        mangled_name = '__klam_fn_' + name.to_s.gsub(/[^a-zA-Z0-9]/, '_')
        render_string(<<-EOT, name_rb, params_rb, body_rb, mangled_name, params.size)
          def $4($2)
            $3
          end
          @eigenclass.rename_method(:$4, $1)
          @arities[$1] = $5
          @curried_methods.delete($1)
          @loop_cache.delete($1)
          $1
        EOT
      end

      def emit_do(form)
        rands = form[1,2]
        rands_rb = rands.map { |rand| emit_ruby(rand) }
        '(' + rands_rb.join(';') + ')'
      end

      def emit_fix_vars(form)
        _, params, expr = form
        params_rb = params.map { |param| emit_ruby(param) }
        expr_rb = emit_ruby(expr)

        render_string('(::Kernel.lambda { |$1| $2 }).call($1)',
                      params_rb, expr_rb)
      end

      def emit_if(form)
        args = form[1..3].map { |sexp| emit_ruby(sexp) }
        render_string('($1 ? $2 : $3)', *args)
      end

      def emit_lambda(form)
        _, params, body = form
        params_rb = params.map { |param| emit_ruby(param) }
        body_rb = emit_ruby(body)

        render_string('(::Kernel.lambda { |$1| $2 })', params_rb, body_rb)
      end

      def emit_let(form)
        _, var, value_expr, body_expr = form

        var_rb = emit_ruby(var)
        value_expr_rb = emit_ruby(value_expr)
        body_expr_rb = emit_ruby(body_expr)

        render_string('($1 = $2; $3)', var_rb, value_expr_rb, body_expr_rb)
      end

      def emit_loop(form)
        name_rb = emit_ruby(form[1])
        params_rb = form[2].map {|v| emit_ruby(v)}
        expr_rb = emit_ruby(form[3])
        render_string('(@loop_cache[$1] ||= ::Kernel.lambda { |$2| $3 }).call($2)', name_rb,
                      params_rb, expr_rb)
      end

      def emit_recur(form)
        _, params, new_value_exprs = form
        if params.size > 0
          params_rb = params.map { |param| emit_ruby(param) }
          new_value_exprs_rb = new_value_exprs.map { |expr| emit_ruby(expr) }

          render_string('(($1 = $2); redo)', params_rb, new_value_exprs_rb)
        else
          'redo'
        end
      end

      def emit_string(str)
        str.inspect
      end

      def emit_symbol(sym)
        ':"' + sym.to_s + '"'
      end

      def emit_trap_error(form)
        _, expr, handler = form
        err_var = fresh_variable

        expr_rb = emit_ruby(expr)
        apply_handler_rb = emit_application([handler, err_var])
        err_var_rb = emit_ruby(err_var)

        render_string('(begin; $2; rescue => $1; $3; end)', err_var_rb,
                      expr_rb, apply_handler_rb)
      end
    end
  end
end
