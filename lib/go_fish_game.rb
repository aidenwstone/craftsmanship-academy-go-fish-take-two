require_relative 'card_deck'
require_relative 'turn_result'

class GoFishGame
  attr_reader :players, :deck, :results_log

  SMALL_GAME_MAX_SIZE = 3
  SMALL_GAME_DEAL_AMOUNT = 7
  LARGE_GAME_DEAL_AMOUNT = 5

  def initialize(players)
    @players = players
    @deck = CardDeck.new
    @results_log = []
  end

  def start
    deck.shuffle
    deal_cards
  end

  def play_turn(opponent_id, rank)
    player_in_question = player_by_id(opponent_id.to_i)
    cards = player_in_question.take_cards_of_rank(rank)

    current_player.add_cards(cards) if cards.any?
    fished_card = go_fish if cards.empty?

    add_result(player_in_question, rank, cards, fished_card)
    end_turn(cards, fished_card, rank)
  end

  def current_player
    players.first
  end

  private

  def deal_cards
    players.each do |player|
      cards_to_add = @deck.deal(deal_amount)
      player.add_cards(cards_to_add)
    end
  end

  def deal_amount
    players.size <= SMALL_GAME_MAX_SIZE ? SMALL_GAME_DEAL_AMOUNT : LARGE_GAME_DEAL_AMOUNT
  end

  def player_by_id(id)
    players.find { |player| player.id == id }
  end

  def go_fish
    card = deck.deal
    current_player.add_cards([card])

    card
  end

  def end_turn(cards_taken, fished_card, rank_in_question)
    players.rotate! unless cards_taken.any? || fished_card.rank == rank_in_question
  end

  def add_result(player_in_question, rank, cards, fished_card)
    turn_result = TurnResult.new(player: current_player, opponent: player_in_question,
                                 rank_in_question: rank, cards_taken: cards,
                                 fished_card: fished_card)

    results_log << turn_result
    turn_result
  end
end
