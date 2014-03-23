require 'spec_helper'

describe Klam::Primitives::Symbols do
  include Klam::Primitives::Symbols

  describe '(intern Str)' do
    it 'returns the symbol corresponding to the given string' do
      expect(intern('foo')).to eq(:foo)
    end
  end
end
