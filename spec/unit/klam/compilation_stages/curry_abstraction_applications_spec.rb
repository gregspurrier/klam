require 'spec_helper'

describe Klam::CompilationStages::CurryAbstractionApplications do
  include Klam::CompilationStages::CurryAbstractionApplications
  it 'converts to applying one argument at a time' do
    expr = [[:foo], 1, 2, 3]
    expected = [[[[:foo], 1], 2], 3]

    expect(curry_abstraction_applications(expr)).to eq(expected)
  end

  it 'converts variable application to curried form' do
    var = Klam::Variable.new('foo')
    expr = [var, 1, 2, 3]
    expected = [[[var, 1], 2], 3]

    expect(curry_abstraction_applications(expr)).to eq(expected)
  end
end
