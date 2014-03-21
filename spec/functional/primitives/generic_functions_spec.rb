require 'spec_helper'

describe 'Generic function primitives', :type => :functional do
  describe '(defun Name Params Expr)' do
    it 'returns Name' do
      expect_kl('(defun foo (X) X)').to eq(:foo)
    end

    it 'installs Name as a global function' do
      eval_kl('(defun foo (X) X)')
      expect_kl('(foo 37)').to eq(37)
    end

    it 'allows names that are not allowed with the Ruby define syntax' do
      eval_kl('(defun f-o-o (X) X)')
      expect_kl('(f-o-o 37)').to eq(37)
    end

    it 'allows parameter names that are not valid Ruby parameter names' do
      eval_kl('(defun foo (A!B?-C) A!B?-C)')
      expect_kl('(foo 37)').to eq(37)
    end
  end
end
