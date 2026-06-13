require_relative '../lib/turn_result'
require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'

describe TurnResult do # rubocop:disable Metrics/BlockLength
  let(:player) { GoFishPlayer.new(1) }
  let(:opponent) { GoFishPlayer.new(2) }
  let(:rank_in_question) { 'A' }
  let(:cards_taken) do
    [
      PlayingCard.new('A', 'Spades'),
      PlayingCard.new('A', 'Clubs')
    ]
  end
  let(:fished_card) { PlayingCard.new('7', 'Diamonds') }

  describe '#formatted_message' do # rubocop:disable Metrics/BlockLength
    context 'when cards were taken from the opponent' do
      let(:turn_result) do
        TurnResult.new(
          player: player,
          opponent: opponent,
          rank_in_question: rank_in_question,
          cards_taken: cards_taken,
          fished_card: nil
        )
      end

      it 'returns a formatted success message' do
        success_regex = /Player 1.*Player 2.*A of Spades.*A of Clubs/

        expect(turn_result.formatted_message).to match success_regex
      end
    end

    context 'when the player went fishing' do
      let(:turn_result) do
        TurnResult.new(
          player: player,
          opponent: opponent,
          rank_in_question: rank_in_question,
          cards_taken: [],
          fished_card: fished_card
        )
      end

      it 'returns a formatted go fish message' do
        go_fish_regex = /Player 1.*A's.*Player 2.*go fish/

        expect(turn_result.formatted_message).to match go_fish_regex
      end
    end
  end
end
