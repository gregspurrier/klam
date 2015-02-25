require 'spec_helper'

describe Klam::Primitives::ErrorHandling do
  include Klam::Primitives::ErrorHandling

  def value(sym)
    false
  end

  describe '#simple-error' do
    it 'raises an error having the supplied message' do
      expect {
        send(:"simple-error", 'oops!')
      }.to raise_error(Klam::Error, 'oops!')
    end
  end

  describe '#error-to-string' do
    it 'extracts the message from the given error' do
      expect(send(:"error-to-string", Klam::Error.new('oops!'))).to eq('oops!')
    end
  end
end
