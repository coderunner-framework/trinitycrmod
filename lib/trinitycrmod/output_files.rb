require 'text-data-tools'

class CodeRunner
  class Trinity
    #  this module provides easy access to the Trinity  textbased output data
    #  by defining a TextDataFile  for every text  output file. See the documentation
    #  for TextDataTools  for more information.
    module OutputFiles
      def info_outfile
        TextDataTools::Named::DataFile.new(@directory + '/' + @run_name + '.info', ':')
      end
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
