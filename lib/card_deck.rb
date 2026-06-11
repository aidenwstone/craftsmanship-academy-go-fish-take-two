require_relative 'playing_card'

class CardDeck
  attr_reader :cards

  def initialize
    @cards = PlayingCard::SUITS.flat_map do |suit|
      PlayingCard::RANKS.map do |rank|
        PlayingCard.new(rank, suit)
      end
    end
  end

  def cards_left
    cards.size
  end

  def deal(amount = nil)
    return cards.shift(amount) if amount

    cards.shift
  end
end
