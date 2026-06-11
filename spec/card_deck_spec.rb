require_relative '../lib/card_deck'

describe CardDeck do # rubocop:disable Metrics/BlockLength
  let(:deck) { CardDeck.new }

  describe '#deal' do
    context 'when given no argument' do
      let(:card) { deck.deal }

      it 'removes and returns the top card from the deck' do
        deck_size = deck.cards_left

        expect(card).to be_a PlayingCard
        expect(deck.cards_left).to be deck_size - 1
      end
    end

    context 'when given 7 as an argument' do
      let(:cards) { deck.deal(7) }

      it 'removes and returns the top 7 cards from the deck' do
        deck_size = deck.cards_left

        first_seven_cards = deck.cards.first(7)
        expect(cards).to match_array(first_seven_cards)
        expect(deck.cards_left).to be deck_size - 7
      end
    end
  end

  describe '#shuffle' do
    let(:shuffled_deck) { deck.shuffle }
    let(:fresh_deck) { CardDeck.new }

    it 'shuffles the deck' do
      expect(shuffled_deck.cards).not_to eq fresh_deck.cards
    end
  end
end
