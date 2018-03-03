module TeamSpeak
  module Exceptions
    class ServerConnectionFailed < TeamSpeak::Exceptions::StandardException
      def initialize(ip_address, query_port, message)
        @ip_address = ip_address
        @query_port = query_port
        @message = message
      end
    end
  end
end
