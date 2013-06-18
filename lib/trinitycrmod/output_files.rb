require 'text-data-tools'

class CodeRunner
  class Trinity
    #  This module provides easy access to the Trinity  textbased output data
    #  by defining a TextDataTools::Named::DataFile or TextDataTools::Column::DataFile  
		#  for every text  output file. See the documentation
    #  for TextDataTools  for more information.
    module OutputFiles
			# File ending in '.info': contains global results.
      def info_outfile
        TextDataTools::Named::DataFile.new(@directory + '/' + @run_name + '.info', ':')
      end
			# File ending in '.fluxes': contains heat flux, momentum flux etc.
      def fluxes_outfile
        TextDataTools::Column::DataFile.new(@directory + '/' + @run_name + '.fluxes', true, /\S+/, /(?:\#\s+)?\d:.*?(?=\d:)/)
      end
			# File ending in '.nt': contains profiles: Ti, Te etc.
      def nt_outfile
        TextDataTools::Column::DataFile.new(@directory + '/' + @run_name + '.nt', true, /\S+/, /(?:\#\s+)?\d:.*?(?=\d:)/)
      end
      def time_outfile
        TextDataTools::Column::DataFile.new(@directory + '/' + @run_name + '.time', true, /\S+/, /\w+/)
      end
    end
    include OutputFiles
  end
end
