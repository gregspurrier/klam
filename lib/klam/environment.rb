module Klam
  class Environment < BasicObject
    include ::Klam::Primitives::BooleanOperations
    include ::Klam::Primitives::Symbols
    include ::Klam::Primitives::Strings
    include ::Klam::Primitives::Assignments
    include ::Klam::Primitives::ErrorHandling
    include ::Klam::Primitives::Lists
    include ::Klam::Primitives::GenericFunctions
    include ::Klam::Primitives::Vectors
    include ::Klam::Primitives::Streams
    include ::Klam::Primitives::Time
    include ::Klam::Primitives::Arithmetic
    include ::Klam::Primitives::Interop

    def initialize
      # The global assignments namespace. Errors are thrown here in the
      # missing element handler rather than in the value primitive in order
      # to facilitate inlining later.
      @assignments = ::Hash.new do |_, name|
        ::Kernel.raise ::Klam::Error, "The variable #{name} is unbound."
      end

      @arities = ::Hash.new { |h, k| h[k] = __arity(k) }
      @curried_methods = ::Hash.new { |h, k| h[k] = __method(k).to_proc.curry }

      # Grab a handle to this object's eigenclass for use later when the
      # compiled code needs to reference it. It is used, e.g., when renaming
      # methods.
      @eigenclass = class << self; self; end

      @compiler = ::Klam::Compiler.new(self)

      # The open primitive depends on having *home-directory* assigned.
      set(:"*home-directory*", ::Dir.pwd)
    end

    def __apply(rator, *rands)
      if rator.kind_of?(::Symbol)
        @curried_methods[rator].call(*rands)
      else
        rator.call(*rands)
      end
    end

    def __method(sym)
      @eigenclass.instance_method(sym).bind(self)
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
