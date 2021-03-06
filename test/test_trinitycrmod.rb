require 'helper'

require 'rbconfig'
$ruby_command = "#{RbConfig::CONFIG['bindir']}/#{RbConfig::CONFIG['ruby_install_name']}"
$coderunner_command = "#{$ruby_command}  -I lib/ lib/coderunner.rb"

class TestTrinitycrmodIFSPPPL < MiniTest::Test
  def setup
    #puts "setup"; STDIN.gets
    cleanup if FileTest.exist?('test/ifspppl/.code_runner_script_defaults')
    @runner = CodeRunner.fetch_runner(Y: 'test/ifspppl', C: 'trinity', X: '/dev/null')
		system("gunzip test/gs2_42982/pr08_jet_42982_1d.dat.gz -c > test/gs2_42982/pr08_jet_42982_1d.dat")
		system("gunzip test/gs2_42982/pr08_jet_42982_2d.dat.gz -c > test/gs2_42982/pr08_jet_42982_2d.dat")
		FileUtils.makedirs('test/ifspppl/v')
  end
  def cleanup
    #FileUtils.rm('test/ifspppl/.code_runner_script_defaults.rb')
    #FileUtils.rm('test/ifspppl/.CODE_RUNNER_TEMP_RUN_LIST_CACHE')
    #FileUtils.rm('test/gs2_42982/pr08_jet_42982_1d.dat')
    #FileUtils.rm('test/gs2_42982/pr08_jet_42982_2d.dat')
		#FileUtils.rm_r('test/ifspppl/v')
  end
  def teardown
  end
  def test_basics
    assert_equal(@runner.run_class, CodeRunner::Trinity)
  end
  def test_submit
    @runner.run_class.make_new_defaults_file("rake_test", "test/ifspppl/test.trin")
    FileUtils.mv('rake_test_defaults.rb', @runner.run_class.rcp.user_defaults_location)
		if ENV['TRINITY_EXEC']
      CodeRunner.submit(Y: 'test/ifspppl', T: false, D: 'rake_test', n: '1', X: ENV['TRINITY_EXEC'])
      CodeRunner.submit(Y: 'test/ifspppl', T: false, D: 'rake_test', n: '1', X: ENV['TRINITY_EXEC'], p: '{restart_id: 1}')
			Dir.chdir('test/ifspppl') do
				system "ls v/id_2/"
				#system "less v/id_2/#{@runner.run_list[2].error_file}"
			end
      if ENV['TEST_INTERP'] 
        CodeRunner.submit(Y: 'test/ifspppl', T: false, D: 'rake_test', n: '1', X: ENV['TRINITY_EXEC'], p: '{grad_option: "tigrad", ntstep: 100, ntdelt_max: 0.01, include_neo: ".false."}')
        CodeRunner.submit(Y: 'test/ifspppl', T: false, D: 'rake_test', n: '1', X: ENV['TRINITY_EXEC'], p: %${grad_option: "tigrad", flux_option: "shell", flux_shell_script: "echo starting; #$ruby_command -I '#{File.dirname(File.expand_path(__FILE__))}/../lib' -e 'require %[rubygems]; require %[trinitycrmod]; CodeRunner::Trinity.interpolate_fluxes(%[../id_3/], %[.], %[tigrad], 2)\'; echo ending", ntstep: 100, include_neo: ".false."}$)
      end
			#@runner.update
			#CodeRunner.status(Y: 'test/ifspppl')
			#STDIN.gets
			assert_equal(:Complete, @runner.run_list[1].status)
			assert_equal(:Complete, @runner.run_list[2].status)
			assert_equal(@runner.run_list[1].list(:t).values.max, @runner.run_list[2].list(:t).values.min)
		else
      CodeRunner.submit(Y: 'test/ifspppl', T: true, D: 'rake_test')
		end
		base_hash = @runner.run_class.parse_input_file('test/ifspppl/test.trin')
		test_hash = @runner.run_class.parse_input_file('test/ifspppl/v/id_1/v_id_1_t.trin')
		assert_equal(base_hash, test_hash)
		CodeRunner.status(Y: 'test/ifspppl')
    FileUtils.rm(@runner.run_class.rcp.user_defaults_location + '/rake_test_defaults.rb')
    FileUtils.rm('test/ifspppl/rake_test_defaults.rb')
  end
end

unless ENV['NO_GS2']

