# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "trinitycrmod"
  gem.homepage = "http://github.com/edmundhighcock/trinitycrmod"
  gem.license = "GPLv3"
  gem.summary = %Q{CodeRunner module for the Trinity simulation software.}
  gem.description = %Q{This module allows Trinity, the Multiscale Gyrokinetic Turbulent Transport solver for Fusion Reactors, to harness the power of CodeRunner, a framework for the automated running and analysis of simulations.}
  gem.email = "edmundhighcock@sourceforge.net"
  gem.authors = ["Edmund Highcock"]
	gem.files.exclude 'test/**/*'
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test => [:clean_tests]) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

Rake::TestTask.new(:sync_variables) do |test|
  test.libs << 'lib' << 'sync_variables'
  test.pattern = 'sync_variables/sync_variables.rb'
  test.verbose = true
end

task :clean_tests do 
    require 'coderunner'
  require 'rubygems'
  require 'bundler'
  begin
    Bundler.setup(:default, :development)
  rescue Bundler::BundlerError => e
    $stderr.puts e.message
    $stderr.puts "Run `bundle install` to install missing gems"
    exit e.status_code
  end
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
    @runner = CodeRunner.fetch_runner(Y: 'test/gs2_42982', C: 'trinity', X: '/dev/null')
    FileUtils.rm(@runner.run_class.rcp.user_defaults_location + '/rake_test_gs2_42982_defaults.rb') rescue nil
    FileUtils.rm('test/gs2_42982/rake_test_gs2_42982_defaults.rb') rescue nil
    FileUtils.rm('test/gs2_42982/pr08_jet_42982_1d.dat') rescue nil
    FileUtils.rm('test/gs2_42982/pr08_jet_42982_2d.dat') rescue nil
    FileUtils.rm('test/gs2_42982/.CODE_RUNNER_TEMP_RUN_LIST_CACHE') rescue nil
    #STDIN.gets
    FileUtils.rm_r('test/gs2_42982/v/') rescue nil
    FileUtils.rm_r('test/gs2_42982_results/v') rescue nil
    FileUtils.rm('test/gs2_42982_results/.code_runner_script_defaults.rb') rescue nil
    FileUtils.rm('test/gs2_42982_results/.CODE_RUNNER_TEMP_RUN_LIST_CACHE') rescue nil
    FileUtils.rm('test/ifspppl_results/.code_runner_script_defaults.rb') rescue nil
    FileUtils.rm_r('test/ifspppl_results/v/id_1/') rescue nil
    FileUtils.rm('test/ifspppl/.code_runner_script_defaults.rb') rescue nil
    FileUtils.rm('test/ifspppl/.CODE_RUNNER_TEMP_RUN_LIST_CACHE') rescue nil
    FileUtils.rm('test/gs2_42982/pr08_jet_42982_1d.dat') rescue nil
    FileUtils.rm('test/gs2_42982/pr08_jet_42982_2d.dat') rescue nil
    FileUtils.rm_r('test/ifspppl/v') rescue nil
end


    

#require 'rcov/rcovtask
#Rcov::RcovTask.new do |test|
  ##test.libs << 'test'
  ##test.pattern = 'test/**/test_*.rb'
  ##test.verbose = true
  ##test.rcov_opts << '--exclude "gems/*"'
##end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "trinitycrmod #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
