# the standard exception is the parent of all exceptions
require_relative 'exceptions/standard_exception.rb'

# alphabetical order of exceptions
require_relative 'exceptions/command_execution_failed.rb'
require_relative 'exceptions/not_connected.rb'
require_relative 'exceptions/query_login_failed.rb'
require_relative 'exceptions/server_connection_failed.rb'
