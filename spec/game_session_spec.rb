require_relative '../lib/game_session'
require_relative '../lib/go_fish_socket_server'
require_relative 'mock_go_fish_socket_client'

describe GameSession do # rubocop:disable Metrics/BlockLength
  let(:client1) { game_session.clients[0] }
  let(:client2) { game_session.clients[1] }

  before(:each) do
    @clients = []
    @server = GoFishSocketServer.new
    @server.start
    sleep 0.2 # Ensure server is ready for clients
  end

  after(:each) do
    @server.stop
    @clients.each(&:close)
  end

  describe '#run_turn' do # rubocop:disable Metrics/BlockLength
    let!(:mock_client1) { create_client('Player 1') }
    let!(:mock_client2) { create_client('Player 2') }
    let!(:game_session) { @server.create_game_if_possible }

    let(:chosen_rank) { 'A' }
    let(:chosen_opponent_id) { '2' }

    before do
      game_session.game.start
    end

    it 'shows the players their hands' do
      hand_regex = /Spades|Clubs|Hearts|Diamonds/

      # Shows introductory message
      mock_client1.capture_output
      mock_client2.capture_output
      game_session.run_turn
      # Shows hands

      expect(mock_client1.capture_output).to match hand_regex
      expect(mock_client2.capture_output).to match hand_regex

      game_session.run_turn
      # Shows nothing

      expect(mock_client1.capture_output).to be_empty
      expect(mock_client2.capture_output).to be_empty
    end

    it 'prompts current player for rank once' do
      rank_regex = /which rank/i

      # Shows introductory message
      mock_client1.capture_output
      mock_client2.capture_output
      game_session.run_turn
      # Shows hands
      # Prompts current player for rank

      expect(mock_client1.capture_output).to match rank_regex
      expect(mock_client2.capture_output).not_to match rank_regex

      game_session.run_turn
      # Shows nothing

      expect(mock_client1.capture_output).to be_empty
    end

    it 'prompts current player for opponent once' do
      opponent_regex = /which opponent/i

      # Shows introductory message
      mock_client1.capture_output
      mock_client2.capture_output
      game_session.run_turn
      # Shows hands
      # Prompts current player for rank
      mock_client1.capture_output
      mock_client2.capture_output

      mock_client1.provide_input chosen_rank
      game_session.run_turn
      # Prompts current player for opponent

      expect(mock_client1.capture_output).to match opponent_regex
      expect(mock_client2.capture_output).to be_empty

      game_session.run_turn
      # Shows nothing

      expect(mock_client1.capture_output).to be_empty
    end

    it 'announces the result' do
      skip
      result_regex = /asked for/

      # Shows introductory message
      mock_client1.capture_output
      mock_client2.capture_output
      game_session.run_turn
      # Shows hands
      # Prompts current player for rank

      mock_client1.provide_input chosen_rank
      game_session.run_turn
      # Prompts current player for opponent

      mock_client1.provide_input chosen_opponent_id
      game_session.run_turn

      expect(mock_client1.capture_output).to match result_regex
      expect(mock_client2.capture_output).to match result_regex
    end

    # TODO: Test reset after turn?
  end
end

def create_client(name) # rubocop:disable Lint/UnusedMethodArgument
  client = MockGoFishSocketClient.new(@server.port_number)
  @clients.push(client)
  @server.accept_new_client
  client
end
