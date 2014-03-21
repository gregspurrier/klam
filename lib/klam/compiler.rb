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
    include Klam::CompilationStages::SimplifyBooleanOperations
    include Klam::CompilationStages::EmitRuby

    def initialize
      @generator = Klam::VariableGenerator.new
    end

    def compile(kl)
      stages = [
        :kl_to_internal_representation,
        :strip_type_declarations,
        :make_abstractions_variadic,
        :convert_lexical_variables,
        :simplify_boolean_operations,
        :emit_ruby
      ]
      apply_stages(stages, kl)
    end

  private

    def apply_stages(stages, kl)
      stages.reduce(kl) do |exp, stage|
        send(stage, exp)
      end
    end

    # Returns a new Klam::Variable object that is unique within this
    # instance of the compiler. Variables are never used in a global
    # context in Kl, so this is sufficient to avoid collisions.
    def fresh_variable
      @generator.next
    end
  end
end
