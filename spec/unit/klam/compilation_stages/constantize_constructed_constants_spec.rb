require 'spec_helper'


describe Klam::CompilationStages::ConstantizeConstructedConstants do
  include Klam::CompilationStages::ConstantizeConstructedConstants

  # ConstantizeConstructedConstants requires this function to be defined
  # by its including class.
  def fresh_constant
    @generator.next
  end

  def reset_generator
    @generator = Klam::ConstantGenerator.new
  end

  before(:each) do
    reset_generator
  end

  it 'constantizes lists of constants' do
    const1 = fresh_constant
    const2 = fresh_constant
    expr = [:defun, :f, [],
             [:cons, 1, [:cons, 2, []]]]

    expected = [:let, const1, [:cons, 2, []],
                 [:let, const2, [:cons, 1, const1],
                   [:"[DEFUN-CLOSURE]", :f, [],
                     const2]]]

    reset_generator
    expect(constantize_constructed_constants(expr)).to eq(expected)
  end
end
