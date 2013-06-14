require 'coderunner'

class CodeRunner
	#  This is a customised subclass of the CodeRunner::Run  class which allows CodeRunner to run and analyse the multiscale gyrokinetic  turbulent transport solver Trinity.
	#
	#  It  generates the Trinity input file, and both analyses the results and allows easy plotting of them. It also interfaces with the GS2 CodeRunner  module to allow analysis of the individual GS2 results if GS2 is being used as the flux code.
	class Trinity < Run::FortranNamelist
		#include CodeRunner::SYSTEM_MODULE



		# Where this file is
		@code_module_folder = folder = File.dirname(File.expand_path(__FILE__)) # i.e. the directory this file is in

		# Use the Run::FortranNamelist tools to process the variable database
		setup_namelists(@code_module_folder)

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
		@excluded_sub_folders = (1...1000).to_a.map{|i| i.to_s}

		#  A hook which gets called when printing the standard run information to the screen using the status command.
		def print_out_line
			name = @run_name
			name += " (res: #@restart_id)" if @restart_id
			name += " real_id: #@real_id" if @real_id
			beginning = sprintf("%2d:%d %-60s %1s:%2.1f(%s) %3s%1s",  @id, @job_no, name, @status.to_s[0,1],  @run_time.to_f / 60.0, @nprocs.to_s, percent_complete, "%")
			if ctd
				beginning += sprintf("Q:%f MW, Pfusion:%f MW, Ti0:%f keV, Te0:%f keV, n0:%f x10^20", fusion1, pfus, ti0, te0, ne0)
			end
			beginning += "  ---#{@comment}" if @comment
			beginning
		end


		#  This is a hook which gets called just before submitting a simulation. It sets up the folder and generates any necessary input files.
		def generate_input_file
				write_input_file
		end

		#  This command uses the infrastructure provided by Run::FortranNamelist, provided by CodeRunner itself.
		def write_input_file
			File.open(@run_name + ".trin", 'w'){|file| file.puts input_file_text}
		end

		def parameter_string
			@run_name + ".trin"
		end

		def parameter_transition
		end


		@source_code_subfolders = []

		# This method, as its name suggests, is called whenever CodeRunner is asked to analyse a run directory. This happens if the run status is not :Complete, or if the user has specified recalc_all(-A on the command line) or reprocess_all (-a on the command line).
		#
		def process_directory_code_specific
			get_status
			@percent_complete = nil
		end

		def get_status
			if @running
				get_completed_timesteps
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
				completed_timesteps = time_file.get_1d_array_integer(/itstep/).max
			end
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


	end
end

