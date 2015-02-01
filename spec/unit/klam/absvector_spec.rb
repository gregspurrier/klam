require 'spec_helper'

describe Klam::Absvector do
  describe '#to_a' do
    it 'skips the first element' do
      a = Klam::Absvector.new(3)
      a[0] = 1
      a[1] = 2
      a[2] = 3
      expect(a.to_a).to eq([2,3])
    end
  end

  describe '#each' do
    it 'skips the first element' do
      a = Klam::Absvector.new(3)
      a[0] = 1
      a[1] = 2
      a[2] = 3
      b = []
      a.each { |x| b << x }
      expect(b).to eq([2,3])
    end
  end
end
