require 'spec_helper'

describe 'Error handling primitives', :type => :functional do
  describe '(trap-error Expr Handler)' do
    describe 'when evaluating Expr succeeds' do
      it 'returns the normal form of Expr' do
        expect_kl('(trap-error (+ 1 2) error-to-string)').to eq(3)
      end
    end

    describe 'when evaluating Expr raises an error' do
      it 'applies Handler to the error' do
        expect_kl('(trap-error (simple-error "oops!") error-to-string)')
          .to eq('oops!')
      end
    end

    it 'may be used as an argument to another function' do
      expect_kl('(+ (trap-error 2 error-to-string) 3)').to eq(5)
    end
  end
end
