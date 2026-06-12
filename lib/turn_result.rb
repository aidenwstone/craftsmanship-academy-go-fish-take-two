class TurnResult
  attr_reader :player, :opponent, :rank_in_question, :cards_taken, :fished_card

  def initialize(player:, opponent:, rank_in_question:, cards_taken:, fished_card:)
    @player = player
    @opponent = opponent
    @rank_in_question = rank_in_question
    @cards_taken = cards_taken
    @fished_card = fished_card
  end
end
