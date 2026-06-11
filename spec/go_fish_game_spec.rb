require_relative '../lib/go_fish_game'
require_relative '../lib/go_fish_player'

describe GoFishGame do # rubocop:disable Metrics/BlockLength
  let(:players) do
    [
      GoFishPlayer.new,
      GoFishPlayer.new
    ]
  end
  let(:game) { GoFishGame.new(players) }

  describe '#start' do # rubocop:disable Metrics/BlockLength
    let(:cards_given) { deal_amount * game.players.size }

    it 'shuffles the cards' do
      # unshuffled_cards = CardDeck.new
      expect(game.deck).to receive(:shuffle).once
      game.start
      # expect(game.deck).not_to match_array unshuffled_cards
    end

    context 'when a game is started with 3 players' do
      let(:deal_amount) { 7 }

      before do
        game.players.push GoFishPlayer.new
      end

      it 'deals out 7 cards to each player from the deck' do
        game.start

        game.players.each do |player|
          expect(player.hand.size).to eq deal_amount
        end
        expect(game.deck.cards_left).to eq CardDeck::STARTING_DECK_SIZE - cards_given
      end
    end

    context 'when a game is started with 4 players' do
      let(:deal_amount) { 5 }

      before do
        game.players.push GoFishPlayer.new
        game.players.push GoFishPlayer.new
      end

      it 'deals out 5 cards to each player from the deck' do
        game.start

        game.players.each do |player|
          expect(player.hand.size).to eq deal_amount
        end
        expect(game.deck.cards_left).to eq CardDeck::STARTING_DECK_SIZE - cards_given
      end
    end
  end
end
