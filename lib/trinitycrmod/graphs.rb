class CodeRunner::Trinity
	module TrinityGraphKits
		# Graphs plotting quantities from the '.nt' file vs rho for a given t_index
		def nt_prof_graphkit(options)
			prof_graphkit(options.dup.absorb({outfile: :nt}))
		end
		# Graphs plotting quantities from the '.fluxes' file vs rho for a given t_index
		def fluxes_prof_graphkit(options)
			prof_graphkit(options.dup.absorb({outfile: :fluxes, exclude_perturbed_fluxes: true}))
		end
		def prof_graphkit(options)
			raise "Please specify t_index" unless options[:t_index]
			it = options[:t_index] - 1
			array = get_2d_array_float(options[:outfile], options[:header], /1.*time/)[it]
			rho_array = get_2d_array_float(options[:outfile], /2.*radius/, /1.*time/)[it]
			if options[:exclude_perturbed_fluxes]
				s = array.size
				array = array.slice(0...nrad-1)
				rho_array = rho_array.slice(0...nrad-1)
			end
			#p rho_array, array
			GraphKit.autocreate(x: {data: rho_array.to_gslv, title: 'rho', units: ''},
													y: {data: array.to_gslv, title: options[:title]||"", units: options[:units]||""}
												 )
		end
		# Graph of Qi in gyroBohm units against rho for a given t_index
		def ion_hflux_gb_prof_graphkit(options)
			fluxes_prof_graphkit(options.dup.absorb({header: /Qi.*\(GB/, title: 'Ion Heat Flux', units: 'Q_gB'}))
		end
		# Graph of toroidal angular momentum flux in gyroBohm units against rho for a given t_index
		def lflux_gb_prof_graphkit(options)
			fluxes_prof_graphkit(options.dup.absorb({header: /Pi.*\(GB/, title: 'Toroidal Angular Momentum Flux', units: 'Pi_gB'}))
		end
		# Graph of toroidal angular momentum against rho for a given t_index
		def ang_mom_prof_graphkit(options)
			return nt_prof_graphkit(options.dup.absorb({header: /ang\s+mom/, title: 'Angular Momentum', units: ''}))
		end
		# Graph of Ti against rho for a given t_index
		def ion_temp_prof_graphkit(options)
			return nt_prof_graphkit(options.dup.absorb({header: /i\+ temp/, title: 'Ti', units: 'keV'}))
		end
	end

	include TrinityGraphKits

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
		if meth = TrinityGraphKits.instance_methods.find{|m| m.to_s == name + '_graphkit'}
			return send(meth, options)
		else
			raise	"GraphKit not found: #{name}"
		end	
	end
end
