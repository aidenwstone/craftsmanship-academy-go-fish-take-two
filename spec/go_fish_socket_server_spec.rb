require_relative '../lib/go_fish_socket_server'
require_relative 'mock_go_fish_socket_client'

describe GoFishSocketServer do # rubocop:disable Metrics/BlockLength
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

  context 'before it is started' do
    it 'is not listening on a port' do
      @server.stop
      expect { MockGoFishSocketClient.new(@server.port_number) }.to raise_error(Errno::ECONNREFUSED)
    end
  end

  describe '#accept_new_client' do
    it 'creates a new client' do
      client_count = @server.clients.size

      create_client('Player 1')

      expect(@server.clients.size).to eq client_count + 1
      expect(@server.clients.last).to be_a Client
    end

    it 'sends a welcome message' do
      welcome_regex = /welcome/i

      client = create_client('Player 1')

      expect(client.capture_output).to match welcome_regex
    end
  end

  describe '#create_game_if_possible' do # rubocop:disable Metrics/BlockLength
    context 'when one client joins' do
      before do
        create_client('Player 1')
      end

      it 'does not create a game' do
        @server.create_game_if_possible

        expect(@server.game_sessions.size).to be_zero
      end

      it 'returns nil' do
        expect(@server.create_game_if_possible).to be_nil
      end
    end

    context 'when a second client joins' do
      let!(:client1) { create_client('Player 1') }
      let!(:client2) { create_client('Player 2') }

      it 'creates a new game session' do
        game_count = @server.game_sessions.size

        @server.create_game_if_possible

        expect(@server.game_sessions.size).to be game_count + 1
        expect(@server.game_sessions.last).to be_a GameSession
      end

      it 'sends game starting message to clients' do
        starting_regex = /starting/i

        client1.capture_output
        client2.capture_output
        @server.create_game_if_possible

        expect(client1.capture_output).to match starting_regex
        expect(client2.capture_output).to match starting_regex
      end

      it 'returns the game session object' do
        expect(@server.create_game_if_possible).to be_a GameSession
      end
    end
  end
end

def create_client(name) # rubocop:disable Lint/UnusedMethodArgument
  client = MockGoFishSocketClient.new(@server.port_number)
  sleep(0.1)
  @clients.push(client)
  @server.accept_new_client
  sleep(0.1)
  client
end