class TestTrinitycrmodGs2 < MiniTest::Test
	def setup
    cleanup
		CodeRunner.setup_run_class('trinity')
		Dir.chdir('test/gs2_42982'){
			CodeRunner::Trinity.use_new_defaults_file_with_flux('rake_test_gs2_42982', 'shot42982_jet.trin', 'shot42982_jet.in', 'gs2')
		}
    @runner = CodeRunner.fetch_runner(Y: 'test/gs2_42982', C: 'trinity', X: '/dev/null')
		system("gunzip test/gs2_42982/pr08_jet_42982_1d.dat.gz -c > test/gs2_42982/pr08_jet_42982_1d.dat")
		system("gunzip test/gs2_42982/pr08_jet_42982_2d.dat.gz -c > test/gs2_42982/pr08_jet_42982_2d.dat")
	end
	def test_submit
		if ENV['TRINITY_EXEC']
			CodeRunner.submit(Y: 'test/gs2_42982', X: ENV['TRINITY_EXEC'], n: '8', p: '{flux_pars: {nstep: 50}}')
			CodeRunner.submit(Y: 'test/gs2_42982', X: ENV['TRINITY_EXEC'], n: '8', p: '{restart_id: 1, flux_pars: {nstep: 10, nwrite: 1, nsave: 1}}')
			CodeRunner.submit(Y: 'test/gs2_42982', X: ENV['TRINITY_EXEC'], n: '8', p: '{restart_id: 2, flux_pars: {nstep: 10}}')
			CodeRunner.submit(Y: 'test/gs2_42982', X: ENV['TRINITY_EXEC'], n: '8', p: '{restart_id: 3, flux_pars: {nstep: 10, nwrite: 1, tprim_1: {calib: 5.0, jac: 9.0}}, neval_calibrate: 6, ncc_calibrate: 1}')
      #STDIN.gets
      @runner.run_list[4].calibration_graphkit({}).gnuplot
			CodeRunner.submit(Y: 'test/gs2_42982', X: ENV['TRINITY_EXEC'], n: '8', p: '{no_restart_gs2: true, restart_id: 4, flux_pars: {nstep: 10, nwrite: 1, nsave: 1}, neval_calibrate: 6, ncc_calibrate: 1}')
			CodeRunner.status(Y: 'test/gs2_42982')
      #CodeRunner.run_command('watch_calibration_status', j: 5, Y: 'test/gs2_42982') 
      #STDIN.gets
		  runs = @runner.run_list
			assert_equal(:Complete, runs[1].status)
			assert_equal(:Complete, runs[2].status)
			assert_equal(1, runs[2].flux_runs[1].nwrite)
			assert_equal(1, runs[3].flux_runs[1].nwrite)
			assert_equal(9.0, runs[4].flux_runs[1].tprim_1)
			assert_equal(5.0, runs[4].flux_runs[8].tprim_1)
			assert_equal(runs[1].list(:t).values.max, runs[2].list(:t).values.min)
			assert_equal(runs[3].list(:t).values.max, runs[4].list(:t).values.min)
		  assert_equal(runs[2].flux_runs[3].gsl_vector('phi2tot_over_time')[-1].round(1), runs[3].flux_runs[3].gsl_vector('phi2tot_over_time')[0].round(1))
      assert_equal(9, runs[5].flux_runs.size)
      assert_equal("noise", runs[5].flux_runs[8].ginit_option)
      testrun=6

		else
			CodeRunner.submit(Y: 'test/gs2_42982', X: '/dev/null', n: '8')
			CodeRunner.submit(Y: 'test/gs2_42982', X: '/dev/null', n: '8')
      testrun=3
		end
	  CodeRunner.submit(Y: 'test/gs2_42982', X: '/dev/null', n: '16', p: '{grad_option: "ntgrads", flux_pars: {nx: 43, delt: {2=>0.003}}}')
		@runner.use_component = :component
		@runner.recalc_all = true
		@runner.update
		#CodeRunner.status(Y: 'test/gs2_42982', h: :component, A: true)
		assert_equal(0.003, @runner.run_list[testrun].flux_runs[2].delt)
		assert_equal(0.01, @runner.run_list[testrun].flux_runs[1].delt)
		assert_equal(43, @runner.run_list[testrun].flux_runs[1].nx)
		assert_equal(16, @runner.run_list[testrun].flux_runs.size)
		assert_equal(8, @runner.run_list[1].flux_runs.size)
	end
  def cleanup
    #@runner = CodeRunner.fetch_runner(Y: 'test/gs2_42982', C: 'trinity', X: '/dev/null')
    #FileUtils.rm(@runner.run_class.rcp.user_defaults_location + '/rake_test_gs2_42982_defaults.rb') rescue nil
    #FileUtils.rm('test/gs2_42982/rake_test_gs2_42982_defaults.rb') rescue nil
    #FileUtils.rm('test/gs2_42982/pr08_jet_42982_1d.dat') rescue nil
    #FileUtils.rm('test/gs2_42982/pr08_jet_42982_2d.dat') rescue nil
    #FileUtils.rm('test/gs2_42982/.CODE_RUNNER_TEMP_RUN_LIST_CACHE') rescue nil
    ##STDIN.gets
    #FileUtils.rm_r('test/gs2_42982/v/') rescue nil
  end
	def teardown 
		if ENV['TRINITY_EXEC'] and not FileTest.exist?('test/gs2_42982_results/v.tgz')
			Dir.chdir('test/gs2_42982'){system("tar -czf v.tgz v/")}
			FileUtils.mv('test/gs2_42982/v.tgz', 'test/gs2_42982_results/.')
		end
	end
