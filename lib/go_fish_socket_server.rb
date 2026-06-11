require 'socket'
require_relative 'client'
require_relative 'game_session'

class GoFishSocketServer
  attr_reader :server

  PORT_NUMBER = 3336
  MIN_PLAYERS = 2

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

  def game_sessions
    @game_sessions ||= []
  end

  def accept_new_client
    socket = server.accept_nonblock
    client_id = clients.size + 1
    client = Client.new(socket, client_id)

    clients << client

    client.write_socket 'Welcome to Go Fish!'
  rescue IO::WaitReadable # rubocop:disable Lint/SuppressedException
  end

  def create_game_if_possible
    return unless clients.count >= MIN_PLAYERS

    game_session = GameSession.new(clients)

    game_sessions << game_session

    clients.each do |client|
      client.write_socket 'Go Fish is starting...'
    end

    game_session
  end

  def run_game(game_session)
    game_session.run
  end
end
