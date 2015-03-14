module Klam
  class Compiler
    # Compiliation is implmented as a series of stages, each defined in
    # its own module. The first stage converts Kl s-expressions to the
    # the compiler's internal represenation. The final stage converts
    # the internal representation of a string containing Ruby code
    # suitable for use with instance_eval in the context of a
    # Klam::Environment instance.

    include Klam::CompilationStages::KlToInternalRepresentation
    include Klam::CompilationStages::StripTypeDeclarations
    include Klam::CompilationStages::MakeAbstractionsVariadic
    include Klam::CompilationStages::ConvertLexicalVariables
    include Klam::CompilationStages::ConvertFreezesToLambdas
    include Klam::CompilationStages::SimplifyBooleanOperations
    include Klam::CompilationStages::ConvertPartialApplicationsToLambdas
    include Klam::CompilationStages::CurryAbstractionApplications
    include Klam::CompilationStages::MakeAbstractionsMonadic
    include Klam::CompilationStages::ConstantizeConstructedConstants
    include Klam::CompilationStages::ConvertSelfTailCallsToLoops
    include Klam::CompilationStages::EmitRuby

    def initialize(environment)
      @environment = environment
      @constant_generator = Klam::ConstantGenerator.new
      @variable_generator = Klam::VariableGenerator.new
      @ruby_interop_syntax_enabled = false
    end

    def compile(kl)
      stages = [
        :kl_to_internal_representation,
        :strip_type_declarations,
        :make_abstractions_variadic,
        :convert_lexical_variables,
        :convert_freezes_to_lambdas,
        :simplify_boolean_operations,
        :convert_partial_applications_to_lambdas,
        :curry_abstraction_applications,
        :make_abstractions_monadic,
        :constantize_constructed_constants,
        :convert_self_tail_calls_to_loops,
        :emit_ruby
      ]
      apply_stages(stages, kl)
    end

    def enable_ruby_interop_syntax!
      @ruby_interop_syntax_enabled = true
    end

    def disable_ruby_interop_syntax!
      @ruby_interop_syntax_enabled = false
    end

    def ruby_interop_syntax_enabled?
      @ruby_interop_syntax_enabled
    end

  private

    def apply_stages(stages, kl)
      stages.reduce(kl) do |exp, stage|
        send(stage, exp)
      end
    end

    def arity(sym)
      @environment.__arity(sym)
    end

    def fresh_constant
      @constant_generator.next
    end

    def fresh_variable
      @variable_generator.next
    end
  end
end
