require 'spec_helper'

describe Klam::Reader do
  include Klam::Converters::List

  def reader(str)
    Klam::Reader.new(StringIO.new(str))
  end

  before(:each) do
    @empty_list = Klam::Primitives::Lists::EMPTY_LIST
  end

  describe 'Reading lists' do
    it 'reads () as an empty list' do
      expect(reader('()').next)
        .to be(@empty_list)
    end

    it 'reads a list as a single expression' do
      list = reader('(1 2 3)').next
      expect(list).to eq(arrayToList([1, 2, 3]))
    end

    it 'supports nested lists' do
      list = reader('(1 (2 (3) ()))').next
      expect(list)
        .to eq(arrayToList([1,
                            arrayToList([2, arrayToList([3]), @empty_list])]))
    end

    it 'raises an error on unterminated lists' do
      expect {
        reader('(1').next
      }.to raise_error(Klam::SyntaxError, 'Unterminated list')
    end
  end

  describe 'Reading booleans' do
    it 'reads true as true' do
      expect(reader('true').next).to be(true)
    end

    it 'reads false as false' do
      expect(reader('false').next).to be(false)
    end
  end
end
