class CodeRunner
class ZeroEval
  def eval(*args)
    0.0
  end
end
class Trinity
class << self
  # To be used in conjunction with the shell script
  # option in Trinity. Read the output of old_run_name
  # (which may be a commma-separated list of multiple runs)
  # and read the contents of <run_name>_flux_inputs.dat and use them
  # to interpolate esitmates of the fluxes
  def interpolate_fluxes(old_run_name, run_name, grad_option, ntspec)
    ccfile = TextDataTools::Column::DataFile.new(old_run_name + '.cc', true, /\S+/, /(?:\#\s+)?\d+:.*?(?=\d+:|\Z)/)
    geofile = TextDataTools::Column::DataFile.new(old_run_name + '.geo', true, /\S+/, /(?:\#\s+)?\d+:\D*?(?=\d:|\d\d:|\Z)/)
    radius_data = ccfile.get_1d_array_float(/radius/)
    radius_uniq = radius_data.uniq
    ncc = radius_uniq.size
    np = radius_data.size/ncc
    #p 'np', np
    #p 'ion_tprim_perturb_data',ion_tprim_perturb_data = ccfile.get_1d_array_float(/11:/).pieces(np)
    perturb = {
      fprim: /10:/,
      ion_tprim: /11:/,
      eln_tprim: /12:/,
      dens: /18:/,
      ion_temp: /19:/,
      eln_temp: /20:/
    }
    perturb_data = perturb.inject({}) do |h,(k,v)| 
      h[k] = ccfile.get_1d_array_float(v).pieces(np).transpose
      h
    end
    fluxes = {
      ion_hflux: /5: i/,
      eln_hflux: /6: e/,
      pflux: /3: i/,
      lflux: /9: v/,
      ion_heat: /7: i/,
      eln_heat: /8: e/
    }
    fluxes_data = fluxes.inject({}) do |h,(k,v)| 
      h[k] = ccfile.get_1d_array_float(v).pieces(np).transpose
      h
    end
    dvdrho = geofile.get_1d_array_float(/area/)
    grho = geofile.get_1d_array_float(/grho/)
    case grad_option
    when 'tigrads'
      jacobian_vecs = [:ion_temp,:ion_tprim]
      jacobian_vecs = [:ion_tprim]
      interp_vecs = [:ion_hflux]
      njac = 2
    end
    GraphKit.quick_create([perturb_data[:ion_tprim][0].to_gslv, fluxes_data[:ion_hflux][0].to_gslv])#.gnuplot
    p perturb_data[:ion_tprim][0]
    interp = fluxes_data.inject({}) do |h, (k,v)|
        h[k] = radius_uniq.size.times.map do |i| 
          if interp_vecs.include?(k)
            puts 'i is', i
            GSL::ScatterInterp.alloc(
              :linear, 
              jacobian_vecs.map{|name| 
                arr = perturb_data[name]
                arr[i].to_gslv + 
                GSL::Vector.linspace(0,1e-9,arr[i].size)
              } + [v[i].to_gslv], 
              false
            ) 
          else
            ZeroEval.new
          end
        end
      h
    end
    if run_name != 'dummy'
      arr = File.read(run_name + '_flux_inputs.dat').scanf("%e")
      # each of these quantities is a flat array with 
      # radial index varying fastest, then jacobian index
      # then species index where appropriate
      i = 0
      dens = arr[i...(i+=ncc*njac)]
      temp = arr[i...(i+=ncc*njac*(ntspec+1))].pieces(2) # This is hardwired to 2
      fprim = arr[i...(i+=ncc*njac)]
      tprim = arr[i...(i+=ncc*njac*(ntspec+1))].pieces(2) # This is hardwired to 2

      File.open(run_name + '_flux_results.dat') do |file|
      end
    else
      vec = GSL::Vector.linspace(perturb_data[:ion_tprim][0].min, perturb_data[:ion_tprim][0].max,20)
      #GraphKit.quick_create([vec, vec.collect{|x| interp[:ion_hflux][0].eval(x)}]).gnuplot
    end

    #GraphKit.quick_create([vec, vec.collect{|x| interp[:ion_hflux][0].eval(perturb_data[:ion_tprim][0].to_gslv.min, x)}]).gnuplot

    #p [tprim_perturb_data, fprim_perturb_data]
  end
end
end
end
