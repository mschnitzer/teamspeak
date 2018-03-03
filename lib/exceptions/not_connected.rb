module TeamSpeak
  module Exceptions
    class NotConnected < TeamSpeak::Exceptions::StandardException
      def initialize(message)
        @message = message
      end
    end
  end
end
