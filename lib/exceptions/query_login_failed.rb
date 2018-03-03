module TeamSpeak
  module Exceptions
    class QueryLoginFailed < TeamSpeak::Exceptions::StandardException
      def initialize(message)
        @message = message
      end
    end
  end
end
