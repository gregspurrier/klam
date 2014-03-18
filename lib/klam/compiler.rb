module Klam
  class Compiler
    def compile(form)
      case form
      when Symbol
        emit_symbol(form)
      when String
        emit_string(form)
      when Numeric
        form.to_s
      when true, false
        form.to_s
      end
    end

  private

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
