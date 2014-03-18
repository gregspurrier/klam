require 'spec_helper'

describe Klam::Lexer do
  def lexer(str)
    Klam::Lexer.new(StringIO.new(str))
  end

  describe 'syntax tokens' do
    it 'reads ( as a Klam::Lexer::OpenParen' do
      expect(lexer("(").next).to be_kind_of(Klam::Lexer::OpenParen)
    end

    it 'reads ) as a Klam::Lexer::CloseParen' do
      expect(lexer(")").next).to be_kind_of(Klam::Lexer::CloseParen)
    end
  end

  describe 'string tokens' do
    it 'reads double-quoted strings' do
      expect(lexer('"Fred"').next).to eq("Fred")
    end

    it 'throws Klam::SyntaxError on unterminated strings' do
      expect {
        lexer('"Fred').next
      }.to raise_error(Klam::SyntaxError, "unterminated string")
    end
  end

  describe 'symbols' do
    it 'reads sign characters not followed by digits as symbols' do
      expect(lexer('-').next).to eq('-'.to_sym)
      expect(lexer('+').next).to eq('+'.to_sym)
      expect(lexer('--+-').next).to eq('--+-'.to_sym)
    end

    it 'reads double decimal points followed by digits as symbols' do
      expect(lexer('..77').next).to eq('..77'.to_sym)
    end

    it "accepts =-*/+_?$!@~><&%'#`;:{} in symbols" do
      all_punctuation = "=-*/+_?$!@~><&%'#`;:{}"
      sym = lexer(all_punctuation).next
      expect(sym).to be_kind_of(Symbol)
      expect(sym.to_s).to eq(all_punctuation)
    end
  end

  describe 'numbers' do
    it 'reads integers as Fixnums' do
      num = lexer("37").next
      expect(num).to be_kind_of(Fixnum)
      expect(num).to eq(37)
    end

    it 'reads floating points as Floats' do
      num = lexer("37.42").next
      expect(num).to be_kind_of(Float)
      expect(num).to eq(37.42)
    end

    it 'with an odd number of leading minuses are negative' do
      expect(lexer('-1').next).to eq(-1)
      expect(lexer('---1').next).to eq(-1)
    end

    it 'with an even number of leading minuses are positive' do
      expect(lexer('--1').next).to eq(1)
      expect(lexer('----1').next).to eq(1)
    end

    it 'with leading + does not change sign' do
      expect(lexer('+-1').next).to eq(-1)
      expect(lexer('-+--1').next).to eq(-1)
      expect(lexer('-+-+1').next).to eq(1)
      expect(lexer('+-+-+-+-+1').next).to eq(1)
    end

    it 'allows leading decimal points' do
      expect(lexer('.9').next).to eq(0.9)
      expect(lexer('-.9').next).to eq(-0.9)
    end

    it 'treats a trailing decimal followed by EOF as a symbol' do
      l = lexer('7.')
      num = l.next
      expect(num).to be_kind_of(Fixnum)
      expect(num).to eq(7)

      sym = l.next
      expect(sym).to be_kind_of(Symbol)
      expect(sym.to_s).to eq('.')
    end

    it 'treats a trailing decimal followed by non-digit as a symbol' do
      l = lexer('7.a')
      num = l.next
      expect(num).to be_kind_of(Fixnum)
      expect(num).to eq(7)

      sym = l.next
      expect(sym).to be_kind_of(Symbol)
      expect(sym.to_s).to eq('.a')
    end

    it 'handles multiple decimal points like shen does' do
      l = lexer('7.8.9')
      expect(l.next).to eq(7.8)
      expect(l.next).to eq(0.9)
    end
  end

  describe 'booleans' do
    it 'reads true as boolean true' do
      expect(lexer('true').next).to be_kind_of(TrueClass)
    end

    it 'reads false as boolean false' do
      expect(lexer('false').next).to be_kind_of(FalseClass)
    end
  end

  describe 'whitespace' do
    it 'is ignored between tokens' do
      l = lexer("     (\n\t)   ")
      expect(l.next).to be_kind_of(Klam::Lexer::OpenParen)
      expect(l.next).to be_kind_of(Klam::Lexer::CloseParen)
      expect(l.next).to be_nil
    end

    it 'is left intact in strings' do
      expect(lexer('     "one two"   ').next).to eq("one two")
    end
  end

  it 'works with these all together' do
    l = lexer('(12 quick m-*$ RAN `fast\' -.7) "oh 12 yeah!"  ')
    expect(l.next).to be_kind_of(Klam::Lexer::OpenParen)
    expect(l.next).to eq(12)
    expect(l.next).to eq(:quick)
    expect(l.next).to eq('m-*$'.to_sym)
    expect(l.next).to eq(:RAN)
    expect(l.next).to eq("`fast'".to_sym)
    expect(l.next).to eq(-0.7)
    expect(l.next).to be_kind_of(Klam::Lexer::CloseParen)
    expect(l.next).to eq("oh 12 yeah!")
    expect(l.next).to be_nil
  end
end
