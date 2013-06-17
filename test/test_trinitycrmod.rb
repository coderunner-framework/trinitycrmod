require 'helper'

class TestTrinitycrmodIFSPPPL < Test::Unit::TestCase
  def setup
    @runner = CodeRunner.fetch_runner(Y: 'test/ifspppl', C: 'trinity', X: '/dev/null')
  end
  def teardown
    FileUtils.rm('test/ifspppl/.code_runner_script_defaults.rb')
    FileUtils.rm('test/ifspppl/.CODE_RUNNER_TEMP_RUN_LIST_CACHE')
  end
  def test_basics
    assert_equal(@runner.run_class, CodeRunner::Trinity)
  end
  def test_submit
    @runner.run_class.make_new_defaults_file("rake_test", "test/ifspppl/test.trin")
    FileUtils.mv('rake_test_defaults.rb', @runner.run_class.rcp.user_defaults_location)
    CodeRunner.submit(Y: 'test/ifspppl', T: true, D: 'rake_test')
		base_hash = @runner.run_class.parse_input_file('test/ifspppl/test.trin')
		test_hash = @runner.run_class.parse_input_file('test/ifspppl/v/id_1/v_id_1.trin')
		assert_equal(base_hash, test_hash)
    FileUtils.rm(@runner.run_class.rcp.user_defaults_location + '/rake_test_defaults.rb')
    FileUtils.rm('test/ifspppl/rake_test_defaults.rb')
		FileUtils.rm_r('test/ifspppl/v')
  end
end

class TestTrinitycrmodIFSPPPLAnalysis < Test::Unit::TestCase
  def setup
    #@runner = CodeRunner.fetch_runner(Y: 'test/ifspppl_results', C: 'trinity', X: '/dev/null')
		Dir.chdir('test/ifspppl_results/v'){str = "tar -xzf id_1.tgz";system str}
    @runner = CodeRunner.fetch_runner(Y: 'test/ifspppl_results', C: 'trinity', X: ENV['HOME'] + '/Code/trinity/trunk/trinity', A: true)
    #@runner.run_class.make_new_defaults_file("rake_test", "test/ifspppl/test.trin")
    #FileUtils.mv('rake_test_defaults.rb', @runner.run_class.rcp.user_defaults_location)
    #CodeRunner.submit(Y: 'test/ifspppl_results', D: 'rake_test', n: '1')
  end
  def test_analysis
    CodeRunner.status(Y: 'test/ifspppl_results')
    assert_equal(@runner.run_list.size, 1)
    assert_equal(@runner.run_list[1].fusionQ, 0.075658439797815016)
    FileUtils.rm('test/ifspppl_results/.CODE_RUNNER_TEMP_RUN_LIST_CACHE')
  end
	def test_graphs
	  kit = @runner.run_list[1].graphkit('ion_temp_prof', {t_index: 2})
		#kit.gnuplot
		assert_equal(kit.data[0].class, GraphKit::DataKit)
		assert_equal(kit.data[0].x.data[0], 0.05)
	end
  def teardown
    FileUtils.rm('test/ifspppl_results/.code_runner_script_defaults.rb')
    FileUtils.rm_r('test/ifspppl_results/v/id_1/')
  end
end
