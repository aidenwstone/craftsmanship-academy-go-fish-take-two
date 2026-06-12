require_relative 'go_fish_game'
require_relative 'go_fish_player'

class GameSession
  attr_reader :clients, :game
  attr_accessor :hands_shown, :rank_prompt_shown, :chosen_rank,
                :chosen_opponent_id, :opponent_prompt_shown

  def initialize(clients)
    @clients = clients
    @game = GoFishGame.new(
      clients.map do |client|
        GoFishPlayer.new(client.id)
      end
    )
  end

  def run
    game.start
    loop { run_turn } # TODO: Change to until game.winner
  end

  def run_turn
    show_hands
    current_client = client_from_player(game.current_player)
    return unless prompt_for_rank(current_client)

    prompt_for_opponent(current_client)
  end

  private

  def show_hands
    clients.each do |client|
      player = player_from_client(client)
      client.write_socket "Your hand is\n#{player.formatted_hand}" unless hands_shown
    end
    self.hands_shown = true
  end

  def prompt_for_rank(client)
    return chosen_rank if chosen_rank

    client.write_socket 'Which rank do you want to ask for:' unless rank_prompt_shown
    self.rank_prompt_shown = true
    self.chosen_rank = client.read_socket
  end

  def prompt_for_opponent(client)
    return chosen_opponent_id if chosen_opponent_id

    client.write_socket 'Which opponent do you want to ask:' unless opponent_prompt_shown
    self.opponent_prompt_shown = true
    self.chosen_opponent_id = client.read_socket
  end

  def player_from_client(client)
    game.players.find do |player|
      player.id == client.id
    end
  end

  def client_from_player(player)
    clients.find do |client|
      client.id == player.id
    end
  end
end
