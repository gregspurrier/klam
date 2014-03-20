module Klam
  class Compiler
    include Klam::Primitives::Lists
    include Klam::Converters::List
    include Klam::Template

    def compile(kl)
      if cons?(kl)
        sexp = listToArray(kl)
      else
        sexp = kl
      end
      compile_sexp(sexp)
    end

  private

    def compile_sexp(sexp)
      case sexp
      when Symbol
        emit_symbol(sexp)
      when String
        emit_string(sexp)
      when Numeric
        sexp.to_s
      when true, false
        sexp.to_s
      when Array
        compile_form(sexp)
      end
    end

    def compile_form(form)
      case form[0]
      when :if
        emit_if(form)
      else
        emit_application(form)
      end
    end

    # Bare-bones function application for now.
    def emit_application(form)
      render_string('__send__($1)', form.map { |sexp| compile_sexp(sexp) })
    end

    def emit_if(form)
      args = form[1..3].map { |sexp| compile_sexp(sexp) }
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
