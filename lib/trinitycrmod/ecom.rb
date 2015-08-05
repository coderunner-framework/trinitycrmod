class CodeRunner::Trinity
	def uses_ecom?
		@geo_option == "ecom" 
	end
  def ecom_run
    CodeRunner.setup_run_class('ecom')
    ecrun = CodeRunner::Ecom.new(@runner)
    raise 'No ecom input file' unless FileTest.exist?(chfile=@directory + '/chease/ecom.in')
    ecrun.instance_eval(CodeRunner::Ecom.defaults_file_text_from_input_file(chfile))
    #puts ['ecrun1', ecrun.nsurf, self.class.defaults_file_text_from_input_file(chfile), chfile]
    return ecrun
  end
	def setup_ecom
		ep "Setting up ecom files..."
    if evolve_geometry.fortran_true?
      FileUtils.cp_r(@gs_folder, 'chease')
      ecrun = ecom_run
      ecrun.iptype = 2 # Use numerical pressure
      ecrun.iptable = 2 # File contains rho_tor and pressure
      ecrun.file_prof = 'Profile.dat' # Trinity always expects the file to be called this
      #ecrun.neqdsk = 0 # Use EXPEQ
      #ecrun.nsurf = 6
      #puts ['ecrun2', ecrun.nsurf]
      #ecrun.nppfun = 4 # Pres profile from EXPEQ
      #ecrun.nfunc = 4 # Current func
      #ecrun.nopt = -1 # Use prev soln for initial 
      Dir.chdir(@directory + '/chease/'){ecrun.write_input_file}
    else
      FileUtils.mkdir('chease') unless FileTest.exist? 'chease'
      origfile = @runner.root_folder + '/ogyropsi.dat'
      FileUtils.cp(origfile, 'chease/ogyropsi.dat') if FileTest.exist? origfile
    end
	end

end
