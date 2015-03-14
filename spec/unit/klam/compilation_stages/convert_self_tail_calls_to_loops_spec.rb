require 'spec_helper'

describe Klam::CompilationStages::ConvertSelfTailCallsToLoops do
  include Klam::CompilationStages::ConvertSelfTailCallsToLoops

  # ConvertSelfTailCallsToLoops requires this function to be defined
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
    loop_var = fresh_variable
    expr = [:defun, :f, [:X, :Y],
             [:if, true,
               [:f, 7, 8],
               [:let, :Z, 37,
                 [:f, :Z, 99]]]]
    expected = [:defun, :f, [:X, :Y],
                 [:"[LOOP]", loop_var,
                   [:if, true,
                     [:"[RECUR]", [:X, :Y], [7, 8], loop_var],
                     [:let, :Z, 37,
                      [:"[RECUR]", [:X, :Y], [:Z, 99], loop_var]]]]]

    reset_generator
    expect(convert_self_tail_calls_to_loops(expr)).to eq(expected)
  end

  it 'does not convert partial calls' do
    loop_var = fresh_variable
    expr = [:defun, :f, [:X, :Y],
             [:f, :X]]
    expected = [:defun, :f, [:X, :Y],
                 [:"[LOOP]", loop_var,
                   [:f, :X]]]

    reset_generator
    expect(convert_self_tail_calls_to_loops(expr)).to eq(expected)
  end
end
