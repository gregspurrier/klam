require 'spec_helper'

describe 'Boolean operation primitives', :type => :functional do
  describe '(and Expr1 Expr2)' do
    describe 'when Expr1 evaluates to true' do
      it 'returns the result of evaluating Expr2' do
        expect_kl('(and (< 1 2) (> 3 3))').to be(false)
        expect_kl('(and (< 1 2) (>= 3 3))').to be(true)
      end
    end

    describe 'when Expr1 evaluates to false' do
      it 'returns false' do
        expect_kl('(and (> 1 2) true)').to be(false)
      end

      it 'does not evaluate Expr2' do
        eval_kl('(set success true)')
        eval_kl('(and (> 1 2) (set success false))')
        expect_kl('(value success)').to be(true)
      end
    end
  end

  describe '(if Test TrueExpr FalseExpr)' do
    describe 'when Test evaluates to true' do
      it 'returns the value of TrueExpr' do
        expect_kl('(if (< 1 2) yes no)').to eq(:yes)
      end

      it 'does not evaluate FalseExpr' do
        eval_kl('(set success true)')
        eval_kl('(if (< 1 2) yes (set success false))')
        expect_kl('(value success)').to be(true)
      end
    end

    describe 'when Test evaluates to false' do
      it 'returns the value of FalseExpr' do
        expect_kl('(if (> 1 2) yes no)').to eq(:no)
      end

      it 'does not evaluate TrueExpr' do
        eval_kl('(set success true)')
        eval_kl('(if (> 1 2) (set success false) no)')
        expect_kl('(value success)').to be(true)
      end
    end
  end

  describe '(or Expr1 Expr2)' do
    describe 'when Expr1 evaluates to true' do
      it 'returns true' do
        expect_kl('(or (< 1 2) false)').to be(true)
      end

      it 'does not evaluate Expr2' do
        eval_kl('(set success true)')
        eval_kl('(or (< 1 2) (set success false))')
        expect_kl('(value success)').to be(true)
      end
    end

    describe 'when Expr1 evaluates to false' do
      it 'returns the result of evaluating Expr2' do
        expect_kl('(or (> 1 2) (> 3 3))').to be(false)
        expect_kl('(or (> 1 2) (>= 3 3))').to be(true)
      end
    end
  end
end
