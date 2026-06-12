require_relative 'card_deck'

class GoFishGame
  attr_reader :players, :deck

  SMALL_GAME_MAX_SIZE = 3
  SMALL_GAME_DEAL_AMOUNT = 7
  LARGE_GAME_DEAL_AMOUNT = 5

  def initialize(players)
    @players = players
    @deck = CardDeck.new
  end

  def start
    deck.shuffle
    deal_cards
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
end
