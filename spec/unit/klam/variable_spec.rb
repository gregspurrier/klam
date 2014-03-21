require 'spec_helper'

describe Klam::Variable do
  describe "#==" do
    before(:each) do
      @name = 'foo'
      @variable = Klam::Variable.new(@name)
    end

    it 'returns true when the other variable has the same name' do
      expect(@variable == Klam::Variable.new(@name)).to be(true)
    end

    it 'returns false when the other variable has a different name' do
      expect(@variable == Klam::Variable.new(@name + '1')).to be(false)
    end

    it 'returns false when the other object is not a Klam::Variable' do
      expect(@variable == :foo).to be(false)
    end
  end
end
