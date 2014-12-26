require 'spec_helper'

describe 'Application', :type => :functional do
  describe 'of functions' do
    describe 'when all arguments are provided' do
      it 'returns the result of applying the function to its arguments' do
        eval_kl('(defun add (A B) (+ A B))')
        expect_kl('(add 2 3)').to eq(5)
      end
    end

    describe 'when not all arguments are provided' do
      before(:each) do
        eval_kl('(defun add3 (A B C) (+ (+ A B) C))')
      end

      it 'returns a function' do
        expect_kl('(add3 1)').to be_kind_of(Proc)
      end

      it 'evaluates once all of the arguments are provided' do
        expect_kl('((add3 1) 2 3)').to eq(6)
      end

      it 'allows further partial application' do
        expect_kl('(((add3 1) 2) 3)').to eq(6)
      end
    end

    describe 'uncurrying' do
      before(:each) do
        eval_kl('(defun add3 (A) (lambda B (lambda C (+ (+ A B) C))))')
      end

      it 'provides the equivalent behavior to defining a polyadic function' do
        expect_kl('(add3 1 2 3)').to eq(6)
        expect_kl('((add3 1 2) 3)').to eq(6)
        expect_kl('((add3 1) 2 3)').to eq(6)
      end
    end

    describe 'when the function takes no arguments' do
      it 'returns the result of evaluating the function\'s body' do
        eval_kl('(defun thirty-seven () 37)')
        expect_kl('(thirty-seven)').to eq(37)
      end
    end
  end

  describe 'of abstractions' do
    describe 'when applied directly' do
      it 'returns the result of applying the abstraction to its argument' do
        expect_kl('((lambda X (+ X 3)) 2)').to eq(5)
      end

      it 'uncurries additional arguments' do
        expect_kl('((lambda A (lambda B (lambda C (+ (+ A B) C)))) 1 2 3)')
          .to eq(6)
      end
    end

    describe 'when returned from another function' do
      it 'returns the result of applying the returned abstraction to its arg' do
        eval_kl('(defun make-adder (X) (lambda Y (+ X Y)))')
        expect_kl('((make-adder 3) 2)').to eq(5)
      end
    end
  end

  describe "of variables" do
    describe "when bound to functions" do
      describe 'when applied directly' do
        it 'returns the result of applying the abstraction to its argument' do
          expect_kl('(let F (lambda X (+ X 3)) (F 2))').to eq(5)
        end

        it 'uncurries additional arguments' do
          expect_kl('(let F (lambda A (lambda B (lambda C (+ (+ A B) C)))) (F 1 2 3))')
            .to eq(6)
        end
      end
    end

    describe "when bound to symbols" do
      it 'invokes the function bound to the symobl in the global environment' do
        expect_kl('(let F + (F 1 2))').to eq(3)
      end

      it 'supports partial evaluation' do
        expect_kl('(let F + ((F 1) 2))').to eq(3)
      end
    end
  end
end
