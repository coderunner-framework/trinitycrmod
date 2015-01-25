
class CodeRunner::Trinity
	def check_parameters

		check_geometery
		check_parallelisation
		check_flux_option

	end

	def check_geometery
		error( "Can't find geo_file #@geo_file (the path of geo file should be either absolute or set relative to the run folder #@directory). If you are not using a geometry file for this run please unset the parameter geo_file.") if @geo_file and not FileTest.exist? @geo_file
	end

	def check_parallelisation
		error("nrad must be explicitly specified") unless @nrad
		error("Number of jobs: #{n_flux_tubes_jac} must evenly divide the number of processors: #{actual_number_of_processors} when fork_flag is .true.") if fork_flag_actual.fortran_true? and not actual_number_of_processors%n_flux_tubes_jac == 0

	end

	def check_flux_option
		if @flux_option == "gs2"
		 error("subfolders must be .true. ") unless @subfolders and @subfolders.fortran_true?
		end
	end
end

