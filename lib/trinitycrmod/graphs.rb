class CodeRunner::Trinity
	module TrinityGraphKits
		def nt_prof_graphkit(options)
			raise "Please specify t_index" unless options[:t_index]
			it = options[:t_index] - 1
			array = nt_outfile.get_2d_array_float(options[:header], /1.*time/)
			rho_array = nt_outfile.get_2d_array_float(/2.*radius/, /1.*time/)
			#p rho_array, array
			GraphKit.autocreate(x: {data: rho_array[it].to_gslv, title: 'rho', units: ''},
													y: {data: array[it].to_gslv, title: options[:title]||"", units: options[:units]||""}
												 )
		end
		def ang_mom_prof_graphkit(options)
			return nt_prof_graphkit(options.dup.absorb({header: /ang\s+mom/, title: 'Angular Momentum', units: ''}))
		end
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
