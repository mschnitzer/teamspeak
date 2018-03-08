module TeamSpeak3
  class VirtualServer
    attr_reader :server

    attr_reader :id
    attr_reader :name
    attr_reader :port
    attr_reader :status
    attr_reader :clients_online
    attr_reader :query_clients_online
    attr_reader :slots
    attr_reader :uptime
    attr_reader :autostart
    attr_reader :uid

    def initialize(server, params)
      @server = server

      @id = params[:virtualserver_id].to_i
      @name = params[:virtualserver_name]
      @port = params[:virtualserver_port].to_i
      @status = params[:virtualserver_status].to_sym
      @clients_online = params[:virtualserver_clientsonline].to_i
      @query_clients_online = params[:virtualserver_queryclientsonline].to_i
      @slots = params[:virtualserver_maxclients].to_i
      @uptime = Time.now - params[:virtualserver_uptime].to_i
      @autostart = params[:virtualserver_uptime].to_i == 1
      @uid = params[:virtualserver_unique_identifier]
    end

    def channels
      channels_list = []
      channels = execute "channellist -topic -flags -voice -limits -icon"

      channels[:data].each do |channel|
        channels_list << TeamSpeak3::Channel.new(self, channel)
      end

      channels_list
    end

    def clients
      clients_list = []
      clients = execute "clientlist -uid -away -voice -times -groups -info -icon -country"

      clients[:data].each do |client|
        clients_list << TeamSpeak3::Client.new(self, client)
      end

      clients_list
    end

    def send_message(message)
      server.send_message_to(self, message)
    end

    def execute(command)
      check_active_server
      @server.execute(command)
    end

    def ==(target)
      @id == target
    end

    private

    def check_active_server
      if @server.active_server != @id
        @server.select_server(@id)
      end
    end
  end
end
