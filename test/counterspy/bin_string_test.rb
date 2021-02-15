require "test_helper"

require "counterspy/bin_string"

module Counterspy::Test
  class BinString < Minitest::Test

    STR_ISO = "ISO ".encode(Encoding::ISO_8859_1)
    STR_UTF = "UTF_8 ".encode(Encoding::UTF_8)
    STR_ASC = "US-ASCII".encode(Encoding::ASCII) # ASCII-7BIT

    def test_concat_force_BINARY_encoding()
      str = Counterspy::BinString.new("BINARY ")
      str.concat(STR_ISO, STR_UTF)
      str << STR_ASC
      assert_equal(str.encoding, Encoding::BINARY)
      assert_equal("BINARY ISO UTF_8 US-ASCII", str)
    end

    def test_inspect_format()
      str = Counterspy::BinString.new("BIN")
      assert_equal(str.to_str, "BIN")
      assert_equal("#{str}", "BIN")
      assert_equal(str.inspect,"0x42_49_4E")
    end
  end # class BinString
end # module Counterspy::Test
