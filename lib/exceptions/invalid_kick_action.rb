module TeamSpeak3
  module Exceptions
    class InvalidKickAction < TeamSpeak3::Exceptions::StandardException
      attr_reader :action

      def initialize(action)
        @action = action
        @message = "Invalid kick action '#{action}'."
      end
    end
  end
end
