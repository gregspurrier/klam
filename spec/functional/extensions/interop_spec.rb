require 'spec_helper'

describe 'extension: Ruby interop', :type => :functional do
  describe 'primitives' do
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

  describe 'sugared forms' do
    before(:each) do
      eval_kl('(rb +)')
    end

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

      it 'supports -> and <- in place of []= and []' do
        eval_kl('(set foo (#Array.new))')
        eval_kl('(.-> (value foo) 0 37)')
        expect_kl('(.<- (value foo) 0)').to eq(37)
      end
    end

    describe 'class method invocation' do
      it 'works when class is in object position' do
        expect_kl('(.sqrt #Math 4)').to eq(2)
      end

      it 'supports combining class and method in operator position' do
        expect_kl('(#Math.sqrt 4)').to eq(2)
      end
    end
  end
end
