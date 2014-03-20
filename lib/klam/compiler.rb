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
        emit_application(sexp)
      end
    end

    # Bare-bones function application for now.
    def emit_application(form)
      render_string('__send__($1)', form.map { |exp| compile_sexp(exp) })
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
