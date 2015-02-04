require 'spec_helper'

describe Klam::CompilationStages::ConvertSelfTailCallsToLoops do
  include Klam::CompilationStages::ConvertSelfTailCallsToLoops

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


  it 'converts self tail calls to loop/recur' do
    # For simplicity the vars below are symbols, but will be
    # Klam::Variables in practice. They do not come into play for
    # the conversion, though.
    expr = [:defun, :f, [:X, :Y],
             [:if, true,
               [:f, 7, 8],
               [:let, :Z, 37,
                 [:f, :Z, 99]]]]
    loop_var = fresh_variable
    expected = [:defun, :f, [:X, :Y],
                 [:"[LOOP]", loop_var, [:X, :Y],
                   [:if, true,
                     [:"[RECUR]", [:X, :Y], [7, 8], loop_var],
                     [:let, :Z, 37,
                      [:"[RECUR]", [:X, :Y], [:Z, 99], loop_var]]]]]

    reset_generator
    expect(convert_self_tail_calls_to_loops(expr)).to eq(expected)
  end

  it 'does not convert partial calls' do
    expr = [:defun, :f, [:X, :Y],
             [:f, :X]]
    loop_var = fresh_variable
    expected = [:defun, :f, [:X, :Y],
                 [:"[LOOP]", loop_var, [:X, :Y],
                   [:f, :X]]]

    reset_generator
    expect(convert_self_tail_calls_to_loops(expr)).to eq(expected)
  end
end