end

class TestTrinitycrmodGs2Analysis < MiniTest::Test
	def setup
    cleanup if FileTest.exist?('test/gs2_42982_results/v')
		Dir.chdir('test/gs2_42982_results/'){system "tar -xzf v.tgz"}
    @runner = CodeRunner.fetch_runner(Y: 'test/gs2_42982_results', C: 'trinity', A: true)
	end
	def test_analysis
		CodeRunner.status(Y: 'test/gs2_42982_results')
		CodeRunner.status(Y: 'test/gs2_42982_results', h: :component)
		run = @runner.run_list[1]
		newrun=nil
		Dir.chdir(run.directory){run.save; newrun = CodeRunner::Trinity.load(Dir.pwd, @runner)}
		assert_equal(CodeRunner, newrun.runner.class)
		assert_equal(CodeRunner, newrun.flux_runs[1].runner.class)
		run.status = :Unknown
		@runner.recheck_filtered_runs
	  assert_equal(8, @runner.run_list[1].gs2_run_times[0].size)
    @runner.use_component = :real
    @runner.run_graphkit('nc_temp_grid', {t_index: 1, conditions: "id==3"}).gnuplot
	end
	#def test_load_component_runs
		#CodeRunner.status(Y: 'test/gs2_42982_results')
		#run = @runner.run_list[1]
		#newrun=nil
		#Dir.chdir(run.directory){run.save; newrun = CodeRunner::Trinity.load(Dir.pwd, @runner)}
		#assert_equal(CodeRunner, newrun.runner.class)
	#end
  def cleanup
		#FileUtils.rm_r('test/gs2_42982_results/v')
    #FileUtils.rm('test/gs2_42982_results/.code_runner_script_defaults.rb')
    #FileUtils.rm('test/gs2_42982_results/.CODE_RUNNER_TEMP_RUN_LIST_CACHE')
  end
	def teardown
	end
end


end #unless ENV['NO_GS2']
class TestTrinitycrmodIFSPPPLAnalysis < MiniTest::Test
  def setup
    #@runner = CodeRunner.fetch_runner(Y: 'test/ifspppl_results', C: 'trinity', X: '/dev/null')
    cleanup if FileTest.exist?('test/ifspppl_results/v/id_1')
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
		list_t = @runner.run_list[1].list(:t)
		assert_equal(201, list_t.size)
		assert_equal(0.04375, list_t[10])
    FileUtils.rm('test/ifspppl_results/.CODE_RUNNER_TEMP_RUN_LIST_CACHE')
  end
	def test_graphs
	  kit = @runner.run_list[1].graphkit('ion_temp_prof', {t_index: 2})
		#kit.gnuplot
		assert_equal(kit.data[0].class, GraphKit::DataKit)
		assert_equal(kit.data[0].x.data[0], 0.05)
	  kit = @runner.run_list[1].graphkit('ion_hflux_gb_prof', {t_index: 2})
		#kit.gnuplot
		assert_equal(kit.data[0].class, GraphKit::DataKit)
		assert_equal(8,kit.data[0].y.data.size)
		assert_equal(kit.data[0].y.data[0], 0.001944)
	  kit = @runner.run_list[1].graphkit('ion_pwr_prof', {t_index: 2})
		assert_equal(8,kit.data[0].y.data.size)
		assert_equal(kit.data[0].y.data[0], 0.2412)

	  kit = @runner.run_list[1].graphkit('profiles', {t_index: 2})
	  kit = @runner.run_list[1].graphkit('integrated_profiles', {t_index: 2})

		#kit.gnuplot
	end
  def test_interpolate_fluxes
    #CodeRunner::Trinity.interpolate_fluxes('test/ifspppl_results/v/id_1/', 'dummy', 'tigrads', 2)
  end

	def test_average_graphs
	  kit = @runner.run_list[1].graphkit('ion_hflux_gb_prof', {t_index: 2})
		#kit.gnuplot
		assert_equal(kit.data[0].class, GraphKit::DataKit)
		assert_equal(kit.data[0].y.data[0], 0.001944)
	  kit = @runner.run_list[1].graphkit('ion_hflux_gb_prof', {t_index: 1})
		#kit.gnuplot
		assert_equal(kit.data[0].class, GraphKit::DataKit)
		assert_equal(kit.data[0].y.data[0], 0.001975)
	  kit = @runner.run_list[1].graphkit('ion_hflux_gb_prof', {t_index: 2, time_average: -1})
		assert_equal([0.001975, 0.001944].sum/2.0, kit.data[0].y.data[0])
	end
  def teardown
    return
    #cleanup
  end
  def cleanup
    #FileUtils.rm('test/ifspppl_results/.code_runner_script_defaults.rb') rescue nil
    #FileUtils.rm_r('test/ifspppl_results/v/id_1/') rescue nil
  end
end
