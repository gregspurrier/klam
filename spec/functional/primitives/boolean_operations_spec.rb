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

  describe '(cond Test1 Expr1 ... TestN ExprN)' do
    it 'returns the normal form of the Expr for the first true Test' do
      kl = <<-EOKL
        (cond
          ((< 3 3) 1)
          ((= 3 3) 2)
          ((= 1 1) 3))
      EOKL

      expect_kl(kl).to eq(2)
    end

    it 'does not evaluate the other Exprs' do
      eval_kl('(set expr1-was-evaluated false)')
      eval_kl('(set expr2-was-evaluated false)')
      eval_kl('(set expr3-was-evaluated false)')

      kl = <<-EOKL
        (cond
          ((< 3 3) (set expr1-was-evaluated true))
          ((<= 3 3) (set expr2-was-evaluated true))
          ((<= 1 1) (set expr3-was-evaluated true)))
      EOKL
      eval_kl(kl)

      expect_kl('(value expr1-was-evaluated)').to be(false)
      expect_kl('(value expr2-was-evaluated)').to be(true)
      expect_kl('(value expr3-was-evaluated)').to be(false)
    end

    it 'does not evaluate the subsequent tests' do
      eval_kl('(set test3-was-evaluated false)')

      kl = <<-EOKL
        (cond
          ((< 3 3) 1)
          ((<= 3 3) 2)
          ((set test3-was-evaluated true) 3))
      EOKL
      eval_kl(kl)

      expect_kl('(value test3-was-evaluated)').to be(false)
    end

    it 'raises an error if none of the tests evaluate to true' do
      expect_kl('(trap-error (cond (false false)) error-to-string)')
        .to eq('cond failure')
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
