require 'spec_helper'

describe Klam::CompilationStages::ConvertSelfTailCallsToLoops do
  include Klam::CompilationStages::ConvertSelfTailCallsToLoops
  it 'converts self tail calls to loop/recur' do
    # For simplicity the vars below are symbols, but will be
    # Klam::Variables in practice. They do not come into play for
    # the conversion, though.
    expr = [:defun, :f, [:X, :Y],
             [:if, true,
               [:f, 7, 8],
               [:let, :Z, 37,
                 [:f, :Z, 99]]]]
    expected = [:defun, :f, [:X, :Y],
                 [:"[LOOP]",
                   [:if, true,
                     [:"[RECUR]", [:X, :Y], [7, 8]],
                     [:let, :Z, 37,
                       [:"[RECUR]", [:X, :Y], [:Z, 99]]]]]]

    expect(convert_self_tail_calls_to_loops(expr)).to eq(expected)
  end
end
