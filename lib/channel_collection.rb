module TeamSpeak3
  class ChannelCollection < Array
    def initialize(virtual_server)
      @virtual_server = virtual_server
    end

    def create(name, opts = {})
      Channel.create(@virtual_server, name, opts)
    end

    def find(id)
      self.each do |channel|
        return channel if channel.id == id.to_i
      end

      nil
    end
  end
end
