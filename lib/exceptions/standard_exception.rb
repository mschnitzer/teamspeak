module TeamSpeak
  module Exceptions
    class StandardException < Exception
      attr_reader :message

      def to_s
        @message
      end
    end
  end
end
