require 'spec_helper'

describe Klam::Primitives::Vectors do
  include Klam::Primitives::Vectors

  describe '(absvector N)' do
    it 'returns an absvector of size N' do
      vec = absvector(3)
      expect(vec).to be_instance_of Klam::Absvector
      expect(vec.size).to eq(3)
    end
  end

  describe '(address-> V N Value)' do
    before(:each) do
      @vec = absvector(3)
    end

    it 'returns V' do
      expect(send(:"address->", @vec, 1, :foo)).to be @vec
    end

    it 'stores Value in index N of V' do
      send(:"address->", @vec, 1, :foo)
      expect(send(:"<-address", @vec, 1)).to eq(:foo)
    end

    it 'raises an error if N is negative' do
      expect {
        send(:"address->", @vec, -1, :foo)
      }.to raise_error(::Klam::Error)
    end

    it 'raises an error if N is >= the size of the V' do
      expect {
        send(:"address->", @vec, 3, :foo)
      }.to raise_error(::Klam::Error)
    end
  end

  describe '(<-address V N)' do
    before(:each) do
      @vec = absvector(3)
    end

    it 'returns the value previously stored at index N of V' do
      send(:"address->", @vec, 1, :foo)
      expect(send(:"<-address", @vec, 1)).to eq(:foo)
    end

    it 'does not raise an error if index N is uninitialized in V' do
      expect {
        send(:"<-address", @vec, 1)
      }.not_to raise_error
    end

    it 'raises an error if N is negative' do
      expect {
        send(:"<-address", @vec, -1)
      }.to raise_error(::Klam::Error)
    end

    it 'raises an error if N is >= the size of the V' do
      expect {
        send(:"<-address", @vec, 3)
      }.to raise_error(::Klam::Error)
    end
  end

  describe '(absvector? X)' do
    it 'returns true for vectors' do
      expect(absvector?(absvector(1))).to be true
    end

    it 'returns false for other types' do
      expect(absvector?(37)).to be false
    end
  end
end
