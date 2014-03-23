module Klam
  class Environment < BasicObject
    include ::Klam::Primitives::BooleanOperations
    include ::Klam::Primitives::Symbols
    include ::Klam::Primitives::Strings
    include ::Klam::Primitives::Assignments
    include ::Klam::Primitives::ErrorHandling
    include ::Klam::Primitives::Lists
    include ::Klam::Primitives::GenericFunctions
    include ::Klam::Primitives::Streams
    include ::Klam::Primitives::Arithmetic

    def initialize
      # The global assignments namespace. Errors are thrown here in the
      # missing element handler rather than in the value primitive in order
      # to facilitate inlining later.
      @assignments = ::Hash.new do |_, name|
        ::Kernel.raise ::Klam::Error, "The variable #{name} is unbound."
      end

      # Grab a handle to this object's eigenclass for use later when the
      # compiled code needs to reference it. It is used, e.g., when renaming
      # methods.
      @eigenclass = class << self; self; end

      # The open primitive depends on having *home-directory* assigned.
      set(:"*home-directory*", ::Dir.pwd)
    end

    def __arity(sym)
      @eigenclass.instance_method(sym).arity
    rescue ::NameError
      -1
    end

    class << self
      def rename_method(old_name, new_name)
        alias_method(new_name, old_name)
        remove_method(old_name)
      end
    end
  end
end
