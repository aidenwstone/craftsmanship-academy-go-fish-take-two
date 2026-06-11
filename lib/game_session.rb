require_relative 'go_fish_game'
require_relative 'go_fish_player'

class GameSession
  attr_reader :clients, :game

  def initialize(clients)
    @clients = clients
    @game = GoFishGame.new(
      clients.map do |client|
        GoFishPlayer.new(client.id)
      end
    )
  end
end
