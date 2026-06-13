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
    base_message = "Player #{player.id} asked for #{rank_in_question}'s from Player #{opponent.id}"

    if cards_taken.any?
      "#{base_message}, and took #{cards_taken.join(', ')}."
    else
      "#{base_message}, but had to go fish."
    end
  end
end
