module Klam
  module Primitives
    module Symbols
      def intern(str)
        case str
        when 'true'
          true
        when 'false'
          false
        else
          str.intern
        end
      end
    end
  end
end
