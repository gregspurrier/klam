require 'spec_helper'

describe 'extension: Ruby interop primitives', :type => :functional do
  describe 'rb-send' do
    it 'invokes a method on a Ruby object, passing the provided args' do
      expect_kl('(rb-send "def" prepend "abc")').to eq('abcdef')
    end
  end

  describe 'rb-const' do
    it 'looks up the named constant in the Ruby environment' do
      expect_kl('(rb-const "::Math::PI")').to eq(Math::PI)
    end
  end
end
