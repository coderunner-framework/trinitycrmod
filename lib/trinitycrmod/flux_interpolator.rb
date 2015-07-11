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
    p 'radius_uniq', radius_uniq
    ncc = radius_uniq.size
    np = radius_data.size/ncc
    p 'np is ', np, 'ncc is', ncc
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
      rescue=>err
        p ccfile.get_1d_array(v)
        puts "Error reading: #{k}, #{v}"
        raise err
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
    when 'ntgrads'
      jacobian_vecs = [:ion_tprim, :eln_tprim, :fprim]
      jacobian_vecs = [:ion_tprim, :fprim]
      interp_vecs = [:ion_hflux, :eln_hflux, :pflux]
      njac = 4
    else 
      raise "Unknown grad_option: #{grad_option}"
    end
    GraphKit.quick_create([perturb_data[:ion_tprim][0].to_gslv, fluxes_data[:ion_hflux][0].to_gslv])#.gnuplot
    #p perturb_data[:ion_tprim][0]
    interp = fluxes_data.inject({}) do |h, (k,v)|
        h[k] = radius_uniq.size.times.map do |i| 
          if interp_vecs.include?(k)
            #puts 'i is', i
            GSL::ScatterInterp.alloc(
              :linear, 
              jacobian_vecs.map{|name| 
                arr = perturb_data[name]
                arr[i].to_gslv + 
                GSL::Vector.linspace(0,1e-9,arr[i].size)
              } + [v[i].to_gslv], 
              false,
             1.0
            ) 
          else
            ZeroEval.new
          end
        end
      h
    end
    if false and run_name != 'dummy'
      arr = []
      File.read(run_name + '.flux_inputs').scanf("%e"){|m| p m; arr+= m}
      # each of these quantities is a flat array with 
      # radial index varying fastest, then jacobian index
      # then species index where appropriate
      i = 0
      #p arr
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

      #p 'inputs', inputs.values.map{|v| v.size}, inputs[:eln_tprim]

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
      vec2 = GSL::Vector.linspace(perturb_data[:fprim][0].min, perturb_data[:fprim][0].max,20)
      mat = GSL::Matrix.alloc(20,20)
      for i in 0...20
        for j in 0...20
          mat[i,j] = interp[:ion_hflux][0].eval(vec[i], vec2[j])
        end
      end
      vec3 = GSL::Vector.linspace(perturb_data[:ion_tprim][1].min, perturb_data[:ion_tprim][1].max,20)
      vec4 = GSL::Vector.linspace(perturb_data[:fprim][1].min, perturb_data[:fprim][1].max,20)
      mat2 = GSL::Matrix.alloc(20,20)
      for i in 0...20
        for j in 0...20
          mat2[i,j] = interp[:ion_hflux][1].eval(vec3[i], vec4[j])
        end
      end
      #vec.collect{|x| vec2.collect{|y| mat(interp[:ion_hflux][0].eval(x)}
      #GraphKit.quick_create([vec, vec2, mat], [perturb_data[:ion_tprim][0].to_gslv, perturb_data[:fprim][0], fluxes_data[:ion_hflux][0].to_gslv], [vec3, vec4, mat2], [perturb_data[:ion_tprim][1].to_gslv, perturb_data[:fprim][1], fluxes_data[:ion_hflux][1].to_gslv]).gnuplot live: true
      vec5 = GSL::Vector.linspace(perturb_data[:ion_tprim][2].min, perturb_data[:ion_tprim][2].max,20)
      vec6 = GSL::Vector.linspace(perturb_data[:fprim][2].min, perturb_data[:fprim][2].max,20)
      mat3 = GSL::Matrix.alloc(20,20)
      for i in 0...20
        for j in 0...20
          mat3[i,j] = interp[:ion_hflux][2].eval(vec5[i], vec6[j])
        end
      end
      #vec.collect{|x| vec2.collect{|y| mat(interp[:ion_hflux][0].eval(x)}
      #GraphKit.quick_create([vec, vec2, mat], [perturb_data[:ion_tprim][0].to_gslv, perturb_data[:fprim][0], fluxes_data[:ion_hflux][0].to_gslv], [vec3, vec4, mat2], [perturb_data[:ion_tprim][1].to_gslv, perturb_data[:fprim][1], fluxes_data[:ion_hflux][1].to_gslv],[vec5, vec6, mat3], [perturb_data[:ion_tprim][2].to_gslv, perturb_data[:fprim][2], fluxes_data[:ion_hflux][2].to_gslv]).gnuplot live: true
      vec7 = GSL::Vector.linspace(perturb_data[:ion_tprim][3].min, perturb_data[:ion_tprim][3].max,20)
      vec8 = GSL::Vector.linspace(perturb_data[:fprim][3].min, perturb_data[:fprim][3].max,20)
      mat4 = GSL::Matrix.alloc(20,20)
      for i in 0...20
        for j in 0...20
          mat4[i,j] = interp[:ion_hflux][3].eval(vec7[i], vec8[j])
        end
      end
      #vec.collect{|x| vec2.collect{|y| mat(interp[:ion_hflux][0].eval(x)}
      GraphKit.quick_create([vec, vec2, mat], [perturb_data[:ion_tprim][0].to_gslv, perturb_data[:fprim][0], fluxes_data[:ion_hflux][0].to_gslv], [vec3, vec4, mat2], [perturb_data[:ion_tprim][1].to_gslv, perturb_data[:fprim][1], fluxes_data[:ion_hflux][1].to_gslv],[vec5, vec6, mat3], [perturb_data[:ion_tprim][2].to_gslv, perturb_data[:fprim][2], fluxes_data[:ion_hflux][2].to_gslv],[vec7, vec8, mat4], [perturb_data[:ion_tprim][3].to_gslv, perturb_data[:fprim][3], fluxes_data[:ion_hflux][3].to_gslv]).gnuplot live: true
    end
      #vec = GSL::Vector.linspace(perturb_data[:ion_tprim][0].min, perturb_data[:ion_tprim][0].max,20)
      #GraphKit.quick_create([vec, vec.collect{|x| interp[:ion_hflux][0].eval(x)}], [perturb_data[:ion_tprim][0].to_gslv, fluxes_data[:ion_hflux][0].to_gslv]).gnuplot

      #vec = GSL::Vector.linspace(perturb_data[:ion_tprim][1].min, perturb_data[:ion_tprim][1].max,20)
      #GraphKit.quick_create([vec, vec.collect{|x| interp[:ion_hflux][1].eval(x)}], [perturb_data[:ion_tprim][1].to_gslv, fluxes_data[:ion_hflux][1].to_gslv]).gnuplot
      #vec = GSL::Vector.linspace(perturb_data[:ion_tprim][2].min, perturb_data[:ion_tprim][2].max,80)
      #GraphKit.quick_create([vec, vec.collect{|x| interp[:ion_hflux][2].eval(x)}], [perturb_data[:ion_tprim][2].to_gslv, fluxes_data[:ion_hflux][2].to_gslv]).gnuplot
      #STDIN.gets
    #GraphKit.quick_create([vec, vec.collect{|x| interp[:ion_hflux][0].eval(perturb_data[:ion_tprim][0].to_gslv.min, x)}]).gnuplot

    #p [tprim_perturb_data, fprim_perturb_data]
  end
end
end
end
