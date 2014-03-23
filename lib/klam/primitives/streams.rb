module Klam
  module Primitives
    module Streams
      def read_byte(stream)
        if stream.eof?
          -1
        else
          stream.readbyte
        end
      end
      alias_method :"read-byte", :read_byte
      remove_method :read_byte

      def write_byte(byte, stram)
        stream.putc byte
        byte
      end
      alias_method :"write-byte", :write_byte
      remove_method :write_byte

      def open(name, direction)
        ::File.open(::File.expand_path(name, value(:'*home-directory*')),
                    direction == :out ? 'w' : 'r')
      end

      def close(stream)
        stream.close
        :NIL
      end
    end
  end
end

