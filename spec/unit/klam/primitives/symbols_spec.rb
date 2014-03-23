require 'spec_helper'

describe Klam::Primitives::Symbols do
  include Klam::Primitives::Symbols

  describe '(intern Str)' do
    it 'returns the symbol corresponding to the given string' do
      expect(intern('foo')).to eq(:foo)
    end

    it 'returns the boolean true when given the string "true"' do
      expect(intern('true')).to be(true)
    end

    it 'returns the boolean false when given the string "false"' do
      expect(intern('false')).to be(false)
    end
  end
end
