
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
	end
	include ActualParameterValues
end
