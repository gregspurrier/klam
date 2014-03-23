require 'spec_helper'

describe Klam::Primitives::BooleanOperations do
  include Klam::Primitives::BooleanOperations

  describe '(if TestVal TrueVal FalseVal)' do
    it 'returns TrueVal if TestVal is true' do
      expect(send(:if, true, :foo, :bar)).to eq(:foo)
    end

    it 'returns FalseVal if TestVal is false' do
      expect(send(:if, false, :foo, :bar)).to eq(:bar)
    end
  end

  describe '(and A B)' do
    it 'returns true when both A and B are true' do
      expect(send(:and, true, true)).to be(true)
    end

    it 'returns false otherwise' do
      expect(send(:and, false, true)).to be(false)
      expect(send(:and, true, false)).to be(false)
      expect(send(:and, false, false)).to be(false)
    end
  end

  describe '(or A B)' do
    it 'returns false when both A and B are false' do
      expect(send(:or, false, false)).to be(false)
    end

    it 'returns true otherwise' do
      expect(send(:or, false, true)).to be(true)
      expect(send(:or, true, false)).to be(true)
      expect(send(:or, true, true)).to be(true)
    end
  end
end
