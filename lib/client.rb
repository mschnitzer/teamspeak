module TeamSpeak3
  class Client
    attr_reader :virtual_server

    attr_reader :client_id
    attr_reader :client_database_id
    attr_reader :channel_id
    attr_reader :nickname
    attr_reader :type_id
    attr_reader :away_message
    attr_reader :flags
    attr_reader :talk_power
    attr_reader :uid
    attr_reader :version
    attr_reader :platform
    attr_reader :servergroups
    attr_reader :channel_group_id
    attr_reader :channel_group_inherited_channel_id
    attr_reader :idle_time
    attr_reader :created_at
    attr_reader :last_connected
    attr_reader :icon_id
    attr_reader :country

    def initialize(virtual_server, params)
      @virtual_server = virtual_server

      @client_id = params[:clid].to_i
      @client_database_id = params[:client_database_id].to_i
      @channel_id = params[:cid].to_i
      @nickname = params[:client_nickname]
      @type_id = params[:client_type].to_i
      @away = params[:client_away].to_i == 1
      @away_message = params[:client_away_message]

      @flags = []
      @flags << :talking if params[:client_flag_talking].to_i == 1

      @input_muted = true if params[:client_input_muted].to_i == 1
      @output_muted = true if params[:client_output_muted].to_i == 1

      @input_hardware = true if params[:client_input_hardware].to_i == 1
      @output_hardware = true if params[:client_output_hardware].to_i == 1

      @talk_power = params[:client_talk_power].to_i
      @talker = params[:client_is_talker].to_i == 1
      @priority_speaker = params[:client_is_priority_speaker].to_i == 1
      @recording = params[:client_is_recording].to_i == 1
      
      @channel_commander = params[:client_is_channel_commander].to_i == 1

      @uid = params[:client_unique_identifier]
      @version = params[:client_version]
      @platform = params[:client_platform]
      @servergroups = params[:client_servergroups].split(',').map {|group| group.to_i}
      @channel_group_id = params[:client_channel_group_id].to_i
      @channel_group_inherited_channel_id = params[:client_channel_group_inherited_channel_id].to_i

      @idle_time = Time.now - params[:client_idle_time].to_i
      @created_at = Time.at(params[:client_created].to_i)
      @last_connected = Time.at(params[:client_lastconnected].to_i)

      @icon_id = params[:client_icon_id].to_i

      @country = params[:client_country]
    end

    def away?
      @away
    end

    def channel_commander?
      @channel_commander
    end

    def flag?(flag)
      @flags.include?(flag)
    end

    def input_hardware?
      @input_hardware
    end

    def input_muted?
      @input_muted
    end

    def kick_from_server!(reason = nil)
      virtual_server.server.kick_client!(client_id, :server, reason)
      true
    end

    def kick_from_channel!(reason = nil)
      virtual_server.server.kick_client!(client_id, :channel, reason)
      true
    end

    def output_hardware?
      @output_hardware
    end

    def output_muted?
      @output_muted
    end

    def priority_speaker?
      @priority_speaker
    end

    def recording?
      @recording
    end

    def send_message(message)
      virtual_server.server.send_message_to(self, message)
    end

    def talker?
      @talker
    end

    def talking?
      flag?(:talking)
    end
  end
end
