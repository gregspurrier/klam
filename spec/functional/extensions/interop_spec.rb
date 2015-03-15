require 'spec_helper'

describe 'extension: Ruby interop primitives', :type => :functional do
  describe 'rb-send' do
    it 'invokes a method on a Ruby object, passing the provided args' do
      expect_kl('(rb-send "def" prepend "abc")').to eq('abcdef')
    end
  end

  describe 'rb-send-block' do
    it 'invokes a method on a Ruby object, passing the provided block' do
      code = '(rb-send-block (cons 1 (cons 2 ())) map (lambda X (* 2 X)))'
      expect_kl(code).to eq([2, 4])
    end

    it 'supports blocks with arity greater than 1' do
      eval_kl('(set vec (absvector 2))')
      result = eval_kl <<-EOKL
        (let V (absvector 2)
          (do (rb-send-block (cons 37 (cons 42 ())) each_with_index
                             (lambda X (lambda Y (address-> V Y X))))
              V))
      EOKL
      expected = Klam::Absvector.new(2)
      expected.store(0, 37)
      expected.store(1, 42)
      expect(result).to eq(expected)
    end

    it 'supports symbols as blocks' do
      eval_kl('(set vec (absvector 2))')
      expect_kl('(rb-send-block (cons 1 (cons 2())) map str)').to eq(%w{1 2})
    end
  end

  describe 'rb-const' do
    it 'looks up the named constant in the Ruby environment' do
      expect_kl('(rb-const "::Math::PI")').to eq(Math::PI)
    end
  end
end
