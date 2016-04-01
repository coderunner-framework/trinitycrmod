# This file contains methods which allow Trinity to use GS2 as 
# the flux solver

#class NumRu::NetCDF
	#def _dump_data
		#Marshal.dump(nil)
	#end
#end
class CodeRunner
	class Trinity
		module TrinityComponent 
			attr_accessor :trinity_run
			def initialize(runner, trinity_run, trinity_id)
				super(runner)
				@trinity_run = trinity_run
        @trinity_id = trinity_id
				self
			end
      def generate_run_name
        @run_name = @trinity_run.flux_run_name(@trinity_id)
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
				return self.class.new(@runner, @trinity_run, @trinity_id).learn_from(self)
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

    class TrinityComponent::Gs2 < CodeRunner::Gs2
      include TrinityComponent
    end

    class TrinityComponent::Gryfx < CodeRunner::Gryfx
      include TrinityComponent
    end

    

		# This function creates a new Trinity defaults file, with Trinity parameters taken from 
		# trinity_input_file, and GS2 parameters taken from gs2_input_file. The file is then moved
		# to the CodeRunner central defaults location, the current folder is configured to use 
		# the defaults file.
		def self.use_new_defaults_file_with_flux(name = ARGV[-4], trinity_input_file = ARGV[-3], flux_input_file = ARGV[-2], fluxcode=ARGV[-1])
	    raise "Please specify a name, a trinity input file and a flux code input file" if name == "use_new_defaults_file_with_flux"
	    defaults_filename = "#{name}_defaults.rb"
			tmp_filename = "#{name}_flxtmp_defaults.rb"
			central_defaults_filename = rcp.user_defaults_location + "/" + defaults_filename
			#FileUtils.rm(name + '_defaults.rb') if FileTest.exist?(name + '_defaults.rb')
			#FileUtils.rm(central_defaults_filename) if FileTest.exist?(central_defaults_filename)
			FileUtils.rm(tmp_filename) if FileTest.exist?(tmp_filename)
			raise "Defaults file: #{central_defaults_filename} already exists" if FileTest.exist? central_defaults_filename

      flxclass = flux_class(fluxcode)

			make_new_defaults_file(name, trinity_input_file)
			flxclass.make_new_defaults_file(name + '_flxtmp', flux_input_file)

			File.open(defaults_filename, 'a'){|file| file.puts <<EOF2
@set_flux_defaults_procs.push(Proc.new do
flux_runs.each do |run|
run.instance_eval do
#{File.read(tmp_filename).gsub(/\A|\n/, "\n  ")}
end
end
end)


EOF2
    
      }
			#FileUtils.mv(defaults_filename, central_defaults_filename)
			FileUtils.rm(tmp_filename)
			CodeRunner.fetch_runner(C: rcp.code, m: (rcp.modlet? ? rcp.modlet : nil), D: name)

		end

		# Generates the component runs for GS2 and returns the hash
		# Raises an error if flux_option != "gs2"
		def flux_runs
			raise FluxOptionError.new("flux_runs called and flux_option != gs2 or gryfx") if not (flux_gs2? or flux_gryfx?)
     

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

    # Override standard CodeRunner method to allow for flux code variables
		def evaluate_defaults_file(filename)
			text = File.read(filename)
			instance_eval(text)
			text.scan(/^\s*@(\w+)/) do
				var_name = $~[1].to_sym
				next if var_name == :defaults_file_description
				unless rcp.variables.include? var_name or (flux_gs2? and Gs2.rcp.variables.include? var_name) or (flux_gryfx? and Gryfx.rcp.variables.include? var_name)
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

    def self.flux_class(code)
      case code
      when "gs2"
        CodeRunner::Trinity::TrinityComponent::Gs2
      when "gryfx"
        CodeRunner::Trinity::TrinityComponent::Gryfx
      end
    end
    def flux_class
      self.class.flux_class(@flux_option)
    end
		# Is the flux tube code being used gs2?
		def flux_gs2?
			@flux_option == "gs2"
		end
		# Is the flux tube code being used gryfx?
		def flux_gryfx?
			@flux_option == "gryfx"
		end

    def flux_run_name(i)
      if i >= n_flux_tubes_jac
        jn = i - n_flux_tubes_jac + 1
        run_name = "calibrate_" + @run_name + (jn).to_s
      else
        jn = i + 1
        run_name = @run_name + (jn).to_s
      end 
      run_name
    end
    def flux_folder_name(i)
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

  # Backwards compatibility
  Gs2::TrinityComponent = Trinity::TrinityComponent::Gs2
end
