require 'spec_helper'

describe 'Tail call optimization', :type => :functional do
  it 'optimizes self tail calls so that they do not blow up the stack' do
    eval_kl('(defun count-down (X) (if (> X 0) (count-down (- X 1)) true))')
    expect_kl('(count-down 10000)').to be(true)
  end

  it 'preserves the value of closed-over loop variables' do
    eval_kl <<-EOKL
      (defun sample-loop-val (N Closure)
        (if (> N 0)
          (sample-loop-val (- N 1) (lambda X N))
          Closure))
    EOKL
    expect_kl('((sample-loop-val 2 foo) ignored)').to eq(1)
  end
end
