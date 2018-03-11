require 'net/telnet'

module TeamSpeak3
  VERSION = "0.0.5"
end

# exceptions shall be required first
require_relative 'exceptions.rb'

# library classes ordered alphabetically
require_relative 'channel.rb'
require_relative 'channel_collection.rb'
require_relative 'client.rb'
require_relative 'command_parameter.rb'
require_relative 'virtual_server.rb'
require_relative 'server_response.rb'
require_relative 'server.rb'
