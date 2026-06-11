require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'

describe GoFishPlayer do # rubocop:disable Metrics/BlockLength
  let!(:player) { GoFishPlayer.new }
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
      it 'adds the card to the hand' do
        current_hand_size = player.hand.size

        player.add_cards([card1, card2])
        expect(player.hand.length).to eq current_hand_size + 2
        expect(player.hand).to include card1
        expect(player.hand).to include card2
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
