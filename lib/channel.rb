module TeamSpeak3
  class Channel
    attr_reader :virtual_server

    attr_reader :id
    attr_reader :pid
    attr_reader :name
    attr_reader :order
    attr_reader :total_clients
    attr_reader :needed_subscribe_power

    attr_reader :topic

    attr_reader :flags

    attr_reader :codec
    attr_reader :codec_quality
    attr_reader :needed_talk_power

    attr_reader :icon_id

    attr_reader :total_clients_family
    attr_reader :max_clients
    attr_reader :max_family_clients

    def initialize(virtual_server, params)
      @virtual_server = virtual_server

      @id = params[:cid].to_i
      @pid = params[:pid].to_i
      @name = params[:channel_name]
      @order = params[:order].to_i
      @total_clients = params[:total_clients].to_i
      @needed_subscribe_power = params[:channel_needed_subscribe_power].to_i

      # option: :topic
      @topic = params[:channel_topic]

      # option: :flags
      @flags = []
      @flags << :default if params[:channel_flag_default].to_i == 1
      @flags << :password if params[:channel_flag_password].to_i == 1
      @flags << :permanent if params[:channel_flag_permanent].to_i == 1
      @flags << :semi_permanent if params[:channel_flag_semi_permanent].to_i == 1

      # option: :voice
      @codec = params[:channel_codec].to_i
      @codec_quality = params[:channel_codec_quality].to_i
      @needed_talk_power = params[:channel_needed_talk_power].to_i

      # option: :icon
      @icon_id = params[:channel_icon_id].to_i

      # option: :limits
      @total_clients_family = params[:total_clients_family].to_i
      @max_clients = params[:channel_maxclients].to_i
      @max_family_clients = params[:channel_maxfamilyclients].to_i
    end

    def self.create(virtual_server, name, opts = {})
      command_parameters = { channel_name: name }

      command_parameters[:channel_topic] = opts[:topic] if opts[:topic]
      command_parameters[:channel_description] = opts[:description] if opts[:description]
      command_parameters[:channel_password] = opts[:password] if opts[:password]
      command_parameters[:channel_codec] = opts[:codec] if opts[:codec]
      command_parameters[:channel_codec_quality] = opts[:codec_quality] if opts[:codec_quality]
      command_parameters[:channel_maxclients] = opts[:max_clients] if opts[:max_clients]
      command_parameters[:channel_maxfamilyclients] = opts[:max_family_clients] if opts[:max_family_clients]
      command_parameters[:channel_order] = opts[:order] if opts[:order]
      command_parameters[:channel_needed_talk_power] = opts[:needed_talk_power] if opts[:needed_talk_power]
      command_parameters[:channel_name_phonetic] = opts[:name_phonetic] if opts[:name_phonetic]
      command_parameters[:channel_icon_id] = opts[:icon_id] if opts[:icon_id]
      command_parameters[:channel_codec_is_unencrypted] = opts[:codec_is_unencrypted] if opts[:codec_is_unencrypted]
      command_parameters[:cpid] = opts[:parent_id] if opts[:parent_id]

      response = virtual_server.execute :channelcreate, command_parameters
      virtual_server.channels.find(response[:data].first[:cid])
    end

    def codec_name
      return "Speex Narrowband" if @codec == 0
      return "Speex Wideband" if @codec == 1
      return "Speex Ultra-Wideband" if @codec == 2
      return "CELT Mono" if @codec == 3
      return "Opus Voice" if @codec == 4
      return "Opus Music" if @codec == 5
    end

    def permanent?
      flag?(:permanent)
    end

    def semi_permanent?
      flag?(:semi_permanent)
    end

    def password?
      flag?(:password)
    end

    def default?
      flag?(:default)
    end

    def flag?(flag)
      @flags.include?(flag.to_sym)
    end

    def send_message(message)
      virtual_server.server.send_message_to(self, message)
    end

    def ==(target)
      @id == target
    end
  end
end
