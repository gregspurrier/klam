require 'spec_helper'

describe 'extension: (do X Y)', :type => :functional do
  it 'evaluates X before Y' do
    eval_kl('(set foo "a")')
    eval_kl('(do (set foo (cn (value foo) "b")) (set foo (cn (value foo) "c")))')
    expect_kl('(value foo)').to eq("abc")
  end

  it 'returns the normal form of Y' do
    expect_kl('(do 37 (+ 40 2))').to eq(42)
  end

  it 'treats Y as being in tail position' do
    eval_kl('(defun count-down (X) (if (> X 0) (do ignore-me (count-down (- X 1))) true))')
    expect_kl('(count-down 20000)').to be(true)
  end

  it 'allows nesting calls' do
    expect_kl('(do (+ 1 0) (do (+ 1 1) (+ 1 2)))').to eq(3)
  end
end
