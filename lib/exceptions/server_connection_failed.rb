module TeamSpeak3
  module Exceptions
    class ServerConnectionFailed < TeamSpeak3::Exceptions::StandardException
      attr_reader :ip_address
      attr_reader :query_port

      def initialize(ip_address, query_port, message)
        @ip_address = ip_address
        @query_port = query_port
        @message = message
      end
    end
  end
end
