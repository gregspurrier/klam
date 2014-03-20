require 'spec_helper.rb'

describe 'Assignments primitives', :type => :functional do
  describe '(set Name Value)' do
    it 'associates Value with Name' do
      eval_kl('(set foo bar)')
      expect_kl('(value foo)').to eq(:bar)
    end

    it 'returns Value' do
      expect_kl('(set foo bar)').to eq(:bar)
    end

    it 'overwrites the previous value when called again with same Name' do
      eval_kl('(set foo bar)')
      expect_kl('(set foo baz)').to eq(:baz)
    end

    it 'does not interfere with the function namespace' do
      eval_kl('(set value bar)')
      expect_kl('(value value)').to eq(:bar)
    end
  end

  describe '(value Name)' do
    # Duplicated for documentation purposes
    it 'returns the value associated with Name' do
      eval_kl('(set foo bar)')
      expect_kl('(value foo)').to eq(:bar)
    end

    it 'raises an error if Name has not previously been set' do
      expect {
        eval_kl('(value an-unset-symobl)')
      }.to raise_error(Klam::Error)
    end
  end
end
