require 'spec_helper'

describe Klam::Converters::List do
  include Klam::Converters::List

  before(:each) do
    @empty_list = Klam::Primitives::Lists::EMPTY_LIST
  end

  describe '.arrayToList' do
    it 'returns the empty list when given an empty array' do
      expect(arrayToList([])).to be @empty_list
    end

    it 'handles nested empty lists' do
      expect(arrayToList([[]])).to eq(cons(@empty_list, @empty_list))
    end

    it 'returns the corresponding list for a non-empty array' do
      expect(arrayToList([1, 2])).to eq(cons(1, cons(2, @empty_list)))
    end

    it 'recursively converts nested arrays to nested lists' do
      array1 = [1, 2]
      list1 = arrayToList(array1)
      array2 = [:a, :b, :c]
      list2 = arrayToList(array2)

      expect(arrayToList([array1, array2])).to eq(cons(list1, cons(list2, nil)))
    end
  end

  describe '.listToArray' do
    it 'returns an empty array when given the empty list' do
      expect(listToArray(@empty_list)).to eq([])
    end

    it 'handles nested empty lists' do
      expect(listToArray(cons(@empty_list, @empty_list))).to eq([[]])
    end

    it 'returns the corresponding array for a non-emtpy list' do
      expect(listToArray(cons(1, cons(2, @empty_list)))).to eq([1, 2])
    end

    it 'recursively converts nested lists to nested arrays' do
      list1 = cons(1, cons(2, @empty_list))
      array1 = listToArray(list1)
      list2 = cons(:a, cons(:b, cons(:c, @empty_list)))
      array2 = listToArray(list2)

      expect(listToArray(cons(list1, cons(list2, @empty_list))))
        .to eq([array1, array2])
    end
  end
end
