module Klam
  class Reader
    include Klam::Converters::List

    def initialize(stream)
      @lexer = Klam::Lexer.new(stream)
    end

    def next
      token = @lexer.next
      unless token.nil?
        if token.kind_of? Klam::Lexer::OpenParen
          read_list
        else
          token
        end
      end
    end

  private

    def read_list
      items = []
      stack = [items]

      until stack.empty? do
        token = @lexer.next
        raise Klam::SyntaxError, 'Unterminated list' if token.nil?
        case token
        when Klam::Lexer::OpenParen
          items = []
          stack.push items
        when Klam::Lexer::CloseParen
          array = stack.pop
          unless stack.empty?
            items = stack.last
            items << array
          end
        else
          items << token
        end
      end
      arrayToList(array)
    end
  end
end
