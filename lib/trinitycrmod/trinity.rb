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


    # Setup gs2 in case people are using it
    CodeRunner.setup_run_class('gs2')
    # Setup gryfx in case people are using it
    CodeRunner.setup_run_class('gryfx')
    require 'trinitycrmod/trinity_gs2'

    CodeRunner.setup_run_class('ecom')

    # Where this file is
    @code_module_folder = File.dirname(File.expand_path(__FILE__)) # i.e. the directory this file is in

    # Use the Run::FortranNamelist tools to process the variable database
    setup_namelists(@code_module_folder)
    @variables += [:flux_pars]
    require 'trinitycrmod/output_files'
    require 'trinitycrmod/graphs'
    require 'trinitycrmod/check_parameters'
    require 'trinitycrmod/actual_parameter_values'
    require 'trinitycrmod/chease'
    require 'trinitycrmod/ecom'
    require 'trinitycrmod/calib'
    require 'trinitycrmod/flux_interpolator'
    require 'trinitycrmod/read_netcdf'


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
      :plasma_volume,
      :wth
    ]

    @code_long="Trinity Turbulent Transport Solver"

    @run_info=[:time, :is_a_restart, :restart_id, :restart_run_name, :completed_timesteps, :percent_complete, :no_restart_gs2, :gs_folder]

    @uses_mpi = true

    @modlet_required = false

    @naming_pars = []

    #  Any folders which are a number will contain the results from flux simulations.
    @excluded_sub_folders = (1...1000).to_a.map{|i| "flux_tube_" + i.to_s} + ['chease', 'ecom']

    #  A hook which gets called when printing the standard run information to the screen using the status command.
    def print_out_line
      #p ['id', id, 'ctd', ctd]
      #p rcp.results.zip(rcp.results.map{|r| send(r)})
      name = @run_name
      name += " (res: #@restart_id)" if @restart_id
      name += " real_id: #@real_id" if @real_id
      beginning = sprintf("%2d:%d %-60s %1s:%2.1f(%s) %3s%1s",  @id, @job_no, name, @status.to_s[0,1],  @run_time.to_f / 60.0, @nprocs.to_s, percent_complete, "%")
      if ctd and fusionQ
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


    # Modify new_run so that it becomes a restart of self. Adusts
    # all the parameters of the new run to be equal to the parameters
    # of the run that calls this function, and sets up its run name
    # correctly
    def restart(new_run)
      #new_run = self.dup
      (rcp.variables).each{|v| new_run.set(v, send(v)) if send(v) or new_run.send(v)}
      @naming_pars.delete(:preamble)
      SUBMIT_OPTIONS.each{|v| new_run.set(v, self.send(v)) unless new_run.send(v)}
      #(rcp.results + rcp.gs2_run_info).each{|result| new_run.set(result, nil)}
      new_run.is_a_restart = true
      new_run.restart_id = @id
      new_run.restart_run_name = @run_name
      new_run.init_option = "restart"
      new_run.iternt_file = @run_name + ".iternt"
      new_run.iterflx_file = @run_name + ".iterflx"
      new_run.itercalib_file = @run_name + ".itercalib"
      new_run.restart_file = @run_name + ".out.nc"
      new_run.init_file = @run_name + ".tmp"
      new_run.flux_pars = @flux_pars.absorb(new_run.flux_pars) if @flux_pars and new_run.flux_pars
      new_run.run_name = nil
      new_run.naming_pars = @naming_pars
      new_run.update_submission_parameters(new_run.parameter_hash.inspect, false) if new_run.parameter_hash
      new_run.naming_pars.delete(:restart_id)
      new_run.generate_run_name
      new_run.run_name += '_t'
      if @flux_option == "gs2"
        flux_runs.each_with_index do |run, i|
          CodeRunner::Gs2.rcp.variables.each{|v|
            next if [:ginit_option, :delt_option].include? v and new_run.no_restart_gs2
            new_run.flux_runs[i].set(v, run.send(v)) if run.send(v) or new_run.flux_runs[i].send(v)
          }
        end
      elsif @flux_option == "gryfx"
        flux_runs.each_with_index do |run, i|
          CodeRunner::Gryfx.rcp.variables.each{|v|
            new_run.flux_runs[i].set(v, run.send(v)) if run.send(v) or new_run.flux_runs[i].send(v)
          }
          eputs "parameter_hash_string is " + new_run.flux_runs[i].parameter_hash_string
          eputs "nwrite is ", new_run.flux_runs[i].nwrite, run.nwrite
          new_run.flux_runs[i].update_submission_parameters(new_run.flux_runs[i].parameter_hash_string, false)
          eputs "nwrite 2 is ", new_run.flux_runs[i].nwrite, run.nwrite
        end
      end
      @runner.nprocs = @nprocs if @runner.nprocs == "1" # 1 is the default so this means the user probably didn't specify nprocs
      # This is unnecessary for single restart file.
      warning( "Restart is not on the same number of processors as the previous run: new is #{new_run.nprocs.inspect} and old is #{@nprocs.inspect}... this is only OK if you are using parallel netcdf and single restart files.") if flux_gs2? and not new_run.no_restart_gs2 and (!new_run.nprocs or new_run.nprocs != @nprocs)
      raise "Restart cannot have a different sized jacobian: new is #{new_run.n_flux_tubes_jac} and old is #{n_flux_tubes_jac}" unless new_run.n_flux_tubes_jac == n_flux_tubes_jac
      eputs 'Copying Trinity Restart files', ''
      #system "ls #@directory"
      ['iternt', 'iterflx', 'tmp', 'itercalib', 'out.nc'].each do |ext|
        next if ['itercalib', 'out.nc'].include? ext and not FileTest.exist?("#@directory/#@run_name.#{ext}")
        # Unlike gs2, trinity always uses the current run name to generate the
        # restart files. Thus, the name of the restart files changes with every
        # run.
        FileUtils.cp("#@directory/#@run_name.#{ext}", "#{new_run.directory}/.")
      end
      if (new_run.flux_gs2? and flux_gs2?) and not new_run.no_restart_gs2
        for i in 0...n_flux_tubes
          break if i >= new_run.n_flux_tubes
          folder = flux_folder_name(i)

          new_run.flux_runs[i].directory = new_run.directory + "/#{folder}"
          FileUtils.makedirs(new_run.flux_runs[i].directory)

          flux_runs[i].restart(new_run.flux_runs[i])
          if new_run.neval_calibrate and new_run.neval_calibrate > 0 and 
            new_run.flux_runs[i].nonlinear_mode == "off" 

            new_run.flux_runs[i].ginit_option = "noise"
            new_run.flux_runs[i].delt_option = "default"
            new_run.flux_runs[i].is_a_restart = false
            new_run.flux_runs[i].restart_id = nil
          end
        end
      end
      if (new_run.flux_gryfx? and flux_gryfx?) and not new_run.no_restart_gs2
        for i in 0...n_flux_tubes
          break if i >= new_run.n_flux_tubes
          next if not FileTest.exist? flux_runs[i].directory + '/' + flux_runs[i].run_name + '.restart.cdf'
          eputs " old new nx #{flux_runs[i].nx} #{new_run.flux_runs[i].nx}"
          if not (
            flux_runs[i].nx ==  new_run.flux_runs[i].nx and
            flux_runs[i].ny ==  new_run.flux_runs[i].ny and
            flux_runs[i].ngauss ==  new_run.flux_runs[i].ngauss and
            flux_runs[i].negrid ==  new_run.flux_runs[i].negrid and
            flux_runs[i].ntheta == new_run.flux_runs[i].ntheta
          )
            new_run.flux_runs[i].ginit_option = "noise"
            new_run.flux_runs[i].delt_option = "default"
            new_run.flux_runs[i].is_a_restart = false
            new_run.flux_runs[i].restart_id = nil
            new_run.flux_runs[i].restart = "off"
            next
          end
          folder = flux_folder_name(i)
          new_run.flux_runs[i].directory = new_run.directory + "/#{folder}"
          FileUtils.makedirs(new_run.flux_runs[i].directory)
          #eputs "nwrite 3 is ", new_run.flux_runs[i].nwrite
          flux_runs[i].set_restart(new_run.flux_runs[i])
          #eputs "nwrite 4 is ", new_run.flux_runs[i].nwrite
        end
      end
       #eputs "nwrite 5 is ", new_run.flux_runs[0].nwrite
      new_run
    end
    #  This is a hook which gets called just before submitting a simulation. It sets up the folder and generates any necessary input files.
    def generate_input_file
        @run_name += "_t"
        if @restart_id
          @runner.run_list[@restart_id].restart(self)
        end
        if uses_ecom?
          setup_ecom
        elsif uses_chease?
          setup_chease
        end
        #eputs "nwrite 6 is ", new_run.flux_runs[0].nwrite
        @avail_cpu_time = (@wall_mins-1.0) * 60 if @wall_mins
        if flux_gs2? or flux_gryfx?
          @avail_cpu_time = (@wall_mins-6.0) * 60 if @wall_mins
        end
        check_parameters
        write_input_file
        #eputs "nwrite 7 is ", new_run.flux_runs[0].nwrite
        generate_flux_input_files if flux_gs2? or flux_gryfx?
        #eputs "nwrite 8 is ", new_run.flux_runs[0].nwrite
    end


    # Update submission parameters in the normal way then deal with parameters
    # for the flux code. Each flux code will behave differently.
    #
    # * Gs2
    #   flux_pars: {nx: 43, delt: {1=> 0.01, 2=>0.05}}
    #  will set nx for all runs to be 43, and delt for run 1 to 0.01, delt
    #  for run 2 to be 0.05
    def update_submission_parameters(parameters, start_from_defaults=true)
      @set_flux_defaults_procs ||= []
      super(parameters, start_from_defaults)
      if flux_gs2? or flux_gryfx?
        raise "No set_flux_defaults_procs defined" unless @set_flux_defaults_procs.size > 0
        @set_flux_defaults_procs.each{|prc| prc.call}
        flux_parameter_hashes = {}
        if @flux_pars
          @flux_pars.each do |par, val|
            if val.kind_of? Hash
              #val.each{|n,v| gs2_runs[n].set(par, v)}
              val.each do |n,v|
                if n == :jac
                  range =  0...n_flux_tubes_jac
                elsif n == :calib
                  range =  n_flux_tubes_jac...n_flux_tubes
                else
                  range = n..n
                end
                for i in range
                  flux_parameter_hashes[i] ||= {}
                  flux_parameter_hashes[i][par] = v
                end
                #gs2_parameter_hashes[n] ||= {}
                #gs2_parameter_hashes[n][par] = v
              end
            else
              for i in 0...n_flux_tubes
                #gs2_runs.each{|r| r.set(par, val)}
                flux_parameter_hashes[i] ||= {}
                flux_parameter_hashes[i][par] = val
              end
            end
          end
        end
        for i in 0...n_flux_tubes
          flux_runs[i].parameter_hash = (flux_parameter_hashes[i] || {}).inspect
          flux_runs[i].update_submission_parameters(flux_runs[i].parameter_hash, false)
        end
      end
      self
    end


    def confinement_time
      area = new_netcdf_file.var('area_grid').get('start' => [0,0], 'end'=> [-1,0])[true,0].to_a.to_gslv
      grho = new_netcdf_file.var('grho_grid').get('start' => [0,0], 'end'=> [-1,0])[true,0].to_a.to_gslv
      pressure = new_netcdf_file.var('pres_grid').get('start' => [0,0,0,-1], 'end' => [-1,-1,0,-1])[true,true,0,0].to_a
      #pressure = pressure.map{|arr| arr.to_gslv}.sum
      rad_in = @rad_out/(2.0*@nrad.to_f-1) 
      drad = (@rad_out - rad_in) / (@nrad.to_f - 1)
      if @evolve_temperature.fortran_true? 
        if @te_equal_ti.fortran_true?
          if @equal_ion_temps.fortran_true?
            stored_energy = area.subvector(@nrad-1)*pressure[1].to_gslv.subvector(@nrad-1)*grho.subvector(@nrad-1)*drad
            stored_energy = stored_energy.sum*1e3*1.6e-19*1e20
            power = @i_powerin_1*1e6
            return stored_energy/power
          end
        end
      end
    end
    # Override CodeRunner::Run method to deal with flux_pars properly
    # when generating run_name
    def generate_run_name
      return super if CodeRunner::GLOBAL_OPTIONS[:short_run_name]
      @run_name = %[v#@version] + @naming_pars.inject("") do |str, par|
        case par
        when :flux_pars
          str+="_flx_#{send(par).map{|k,v| "#{k}_#{v.to_s[0..8]}"}.join("_")}}"
        else
          str+="_#{par}_#{send(par).to_s[0...8]}"
        end
      end
      @run_name = @run_name.gsub(/\s+/, "_").gsub(/[\/{}"><:=]/, '') + "_id_#@id"
    end

    # The number of separate flux tube results needed for the jacobian
    def n_flux_tubes_jac
      d1 = dflx_stencil_actual - 1
      ngrads = d1 * case @grad_option
      when nil
        n = 0
        n = n + @n_ion_spec if (evolve_density_actual.fortran_true?) 
        if (evolve_temperature_actual.fortran_true?) 
          if (equal_ion_temps_actual.fortran_true?) then
            n = n + 1
          else
            n = n + n_ion_spec
          end 
          n=n+1 if (te_equal_ti_actual.fortran_false? and te_fixed_actual.fortran_false?)
          n = n + 1 if (evolve_flow_actual.fortran_true?)
        end
        n
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
    def n_flux_tubes
      if @neval_calibrate and @neval_calibrate > 0
        raise "neval_calibrate set but ncc_calibrate not set" unless @ncc_calibrate
        n_flux_tubes_jac + @ncc_calibrate
      else
        n_flux_tubes_jac
      end
    end

    # Writes the gs2 input files, creating separate subfolders
    # for them if @subfolders is .true.
    def generate_flux_input_files
      # At the moment we must use subfolders
      for i in 0...n_flux_tubes
        #gs2run = gs2_run(:base).dup
        #gs2_run(i).instance_variables.each do |var|
          #gs2run.instance_variable_set(var, gs2_run(i).instance_variable_get(var))
        #end
        fluxrun = flux_runs[i]
        #ep ['gs2_runs[i] in generate', gs2_runs[i].nwrite]
        #p ['i',i]
        #if i >= n_flux_tubes_jac
          #jn = i - n_flux_tubes_jac + 1
          #run_name = "calibrate_" + @run_name + (jn).to_s
          #folder = "calibrate_#{jn}"
        #else
          #jn = i + 1
          #run_name = @run_name + (jn).to_s
          #folder = "flux_tube_#{jn}"
        #end

        folder = flux_folder_name(i)
        run_name = flux_run_name(i)

        if @subfolders and @subfolders.fortran_true?
          fluxrun.directory = @directory + "/" + folder
          FileUtils.makedirs(fluxrun.directory)
          fluxrun.relative_directory = @relative_directory + "/" + folder
          fluxrun.restart_dir = fluxrun.directory + "/nc"
        else
          fluxrun.directory = @directory
          fluxrun.relative_directory = @relative_directory
        end
        fluxrun.run_name = run_name
        fluxrun.nprocs = @nprocs
        if i==0
          block = Proc.new{check_parameters}
        else
          block = Proc.new{}
        end
        #if @restart_id
          #gs2run.restart_id =
        Dir.chdir(fluxrun.directory) do
          fluxrun.generate_input_file(&block)
          fluxrun.write_info
        end

        ### Hack the input file so that gs2 gets the location of
        # the restart dir correctly within trinity
        if @subfolders and @subfolders.fortran_true? 
          infile = fluxrun.directory + "/" + fluxrun.run_name + ".in"
          text = File.read(infile)
          File.open(infile, 'w'){|f| f.puts text.sub(/restart_dir\s*=\s*"nc"/, "restart_dir = \"#{folder}/nc\"")}
        end
      end
    end

    def watch_calibration_status
      if @flux_option == "gs2"
        command = gs2_runs.map{|r| 
          FileTest.exist?(fn="#{r.directory}/#{r.run_name}.out.nc") ?
          "ncdump #{fn} | grep UNLIM" : nil
        }.compact
        command = "watch '#{command.join(' && ')}'"
        puts command
        system command
      else
        raise "watch_calibration_status only implemented for gs2"
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
#<<<<<<< HEAD
      @component_runs ||= []
      if @running
        if (existing = @runner.component_run_list.values.find_all{|r| r.real_id==@id}).size > 0
          @component_runs = existing.sort_by{|r| -r.id}
#=======
      #if (existing = @runner.component_run_list.values.find_all{|r| r.real_id==@id}).size > 0
        #@component_runs = existing.sort_by{|r| -r.id}
        #if @running
#>>>>>>> 90ef5ae701681b63da68f6eb1bd1ec1169873f8b
          return
        end
      end
      @component_runs ||= []
      if flux_gryfx? or flux_gs2?
        fclass = flux_class

        eprint '...getting Trinity components..'
        for i in 0...n_flux_tubes
          component = @component_runs[i]
            #p [i, '9,', component, '4', !@component_runs[i]]; STDIN.gets
          if not component
            #p "HEELO"
            #p [i, '3,', component, '4', @component_runs.size]
            component = @component_runs[i] =  fclass.new(@runner, self, i).create_component
            #component.instance_variable_set(:@output_file, output_file)
            #p [i, '3,', component, '4', @component_runs.size]
            if false
              if i > 0 and @component_runs[i-1]
                component.rcp.variables.each do |var|
                  val = @component_runs[i-1].send(var)
                  component.set(var, val) if val
                end
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
            compdir = flux_folder_name(i) #  "flux_tube_#{i+1}"
            # Stop it actually checking the flux codes every time.
            component.instance_variable_set(:@status, :Complete)
            Dir.chdir(compdir){
              eprint '.'
              component.process_directory
            } if FileTest.exist? compdir
          #}
          component.component_runs = []
          component.trinity_run = self
          #@component_runs.push component
          component.real_id = @id
          #@gs2_run_list[i] = component
          #pp component; STDIN.gets
          #component.runner = nil
          #puts Marshal.dump(component); STDIN.gets
          #pp component; STDIN.gets
          #component.component_runs = []
        end
        eputs 'done'

      end
    end

    def is_converged?
      Dir.chdir(@directory) do
        if FileTest.exist?(new_netcdf_filename) and 
          @convergetol and 
          new_netcdf_file.var('convergeval') and 
          new_netcdf_file.dim('t').length > 2 and
          new_netcdf_file.var('convergeval').get[0,-1] < @convergetol
          return true
        else
          return false
        end
      end
    end


    @source_code_subfolders = []

    # This method, as its name suggests, is called whenever CodeRunner is asked to analyse a run directory. This happens if the run status is not :Complete, or if the user has specified recalc_all(-A on the command line) or reprocess_all (-a on the command line).
    #
    def process_directory_code_specific
      get_status
      #p ['id is', id, 'ctd is ', ctd]
      if ctd
        get_global_results rescue nil
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
        if @completed_timesteps == @ntstep
          @status = :Complete
        else
          if FileTest.exist?(output_file) and File.read(output_file) =~/trinity\s+finished/i
            @status = :Complete
          else
            @status = :Failed
          end
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
      if FileTest.exist? new_netcdf_filename
        @plasma_volume = new_netcdf_file.var('plasma_volume').get[-1]
        @pfus = new_netcdf_file.var('fusion_power').get[-1]
        @fusionQ = new_netcdf_file.var('fusion_gain').get[-1]
        @pnet = new_netcdf_file.var('net_power').get[-1]
        @alpha_power = new_netcdf_file.var('alpha_power_total').get[-1]
        @aux_power = new_netcdf_file.var('aux_power_total').get[-1]
        @rad_power = new_netcdf_file.var('radiate_power_total').get[-1]
        @ne0 = new_netcdf_file.var('ne_core').get[-1]
        @te0 = new_netcdf_file.var('te_core').get[-1]
        @ti0 = new_netcdf_file.var('ti_core').get[-1]
        @omega0 = new_netcdf_file.var('omega_core').get[-1]
      else
        # If the netcdf file is missing try the info file
        @fusionQ = info_outfile.get_variable_value('Q').to_f
        @pfus = info_outfile.get_variable_value(/fusion\s+power/i).to_f
        @pnet = info_outfile.get_variable_value(/net\s+power/i).to_f
        @aux_power = info_outfile.get_variable_value(/aux.*\s+power/i).to_f
        @alpha_power = info_outfile.get_variable_value(/alpha\s+power/i).to_f
        @rad_power = info_outfile.get_variable_value(/radiated\s+power/i).to_f
        @ne0 = info_outfile.get_variable_value(/core\s+density|Core\s+electron\s+density/i).to_f
        @ti0 = info_outfile.get_variable_value(/[Cc]ore\s+T_i/i).to_f
        @te0 = info_outfile.get_variable_value(/[Cc]ore\s+T_e/i).to_f
        @omega0 = info_outfile.get_variable_value(/[Cc]ore\s+omega/i).to_f rescue 0.0 # Old info files don't have omega
      end 
    end

    def self.get_input_help_from_source_code(source_folder)
      source = get_aggregated_source_code_text(source_folder)
      rcp.namelists.each do |nmlst, hash|
        hash[:variables].each do |var, var_hash|

    #       next unless var == :w_antenna
          var = var_hash[:code_name] || var
          values_text = source.scan(Regexp.new("\\W#{var}\\s*=\\s*.+")).join("\n")
          ep values_text
          values = scan_text_for_variables(values_text).map{|(_v,val)| val}
          values.uniq!
    #       ep values if var == :nbeta
          values.delete_if{|val| val.kind_of? String} if values.find{|val| val.kind_of? Numeric}
          values.delete_if{|val| val.kind_of? String and not String::FORTRAN_BOOLS.include? val} if values.find{|val| val.kind_of? String and String::FORTRAN_BOOLS.include? val}
    #       values.sort!
    #       ep var
    #       ep values
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
!     Trinity INPUT FILE automatically generated by CodeRunner
!==============================================================================
!
!  Trinity is a multiscale turbulent transport code for fusion plasmas.
!
!   See http://gyrokinetics.sourceforge.net
!
!  CodeRunner is a framework for the automated running and analysis
!  of large simulations.
!
!   See http://coderunner.sourceforge.net
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

    def run_heuristic_analysis
      ep 'run_heuristic_analysis', Dir.pwd
      infiles = Dir.entries.grep(/^[^\.].*\.trin$/)
      ep infiles
      raise CRMild.new('No input file') unless infiles[0]
      raise CRError.new("More than one input file in this directory: \n\t#{infiles}") if infiles.size > 1
      input_file = infiles[0]
      #ep 'asdf'
      @nprocs ||= "1"
      @executable ||= "/dev/null"
      make_info_file(input_file, false)
    end

    def input_file_extension
      '.trin'
    end

  end
end

