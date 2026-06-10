require 'socket'

class GoFishSocketServer
  PORT_NUMBER = 3336

  def port_number
    PORT_NUMBER
  end

  def start
    @server = TCPServer.new(PORT_NUMBER)
  end

  def stop
    @server&.close
  end
end
