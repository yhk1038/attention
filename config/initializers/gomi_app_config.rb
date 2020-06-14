class GomiStoreConfig
  attr_reader :server

  def initialize
    @server = Server.new
  end

  class Server
    def port
      3000
    end

    def bind
      '0.0.0.0'
    end

    def device_ip
      `ifconfig en0 | grep inet`.split("\n").last.split(' ')[1]
    end
  end
end

$gomi_store_config = GomiStoreConfig.new
