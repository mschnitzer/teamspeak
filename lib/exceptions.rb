# the standard exception is the parent of all exceptions
require_relative 'exceptions/standard_exception.rb'

# alphabetical order of exceptions
require_relative 'exceptions/command_execution_failed.rb'
require_relative 'exceptions/invalid_kick_action.rb'
require_relative 'exceptions/invalid_target.rb'
require_relative 'exceptions/invalid_target_type.rb'
require_relative 'exceptions/max_slot_limit_reached.rb'
require_relative 'exceptions/not_connected.rb'
require_relative 'exceptions/query_login_failed.rb'
require_relative 'exceptions/server_connection_failed.rb'
require_relative 'exceptions/virtual_server_not_running.rb'
require_relative 'exceptions/virtual_server_already_running.rb'
