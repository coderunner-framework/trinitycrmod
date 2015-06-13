require 'scanf'
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
  def interpolate_fluxes(old_run_folder, run_folder, grad_option, ntspec)
    old_run_name = nil
    Dir.chdir(old_run_folder) do
      old_cc = Dir.entries(Dir.pwd).find{|f| f =~ /\.cc$/}
      raise "Can't find cc file in #{old_run_folder}" unless old_cc
      old_run_name = File.expand_path(old_cc).sub(/.cc$/,'')
    end

    run_name = nil
    Dir.chdir(run_folder) do
      new_inp = Dir.entries(Dir.pwd).find{|f| f =~ /.flux_inputs$/}
      raise "Can't find flux_inputs in #{run_folder}" unless new_inp
      run_name = File.expand_path(new_inp).sub(/.flux_inputs$/,'')
    end
    

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
      begin
        h[k] = ccfile.get_1d_array_float(v).pieces(np).transpose
      rescue
        p ccfile.get_1d_array(v)
        exit
      end
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
    area = geofile.get_1d_array_float(/area/)
    grho = geofile.get_1d_array_float(/grho/)
    case grad_option
    when 'tigrad'
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
      arr = []
      File.read(run_name + '.flux_inputs').scanf("%e"){|m| p m; arr+= m}
      # each of these quantities is a flat array with 
      # radial index varying fastest, then jacobian index
      # then species index where appropriate
      i = 0
      p arr
      dens = arr[i...(i+=ncc*njac)]
      temp = arr[i...(i+=ncc*njac*2)].pieces(2) # This is hardwired to 2
      fprim = arr[i...(i+=ncc*njac)]
      tprim = arr[i...(i+=ncc*njac*2)].pieces(2) # This is hardwired to 2
      inputs = {}
      inputs[:dens] = dens
      inputs[:ion_temp] = temp[0]
      inputs[:eln_temp] = temp[1]
      inputs[:fprim] = fprim
      inputs[:ion_tprim] = tprim[0]
      inputs[:eln_tprim] = tprim[1]

      p 'inputs', inputs.values.map{|v| v.size}, inputs[:eln_tprim]

      File.open(run_name + '.flux_results', 'w') do |file|
        njac.times{|ij| (ntspec+1).times{ ncc.times{|ic| file.printf("%e ",interp[:pflux][ic].eval(*jacobian_vecs.map{|v| inputs[v][ic + ij*ncc]}))}}}
        file.printf("\n")
        njac.times{|ij| 
          ncc.times{|ic| file.printf("%e ",interp[:ion_hflux][ic].eval(*jacobian_vecs.map{|v| inputs[v][ic + ij*ncc]}))}
          ntspec.times{
            ncc.times{|ic| file.printf("%e ",interp[:eln_hflux][ic].eval(*jacobian_vecs.map{|v| inputs[v][ic + ij*ncc]}))}
          }
        }
        file.printf("\n")
        njac.times{|ij| 
          ncc.times{|ic| file.printf("%e ",interp[:ion_heat][ic].eval(*jacobian_vecs.map{|v| inputs[v][ic + ij*ncc]}))}
          ntspec.times{
            ncc.times{|ic| file.printf("%e ",interp[:eln_heat][ic].eval(*jacobian_vecs.map{|v| inputs[v][ic + ij*ncc]}))}
          }
        }
        file.printf("\n")
        njac.times{|ij| ncc.times{|ic| file.printf("%e ",interp[:lflux][ic].eval(*jacobian_vecs.map{|v| inputs[v][ic + ij*ncc]}))}}
        file.printf("\n")
        area.each{|v| file.printf("%e ", v)}
        file.printf("\n")
        grho.each{|v| file.printf("%e ", v)}
        file.printf("\n")
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
