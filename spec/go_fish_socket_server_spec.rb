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
end

def create_client(name) # rubocop:disable Lint/UnusedMethodArgument
  client = MockGoFishSocketClient.new(@server.port_number)
  @clients.push(client)
  @server.accept_new_client
  client
end
