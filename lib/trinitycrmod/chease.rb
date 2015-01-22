class CodeRunner::Trinity
	def uses_chease?
		@geo_option == "chease" or @init_option == "chease" or @species_option == "chease"
	end
	def setup_chease
		ep "Setting up chease files..."
		FileUtils.mkdir('chease') unless FileTest.exist? 'chease'
		origfile = @runner.root_folder + '/ogyropsi.dat'
		FileUtils.cp(origfile, 'chease/ogyropsi.dat') if FileTest.exist? origfile
	end

end
