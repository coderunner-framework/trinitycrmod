# This file contains methods which allow Trinity to use GS2 as 
# the flux solver

#class NumRu::NetCDF
	#def _dump_data
		#Marshal.dump(nil)
	#end
#end
class CodeRunner
	class Gs2
		class TrinityComponent < Gs2
			attr_accessor :trinity_run
			def initialize(runner, trinity_run)
				super(runner)
				@trinity_run = trinity_run
				self
			end
			def output_file
				#@output_file ||= '../' +  self.class.to_s
				'../' + @trinity_run.output_file
				#'aa'
			end
			def error_file
				'../' + @trinity_run.error_file
				#'aa'
			end
			def dup
				return self.class.new(@runner, @trinity_run).learn_from(self)
			end
			def save
				#p ['output_file', output_file]
				#p ['ancestors', self.class.ancestors]
				trinrun, @trinity_run = @trinity_run, nil
				component_runs.each{|cr| cr.trinity_run = nil}
				#@trinity_run = nil
				#@output_file = nil
				#GC.start
				#p self.instance_variables.find_all{|v| instance_variable_get(v).class.to_s =~  /NumRu::NetCDF/}
				super
				@trinity_run = trinrun
			end
		end
	end
	class Trinity

		# This function creates a new Trinity defaults file, with Trinity parameters taken from 
		# trinity_input_file, and GS2 parameters taken from gs2_input_file. The file is then moved
		# to the CodeRunner central defaults location, the current folder is configured to use 
		# the defaults file.
		def self.use_new_defaults_file_with_gs2(name = ARGV[-3], trinity_input_file = ARGV[-2], gs2_input_file = ARGV[-1])
	    raise "Please specify a name, a trinity input file and a gs2 input file" if name == "use_new_gs2_defaults_file"
	    defaults_filename = "#{name}_defaults.rb"
			tmp_filename = "#{name}_gs2tmp_defaults.rb"
			central_defaults_filename = rcp.user_defaults_location + "/" + defaults_filename
			FileUtils.rm(name + '_defaults.rb') if FileTest.exist?(name + '_defaults.rb')
			FileUtils.rm(central_defaults_filename) if FileTest.exist?(central_defaults_filename)
			FileUtils.rm(tmp_filename) if FileTest.exist?(tmp_filename)
			raise "Defaults file: #{central_defaults_filename} already exists" if FileTest.exist? central_defaults_filename


			make_new_defaults_file(name, trinity_input_file)
			CodeRunner::Gs2.make_new_defaults_file(name + '_gs2tmp', gs2_input_file)

			File.open(defaults_filename, 'a'){|file| file.puts <<EOF2
@set_flux_defaults_proc = Proc.new do
gs2_runs.each do |run|
run.instance_eval do
#{File.read(tmp_filename).gsub(/\A|\n/, "\n  ")}
end
end
end


EOF2
    
      }
			FileUtils.mv(defaults_filename, central_defaults_filename)
			FileUtils.rm(tmp_filename)
			CodeRunner.fetch_runner(C: rcp.code, m: (rcp.modlet? ? rcp.modlet : nil), D: name)

		end

		# Generates the component runs for GS2 and returns the hash
		# Raises an error if flux_option != "gs2"
		def gs2_runs
			raise FluxOptionError.new("gs2_runs called and flux_option != gs2") if not flux_gs2?

			#puts "2@COMMMMMMMMMMMMMPOOOOOOOOOOOOOONNNETN", @component_runs
			generate_component_runs if not (@component_runs and @component_runs.size == n_flux_tubes)
			#p ["@COMMMMMMMMMMMMMPOOOOOOOOOOOOOONNNETN", @component_runs]
			@component_runs
			#@gs2_run_list ||= {}
			#raise TypeError.new("@runner is nil") if @runner.nil?
			#@gs2_run_list[key] ||= Gs2.new(@runner)
			##if key != :base
				##raise "key in gs2_run must be either :base or an integer" unless key.kind_of? Integer
				##@gs2_run_list[key] ||= @gs2_run_list[:base].dup
			##end
			#@gs2_run_list[key]
		end

    # Override standard CodeRunner method to allow for Gs2 variables
		def evaluate_defaults_file(filename)
			text = File.read(filename)
			instance_eval(text)
			text.scan(/^\s*@(\w+)/) do
				var_name = $~[1].to_sym
				next if var_name == :defaults_file_description
				unless rcp.variables.include? var_name or (flux_gs2? and Gs2.rcp.variables.include? var_name)
					warning("---#{var_name}---, specified in #{File.expand_path(filename)}, is not a variable. This could be an error")
				end
			end
		end

		# An array of arrays containing the GS2 run times for each iteration. 
		# Produced unscientifically by scanning the stdout.
		def gs2_run_times
			raise FluxOptionError.new("gs2_run_times called and flux_option != gs2") if not flux_gs2?
			run_times = []
			File.open(@directory + '/' + output_file, "r").each_line{|l| l.scan(/Job.*timer.*(\b\d+\.\d+\b)/){run_times.push $~[1].to_f}}
			sz = run_times.size.to_f
			return run_times.pieces((sz / n_flux_tubes.to_f).ceil)

		end

		# Is the flux tube code being used gs2?
		def flux_gs2?
			@flux_option == "gs2"
		end

    def gs2_run_name(i)
      if i >= n_flux_tubes_jac
        jn = i - n_flux_tubes_jac + 1
        run_name = "calibrate_" + @run_name + (jn).to_s
      else
        jn = i + 1
        run_name = @run_name + (jn).to_s
      end 
      run_name
    end
    def gs2_folder_name(i)
      if i >= n_flux_tubes_jac
        jn = i - n_flux_tubes_jac + 1
        folder = "calibrate_#{jn}"
      else
        jn = i + 1
        folder = "flux_tube_#{jn}"
      end 
      folder
    end
	end

end
