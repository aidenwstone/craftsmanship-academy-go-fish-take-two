require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'

describe GoFishPlayer do # rubocop:disable Metrics/BlockLength
  let!(:player) { GoFishPlayer.new(1) }
  let(:card1) { PlayingCard.new('A', 'Diamonds') }
  let(:card2) { PlayingCard.new('5', 'Hearts') }

  describe 'add_cards' do
    context 'with 1 card' do
      it 'adds the card to the hand' do
        player.add_cards([card1])
        expect(player.hand.length).to eq 1
        expect(player.hand).to include card1
      end
    end

    context 'with multiple cards' do
      it 'adds the cards to the hand' do
        current_hand_size = player.hand.size

        player.add_cards([card1, card2])
        expect(player.hand.length).to eq current_hand_size + 2
        expect(player.hand).to include card1
        expect(player.hand).to include card2
      end
    end
  end

  describe '#take_cards_of_rank' do
    let(:rank) { 'A' }

    context "when the player's hand includes the rank in question" do
      let(:cards_of_rank) do
        [
          PlayingCard.new('A', 'Spades'),
          PlayingCard.new('A', 'Clubs')
        ]
      end
      let(:other_card) { PlayingCard.new('7', 'Spades') }

      before do
        player.add_cards(cards_of_rank + [other_card])
      end

      it 'removes and returns the cards of that rank' do
        expect(player.take_cards_of_rank(rank)).to match_array cards_of_rank
        expect(player.hand).not_to include(*cards_of_rank)
      end

      it 'does not return other cards' do
        expect(player.take_cards_of_rank(rank)).not_to include other_card
      end
    end

    context "when the player's hand does not include the rank in question" do
      it 'returns an empty array' do
        expect(player.take_cards_of_rank(rank)).to be_empty
      end
    end
  end

  describe '#formatted_hand' do
    context 'with no cards' do
      it 'returns an empty hand message' do
        empty_regex = /no cards/

        result = player.formatted_hand
        expect(result).to match empty_regex
      end
    end

    context 'with cards' do
      it 'returns the formatted hand' do
        cards_regex = /A of Diamonds\s5 of Hearts/

        player.add_cards([card1, card2])

        result = player.formatted_hand
        expect(result).to match cards_regex
      end
    end
  end
end
