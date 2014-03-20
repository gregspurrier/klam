module Klam
  module CompilationStages
    # Kl to Internal Represenation
    #
    # To simplify coding and improve performance, the compiler uses arrays
    # rather than Kl lists to represent nested s-expressions. This stage
    # performs the conversion.
    module KlToInternalRepresentation
      include Klam::Primitives::Lists
      include Klam::Converters::List

      def kl_to_internal_representation(kl)
        if cons?(kl)
          listToArray(kl)
        else
          kl
        end
      end
    end
  end
end
