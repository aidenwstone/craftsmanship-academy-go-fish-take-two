class GoFishPlayer
  attr_reader :hand

  def initialize
    @hand = []
  end

  def add_cards(cards)
    cards.each { |card| hand << card }
  end

  def formatted_hand
    if hand.empty?
      'You have no cards in your hand'
    else
      hand.reduce do |result, card|
        "#{result}\n#{card}"
      end
    end
  end
end
