# This file contains methods which allow Trinity to use GS2 as 
# the flux solver

class CodeRunner
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
gs2_run(:base).instance_eval do
#{File.read(tmp_filename).gsub(/\A|\n/, "\n  ")}
end

EOF2
    
      }
			FileUtils.mv(defaults_filename, central_defaults_filename)
			FileUtils.rm(tmp_filename)
			CodeRunner.fetch_runner(C: rcp.code, m: (rcp.modlet? ? rcp.modlet : nil), D: name)

		end

		def gs2_run(key)
			@gs2_run_list ||= {}
			@gs2_run_list[key] ||= Gs2.new(@runner)
			#if key != :base
				#raise "key in gs2_run must be either :base or an integer" unless key.kind_of? Integer
				#@gs2_run_list[key] ||= @gs2_run_list[:base].dup
			#end
			@gs2_run_list[key]
		end

    # Override standard CodeRunner method to allow for Gs2 variables
		def evaluate_defaults_file(filename)
			text = File.read(filename)
			text.scan(/^\s*@(\w+)/) do
				var_name = $~[1].to_sym
				next if var_name == :defaults_file_description
				unless rcp.variables.include? var_name or Gs2.rcp.variables.include? var_name
					warning("---#{var_name}---, specified in #{File.expand_path(filename)}, is not a variable. This could be an error")
				end
			end
			instance_eval(text)
		end

	end
end
