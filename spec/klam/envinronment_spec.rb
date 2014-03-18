require 'spec_helper'

describe Klam::Environment do
  def expect_kl(str)
    stream = StringIO.new(str)
    reader = Klam::Reader.new(stream)
    form = reader.next
    expect(@env.__send__(:"eval-kl", form))
  end

  before(:each) do
    @env = Klam::Environment.new
  end

  describe '#eval-kl' do
    it 'evaluates numbers to themselves' do
      expect_kl('37').to eq(37)
    end

    it 'evaluates free symbols to themselves' do
      expect_kl('a-symbol').to eq(:"a-symbol")
    end

    it 'evaluates strings to themselves' do
      expect_kl('"a \'fine\' string"').to eq("a 'fine' string")
    end

    it 'evaluates booleans to themselves' do
      expect_kl('true').to be(true)
      expect_kl('false').to be(false)
    end
  end
end
