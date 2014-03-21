require 'spec_helper'

describe 'Application', :type => :functional do
  describe 'of functions' do
    describe 'when all arguments are provided' do
      it 'returns the result of applying the function to its arguments' do
        eval_kl('(defun add (A B) (+ A B))')
        expect_kl('(add 2 3)').to eq(5)
      end
    end

    describe 'when the function takes no arguments' do
      it 'returns the result of evaluating the function\'s body' do
        eval_kl('(defun thirty-seven () 37)')
        expect_kl('(thirty-seven)').to eq(37)
      end
    end

    describe 'when the function is returned from other functions' do
      it 'applies the returned function to its arguments' do
        eval_kl('(defun return-add () add)')
        eval_kl('(defun add (A B) (+ A B))')
        expect_kl('((return-add) 2 3)').to eq(5)
      end
    end
  end

  describe 'of abstractions' do
    describe 'when applied directly' do
      it 'returns the result of applying the abstraction to its argument' do
        expect_kl('((lambda X (+ X 3)) 2)').to eq(5)
      end
    end

    describe 'when returned from another function' do
      it 'returns the result of applying the returned abstraction to its arg' do
        eval_kl('(defun make-adder (X) (lambda Y (+ X Y)))')
        expect_kl('((make-adder 3) 2)').to eq(5)
      end
    end
  end
end
