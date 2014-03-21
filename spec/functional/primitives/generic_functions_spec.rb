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

  describe '(let Var ValueExpr BodyExpr)' do
    it 'evaluates BodyExpr with Var bound to the normal form of ValueExpr' do
      expect_kl('(let X (+ 1 2) (* X 2))').to eq(6)
    end

    it 'uses the inner-most binding when Var is shadowed' do
      expect_kl('(let X 1 (let X 2 X))').to eq(2)
    end
  end
end
