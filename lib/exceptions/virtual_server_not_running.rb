module TeamSpeak3
  module Exceptions
    class VirtualServerNotRunning < TeamSpeak3::Exceptions::StandardException
      attr_reader :server_id

      def initialize(server_id)
        @server_id = server_id
        @message = 'The virtual server is not running'
      end
    end
  end
end
