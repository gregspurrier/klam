require 'spec_helper'

describe 'Tail call optimization', :type => :functional do
  it 'optimizes self tail calls in an if true clause' do
    eval_kl('(defun count-down (X) (if (> X 0) (count-down (- X 1)) true))')
    expect_kl('(count-down 20000)').to be(true)
  end

  it 'optimizes self tail calls in an if false clause' do
    eval_kl('(defun count-down (X) (if (<= X 0) true (count-down (- X 1))))')
    expect_kl('(count-down 20000)').to be(true)
  end

  it 'optimizes self tail calls in a let body' do
    eval_kl('(defun count-down (X) (if (<= X 0) true (let F 1 (count-down (- X 1)))))')
    expect_kl('(count-down 20000)').to be(true)
  end

  it 'uses the current values of the params when calculating the new ones' do
    eval_kl <<-EOKL
      (defun fact-iter (N Accum)
        (if (= N 1)
          Accum
          (fact-iter (- N 1) (* N Accum))))
    EOKL
    expect_kl('(fact-iter 5 1)').to eq(120)
  end

  it 'preserves the value of closed-over function parameters' do
    eval_kl('(set foo (absvector 3))')
    eval_kl <<-EOKL
      (defun do-it (N)
        (if (= N 3)
          true
          (let _ (address-> (value foo) N (freeze N))
               (do-it (+ N 1)))))
    EOKL
    eval_kl('(do-it 0)')
    expect_kl('((<-address (value foo) 0))').to eq(0)
    expect_kl('((<-address (value foo) 1))').to eq(1)
    expect_kl('((<-address (value foo) 2))').to eq(2)
  end

  it 'preserves the value of closed-over local variables' do
    eval_kl('(set foo (absvector 3))')
    eval_kl <<-EOKL
      (defun do-it (N)
        (if (= N 3)
          true
          (let X N
               (let _ (address-> (value foo) N (freeze X))
                    (do-it (+ N 1))))))
    EOKL
    eval_kl('(do-it 0)')
    expect_kl('((<-address (value foo) 0))').to eq(0)
    expect_kl('((<-address (value foo) 1))').to eq(1)
    expect_kl('((<-address (value foo) 2))').to eq(2)
  end

  it 'supports functions with zero arguments' do
    eval_kl('(set counter 0)')
    eval_kl <<-EOKL
      (defun count-down ()
        (if (= 20000 (set counter (+ (value counter) 1)))
          true
          (count-down)))
    EOKL
    expect_kl('(count-down)').to be(true)
  end

end
