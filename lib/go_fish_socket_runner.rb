require_relative 'go_fish_socket_server'

server = GoFishSocketServer.new
server.start
loop do
  server.accept_new_client
  game = server.create_game_if_possible
  server.run_game(game) if game
rescue StandardError
  server.stop
end
