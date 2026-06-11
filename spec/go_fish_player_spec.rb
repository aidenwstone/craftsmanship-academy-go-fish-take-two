require_relative '../lib/go_fish_player'
require_relative '../lib/playing_card'

describe GoFishPlayer do
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
        player.add_cards([card1, card2])
        expect(player.hand.length).to eq 2
        expect(player.hand).to include card1
        expect(player.hand).to include card2
      end
    end
  end
end
