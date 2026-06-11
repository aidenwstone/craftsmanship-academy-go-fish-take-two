require_relative '../lib/playing_card'

describe PlayingCard do # rubocop:disable Metrics/BlockLength
  context 'when the given rank is not in valid rank list' do
    it 'raises an invalid rank error' do
      expect do
        PlayingCard.new('15', 'Spades')
      end.to raise_error PlayingCard::InvalidRank
    end
  end

  context 'when the given suit is not in valid suit list' do
    it 'raises an invalid suit error' do
      expect do
        PlayingCard.new('A', 'Invalid')
      end.to raise_error PlayingCard::InvalidSuit
    end
  end

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
