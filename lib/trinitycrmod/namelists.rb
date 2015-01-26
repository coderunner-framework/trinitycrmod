{:geometry=>
  {:description=>"",
   :should_include=>"true",
   :variables=>
    {:geo_option=>
      {:should_include=>"true",
       :description=>" construct geo profiles from following parameters",
       :help=>" construct geo profiles from following parameters",
       :code_name=>:geo_option,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["default"]},
     :geo_file=>
      {:should_include=>"true",
       :description=>" file with input data",
       :help=>" file with input data",
       :code_name=>:geo_file,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["pr08_jet_42982_2d.dat"]},
     :geo_time=>
      {:should_include=>"true",
       :description=>" target time to sample experimental data (in seconds)",
       :help=>" target time to sample experimental data (in seconds)",
       :code_name=>:geo_time,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[14.0]},
     :rad_out=>
      {:should_include=>"true",
       :description=>" outer radial boundary",
       :help=>" outer radial boundary",
       :code_name=>:rad_out,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.95]},
     :nrad=>
      {:should_include=>"true",
       :description=>" number of radial grid points",
       :help=>" number of radial grid points",
       :code_name=>:nrad,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[9]},
     :bt_in=>
      {:should_include=>"true",
       :description=>
        " if bt_in > 0.0 and overwrite_db_input=T, set bmag = bt_in (B-field strength in Tesla)",
       :help=>
        " if bt_in > 0.0 and overwrite_db_input=T, set bmag = bt_in (B-field strength in Tesla)",
       :code_name=>:bt_in,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :amin_in=>
      {:should_include=>"true",
       :description=>" geometric minor radius at LCFS (in meters)",
       :help=>" geometric minor radius at LCFS (in meters)",
       :code_name=>:amin_in,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :rgeo_in=>
      {:should_include=>"true",
       :description=>" geometric major radius at LCFS (in meters)",
       :help=>" geometric major radius at LCFS (in meters)",
       :code_name=>:rgeo_in,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :q0=>
      {:should_include=>"true",
       :description=>" value of q at core of profile",
       :help=>" value of q at core of profile",
       :code_name=>:q0,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.1]},
     :qa=>
      {:should_include=>"true",
       :description=>" value of q at edge of plasma",
       :help=>" value of q at edge of plasma",
       :code_name=>:qa,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[2.73]},
     :alph_q=>
      {:should_include=>"true",
       :description=>" controls flatness of q profile",
       :help=>" controls flatness of q profile",
       :code_name=>:alph_q,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.6]},
     :sh0=>
      {:should_include=>"true",
       :description=>
        " sh0 > 0.0 makes shat increase sharply from zero near rad=0",
       :help=>" sh0 > 0.0 makes shat increase sharply from zero near rad=0",
       :code_name=>:sh0,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :kap0=>
      {:should_include=>"true",
       :description=>" value of kappa (elongation) at core of plasma",
       :help=>" value of kappa (elongation) at core of plasma",
       :code_name=>:kap0,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.35]},
     :ka=>
      {:should_include=>"true",
       :description=>" value of kappa at edge of plasma (r/a=1)",
       :help=>" value of kappa at edge of plasma (r/a=1)",
       :code_name=>:ka,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.65]},
     :alph_k=>
      {:should_include=>"true",
       :description=>" controls flatness of kappa profile",
       :help=>" controls flatness of kappa profile",
       :code_name=>:alph_k,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.8]},
     :fluxlabel_option=>
      {:should_include=>"true",
       :description=>" sets choice of normalized flux label",
       :help=>" sets choice of normalized flux label",
       :code_name=>:fluxlabel_option,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["default"]},
     :phia_in=>
      {:should_include=>"true",
       :description=>
        " if phia_in > 0.0 and overwrite_db_input=T, set phia = phia_in (phia is sqrt(tor flux) at separatrix)",
       :help=>
        " if phia_in > 0.0 and overwrite_db_input=T, set phia = phia_in (phia is sqrt(tor flux) at separatrix)",
       :code_name=>:phia_in,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :use_external_geo=>
      {:should_include=>"true",
       :description=>
        " true if specifying geometry for flux code externally (e.g. in gs2 input files)",
       :help=>
        " true if specifying geometry for flux code externally (e.g. in gs2 input files)",
       :code_name=>:use_external_geo,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]},
     :write_dbinfo=>
      {:should_include=>"true",
       :description=>
        " set true to write un-interpolated ITER DB info to screen",
       :help=>" set true to write un-interpolated ITER DB info to screen",
       :code_name=>:write_dbinfo,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]},
     :overwrite_db_input=>
      {:should_include=>"true",
       :description=>
        " true if user wants to overwrite 1D variable(s) with input file values",
       :help=>
        " true if user wants to overwrite 1D variable(s) with input file values",
       :code_name=>:overwrite_db_input,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]},
     :evolve_geometry=>
      {:should_include=>"true",
       :description=>
        " if true, recalculate the magnetic equilibrium at each timestep",
       :help=>
        " if true, recalculate the magnetic equilibrium at each timestep",
       :code_name=>:evolve_geometry,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]}}},
 :species=>
  {:description=>"",
   :should_include=>"true",
   :variables=>
    {:species_option=>
      {:should_include=>"true",
       :description=>" construct species profiles from following parameters",
       :help=>" construct species profiles from following parameters",
       :code_name=>:species_option,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["default"]},
     :species_file=>
      {:should_include=>"true",
       :description=>" file with input data",
       :help=>" file with input data",
       :code_name=>:species_file,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["geo_file"]},
     :species_time=>
      {:should_include=>"true",
       :description=>" target time to sample experimental data (in seconds)",
       :help=>" target time to sample experimental data (in seconds)",
       :code_name=>:species_time,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>["geo_time"]},
     :ntspec=>
      {:should_include=>"true",
       :description=>" number of species to evolve (profiles)",
       :help=>" number of species to evolve (profiles)",
       :code_name=>:ntspec,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[2]},
     :qi=>
      {:should_include=>"true",
       :description=>
        " simulated ion species charge (in units of fundamental charge)",
       :help=>" simulated ion species charge (in units of fundamental charge)",
       :code_name=>:qi,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :mi=>
      {:should_include=>"true",
       :description=>" ion mass (in units of proton mass)",
       :help=>" ion mass (in units of proton mass)",
       :code_name=>:mi,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[2.0]},
     :zeff_in=>
      {:should_include=>"true",
       :description=>" effective charge",
       :help=>" effective charge",
       :code_name=>:zeff_in,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :deuterium=>
      {:should_include=>"true",
       :description=>
        " x-label in iter profile database to look for main ion density (\"NMx\")",
       :help=>
        " x-label in iter profile database to look for main ion density (\"NMx\")",
       :code_name=>:deuterium,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[1]},
     :tritium=>
      {:should_include=>"true",
       :description=>
        " x-label in iter profile database to look for secondary ion density (\"NMx\")",
       :help=>
        " x-label in iter profile database to look for secondary ion density (\"NMx\")",
       :code_name=>:tritium,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[2]},
     :impurity=>
      {:should_include=>"true",
       :description=>
        " x-label in iter profile database to look for impurity density (\"NMx\")",
       :help=>
        " x-label in iter profile database to look for impurity density (\"NMx\")",
       :code_name=>:impurity,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[3]},
     :mimp=>
      {:should_include=>"true",
       :description=>" main impurity mass (in units of proton mass)",
       :help=>" main impurity mass (in units of proton mass)",
       :code_name=>:mimp,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[12.0]},
     :zimp=>
      {:should_include=>"true",
       :description=>" main impurity charge number",
       :help=>" main impurity charge number",
       :code_name=>:zimp,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[6.0]}}},
 :time=>
  {:description=>"",
   :should_include=>"true",
   :variables=>
    {:ntstep=>
      {:should_include=>"true",
       :description=>" number of transport time steps",
       :help=>" number of transport time steps",
       :code_name=>:ntstep,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[20]},
     :niter=>
      {:should_include=>"true",
       :description=>" max number of newton iterations per time step",
       :help=>" max number of newton iterations per time step",
       :code_name=>:niter,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[2]},
     :ntdelt=>
      {:should_include=>"true",
       :description=>" initial size of transport time step",
       :help=>" initial size of transport time step",
       :code_name=>:ntdelt,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.01]},
     :ntdelt_max=>
      {:should_include=>"true",
       :description=>" maximum size of transport time step",
       :help=>" maximum size of transport time step",
       :code_name=>:ntdelt_max,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.1]},
     :impfac=>
      {:should_include=>"true",
       :description=>" time centering (1=implicit, 0=explicit)",
       :help=>" time centering (1=implicit, 0=explicit)",
       :code_name=>:impfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :errtol=>
      {:should_include=>"true",
       :description=>
        " maximum allowed relative error upon end of newton iteration",
       :help=>" maximum allowed relative error upon end of newton iteration",
       :code_name=>:errtol,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.2]},
     :errflr=>
      {:should_include=>"true",
       :description=>" relative error below which we stop iterating",
       :help=>" relative error below which we stop iterating",
       :code_name=>:errflr,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.005]},
     :flrfac=>
      {:should_include=>"true",
       :description=>
        " if relative error below errflr/flrfac, decrease ntdelt by factor of 2",
       :help=>
        " if relative error below errflr/flrfac, decrease ntdelt by factor of 2",
       :code_name=>:flrfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[2.0]},
     :nensembles=>
      {:should_include=>"true",
       :description=>
        " # of ensembles to use in ensemble (time) average of fluxes",
       :help=>" # of ensembles to use in ensemble (time) average of fluxes",
       :code_name=>:nensembles,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[1]}}},
 :fluxes=>
  {:description=>"",
   :should_include=>"true",
   :variables=>
    {:flux_option=>
      {:should_include=>"true",
       :description=>" determines flux model (default is gs2)",
       :help=>" determines flux model (default is gs2)",
       :code_name=>:flux_option,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["default"]},
     :flxmult=>
      {:should_include=>"true",
       :description=>" coefficient multiplying fluxes (for testing)",
       :help=>" coefficient multiplying fluxes (for testing)",
       :code_name=>:flxmult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :pflx_min=>
      {:should_include=>"true",
       :description=>" minimum particle flux (for below stability threshold)",
       :help=>" minimum particle flux (for below stability threshold)",
       :code_name=>:pflx_min,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0e-05]},
     :qflx_min=>
      {:should_include=>"true",
       :description=>" minimum heat flux (for below stability threshold)",
       :help=>" minimum heat flux (for below stability threshold)",
       :code_name=>:qflx_min,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0005]},
     :heat_min=>
      {:should_include=>"true",
       :description=>" minimum local heating",
       :help=>" minimum local heating",
       :code_name=>:heat_min,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :lflx_min=>
      {:should_include=>"true",
       :description=>" minimum momentum flux (for below stability threshold)",
       :help=>" minimum momentum flux (for below stability threshold)",
       :code_name=>:lflx_min,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :dfac=>
      {:should_include=>"true",
       :description=>" diffusion coefficient for testing",
       :help=>" diffusion coefficient for testing",
       :code_name=>:dfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.1]},
     :grad_option=>
      {:should_include=>"true",
       :description=>" option determining which equilibrium gradients to vary",
       :help=>" option determining which equilibrium gradients to vary",
       :code_name=>:grad_option,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["default"]},
     :dfprim=>
      {:should_include=>"true",
       :description=>" step size for R/Ln is -R/Ln * dfprim",
       :help=>" step size for R/Ln is -R/Ln * dfprim",
       :code_name=>:dfprim,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.1]},
     :dtprim=>
      {:should_include=>"true",
       :description=>" step size for R/LT is R/LT * dtprim",
       :help=>" step size for R/LT is R/LT * dtprim",
       :code_name=>:dtprim,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.1]},
     :dgexb=>
      {:should_include=>"true",
       :description=>" step size for gexb is gexb * dgexb",
       :help=>" step size for gexb is gexb * dgexb",
       :code_name=>:dgexb,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.2]},
     :fork_flag=>
      {:should_include=>"true",
       :description=>" false for running serially",
       :help=>" false for running serially",
       :code_name=>:fork_flag,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]},
     :check_flux_converge=>
      {:should_include=>"true",
       :description=>" if true, use auto-convergence tests in flux solver",
       :help=>" if true, use auto-convergence tests in flux solver",
       :code_name=>:check_flux_converge,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]},
     :testing=>
      {:should_include=>"true",
       :description=>" if testing, set area, grho = 1",
       :help=>" if testing, set area, grho = 1",
       :code_name=>:testing,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]},
     :dflx_stencil=>
      {:should_include=>"true",
       :description=>" number of fluxes to use for flux derivatives",
       :help=>" number of fluxes to use for flux derivatives",
       :code_name=>:dflx_stencil,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[2, 3]},
     :dprimfac=>
      {:should_include=>"true",
       :description=>
        " if dflx_stencil > 2, multiply dprim values that are negative by this",
       :help=>
        " if dflx_stencil > 2, multiply dprim values that are negative by this",
       :code_name=>:dprimfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :pflx_nfac=>
      {:should_include=>"true",
       :description=>" add to ifs-pppl a particle flux of form pflx_nfac*dens",
       :help=>" add to ifs-pppl a particle flux of form pflx_nfac*dens",
       :code_name=>:pflx_nfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[-0.05]},
     :pflx_rlnfac=>
      {:should_include=>"true",
       :description=>" + pflx_rlnfac*rln",
       :help=>" + pflx_rlnfac*rln",
       :code_name=>:pflx_rlnfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.01]},
     :pflx_rltfac=>
      {:should_include=>"true",
       :description=>" + pflx_rltfac*rlte",
       :help=>" + pflx_rltfac*rlte",
       :code_name=>:pflx_rltfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.01]},
     :vtfac=>
      {:should_include=>"true",
       :description=>
        " v_t=sqrt(vtfac*T/m). should be consistent with definition from flux code",
       :help=>
        " v_t=sqrt(vtfac*T/m). should be consistent with definition from flux code",
       :code_name=>:vtfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[2.0]},
     :ddens=>
      {:should_include=>"true",
       :description=>" step size for density is -density * ddens",
       :help=>" step size for density is -density * ddens",
       :code_name=>:ddens,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.2]},
     :dti=>
      {:should_include=>"true",
       :description=>" step size for Ti is Ti * dti",
       :help=>" step size for Ti is Ti * dti",
       :code_name=>:dti,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.2]},
     :dte=>
      {:should_include=>"true",
       :description=>" step size for Te is Te * dte",
       :help=>" step size for Te is Te * dte",
       :code_name=>:dte,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.2]},
     :dom=>
      {:should_include=>"true",
       :description=>
        " step size for toroidal rotation frequency, omega, is omega * dom",
       :help=>
        " step size for toroidal rotation frequency, omega, is omega * dom",
       :code_name=>:dom,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.2]},
     :nglobalrad=>
      {:should_include=>"true",
       :description=>
        " number of radial points in global gene simulation (1 for local gene)",
       :help=>
        " number of radial points in global gene simulation (1 for local gene)",
       :code_name=>:nglobalrad,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[1]},
     :alph1=>
      {:should_include=>"true",
       :description=>" constant factor multiplying gexb for pb flux option",
       :help=>" constant factor multiplying gexb for pb flux option",
       :code_name=>:alph1,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[13.0]},
     :tp0=>
      {:should_include=>"true",
       :description=>" critical tprim at zero flow shear for pb flux option",
       :help=>" critical tprim at zero flow shear for pb flux option",
       :code_name=>:tp0,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[4.3]},
     :chi0=>
      {:should_include=>"true",
       :description=>
        " constant factor multiplying turbulent chii for pb flux option",
       :help=>" constant factor multiplying turbulent chii for pb flux option",
       :code_name=>:chi0,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[20.0]},
     :prandtl=>
      {:should_include=>"true",
       :description=>" turbulent prandtl number for pb flux option",
       :help=>" turbulent prandtl number for pb flux option",
       :code_name=>:prandtl,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :prandtl_neo=>
      {:should_include=>"true",
       :description=>" neoclassical prandtl number",
       :help=>" neoclassical prandtl number",
       :code_name=>:prandtl_neo,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>["prandtl*0.01"]},
     :evolve_grads_only=>
      {:should_include=>"true",
       :description=>
        " if true, calculate only dependence on grads (not profiles themselves) in jacobian",
       :help=>
        " if true, calculate only dependence on grads (not profiles themselves) in jacobian",
       :code_name=>:evolve_grads_only,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]},
     :subfolders=>
      {:should_include=>"true",
       :description=>" if true, run flux tubes in numbered subfolders",
       :help=>" if true, run flux tubes in numbered subfolders",
       :code_name=>:subfolders,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[".false."]},
     :lgrad_mult=>
      {:should_include=>"true",
       :description=>" Multiply flow gradient by lgrad_mult in ifspppl_fluxes",
       :help=>" Multiply flow gradient by lgrad_mult in ifspppl_fluxes",
       :code_name=>:lgrad_mult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :ncc_calibrate=>
      {:should_include=>"true",
       :description=>
        " Number of flux tubes to use for calibration of reduced model",
       :help=>" Number of flux tubes to use for calibration of reduced model",
       :code_name=>:ncc_calibrate,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[1]},
     :neval_calibrate=>
      {:should_include=>"true",
       :description=>
        " Num. calls to get_fluxes between calibrations (set positive to activate)",
       :help=>
        " Num. calls to get_fluxes between calibrations (set positive to activate)",
       :code_name=>:neval_calibrate,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>[-1]},
     :match_gs2_species=>
      {:should_include=>"true",
       :description=>" If true, try to match gs2 species to ",
       :help=>" If true, try to match gs2 species to ",
       :code_name=>:match_gs2_species,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]},
     :calibrate_abs=>
      {:should_include=>"true",
       :description=>"Enforce positive calibration factor.",
       :help=>"Enforce positive calibration factor.",
       :code_name=>:calibrate_abs,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool}}},
 :init=>
  {:description=>"",
   :should_include=>"true",
   :variables=>
    {:init_option=>
      {:should_include=>"true",
       :description=>" construct initial profiles from following parameters",
       :help=>" construct initial profiles from following parameters",
       :code_name=>:init_option,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["default", "iterdb"]},
     :init_file=>
      {:should_include=>"true",
       :description=>" file with input data",
       :help=>" file with input data",
       :code_name=>:init_file,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["geo_file"]},
     :init_time=>
      {:should_include=>"true",
       :description=>" target time to sample experimental data (in seconds)",
       :help=>" target time to sample experimental data (in seconds)",
       :code_name=>:init_time,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>["geo_time"]},
     :rln=>
      {:should_include=>"true",
       :description=>" initial R/Ln",
       :help=>" initial R/Ln",
       :code_name=>:rln,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0, 1.0]},
     :rlti=>
      {:should_include=>"true",
       :description=>" initial R/LTi",
       :help=>" initial R/LTi",
       :code_name=>:rlti,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[4.0]},
     :rlte=>
      {:should_include=>"true",
       :description=>" initial R/LTe",
       :help=>" initial R/LTe",
       :code_name=>:rlte,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0, 4.0]},
     :nedge=>
      {:should_include=>"true",
       :description=>
        " initial density offset. if positive, override init_option for dens",
       :help=>
        " initial density offset. if positive, override init_option for dens",
       :code_name=>:nedge,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[-1.0]},
     :tiedge=>
      {:should_include=>"true",
       :description=>
        " initial Ti offset. if positive, override init_option for Ti",
       :help=>" initial Ti offset. if positive, override init_option for Ti",
       :code_name=>:tiedge,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[-1.0]},
     :teedge=>
      {:should_include=>"true",
       :description=>
        " initial Te offset. if positive, override init_option for Te",
       :help=>" initial Te offset. if positive, override init_option for Te",
       :code_name=>:teedge,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[-1.0]},
     :densfac=>
      {:should_include=>"true",
       :description=>" factor multiplying ITER DB density",
       :help=>" factor multiplying ITER DB density",
       :code_name=>:densfac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :tifac=>
      {:should_include=>"true",
       :description=>" factor multiplying ITER DB ion temperature",
       :help=>" factor multiplying ITER DB ion temperature",
       :code_name=>:tifac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :tefac=>
      {:should_include=>"true",
       :description=>" factor multiplying ITER DB electron temperature",
       :help=>" factor multiplying ITER DB electron temperature",
       :code_name=>:tefac,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :ledge=>
      {:should_include=>"true",
       :description=>
        " initial L offset. if positive, override init_option for L",
       :help=>" initial L offset. if positive, override init_option for L",
       :code_name=>:ledge,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[-1.0]},
     :rll=>
      {:should_include=>"true",
       :description=>nil,
       :help=>nil,
       :code_name=>:rll,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[]},
     :iternt_file=>
      {:should_include=>"true",
       :description=>
        " file with old profile data for restarts in the middle of a timestep",
       :help=>
        " file with old profile data for restarts in the middle of a timestep",
       :code_name=>:iternt_file,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["restart.iternt"]},
     :iterflx_file=>
      {:should_include=>"true",
       :description=>
        " file with old flx date for restarts in the middle of a timestep",
       :help=>
        " file with old flx date for restarts in the middle of a timestep",
       :code_name=>:iterflx_file,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["restart.iterflx"]},
     :load_balance=>
      {:should_include=>"true",
       :description=>
        " set to true to run with unequal number of procs per flux tube",
       :help=>" set to true to run with unequal number of procs per flux tube",
       :code_name=>:load_balance,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false.", ".true."]},
     :flux_groups=>
      {:should_include=>"true",
       :description=>" The number of processors for each flux calculation",
       :help=>" The number of processors for each flux calculation",
       :code_name=>:flux_groups,
       :must_pass=>
        [{:test=>"kind_of? Integer",
          :explanation=>"This variable must be an integer."}],
       :type=>:Integer,
       :autoscanned_defaults=>["nproc/njobs"]},
     :dyn_load_balance=>
      {:should_include=>"true",
       :description=>
        " set to true to dynamically reallocate processes at runtime",
       :help=>" set to true to dynamically reallocate processes at runtime",
       :code_name=>:dyn_load_balance,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false.", ".true."]},
     :peaking_factor=>
      {:should_include=>"true",
       :description=>
        " If >0 then changes peaking of profiles (1.0 leaves profs unchanged)",
       :help=>
        " If >0 then changes peaking of profiles (1.0 leaves profs unchanged)",
       :code_name=>:peaking_factor,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[-1.0]},
     :itercalib_file=>
      {:should_include=>"true",
       :description=>nil,
       :help=>nil,
       :code_name=>:itercalib_file,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["restart.itercalib"]}}},
 :sources=>
  {:description=>"",
   :should_include=>"true",
   :variables=>
    {:source_option=>
      {:should_include=>"true",
       :description=>" construct source profiles from following parameters",
       :help=>" construct source profiles from following parameters",
       :code_name=>:source_option,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["default"]},
     :source_file=>
      {:should_include=>"true",
       :description=>" file with input data",
       :help=>" file with input data",
       :code_name=>:source_file,
       :must_pass=>
        [{:test=>"kind_of? String",
          :explanation=>"This variable must be a string."}],
       :type=>:String,
       :autoscanned_defaults=>["geo_file"]},
     :source_time=>
      {:should_include=>"true",
       :description=>" target time to sample experimental data (in seconds)",
       :help=>" target time to sample experimental data (in seconds)",
       :code_name=>:source_time,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>["geo_time"]},
     :powerin=>
      {:should_include=>"true",
       :description=>" external power input (in MW)",
       :help=>" external power input (in MW)",
       :code_name=>:powerin,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[50.0]},
     :psig=>
      {:should_include=>"true",
       :description=>
        " width of power input profile (in units of minor radius)",
       :help=>" width of power input profile (in units of minor radius)",
       :code_name=>:psig,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.1]},
     :radin=>
      {:should_include=>"true",
       :description=>" spatial mean of gaussian power deposition profile",
       :help=>" spatial mean of gaussian power deposition profile",
       :code_name=>:radin,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :src_ratio=>
      {:should_include=>"true",
       :description=>" fraction of external power going to ions",
       :help=>" fraction of external power going to ions",
       :code_name=>:src_ratio,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.5]},
     :densin=>
      {:should_include=>"true",
       :description=>" external density input",
       :help=>" external density input",
       :code_name=>:densin,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.0]},
     :nsig=>
      {:should_include=>"true",
       :description=>
        " width of density input profile (in units of minor radius)",
       :help=>" width of density input profile (in units of minor radius)",
       :code_name=>:nsig,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.1]},
     :write_pwr_profs=>
      {:should_include=>"true",
       :description=>" true writes out radial power density profiles",
       :help=>" true writes out radial power density profiles",
       :code_name=>:write_pwr_profs,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]},
     :include_alphas=>
      {:should_include=>"true",
       :description=>" include alpha heating source",
       :help=>" include alpha heating source",
       :code_name=>:include_alphas,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]},
     :include_radiation=>
      {:should_include=>"true",
       :description=>" include bremstrahlung radiation",
       :help=>" include bremstrahlung radiation",
       :code_name=>:include_radiation,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]},
     :pioq=>
      {:should_include=>"true",
       :description=>" ratio of momentum to heat input",
       :help=>" ratio of momentum to heat input",
       :code_name=>:pioq,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[0.1]},
     :write_balance=>
      {:should_include=>"true",
       :description=>
        " true writes out various terms in transport equation each time step",
       :help=>
        " true writes out various terms in transport equation each time step",
       :code_name=>:write_balance,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]},
     :write_smooth=>
      {:should_include=>"true",
       :description=>" true writes out smoothed profiles",
       :help=>" true writes out smoothed profiles",
       :code_name=>:write_smooth,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".false."]},
     :nbi_mult=>
      {:should_include=>"true",
       :description=>
        " multiplies QNBII, QNBIE and SNBIE when using the tokamak profile db, may not be self consistent when using TORQ for torque input (as opposed to pioq)",
       :help=>
        " multiplies QNBII, QNBIE and SNBIE when using the tokamak profile db, may not be self consistent when using TORQ for torque input (as opposed to pioq)",
       :code_name=>:nbi_mult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :icrh_mult=>
      {:should_include=>"true",
       :description=>
        " multiplies QICRHI and QICRHE when using the tokamak profile db",
       :help=>
        " multiplies QICRHI and QICRHE when using the tokamak profile db",
       :code_name=>:icrh_mult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :ech_mult=>
      {:should_include=>"true",
       :description=>
        " multiplies QECHI and QECHE when using the tokamak profile db",
       :help=>" multiplies QECHI and QECHE when using the tokamak profile db",
       :code_name=>:ech_mult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :lh_mult=>
      {:should_include=>"true",
       :description=>
        " multiplies QLHI and QLHE when using the tokamak profile db",
       :help=>" multiplies QLHI and QLHE when using the tokamak profile db",
       :code_name=>:lh_mult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :ibw_mult=>
      {:should_include=>"true",
       :description=>
        " multiplies QIBWI and QIBWE when using the tokamak profile db",
       :help=>" multiplies QIBWI and QIBWE when using the tokamak profile db",
       :code_name=>:ibw_mult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :dwn_mult=>
      {:should_include=>"true",
       :description=>
        " multiplies DWIR, DWER, DNER when using the tokamak profile db",
       :help=>" multiplies DWIR, DWER, DNER when using the tokamak profile db",
       :code_name=>:dwn_mult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :tritium_fraction=>
      {:should_include=>"true",
       :description=>
        " If > 0.0 sets the fraction of tritium in alpha_power, overriding anyother data",
       :help=>
        " If > 0.0 sets the fraction of tritium in alpha_power, overriding anyother data",
       :code_name=>:tritium_fraction,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[-1.0]}}},
 :physics=>
  {:description=>"",
   :should_include=>"true",
   :variables=>
    {:include_neo=>
      {:should_include=>"true",
       :description=>
        " true includes chang-hinton estimate for neoclassical ion heat flux",
       :help=>
        " true includes chang-hinton estimate for neoclassical ion heat flux",
       :code_name=>:include_neo,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]},
     :temp_equil=>
      {:should_include=>"true",
       :description=>" set to false to neglect temperature equilibration",
       :help=>" set to false to neglect temperature equilibration",
       :code_name=>:temp_equil,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]},
     :turb_heat=>
      {:should_include=>"true",
       :description=>" set to false to neglect turbulent heating",
       :help=>" set to false to neglect turbulent heating",
       :code_name=>:turb_heat,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]},
     :numult=>
      {:should_include=>"true",
       :description=>" multiplier of collision frequency for testing",
       :help=>" multiplier of collision frequency for testing",
       :code_name=>:numult,
       :must_pass=>
        [{:test=>"kind_of? Numeric",
          :explanation=>
           "This variable must be a floating point number (an integer is also acceptable: it will be converted into a floating point number)."}],
       :type=>:Float,
       :autoscanned_defaults=>[1.0]},
     :electrostatic=>
      {:should_include=>"true",
       :description=>" if true, set beta to zero (or very small)",
       :help=>" if true, set beta to zero (or very small)",
       :code_name=>:electrostatic,
       :must_pass=>
        [{:test=>"kind_of? String and FORTRAN_BOOLS.include? self",
          :explanation=>
           "This variable must be a fortran boolean. (In Ruby this is represented as a string: e.g. '.true.')"}],
       :type=>:Fortran_Bool,
       :autoscanned_defaults=>[".true."]}}}}
