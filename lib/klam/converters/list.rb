module Klam
  module Converters
    # Utility methods to convert between Ruby Arrays and Kl Lists
    module List
      include Klam::Primitives::Lists

      def arrayToList(array)
        list = EMPTY_LIST
        (array.length - 1).downto(0) do |index|
          item = array[index]
          item = arrayToList(item) if item.kind_of?(Array)
          list = cons(item, list)
        end
        list
      end

      def listToArray(list)
        array = []
        while list != EMPTY_LIST
          item = hd(list)
          item = listToArray(item) if cons?(item) || item == EMPTY_LIST
          array << item
          list = tl(list)
        end
        array
      end
    end
  end
end
