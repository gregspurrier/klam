require 'spec_helper'

describe 'extension: Ruby interop', :type => :functional do
  describe 'constants' do
    it 'evaluates scoped Ruby contants' do
      expect_kl('#Math#PI').to eq(Math::PI)
    end
  end

  describe 'instance method invocation' do
    it 'invokes the method and returns the result' do
      expect_kl('(.reverse "abc")').to eq('cba')
    end

    it 'passes arguments along to the method' do
      expect_kl('(.prepend "Klam!" "Hello, ")').to eq('Hello, Klam!')
    end

    it 'supports objects returned by other functions' do
      expect_kl('(.reverse (cn "ab" "c"))').to eq('cba')
    end

    it 'supports objects bound to variables' do
      expect_kl('(let X "abc" (.reverse X))').to eq('cba')
    end

    it 'supports objects bound to abstraction parameters' do
      expect_kl('((lambda X (.reverse X)) "abc")').to eq('cba')
    end

    it 'supports objects bound to function parameters' do
      eval_kl('(defun ruby-reverse (X) (.reverse X))')
      expect_kl('(ruby-reverse "abc")').to eq('cba')
    end
  end

  describe 'class method invocation' do
    it 'works when class is in object position' do
      expect_kl('(.sqrt #Math 4)').to eq(2)
    end
  end
end
