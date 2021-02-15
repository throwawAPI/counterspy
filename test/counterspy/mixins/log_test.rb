require "test_helper"

require "counterspy/mixins/log"

module Counterspy::Test
  module Mixins
    class Log < Minitest::Test
      class IncludesLog; include Counterspy::Mixins::Log; end
      class ExtendsLog;   extend Counterspy::Mixins::Log; end

      def test_IncludesLog_should_log()
        assert_output(/\[.*IncludesLog#.*\] include/, "") { IncludesLog.new().log("include") }
      end

      def test_ExtendsLog_should_log()
        assert_output(/\[.*ExtendsLog#.*\] extends/, "") { ExtendsLog.log("extends") }
      end

      def test_ExtendsLog_should_not_be_affected_by_IncludesLog()
        il     = IncludesLog.new()
        il.out = :stderr
        assert_output(/\[.*ExtendsLog#.*\] extends/, "") { ExtendsLog.log("extends") }
        assert_output('', /] include/) { il.log("include") }
      end
    end # class Log
  end # module Mixins
end # module Counterspy::Test
