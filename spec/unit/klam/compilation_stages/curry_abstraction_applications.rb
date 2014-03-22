require 'spec_helper'

describe Klam::CompilationStages::CurryAbstractionApplications do
  include Klam::CompilationStages::CurryAbstractionApplications
  it 'converts to applying one argument at a time' do
    expr = [[:foo], 1, 2, 3]
    expected = [[[[:foo], 1], 2], 3]

    expect(curry_abstraction_applications(expr)).to eq(expected)
  end
end
