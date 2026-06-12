class TurnResult
  attr_reader :player, :opponent, :rank_in_question, :cards_taken, :fished_card

  def initialize(player:, opponent:, rank_in_question:, cards_taken:, fished_card:)
    @player = player
    @opponent = opponent
    @rank_in_question = rank_in_question
    @cards_taken = cards_taken
    @fished_card = fished_card
  end

  def formatted_message
    if cards_taken.any?
      "Player #{player.id} took #{cards_taken.join(', ')} from Player #{opponent.id}"
    else
      "Player #{player.id} asked for #{rank_in_question}'s from Player #{opponent.id}, but had to go fish"
    end
  end
end
