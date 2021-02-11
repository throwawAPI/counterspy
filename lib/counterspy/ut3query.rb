require "socket"

module Counterspy
  class UT3Query

    # from Gamespy Query Protocol v4
    # http://wiki.unrealadmin.org/UT3_query_protocol
    PROTOCOL  = ["\xFE".b, "\xFD".b]
    HANDSHAKE = ["\x09".b]
    QUERY     = ["\x00".b]

    def to_hex(str)
      retval = ""
      str.each_byte do |byte|
        retval << " 0x" << byte.to_s(16).rjust(2,'0').upcase
      end
      return retval.lstrip
    end # to_hex()

    def initialize(host:, port:, **o)
      @host      = host
      @port      = port
      @client    = UDPSocket.new
      @wait      = o[:wait]      || 5 # seconds
      @id        = o[:id]        || nil
      @protocol  = o[:protocol]  || self.class::PROTOCOL
      @handshake = o[:handshake] || self.class::HANDSHAKE
      @query     = o[:query]     || self.class::QUERY
      @challenge = nil
      @msg       = []
    end # initialize()

    def handshake(wait=@wait)
      # pack send_msg with the opening bits
      send_msg = []
      send_msg << @protocol
      send_msg << @handshake
      # @id will be used if provided
      # otherwise, we use Time.now to generate @id
      if( @id.nil? )
        id = []
        ts = Time.now.to_i
        id << ((ts & 0xFF_00_00_00) >> 24).chr
        id << ((ts & 0x00_FF_00_00) >> 16).chr
        id << ((ts & 0x00_00_FF_00) >>  8).chr
        id << ((ts & 0x00_00_00_FF) >>  0).chr
      else
        id = @id
      end
      send_msg << id
      send_msg << @msg
      send_msg = send_msg.join
      puts "Handshake [SEND] #{@host}:#{@port} <#{to_hex(send_msg)}>"
      @client.send(send_msg, 0, @host, @port)
      if( wait || @wait )
        if( IO.select([@client], nil, nil, 5) )
          recv_arr = @client.recvfrom(18)
        else
          return nil
        end
      else
        begin
          recv_arr = recvfrom_nonblock(18)
        rescue IO::WaitReadable
          return nil
        end
      end
      recv_msg  = recv_arr[0]
      recv_addr = recv_arr[1]
      puts "Handshake [RECV] #{recv_addr[3]}:#{recv_addr[1]} <#{to_hex(recv_msg)}>"
      return true
    end # handshake()

    def query(msg)
    end # query()
  end # class UT3Query
end # module Counterspy
