require 'spec_helper'

describe Klam::Primitives::Strings do
  include Klam::Primitives::Strings

  describe '(pos Str N)' do
    it 'returns the character at zero-based index N' do
      expect(pos('howdy', 1)).to eq('o')
    end

    it 'raises an error if N is negative' do
      expect {
        pos('howdy', -1)
      }.to raise_error(Klam::Error, 'index out of bounds: -1')
    end

    it 'raises an error if N is beyond the end of the string' do
      expect {
        pos('howdy', 5)
      }.to raise_error(Klam::Error, 'index out of bounds: 5')
    end
  end

  describe '(tlstr Str)' do
    it 'returns a string containing all but the first character of S' do
      expect(tlstr('howdy')).to eq('owdy')
    end

    it 'raises an error when Str is empty' do
      expect {
        tlstr('')
      }.to raise_error('attempted to take tail of empty string')
    end
  end

  describe '(cn S1 S2)' do
    it 'returns S1 concatenated with S2' do
      expect(cn('hi ', 'there')).to eq('hi there')
    end
  end

  describe '(n->string N)' do
    it 'returns a unit string with the character having codepoint N' do
      expect(send(:"n->string", 65)).to eq('A')
    end
  end

  describe '(string->n)' do
    it 'returns the codepoint of the first character' do
      expect(send(:"string->n", 'A')).to eq(65)
    end
  end
end
