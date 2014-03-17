require 'spec_helper'

describe Klam::Primitives::Lists do
  include Klam::Primitives::Lists

  before(:each) do
    @head = :head
    @tail = :tail
    @cons = cons(@head, @tail)
    @empty_list = Klam::Primitives::Lists::EMPTY_LIST
  end

  describe '.cons' do
    it 'returns an object recognized by the cons? predicate' do
      expect(cons?(@cons)).to be true
    end
  end

  describe '.hd' do
    it 'returns the head of the list' do
      expect(hd(@cons)).to eq(@head)
    end

    it 'raises an exception when applied to the empty list' do
      expect { hd(@empty_list) }.to raise_error
    end
  end

  describe '.tl' do
    it 'returns the tail of the list' do
      expect(tl(@cons)).to eq(@tail)
    end

    it 'raises an exception when applied to the empty list' do
      expect { tl(@empty_list) }.to raise_error
    end
  end

  describe '.cons?' do
    it 'returns false for the empty list' do
      expect(cons?(@emtpy_list)).to be false
    end

    it 'returns false for atoms' do
      applications = [true, false, 37, :symbol, 'string'].map { |a| cons?(a) }
      expect(applications.uniq).to eq([false])
    end
  end
end
