class GoFishPlayer
  attr_reader :hand

  def initialize
    @hand = []
  end

  def add_cards(cards)
    cards.each { |card| hand << card }
  end
end
