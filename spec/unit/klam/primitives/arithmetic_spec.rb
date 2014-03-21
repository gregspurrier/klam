require 'spec_helper'

describe Klam::Primitives::Arithmetic do
  include Klam::Primitives::Arithmetic

  describe '+' do
    it 'adds its first argument to its second' do
      expect(send(:+, 1, 2)).to be(3)
    end

    it 'returns an integer when both arguments are integers' do
      expect(send(:+, 1, 2)).to be_kind_of(Fixnum)
    end

    it 'returns a real when either arguments are reals' do
      real_first = send(:+, 1.1, 2)
      real_second = send(:+, 1, 2.1)
      real_both = send(:+, 1.1, 2.1)
      types = [real_first, real_second, real_both].map(&:class)

      expect(types.uniq).to eq([Float])
    end
  end

  describe '-' do
    it 'subtracts its second argument from its second' do
      expect(send(:-, 1, 2)).to be(-1)
    end

    it 'returns an integer when both arguments are integers' do
      expect(send(:-, 1, 2)).to be_kind_of(Fixnum)
    end

    it 'returns a real when either arguments are reals' do
      real_first = send(:-, 1.1, 2)
      real_second = send(:-, 1, 2.1)
      real_both = send(:-, 1.1, 2.1)
      types = [real_first, real_second, real_both].map(&:class)

      expect(types.uniq).to eq([Float])
    end
  end

  describe '*' do
    it 'multiplies its first argument by its second' do
      expect(send(:*, 2, 3)).to be(6)
    end

    it 'returns an integer when both arguments are integers' do
      expect(send(:*, 1, 2)).to be_kind_of(Fixnum)
    end

    it 'returns a real when either arguments are reals' do
      real_first = send(:*, 1.1, 2)
      real_second = send(:*, 1, 2.1)
      real_both = send(:*, 1.1, 2.1)
      types = [real_first, real_second, real_both].map(&:class)

      expect(types.uniq).to eq([Float])
    end
  end

  describe '/' do
    it 'divides its first argument by its second' do
      expect(send(:/, 6, 3)).to be(2)
    end

    it 'returns an integer when both arguments are integers and there is no remainder' do
      expect(send(:/, 6, 2)).to be_kind_of(Fixnum)
    end

    it 'returns a real otherwise' do
      real_first = send(:/, 1.1, 2)
      real_second = send(:/, 1, 2.1)
      real_both = send(:/, 1.1, 2.1)
      having_remainder = send(:/, 3, 2)
      types = [real_first, real_second, real_both, having_remainder]
        .map(&:class)

      expect(types.uniq).to eq([Float])
    end
  end

  describe '<' do
    it 'returns true is the first argument is less than the second' do
      expect(send(:<, 1, 2)).to be(true)
    end

    it 'returns false if the first argument is equal to the second' do
      expect(send(:<, 2, 2)).to be(false)
    end

    it 'returns false if the first argument is greater than the second' do
      expect(send(:<, 3, 2)).to be(false)
    end
  end

  describe '>' do
    it 'returns false is the first argument is less than the second' do
      expect(send(:>, 1, 2)).to be(false)
    end

    it 'returns false if the first argument is equal to the second' do
      expect(send(:>, 2, 2)).to be(false)
    end

    it 'returns true if the first argument is greater than the second' do
      expect(send(:>, 3, 2)).to be(true)
    end
  end

  describe '<=' do
    it 'returns true is the first argument is less than the second' do
      expect(send(:<=, 1, 2)).to be(true)
    end

    it 'returns true if the first argument is equal to the second' do
      expect(send(:<=, 2, 2)).to be(true)
    end

    it 'returns false if the first argument is greater than the second' do
      expect(send(:<=, 3, 2)).to be(false)
    end
  end

  describe '>=' do
    it 'returns false is the first argument is less than the second' do
      expect(send(:>=, 1, 2)).to be(false)
    end

    it 'returns true if the first argument is equal to the second' do
      expect(send(:>=, 2, 2)).to be(true)
    end

    it 'returns true if the first argument is greater than the second' do
      expect(send(:>=, 3, 2)).to be(true)
    end
  end

  describe 'number?' do
    it 'returns true for integers' do
      expect(number?(1)).to be(true)
    end

    it 'returns true for reals' do
      expect(number?(1.1)).to be(true)
    end

    it 'returns false otherwise' do
      expect(number?('hi')).to be(false)
    end
  end
end
