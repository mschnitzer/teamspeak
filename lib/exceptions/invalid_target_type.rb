module TeamSpeak3
  module Exceptions
    class InvalidTargetType < TeamSpeak3::Exceptions::StandardException
      attr_reader :target_type

      def initialize(target_type)
        @target_type = target_type
        @message = "Invalid target type '#{target_type}'."
      end
    end
  end
end
