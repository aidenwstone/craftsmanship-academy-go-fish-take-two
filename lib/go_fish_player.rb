class GoFishPlayer
  attr_reader :id, :hand

  EMPTY_HAND_MESSAGE = 'You have no cards in your hand'.freeze

  def initialize(id)
    @id = id
    @hand = []
  end

  def add_cards(cards)
    cards.each { |card| hand << card }
  end

  def take_cards_of_rank(rank)
    find_by_rank = ->(card) { card.rank == rank }

    cards_of_rank = hand.select(&find_by_rank)
    hand.delete_if(&find_by_rank)

    cards_of_rank
  end

  def formatted_hand
    if hand.empty?
      EMPTY_HAND_MESSAGE
    else
      hand.reduce do |result, card|
        "#{result}\n#{card}"
      end
    end
  end
end
