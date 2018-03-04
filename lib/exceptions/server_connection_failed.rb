module TeamSpeak3
  module Exceptions
    class ServerConnectionFailed < TeamSpeak3::Exceptions::StandardException
      def initialize(ip_address, query_port, message)
        @ip_address = ip_address
        @query_port = query_port
        @message = message
      end
    end
  end
end
