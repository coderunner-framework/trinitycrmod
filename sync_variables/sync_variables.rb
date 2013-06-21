require 'helper'
CodeRunner.setup_run_class('trinity')
CodeRunner::Trinity.get_input_help_from_source_code(ENV['TRINITY_SOURCE'])
CodeRunner::Trinity.update_defaults_from_source_code(ENV['TRINITY_SOURCE'])
CodeRunner::Trinity.synchronise_variables(ENV['TRINITY_SOURCE'])

