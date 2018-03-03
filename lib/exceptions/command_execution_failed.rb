module TeamSpeak
  module Exceptions
    class CommandExecutionFailed < TeamSpeak::Exceptions::StandardException
      attr_reader :error_id
      attr_reader :command

      def initialize(error_id, message, command)
        @error_id = error_id.to_i
        @message = message
        @command = command
      end
    end
  end
end
