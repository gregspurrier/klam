require 'spec_helper'

describe 'Atoms' do
  def read_kl(str)
    stream = StringIO.new(str)
    reader = Klam::Reader.new(stream)
    reader.next
  end

  def expect_eval_kl(str)
    form = read_kl(str)
    expect(@env.__send__(:"eval-kl", form))
  end

  before(:each) do
    @env = Klam::Environment.new
  end

  describe 'numbers' do
    it 'integers evaluate to themselves' do
      expect_eval_kl('37').to eq(read_kl('37'))
    end

    it 'reals evaluate to themselves' do
      expect_eval_kl('37.42').to eq(read_kl('37.42'))
    end
  end

  describe 'symbols' do
    it 'evaluate to themselves' do
      expect_eval_kl('sym').to eq(read_kl('sym'))
    end

    it 'supports the full range of initial symbol characters' do
      # See http://www.shenlanguage.org/learn-shen/shendoc.htm#The%20Syntax%20of%20Symbols
      all_chars = 'abcdefghijklmnopqrstuvwxyz'
      all_chars += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
      all_chars += "=-*/+_?$!@~.><&%'#`;:{}"

      all_chars.each_char do |c|
        expect_eval_kl(c).to eq(read_kl(c))
      end
    end
  end

  describe 'strings' do
    it 'evaluate to themselves' do
      expect_eval_kl('"a string"').to eq(read_kl('"a string"'))
    end

    it 'supports embedded single quotes' do
      expect_eval_kl('"\'quote\'"').to eq(read_kl('"\'quote\'"'))
    end
  end

  describe 'booleans' do
    it 'evaluates true to itself' do
      expect_eval_kl('true').to eq(read_kl('true'))
    end

    it 'evaluates false to itself' do
      expect_eval_kl('false').to eq(read_kl('false'))
    end
  end
end
