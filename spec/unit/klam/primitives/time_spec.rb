require 'spec_helper'

describe Klam::Primitives::Time do
  include Klam::Primitives::Time
  describe '(time Type)' do
    it 'returns the current time in seconds as a float when Type is :real' do
      allow(Time).to receive(:now).and_return(123.4)
      expect(send(:"get-time", :real)).to eq(123.4)
    end

    it 'returns the current time in seconds as an integer when Type is :unix' do
      allow(Time).to receive(:now).and_return(123.4)
      expect(send(:"get-time", :unix)).to eq(123)
    end
  end
end
