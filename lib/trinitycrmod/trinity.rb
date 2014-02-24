require 'coderunner'
require 'text-data-tools'

class CodeRunner
	#  This is a customised subclass of the CodeRunner::Run  class which allows CodeRunner to run and analyse the multiscale gyrokinetic  turbulent transport solver Trinity.
	#
	#  It  generates the Trinity input file, and both analyses the results and allows easy plotting of them. It also interfaces with the GS2 CodeRunner  module to allow analysis of the individual GS2 results if GS2 is being used as the flux code.
	class Trinity < Run::FortranNamelist
		#include CodeRunner::SYSTEM_MODULE
		#

		class FluxOptionError < StandardError; end



		# Where this file is
		@code_module_folder = folder = File.dirname(File.expand_path(__FILE__)) # i.e. the directory this file is in

		# Use the Run::FortranNamelist tools to process the variable database
		setup_namelists(@code_module_folder)
		require 'trinitycrmod/output_files'
		require 'trinitycrmod/graphs'
		require 'trinitycrmod/trinity_gs2'
		require 'trinitycrmod/check_parameters'
		require 'trinitycrmod/actual_parameter_values'
			
		# Setup gs2 in case people are using it
		CodeRunner.setup_run_class('gs2')

		################################################
		# Quantities that are read or determined by CodeRunner
		# after the simulation has ended
		###################################################

		@results = [
			:pfus,
			:fusionQ,
			:pnet,
			:alpha_power,
			:aux_power,
			:rad_power,
			:ne0,
			:ne95,
			:ti0,
			:ti95,
			:te0,
			:te95,
			:omega0,
			:omega95,
			:wth
		]

		@code_long="Trinity Turbulent Transport Solver"

		@run_info=[:time, :is_a_restart, :restart_id, :restart_run_name, :completed_timesteps, :percent_complete]

		@uses_mpi = true

		@modlet_required = false
		
		@naming_pars = []

		#  Any folders which are a number will contain the results from flux simulations.
		@excluded_sub_folders = (1...1000).to_a.map{|i| "flux_tube_" + i.to_s}

		#  A hook which gets called when printing the standard run information to the screen using the status command.
		def print_out_line
			#p ['id', id, 'ctd', ctd]
			#p rcp.results.zip(rcp.results.map{|r| send(r)})
			name = @run_name
			name += " (res: #@restart_id)" if @restart_id
			name += " real_id: #@real_id" if @real_id
			beginning = sprintf("%2d:%d %-60s %1s:%2.1f(%s) %3s%1s",  @id, @job_no, name, @status.to_s[0,1],  @run_time.to_f / 60.0, @nprocs.to_s, percent_complete, "%")
			if ctd
				beginning += sprintf("Q:%f, Pfusion:%f MW, Ti0:%f keV, Te0:%f keV, n0:%f x10^20", fusionQ, pfus, ti0, te0, ne0)
			end
			beginning += "  ---#{@comment}" if @comment
			beginning
		end

		#def self.load(dir, runner)
			#run = super(dir, runner)
			#grun_list = run.instance_variable_get(:@gs2_run_list)
			#grun_list.values.each{|r| r.runner=runner} if grun_list.kind_of? Hash
			#run
		#end


		#  This is a hook which gets called just before submitting a simulation. It sets up the folder and generates any necessary input files.
		def generate_input_file
			  @run_name += "_t"
				check_parameters
				write_input_file
				generate_gs2_input_files if @flux_option == "gs2"
		end


		# The number of separate flux tube results needed for the jacobian
		def n_flux_tubes
			d1 = dflx_stencil_actual - 1
			ngrads =d1 * case @grad_option
										when "tigrad", "ngrad", "lgrad"
											1
										when "tgrads"
											2
										when "ltgrads", "ntgrads"
											3
										when "all"
											4
										else
											raise "unknown grad_option: #@grad_option"
										end
			if evolve_grads_only_actual.fortran_true?
				njac = ngrads + 1
			else
				njac = 2*ngrads+1
			end
			#p 'nraaad', @nrad
			(@nrad-1) * njac
		end
		# Writes the gs2 input files, creating separate subfolders 
		# for them if @subfolders is .true.
		def generate_gs2_input_files
			# At the moment we must use subfolders
			for i in 0...n_flux_tubes
				#gs2run = gs2_run(:base).dup
				#gs2_run(i).instance_variables.each do |var|
					#gs2run.instance_variable_set(var, gs2_run(i).instance_variable_get(var))
				#end
				gs2run = gs2_runs[i]
				#p ['i',i]
				if @subfolders and @subfolders.fortran_true?
					gs2run.directory = @directory + "/flux_tube_#{i+1}"
					FileUtils.makedirs(gs2run.directory)
					gs2run.relative_directory = @relative_directory + "/flux_tube_#{i+1}"
					gs2run.restart_dir = gs2run.directory + "/nc"
				else
					gs2run.directory = @directory
					gs2run.relative_directory = @relative_directory
				end
				gs2run.run_name = @run_name + (i+1).to_s
				gs2run.nprocs = @nprocs
				if i==0
					block = Proc.new{ingen}
				else
					block = Proc.new{}
				end
				Dir.chdir(gs2run.directory){gs2run.generate_input_file(&block); gs2run.write_info}

				### Hack the input file so that gs2 gets the location of 
				# the restart dir correctly within trinity
				if @subfolders and @subfolders.fortran_true?
					infile = gs2run.directory + "/" + gs2run.run_name + ".in"
					text = File.read(infile)
					File.open(infile, 'w'){|f| f.puts text.sub(/restart_dir\s*=\s*"nc"/, "restart_dir = \"flux_tube_#{i+1}/nc\"")}
				end
			end
		end

  def vim_output
		system "vim -Ro #{output_file} #{error_file} #@directory/#@run_name.error #@directory/#@run_name.out "
	end
	alias :vo :vim_output

		#  This command uses the infrastructure provided by Run::FortranNamelist, provided by CodeRunner itself.
		def write_input_file
			File.open(@run_name + ".trin", 'w'){|file| file.puts input_file_text}
		end

		# Parameters which follow the Trinity executable, in this case just the input file.
		def parameter_string
			@run_name + ".trin"
		end

		def parameter_transition
		end

		def generate_component_runs
			#puts "HERE"
			@component_runs ||= []
			if @flux_option == "gs2"
			#puts "HERE"
		  
				for i in 0...n_flux_tubes
					component = @component_runs[i] 
					  #p [i, '9,', component, '4', !@component_runs[i]]; STDIN.gets
					if not component
						#p "HEELO"
					  #p [i, '3,', component, '4', @component_runs.size]
						component = @component_runs[i] =  Gs2.new(@runner).create_component
					  #p [i, '3,', component, '4', @component_runs.size]
						if i > 0 and @component_runs[i-1]
							component.rcp.variables.each do |var|
								val = @component_runs[i-1].send(var)
								component.set(var, val) if val
							end 
						end
					end 
					#p [i,'1', component, '2', @component_runs.size]; STDIN.gets
					component = @component_runs[i] 
					#p [i,'1', component, '2']; STDIN.gets


					component.component_runs = []
					#component.runner = nil
					#pp component; STDIN.gets
					#component.instance_variables.each{|var| puts var; pp var;  puts Marshal.dump(component.instance_variable_get(var)); STDIN.gets}
					#puts Marshal.dump(component); STDIN.gets
					#pp component; STDIN.gets
					#p component.class
					component.job_no = @job_no 
					#component.status = @status
			#p ["HERE2", @component_runs.size, @component_runs[i]]
					#Dir.chdir(@directory) {
						compdir = "flux_tube_#{i+1}"
						Dir.chdir(compdir){component.process_directory} if FileTest.exist? compdir
					#}
					component.component_runs = []
					#@component_runs.push component
					component.real_id = @id
					#@gs2_run_list[i] = component
					#pp component; STDIN.gets
					#component.runner = nil
					#puts Marshal.dump(component); STDIN.gets
					#pp component; STDIN.gets
					#component.component_runs = []
				end
			end
		end

		
		def save
			#@gs2_run_list.values.each{|r| r.runner = nil; r.component_runs = []} if @gs2_run_list.kind_of? Hash
			super
			#@gs2_run_list.values.each{|r| r.runner = @runner} if @gs2_run_list.kind_of? Hash
  
			#logf(:save)
			#raise CRFatal.new("Something has gone horribly wrong: runner.class is #{@runner.class} instead of CodeRunner") unless @runner.class.to_s == "CodeRunner"
			#runner, @runner = @runner, nil
			#@system_triers, old_triers = nil, @system_triers
			#@component_runs.each{|run| run.runner = nil; run.component_runs = []} if @component_runs
			##@component_runs.each{|run| run.runner = nil} if @component_runs
		##   logi(self)
			##pp self
		  ##@component_runs.each{|ph| ph.instance_variables.each{|var| puts var; pp ph.instance_variable_get(var); STDIN.gets;  puts ph.Marshal.dump(instance_variable_get(var))}} if @component_runs
		  ##instance_variables.each{|var| puts var;  instance_variable_get(var);  puts Marshal.dump(instance_variable_get(var)); STDIN.gets}
			#Dir.chdir(@directory){File.open(".code_runner_run_data", 'w'){|file| file.puts Marshal.dump(self)}}
			#@runner = runner
			#@component_runs.each{|run| run.runner = runner} if @component_runs
			#@system_triers = old_triers
		end

		@source_code_subfolders = []

		# This method, as its name suggests, is called whenever CodeRunner is asked to analyse a run directory. This happens if the run status is not :Complete, or if the user has specified recalc_all(-A on the command line) or reprocess_all (-a on the command line).
		#
		def process_directory_code_specific
			get_status
			#p ['id is', id, 'ctd is ', ctd]
			if ctd
				get_global_results 
			end
			#p ['fusionQ is ', fusionQ]
			@percent_complete = completed_timesteps.to_f / ntstep.to_f * 100.0
		end

		def get_status
			if @running
				get_completed_timesteps
				if completed_timesteps == 0
					@status = :NotStarted
				else
					@status = :Incomplete
				end
			else
				get_completed_timesteps
				if File.read(output_file) =~/trinity\s+finished/i
					@status = :Complete
				else
					@status = :Failed
				end
			end
		end

		def get_completed_timesteps
			Dir.chdir(@directory) do
				@completed_timesteps = time_outfile.exists? ? 
					time_outfile.get_1d_array_integer(/itstep/).max :
					0
			end
		end
	

		def get_global_results
			@fusionQ = info_outfile.get_variable_value('Q').to_f
			@pfus = info_outfile.get_variable_value(/fusion\s+power/i).to_f
			@pnet = info_outfile.get_variable_value(/net\s+power/i).to_f
			@aux_power = info_outfile.get_variable_value(/aux.*\s+power/i).to_f
			@alpha_power = info_outfile.get_variable_value(/alpha\s+power/i).to_f
			@rad_power = info_outfile.get_variable_value(/radiated\s+power/i).to_f
			@ne0 = info_outfile.get_variable_value(/core\s+density/i).to_f
			@ti0 = info_outfile.get_variable_value(/core\s+T_i/i).to_f
			@te0 = info_outfile.get_variable_value(/core\s+T_e/i).to_f
			@omega0 = info_outfile.get_variable_value(/core\s+omega/i).to_f
			#p 'send(fusionQ)', send(:fusionQ)
		end

		def self.get_input_help_from_source_code(source_folder)
			source = get_aggregated_source_code_text(source_folder)
			rcp.namelists.each do |nmlst, hash|
				hash[:variables].each do |var, var_hash|

		# 			next unless var == :w_antenna
					var = var_hash[:code_name] || var
					values_text = source.scan(Regexp.new("\\W#{var}\\s*=\\s*.+")).join("\n") 
					ep values_text
					values = scan_text_for_variables(values_text).map{|(v,val)| val} 
					values.uniq!
		# 			ep values if var == :nbeta
					values.delete_if{|val| val.kind_of? String} if values.find{|val| val.kind_of? Numeric}
					values.delete_if{|val| val.kind_of? String and not String::FORTRAN_BOOLS.include? val} if values.find{|val| val.kind_of? String and String::FORTRAN_BOOLS.include? val}
		# 			values.sort!
		# 			ep var
		# 			ep values
					sample_val = values[0]
					p sample_val
					help = values_text.scan(/ !(.*)/).flatten[0]
					p help
					#gets
					var_hash[:help] = help
					var_hash[:description] = help
					save_namelists

				end
			end
		end

		def input_file_header
			<<EOF
!==============================================================================
!  		Trinity INPUT FILE automatically generated by CodeRunner 
!==============================================================================
!
!  Trinity is a multiscale turbulent transport code for fusion plasmas.
!  
!  	See http://gyrokinetics.sourceforge.net
!
!  CodeRunner is a framework for the automated running and analysis 
!  of large simulations. 
!
!  	See http://coderunner.sourceforge.net
!  
!  Created #{Time.now.to_s}
!      by CodeRunner version #{CodeRunner::CODE_RUNNER_VERSION.to_s}
!
!==============================================================================

EOF
		end
		def self.defaults_file_header
			<<EOF1
############################################################################
#                                                                          #
# Automatically generated defaults file for the Trinity CodeRunner module  #
#                                                                          #
# This defaults file specifies a set of defaults for Trinity which are     #
# used by CodeRunner to set up and run Trinity simulations.                #
#                                                                          #
############################################################################

# Created: #{Time.now.to_s}   

@defaults_file_description = ""
EOF1
		end

	end
end

