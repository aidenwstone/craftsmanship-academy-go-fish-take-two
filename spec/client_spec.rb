require_relative '../lib/client'
require_relative '../lib/go_fish_socket_server'
require_relative 'mock_go_fish_socket_client'

describe Client do # rubocop:disable Metrics/BlockLength
  let(:socket) { TCPSocket.new('localhost', 3336) }
  let(:server_client) { @server.clients.last }

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

  describe '#read_socket' do
    context 'when the socket has a message' do
      it 'returns the message' do
        mock_client = create_client('Player')
        message = 'Hello, world!'

        mock_client.provide_input message

        expect(server_client.read_socket).to eq message
      end
    end

    context 'when the socket has no message' do
      it 'returns nil' do
        create_client('Player')

        expect(server_client.read_socket).to be_nil
      end
    end
  end
end

def create_client(name) # rubocop:disable Lint/UnusedMethodArgument
  client = MockGoFishSocketClient.new(@server.port_number)
  @clients.push(client)
  @server.accept_new_client
  client
end
