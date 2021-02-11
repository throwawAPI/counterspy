require "test_helper"

require "counterspy/ut3query"

class Counterspy_UT3QueryTest < Minitest::Test
  def test_UT3Query_creation()
    assert Counterspy::UT3Query.new(host: '127.0.0.1', port: 25565)
  end

  def test_UT3Query_handshake()
    assert Counterspy::UT3Query.new(host: '127.0.0.1', port: 25565).handshake()
  end

  def test_UT3Query_handshake_wild()
    assert(Counterspy::UT3Query.new(host: '194.226.154.130', port: 6500).handshake(), 'Could not connect to server, try getting a new UT3 server from https://www.gametracker.com/search/ut3/')
  end
end
