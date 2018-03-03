module TeamSpeak
  class Server
    attr_reader :ip_address
    attr_reader :query_port
    attr_reader :socket

    def initialize(ip_address, query_port, opts = {})
      @ip_address = ip_address
      @query_port = query_port
      @opts = opts
    end

    def connect
      begin
        @socket = Net::Telnet::new(
          'Host' => @ip_address,
          'Port' => @query_port,
          'Timeout' => @opts[:timeout] || 3,
          'Telnetmode' => false
        )
        
        @socket.waitfor(/Welcome to the TeamSpeak 3 ServerQuery interface/)
      rescue Net::ReadTimeout => err 
        raise TeamSpeak::Exceptions::ServerConnectionFailed.new(@ip_address, @query_port, \
          "Timeout while waiting for TeamSpeak 3 welcome message.")
      rescue Net::OpenTimeout, Errno::ECONNREFUSED => err
        raise TeamSpeak::Exceptions::ServerConnectionFailed.new(@ip_address, @query_port, \
          "Could not open connection to server at #{@ip_address}:#{@query_port}")
      end

      true
    end

    def login(query_user, query_pass)
      verify_connection

      begin
        execute "login client_login_name=#{query_user} client_login_password=#{query_pass}"
      rescue TeamSpeak::Exceptions::CommandExecutionFailed => err
        raise TeamSpeak::Exceptions::QueryLoginFailed, err.message
      end

      true
    end

    private

    def verify_connection
      raise TeamSpeak::Exceptions::NotConnected, 'Not connected to a TeamSpeak 3 server.' unless @socket
    end

    def execute(command)
      @socket.puts(command)

      # every response contains an error information. so we wait until we receive a response
      response = @socket.waitfor(/error id=.*/)

      response = TeamSpeak::ServerResponse.parse(response)
      if response[:errors][:msg] != 'ok'
        raise TeamSpeak::Exceptions::CommandExecutionFailed.new(
          response[:errors][:id],
          response[:errors][:msg],
          command,
        )
      end

      response
    end
  end
end
