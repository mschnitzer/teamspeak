module TeamSpeak3
  class Channel
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

    def ==(target)
      @id == target
    end
  end
end
