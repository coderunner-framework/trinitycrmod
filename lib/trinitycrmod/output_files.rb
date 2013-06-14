require 'text-data-tools'

class CodeRunner
  class Trinity
    #  this module provides easy access to the Trinity  textbased output data
    #  by defining a TextDataFile  for every text  output file. See the documentation
    #  for TextDataTools  for more information.
    module OutputFiles
      def info_file
        TextDataFile.new(@directory + '/' + @run_name + '.info')
      end
      def time_file
        TextDataFile.new(@directory + '/' + @run_name + '.time', true, /\S+/, /\w+/)
      end
    end
  end
end
