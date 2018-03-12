module TeamSpeak3
  class QueryAccount
    attr_reader :nickname

    def initialize(server, nickname)
      @server = server
      @nickname = nickname
    end

    def nickname=(nickname)
      @server.execute :clientupdate, client_nickname: nickname
      @nickname = nickname
    end

    def to_s
      @nickname
    end
  end
end
