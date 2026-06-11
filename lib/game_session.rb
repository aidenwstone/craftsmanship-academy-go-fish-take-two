require_relative 'go_fish_game'
require_relative 'go_fish_player'

class GameSession
  attr_reader :clients, :game
  attr_accessor :hands_shown

  def initialize(clients)
    @clients = clients
    @game = GoFishGame.new(
      clients.map do |client|
        GoFishPlayer.new(client.id)
      end
    )
    @hands_shown = false
  end

  def run
    game.start
    loop { run_turn } # TODO: Change to until game.winner
  end

  def run_turn
    show_hands
  end

  private

  def show_hands
    clients.each do |client|
      player = player_from_client(client)
      client.write_socket "Your hand is\n#{player.formatted_hand}" unless hands_shown
    end
    self.hands_shown = true
  end

  def player_from_client(client)
    game.players.find do |player|
      player.id == client.id
    end
  end
end
