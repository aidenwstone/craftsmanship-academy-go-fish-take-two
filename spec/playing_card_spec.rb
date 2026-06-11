require_relative '../lib/playing_card'

describe PlayingCard do
  describe '#to_s' do
    context 'with an A of Spades' do
      let(:card) { PlayingCard.new('A', 'Spades') }

      it 'returns "A of Spades"' do
        expect(card.to_s).to eq 'A of Spades'
      end
    end

    context 'with a 7 of Clubs' do
      let(:card) { PlayingCard.new('7', 'Clubs') }

      it 'returns "7 of Clubs"' do
        expect(card.to_s).to eq '7 of Clubs'
      end
    end
  end
end
