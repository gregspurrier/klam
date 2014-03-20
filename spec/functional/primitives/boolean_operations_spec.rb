require 'spec_helper'

describe 'Boolean operation primitives', :type => :functional do
  describe '(if Test TrueExpr FalseExpr)' do
    describe 'when Test evaluates to true' do
      it 'returns the value of TrueExpr' do
        expect_kl('(if true yes no)').to eq(:yes)
      end

      it 'does not evaluate FalseExpr' do
        eval_kl('(set success true)')
        eval_kl('(if true yes (set success false))')
        expect_kl('(value success)').to be(true)
      end
    end

    describe 'when Test evaluates to false' do
      it 'returns the value of FalseExpr' do
        expect_kl('(if false yes no)').to eq(:no)
      end

      it 'does not evaluate TrueExpr' do
        eval_kl('(set success true)')
        eval_kl('(if false (set success false) no)')
        expect_kl('(value success)').to be(true)
      end
    end
  end
end
