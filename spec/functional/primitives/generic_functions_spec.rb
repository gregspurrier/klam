require 'spec_helper'

describe 'Generic function primitives', :type => :functional do
  describe '(defun Name Params Expr)' do
    it 'returns Name' do
      expect_kl('(defun foo (X) X)').to eq(:foo)
    end

    it 'does not evaluate Expr' do
      eval_kl('(set success true)')
      eval_kl('(defun foo (X) (set success false))')
      expect_kl('(value success)').to be(true)
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

  describe '(lambda Var Expr)' do
    it 'returns a function' do
      expect_kl('(lambda X X)').to be_kind_of(Proc)
    end

    it 'does not evaluate Expr' do
      eval_kl('(set success true)')
      eval_kl('(lambda X (set success false))')
      expect_kl('(value success)').to be(true)
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

  describe '(freeze Expr)' do
    it 'returns a function' do
      expect_kl('(freeze (+ 30 7))').to be_kind_of(Proc)
    end

    it 'does not evaluate Expr' do
      eval_kl('(set success true)')
      eval_kl('(freeze (set success false))')
      expect_kl('(value success)').to be(true)
    end

    describe 'when thawed' do
      it 'evaluates the frozen Expr and returns the result' do
        eval_kl('(defun thaw (Thunk) (Thunk))')
        expect_kl('(thaw (freeze (+ 30 7)))').to eq(37)
      end
    end
  end

  describe '(type Expr Type)' do
    it 'returns the normal form of Expr' do
      expect_kl('(type (+ 1 2) expr)').to eq(3)
    end
  end
end
