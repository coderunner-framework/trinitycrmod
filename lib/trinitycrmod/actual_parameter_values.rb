
class CodeRunner::Trinity
	# Functions to return the values of parameters if they are not set in CodeRunner.
	# These must be manually kept in sync with Trinity... let's keep their number down
	# to a minimum
	module ActualParameterValues
		def dflx_stencil_actual
			@dflx_stencil or 2
		end
		def evolve_grads_only_actual
			@evolve_grads_only or ".true."
		end
		def fork_flag_actual
			@fork_flag or ".true."
		end
    def evolve_temperature_actual
      @evolve_temperature or ".true."
    end
    def evolve_density_actual
      @evolve_density or ".true."
    end
    def evolve_flow_actual
      @evolve_flow or ".false."
    end
    def equal_ion_temps_actual
      @equal_ion_temps or ".true."
    end
    def te_fixed_actual
      @te_fixed or ".false."
    end
    def te_equal_ti_actual
      @te_equal_ti or ".false."
    end
	end
	include ActualParameterValues
end
