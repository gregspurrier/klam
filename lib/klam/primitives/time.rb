module Klam
  module Primitives
    module Time
      def get_time(type)
        case type
        when :real, :run
          ::Time.now.to_f
        when :unix
          ::Time.now.to_i
        else
          ::Kernel.raise ::Klam::Error, "invalid time parameter: #{type}"
        end

      end
      alias_method :"get-time", :get_time
      remove_method :get_time
    end
  end
end
