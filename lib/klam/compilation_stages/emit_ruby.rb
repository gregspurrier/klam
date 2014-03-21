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

      def emit_ruby(sexp)
        case sexp
        when Symbol
          emit_symbol(sexp)
        when String
          emit_string(sexp)
        when Klam::Variable, Numeric, true, false
          sexp.to_s
        when Array
          emit_compound_form(sexp)
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
        else
          emit_application(form)
        end
      end

      # Bare-bones function application for now.
      def emit_application(form)
        render_string('__send__($1)', form.map { |sexp| emit_ruby(sexp) })
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
        render_string(<<-EOT, name_rb, params_rb, body_rb)
          def __new_global_fn($2)
            $3
          end
          @eigenclass.rename_method(:__new_global_fn, $1)
          $1
        EOT
      end

      def emit_if(form)
        args = form[1..3].map { |sexp| emit_ruby(sexp) }
        render_string('($1 ? $2 : $3)', *args)
      end

      def emit_string(str)
        "'" + escape_string(str) + "'"
      end

      def emit_symbol(sym)
        ':"' + sym.to_s + '"'
      end

      # Escape single quotes and backslashes
      def escape_string(str)
        new_str = ""
        str.each_char do |c|
          if c == "'"
            new_str << "\\"
            new_str << "'"
          elsif c == '\\'
            new_str << '\\'
            new_str << '\\'
          else
            new_str << c
          end
        end
        new_str
      end
    end
  end
end
