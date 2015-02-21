class CodeRunner::Trinity
	module TrinityGraphKits
		# Graphs plotting quantities from the '.nt' file vs rho for a given t_index
		def nt_prof_graphkit(options)
			prof_graphkit(options.dup.absorb({outfile: :nt}))
		end
		# Graphs plotting quantities from the '.nt' file vs rho for a given t_index
		def pwr_prof_graphkit(options)
			prof_graphkit(options.dup.absorb({outfile: :pwr, radius_match: /2.*rad/}))
		end
		# Graphs plotting quantities from the '.fluxes' file vs rho for a given t_index
		def fluxes_prof_graphkit(options)
			prof_graphkit(options.absorb({outfile: :fluxes, exclude_perturbed_fluxes: true}))
		end
		# Graphs plotting quantities from the '.pbalance' file vs rho for a given t_index
		def pbalance_prof_graphkit(options)
			prof_graphkit(options.absorb({outfile: :pbalance}))
		end
		def prof_graphkit(options)
			raise "Please specify t_index" unless options[:t_index]
			it = options[:t_index] - 1
			if ta  = options[:time_average]
				if ta < 0
					t_indices = (it+ta..it).to_a
				else
					t_indices = (it..it+ta).to_a
				end
			else
				t_indices = [it]
			end
			array = t_indices.map{|i| get_2d_array_float(options[:outfile], options[:header], /1.*time/)[i].to_gslv}.mean.to_a
			rho_array = t_indices.map{|i| get_2d_array_float(options[:outfile], options[:radius_match]||/2.*radius/, /1.*time/)[i].to_gslv}.mean.to_a
			if options[:exclude_perturbed_fluxes]
				#s = array.size
				array = array.slice(0...nrad-1)
				rho_array = rho_array.slice(0...nrad-1)
			end
			#p rho_array, array
			kit = GraphKit.autocreate(x: {data: rho_array.to_gslv, title: 'rho', units: ''},
													y: {data: array.to_gslv, title: options[:title]||"", units: options[:units]||""}
												 )
			kit.data[0].title += " at time = #{list(:t)[it+1]} s for id #{id}"
			kit.data[0].gp.with = 'lp'
			kit
		end
		# Graph of Qi in gyroBohm units against rho for a given t_index
		def ion_hflux_gb_prof_graphkit(options)
			fluxes_prof_graphkit(options.absorb({header: /Qi.*\(GB/, title: 'Ion Heat Flux', units: 'Q_gB'}))
		end
		# Graph of Qi in MW against rho for a given t_index
		def ion_hflux_prof_graphkit(options)
			fluxes_prof_graphkit(options.absorb({header: /Qi.*\(MW/, title: 'Ion Heat Flux', units: 'MW'}))
		end
		# Graph of Qe in gyroBohm units against rho for a given t_index
		def eln_hflux_gb_prof_graphkit(options)
			fluxes_prof_graphkit(options.absorb({header: /Qe.*\(GB/, title: 'Electron Heat Flux', units: 'Q_gB'}))
		end
		# Graph of Qe in MW against rho for a given t_index
		def eln_hflux_prof_graphkit(options)
			fluxes_prof_graphkit(options.absorb({header: /Qe.*\(MW/, title: 'Electron Heat Flux', units: 'MW'}))
		end
		# Graph of toroidal angular momentum flux in gyroBohm units against rho for a given t_index
		def lflux_gb_prof_graphkit(options)
			fluxes_prof_graphkit(options.absorb({header: /Pi.*\(GB/, title: 'Toroidal Angular Momentum Flux', units: 'Pi_gB'}))
		end
		# Graph of toroidal angular momentum against rho for a given t_index
		def ang_mom_prof_graphkit(options)
			return nt_prof_graphkit(options.absorb({header: /ang\s+mom/, title: 'Angular Momentum', units: ''}))
		end
		# Graph of Ti against rho for a given t_index
		def ion_temp_prof_graphkit(options)
			return nt_prof_graphkit(options.absorb({header: /i\+ temp/, title: 'Ti', units: 'keV'}))
		end
		# Graph of Te against rho for a given t_index
		def eln_temp_prof_graphkit(options)
			return nt_prof_graphkit(options.absorb({header: /e\- temp/, title: 'Te', units: 'keV'}))
		end
		# Graph of n against rho for a given t_index
		def dens_prof_graphkit(options)
			return nt_prof_graphkit(options.absorb({header: /dens/, title: 'n', units: '10^20 m^-3'}))
		end

		# Graph of ion power integrated from the magnetic axis to rho vs rho
		def ion_pwr_prof_graphkit(options)
			return pbalance_prof_graphkit(options.absorb({header: /i\+ pwr/, title: 'Integrated ion power', units: 'MW'}))
		end
		# Graph of electron power integrated from the magnetic axis to rho vs rho
		def eln_pwr_prof_graphkit(options)
			return pbalance_prof_graphkit(options.absorb({header: /e\- pwr/, title: 'Integrated electron power', units: 'MW'}))
		end
		# Graph of ion power integrated from the magnetic axis to rho vs rho
		def torque_prof_graphkit(options)
			return pbalance_prof_graphkit(options.absorb({header: /torque/, title: 'Integrated torque', units: 'Nm'}))
		end

    def integrate_profkit(kit, area_vectors, t_indices)
      datavecs = kit.data.map{|d| d.y.data}
      #p 'datavecs.size', datavecs.size
      rhovec = kit.data[0].x.data
      rhoarea_vectors = get_1d_array_float('geo', /1:\s*rho/)
      int = GSL::ScatterInterp.alloc(:linear,  [rhoarea_vectors.to_gslv, area_vectors.to_gslv], false )

      area2 = rhovec.map{|rh| int.eval(rh)}
      integrated_values = datavecs.map{|dat| (dat.to_gslv*area2.to_gslv).sum}
      k2 = GraphKit.quick_create([list(:t).values, integrated_values])
      k2.title = kit.title
      k2.ylabel = kit.ylabel
      return k2
    end
    private :integrate_profkit

    # Graph of integrated profiles vs time
    def integrated_profiles_graphkit(options)
      t_indices = list(:t).keys
      kit = t_indices.map{|it| profiles_graphkit(options.absorb({t_index: it}))}.inject{|o,n| o.merge(n)}
      #kit.gnuplot
      #area_vectors = t_indices.map{|i| get_2d_array_float('geo', /13:\s*area/, /1.*time/)[i].to_gslv}
      #system "less #@directory/#@run_name.geo"
      area_vectors = get_1d_array_float('geo', /13:\s*area/)
      kit.each_with_index do |k,ik|
        kit[ik] = integrate_profkit(k, area_vectors, t_indices)
      end

    end
	end

	include TrinityGraphKits

  module TrinityMultiKits
    def profiles_graphkit(options)
      kit = GraphKit::MultiKit.new(
        [
          ion_temp_prof_graphkit(options),
          eln_temp_prof_graphkit(options),
          dens_prof_graphkit(options),
          ang_mom_prof_graphkit(options)
      ]
      )
      kit.each{|k| k.title = nil}
      if options[:horizontal]
        kit.slice(0..2).each{|k| k.xlabel = nil; k.gp.xtics = "format ''"}
        kit[3].gp.xtics = 'format "%2.1f"'
      else
        kit.values_at(0,2).each{|k| k.xlabel = nil; k.gp.xtics = "format ''"}
        kit.gp.multiplot = "layout 2,2"
        kit.gp.key = "tmargin"
      end
      kit

    end
  end

  include TrinityMultiKits

	# This is the hook that is called by CodeRunner, providing the
	# graphkit with the given name and functions to the CodeRunner framework 
	def graphkit(name, options)
		[:t].each do |var|
			#ep 'index', var
			if options[var].class == Symbol and options[var] == :all
				options[var] = list(var).values
			elsif options[var+:_index].class == Symbol and options[var+:_index] == :all
				#ep 'Symbol'
				options[var+:_index] = list(var).keys
			end
			if options[var].class == Array
				return options[var].map{|value| graphkit(name, options.dup.absorb({var =>  value}))}.sum
			elsif options[var+:_index].class == Array
				#ep 'Array'
				return options[var+:_index].map{|value| graphkit(name, options.dup.absorb({var+:_index =>  value}))}.sum
			end
			if options[var].class == Symbol and options[var] == :max
				options[var] = list(var).values.max
			elsif options[var+:_index].class == Symbol and options[var+:_index] == :max
				ep 'Symbol'
				options[var+:_index] = list(var).keys.max
			end
		end
		if (meth = TrinityGraphKits.instance_methods.find{|m| m.to_s == name + '_graphkit'} or 
        meth = TrinityMultiKits.instance_methods.find{|m| m.to_s == name + '_graphkit'})
			return send(meth, options)
		else
			raise	"GraphKit not found: #{name}"
		end	
	end
end
