module Counterspy
  module Mixins
    module Log
      def out=(io)
        @COUNTERSPY_LOG_OUT = io
      end # out=()

      # :stdout and :stderr allow us to get
      # a fresh reference to $stdout and $stderr
      # this is good in case they've been intercepted
      # if you want to ignore a redirected $stdout, use STDOUT
      def out()
        case(@COUNTERSPY_LOG_OUT ||= :stdout)
        when :stdout
          return $stdout
        when :stderr
          return $stderr
        else
          return @COUNTERSPY_LOG_OUT
        end
      end # out()

      # self.is_a?(Class) will test whether the module
      # has been `included` (instance-level) or `extended` (class-level).
      # either way, this Log class can handle it
      def log(msg)
        klass = (self.is_a?(Class) ? self : self.class)
        out.puts("[#{Time.now} #{klass.name}#{caller_method()}] #{msg}")
      end # log()

      # TODO: add .debug() .warn() and .error()

      private
      def caller_method()
        c = caller_locations(2,1)[0] # my caller's caller
        return "##{c.label}:#{c.lineno}"
      end # caller_method()
    end # module Log
  end # module Mixins
end # module Counterspy
