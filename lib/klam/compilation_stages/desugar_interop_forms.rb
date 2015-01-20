module Klam
  module CompilationStages
    module DesugarInteropForms
      def desugar_interop_forms(sexp)
        if ruby_interop_syntax_enabled?
          if sexp.instance_of?(Array)
            if sexp[0].kind_of?(Symbol)
              rands = sexp[1..-1].map { |rand| desugar_interop_forms(rand) }

              name = sexp[0].to_s
              if name.start_with?('.')
                # Instance method invocation
                [:'rb-send', rands[0], name[1..-1].to_sym] + rands[1..-1]
              elsif name =~ /^(#[A-Z][^.]*)(\.[^.]+)/
                # Class method invocation shorthand. Re-cast as normal method
                # invocation on the class.
                desugar_interop_forms([$2.to_sym, $1.to_sym] + sexp[1..-1])
              else
                rands.unshift sexp[0]
              end
            else
              sexp.map { |exp| desugar_interop_forms(exp) }
            end
          elsif sexp.kind_of?(Symbol)
            name = sexp.to_s
            if name =~ /^#[A-Z]/
              # Constant reference
              [:'rb-const', name.gsub('#', '::')]
            else
              sexp
            end
          else
            sexp
          end
        else
          sexp
        end
      end
    end
  end
end
