class CodeRunner::Trinity
	def uses_chease?
		@geo_option == "chease" or @init_option == "chease" or @species_option == "chease"
	end
  def chease_run
    CodeRunner.setup_run_class('chease')
    chrun = CodeRunner::Chease.new(@runner)
    raise 'No chease input file' unless FileTest.exist?(chfile=@directory + '/chease/chease_namelist')
    chrun.instance_eval(CodeRunner::Chease.defaults_file_text_from_input_file(chfile))
    #puts ['chrun1', chrun.nsurf, self.class.defaults_file_text_from_input_file(chfile), chfile]
    return chrun
  end
	def setup_chease
		ep "Setting up chease files..."
    if evolve_geometry.fortran_true?
      FileUtils.cp_r(@gs_folder, 'chease')
      chrun = chease_run
      chrun.neqdsk = 0 # Use EXPEQ
      chrun.nsurf = 6 # Outer surface from EXPEQ
      puts ['chrun2', chrun.nsurf]
      chrun.nppfun = 4 # Pres profile from EXPEQ
      chrun.nfunc = 4 # Current func
      chrun.nopt = -1 # Use prev soln for initial 
      chrun.nblopt = 0 # Don't modify the pressure profile 
      Dir.chdir(@directory + '/chease/'){
        chrun.write_input_file
        FileUtils.cp('NOUT', 'NIN')
      }
    elsif @gs_folder
      FileUtils.cp_r(@gs_folder, 'chease')
    else
      FileUtils.mkdir('chease') unless FileTest.exist? 'chease'
      origfile = @runner.root_folder + '/ogyropsi.dat'
      FileUtils.cp(origfile, 'chease/ogyropsi.dat') if FileTest.exist? origfile
    end
	end

end
