module Klam
  class Environment < BasicObject
    include ::Klam::Primitives::Assignments
    include ::Klam::Primitives::Lists
    include ::Klam::Primitives::GenericFunctions

    def initialize
      # The global assignments namespace. Errors are thrown here in the
      # missing element handler rather than in the value primitive in order
      # to facilitate inlining later.
      @assignments = ::Hash.new do |_, name|
        ::Kernel.raise ::Klam::Error, "The variable #{name} is unbound."
      end
    end
  end
end
