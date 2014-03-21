require 'spec_helper'

describe Klam::CompilationStages::ConvertLexicalVariables do
  include Klam::CompilationStages::ConvertLexicalVariables

  # ConvertLexicalVariables requires this function to be defined
  # by its including class.
  def fresh_variable
    @generator.next
  end

  def reset_generator
    @generator = Klam::VariableGenerator.new
  end

  before(:each) do
    reset_generator
  end

  describe 'with defun' do
    it 'converts formal param symbols to variables' do
      sexp = [:defun, :foo, [:X, :Y], [:+, :X, :Y]]
      converted = convert_lexical_variables(sexp)

      reset_generator
      v1, v2 = fresh_variable, fresh_variable
      expected = [:defun, :foo, [v1, v2], [:+, v1, v2]]

      expect(converted).to eq(expected)
    end
  end
end
