require 'klam/compilation_stages'

module Klam
  class Compiler
    # Compiliation is implmented as a series of stages, each defined in
    # its own module. The first stage converts Kl s-expressions to the
    # the compiler's internal represenation. The final stage converts
    # the internal representation of a string containing Ruby code
    # suitable for use with instance_eval in the context of a
    # Klam::Environment instance.

    include Klam::CompilationStages::KlToInternalRepresentation
    include Klam::CompilationStages::EmitRuby

    def compile(kl)
      stages = [
        :kl_to_internal_representation,
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
  end
end
