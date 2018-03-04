module TeamSpeak3
  module Exceptions
    class InvalidTarget < TeamSpeak3::Exceptions::StandardException
      attr_reader :target

      def initialize(target)
        @target = target
        @message = "Invalid target '#{target}'."
      end
    end
  end
end
