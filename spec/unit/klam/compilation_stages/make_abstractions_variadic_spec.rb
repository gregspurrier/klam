require 'spec_helper'

describe Klam::CompilationStages::MakeAbstractionsVariadic do
  include Klam::CompilationStages::MakeAbstractionsVariadic

  it 'converts the single Kl lambda param to a one-element list' do
    expr = [:lambda, :X, [:lambda, :Y, [:+, :X, :Y]]]
    expected = [:lambda, [:X], [:lambda, [:Y], [:+, :X, :Y]]]

    expect(make_abstractions_variadic(expr)).to eq(expected)
  end
end
