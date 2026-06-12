require_relative '../lib/go_fish_game'
require_relative '../lib/go_fish_player'

describe GoFishGame do # rubocop:disable Metrics/BlockLength
  let(:player1) { GoFishPlayer.new(1) }
  let(:player2) { GoFishPlayer.new(2) }
  let(:players) { [player1, player2] }
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
        game.players.push GoFishPlayer.new(3)
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
        game.players.push GoFishPlayer.new(3)
        game.players.push GoFishPlayer.new(4)
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

  describe '#current_player' do
    context 'when player 1 is in the front of the queue' do
      it 'returns player 1' do
        expect(game.current_player).to be player1
      end
    end

    context 'when player 2 is in the front of the queue' do
      it 'returns player 2' do
        game.players.rotate!

        expect(game.current_player).to be player2
      end
    end
  end

  describe '#play_turn' do # rubocop:disable Metrics/BlockLength
    let(:card) { PlayingCard.new('A', 'Spades') }
    let(:player_in_question_id) { '2' }
    let(:rank_in_question) { 'A' }

    before do
      player2.add_cards([card])
    end

    xit 'adds a new result log' do
      game.play_turn(player_in_question_id, rank_in_question)

      expect(game.results_log.last).to be_a TurnResult
    end

    xit 'returns the result log' do
      result = game.play_turn(player_in_question_id, rank_in_question)

      expect(result).to be_a TurnResult
    end

    context 'when the player in question has the card in question' do
      before do
        game.play_turn(player_in_question_id, rank_in_question)
      end

      it 'gives the card to the current player' do
        expect(player2.hand).to be_empty
        expect(player1.hand).to include card
      end

      it 'does not fish a card from the deck' do
        expect(game.deck.cards_left).to be CardDeck::STARTING_DECK_SIZE
      end
    end

    context 'when the player in question does not have the card in question' do
      let(:card) { PlayingCard.new('7', 'Spades') }

      it 'fishes a card from the deck and gives it to the player' do
        current_hand_size = 0

        game.play_turn(player_in_question_id, rank_in_question)

        expect(game.deck.cards_left).to be CardDeck::STARTING_DECK_SIZE - 1
        expect(player1.hand_size).to be current_hand_size + 1
      end

      context 'when a card not of the rank in question is fished' do
        it 'updates the current player' do
          game.deck.cards.unshift(PlayingCard.new('5', 'Clubs'))

          game.play_turn(player_in_question_id, rank_in_question)

          expect(game.current_player).to be player2
        end
      end

      context 'when a card of the rank in question is fished' do
        it 'does not update the current player' do
          game.deck.cards.unshift(PlayingCard.new('A', 'Clubs'))

          game.play_turn(player_in_question_id, rank_in_question)

          expect(game.current_player).to be player1
        end
      end
    end
  end
end
