class GoFishPlayer
  attr_reader :hand

  EMPTY_HAND_MESSAGE = 'You have no cards in your hand'.freeze

  def initialize
    @hand = []
  end

  def add_cards(cards)
    cards.each { |card| hand << card }
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
