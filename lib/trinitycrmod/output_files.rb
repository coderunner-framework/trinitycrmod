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
        TextDataTools::Column::DataFile.new(@directory + '/' + @run_name + '.fluxes', true, /\S+/, /(?:\#\s+)?\d:.*?(?=\d:|\Z)/)
      end
			# File ending in '.nt': contains profiles: Ti, Te etc.
      def nt_outfile
        TextDataTools::Column::DataFile.new(@directory + '/' + @run_name + '.nt', true, /\S+/, /(?:\#\s+)?\d:.*?(?=\d:|\Z)/)
      end
      def time_outfile
        TextDataTools::Column::DataFile.new(@directory + '/' + @run_name + '.time', true, /\S+/, /\w+/)
      end
			def view_outfiles
				case ENV['EDITOR']
				when /vim/i
					system "#{ENV['EDITOR']} -Rp '+tabdo set nu|set nowrap'  #{info_outfile} #{nt_outfile} #{fluxes_outfile}"
				else
					system "#{ENV['EDITOR']} #{info_outfile} #{nt_outfile} #{fluxes_outfile}"
				end
			end
    end
    include OutputFiles

		#  Return a two-dimensional array of floatingpoint numbers from the file ending in outfile,
		#  from the column whose header matches column_header,  indexed by index_header. See
		#  TextDataTools::Column::DataFile for more information. Outfile is a symbol, use e.g. :nt 
		#  for data from 'run_name.nt'.
		def get_2d_array_float(outfile, column_header, index_header)
			cache[:array_2d] = {} unless [:Complete, :Failed].include? @status
			cache[:array_2d] ||= {}
			cache[:array_2d][[outfile, column_header, index_header]] ||= send(outfile + :_outfile).get_2d_array_float(column_header, index_header)
		end
  end
end
