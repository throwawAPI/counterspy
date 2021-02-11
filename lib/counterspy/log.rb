module Counterspy
  module Log
    # extend Counterspy::Log to give logging access at class level
    # include Counterspy::Log to give logging access at object level
    # `extend self` allows for Counterspy::Log.log()
    extend self

    def out=(io)
      @LOG_OUTPUT = io
    end # out=()

    # :stdout and :stderr allow us to get
    # a fresh reference to $stdout and $stderr
    # this is good in case they've been intercepted
    # if you want to ignore a redirected $stdout, use STDOUT
    def out()
      case(@LOG_OUTPUT ||= :stdout)
      when :stdout
        return $stdout
      when :stderr
        return $stderr
      else
        return @LOG_OUTPUT
      end
    end # out()

    def log(msg)
      if( self.is_a?(Class) )
        klass = self
      else
        klass = self.class
      end
      out.puts("[#{Time.now} #{klass.name}#{caller_method}] #{msg}")
      return self
    end # log()

    def caller_method()
      c = caller_locations(2,1)[0]
      return "##{c.label}:#{c.lineno}"
    end # caller()
  end # module Log
end # module Counterspy
