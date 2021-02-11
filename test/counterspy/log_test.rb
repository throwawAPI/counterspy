require "test_helper"

require "counterspy/log"

class Counterspy_LogTest < Minitest::Test

  class IncludesLog
    include Counterspy::Log
  end # class IncludesLog

  class ExtendsLog
    extend Counterspy::Log
  end # class ExtendsLog

  def test_Log_log_should_log()
    assert_output(/] Log.log/) { Counterspy::Log.log("Log.log") }
  end

  def test_IncludesLog_should_log()
    assert_output(/] include/) { IncludesLog.new().log("include") }
  end

  def test_ExtendsLog_should_log()
    assert_output(/] extend/) { ExtendsLog.log("extend") }
  end

  def test_Log_log_should_not_be_affected_by_IncludesLog()
    il     = IncludesLog.new()
    il.out = :stderr
    assert_output(/] Log.log/, '') { Counterspy::Log.log("Log.log") }
    assert_output('', /] include/) { il.log("include") }
  end
end
