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

        @socket.waitfor("Match" => /Welcome to the TeamSpeak 3 ServerQuery interface/, "FailEOF" => true)
      rescue Net::ReadTimeout
        raise TeamSpeak3::Exceptions::ServerConnectionFailed.new(@ip_address, @query_port, \
          "Timeout while waiting for TeamSpeak 3 welcome message.")
      rescue Net::OpenTimeout, Errno::ECONNREFUSED
        raise TeamSpeak3::Exceptions::ServerConnectionFailed.new(@ip_address, @query_port, \
          "Could not open connection to server at #{@ip_address}:#{@query_port}")
      rescue EOFError
        raise TeamSpeak3::Exceptions::ServerConnectionFailed.new(@ip_address, @query_port, \
          "Server closed the connection.")
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

    def kick_client!(client_id, action, reason = nil)
      # set correct kick action
      action_id = nil
      action_id = 4 if action == :channel
      action_id = 5 if action == :server

      raise TeamSpeak3::Exceptions::InvalidKickAction.new(action) unless action_id

      # handle multiple client ids
      client_ids = ""
      if client_id.is_a?(Integer)
        client_ids = "clid=#{client_id}"
      elsif client_id.is_a?(Array)
        client_id.each { |id| client_ids += "clid=#{id}|" }
        client_ids = client_ids[0..-2]
      end

      # execute command
      command = "clientkick #{client_ids} reasonid=#{action_id}"
      command += " reasonmsg=#{TeamSpeak3::CommandParameter.encode(reason)}" if reason
      execute command
    end

    def send_message_to(target, message, target_type = :auto)
      if target_type == :auto
        if target.is_a?(TeamSpeak3::VirtualServer)
          target_id = target.id
          target_type_id = 3

          select_server target.id
        elsif target.is_a?(TeamSpeak3::Channel)
          target_id = target.id
          target_type_id = 2

          select_server target.virtual_server.id
        elsif target.is_a?(TeamSpeak3::Client)
          target_id = target.client_id
          target_type_id = 1

          select_server target.virtual_server.id
        else
          raise TeamSpeak3::Exceptions::InvalidTarget.new(target)
        end
      else
        target_id = target

        target_type_id = 3 if target_type.to_sym == :server
        target_type_id = 2 if target_type.to_sym == :channel
        target_type_id = 1 if target_type.to_sym == :client

        raise TeamSpeak3::Exceptions::InvalidTargetType.new(target_type) unless target_type_id
      end

      execute "sendtextmessage target=#{target_id} targetmode=#{target_type_id} " \
        "msg=#{TeamSpeak3::CommandParameter.encode(message)}"
      true
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
