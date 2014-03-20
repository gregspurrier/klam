module Klam
  module Primitives
    module Assignments
      def set(name, value)
        @assignments[name] = value
      end

      def value(name)
        @assignments[name]
      end
    end
  end
end
