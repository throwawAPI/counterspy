module Counterspy
  class BinString < String
    # we enforce Encoding::BINARY here, unless explicitly overrriden
    # BINARY, aka ASCII-8BIT, is an encoding that handles raw binary
    # streams gracefully. In theory, you can add an encoding:, but this
    # is discouraged, as its behavior is undefined.
    def initialize(str="", encoding: Encoding::BINARY, capacity: nil)
      if( capacity.nil? )
        super(str, encoding: encoding)
      else
        super(str, encoding: encoding, capacity: capacity)
      end
    end

    # inspect() is formatted to give (more) human-readable hex
    # in place of the raw, unformatted binary encoding.
    # to_s() and to_str() should still give us the raw binary,
    # similiar to the formatting inside a binary file.
    def inspect(radix=16)
      arr = []
      digits = Math.log(256, radix).ceil()
      self.each_byte do |byte|
        arr << byte.to_s(radix).rjust(digits,'0').upcase()
      end #
      return "0x" + arr.join("_")
    end # to_str()
  end # class BinString
end # module Counterspy
