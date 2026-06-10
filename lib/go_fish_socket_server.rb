require 'socket'
require_relative 'client'

class GoFishSocketServer
  attr_reader :server

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

  def clients
    @clients ||= []
  end

  def accept_new_client
    socket = server.accept_nonblock
    client = Client.new(socket)

    clients << client

    client.write_socket 'Welcome to Go Fish!'
  end
end
