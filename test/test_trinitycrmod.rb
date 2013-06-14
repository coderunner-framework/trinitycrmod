require 'helper'

class TestTrinitycrmodIFSPPPL < Test::Unit::TestCase
  def setup
    @runner = CodeRunner.fetch_runner(Y: 'test/ifspppl', C: 'trinity', X: '/dev/null')
  end
  def test_basics
    assert_equal(@runner.run_class, CodeRunner::Trinity)
    p @runner.run_class.rcp.variables
  end
end
