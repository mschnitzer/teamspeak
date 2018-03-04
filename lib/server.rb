module TeamSpeak3
  class Server
    attr_reader :ip_address
    attr_reader :query_port
    attr_reader :socket
    attr_reader :active_server

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
        raise TeamSpeak3::Exceptions::ServerConnectionFailed.new(@ip_address, @query_port, \
          "Timeout while waiting for TeamSpeak 3 welcome message.")
      rescue Net::OpenTimeout, Errno::ECONNREFUSED => err
        raise TeamSpeak3::Exceptions::ServerConnectionFailed.new(@ip_address, @query_port, \
          "Could not open connection to server at #{@ip_address}:#{@query_port}")
      end

      true
    end

    def login(query_user, query_pass)
      verify_connection

      begin
        execute "login client_login_name=#{query_user} client_login_password=#{query_pass}"
      rescue TeamSpeak3::Exceptions::CommandExecutionFailed => err
        raise TeamSpeak3::Exceptions::QueryLoginFailed, err.message
      end

      true
    end

    def select_server(virtual_server_id)
      execute "use sid=#{virtual_server_id}"
      @active_server = virtual_server_id
    end

    def virtual_servers
      server_list = []

      servers = execute "serverlist -uid -all"
      servers[:data].each do |server|
        server_list << TeamSpeak3::VirtualServer.new(self, server)
      end

      server_list
    end

    def execute(command)
      @socket.puts(command)

      # every response contains an error information. so we wait until we receive a response
      response = @socket.waitfor(/error id=.*/)

      response = TeamSpeak3::ServerResponse.parse(response)
      if response[:errors][:msg] != 'ok'
        raise TeamSpeak3::Exceptions::CommandExecutionFailed.new(
          response[:errors][:id],
          response[:errors][:msg],
          command,
        )
      end

      response
    end

    private

    def verify_connection
      raise TeamSpeak3::Exceptions::NotConnected, 'Not connected to a TeamSpeak 3 server.' unless @socket
    end
  end
end
