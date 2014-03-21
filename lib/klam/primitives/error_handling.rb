module Klam
  module Primitives
    module ErrorHandling
      def simple_error(msg)
        ::Kernel.raise ::Klam::Error, msg
      end
      alias_method :"simple-error", :simple_error
      remove_method :simple_error

      # trap-error is a special form and implemented in the compiler

      def error_to_string(err)
        err.message
      end
      alias_method :"error-to-string", :error_to_string
      remove_method :error_to_string
    end
  end
end
