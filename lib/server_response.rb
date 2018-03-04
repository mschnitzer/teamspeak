module TeamSpeak3
  class ServerResponse
    class << self
      def parse(response)
        data, errors = split_data_from_errors(response)

        data = split_keys_from_values(data) if data
        errors = split_keys_from_values(errors, ignore_array_result: true) if errors

        { data: data, errors: errors } 
      end

      private

      def split_keys_from_values(data, opts = {})
        # some commands return an array as response (indicated by a pipe)
        response_list = data.split('|')
        result_list = []

        response_list.each do |data|
          # split data packets (e.g.: cid=1 channel_name=test)
          data = data.split(' ')
          result = {}

          data.each do |key_and_value|
            # the start of the error section is always indicated with 'error'. As there is no '=' and no
            # data we have to split, we can safely skip this iteration
            next if key_and_value == "error"

            trim_pos = key_and_value.index('=')
            
            if trim_pos
              key = key_and_value[0..trim_pos-1]
              value = key_and_value[trim_pos+1..-1]
            else
              key = key_and_value
              value = nil
            end

            result[key.to_sym] = parse_value(value)
          end

          return result if opts[:ignore_array_result]
          result_list.push(result)
        end

        result_list
      end

      def parse_value(value)
        return unless value

        value.gsub!("\\\\", "\\")
        value.gsub!("\/", "/")
        value.gsub!("\\s", " ")
        value.gsub!("\\p", "|")
        value.gsub!("\\a", "\a")
        value.gsub!("\\b", "\b")
        value.gsub!("\\f", "\f")
        value.gsub!("\\n", "\n")
        value.gsub!("\\r", "\r")
        value.gsub!("\\t", "\t")
        value.gsub!("\\v", "\v")
        value
      end

      def split_data_from_errors(response)
        data, errors = response.split("\n")

        # the response always consists of an error information (even if everything was fine) divided
        # by a new line. normally, 'errors' contains the error information, but in case there is only
        # an error and no data has been responded, the 'data' variable actually contains our error
        # information

        if data && !errors
          errors = data
          data = nil
        end

        [ data, errors ]
      end
    end
  end
end
