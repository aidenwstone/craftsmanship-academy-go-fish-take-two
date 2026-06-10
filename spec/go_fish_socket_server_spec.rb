require_relative '../lib/go_fish_socket_server'

class MockGoFishSocketClient
  attr_reader :socket, :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay = 0.3)
    sleep(delay)
    @output = @socket.read_nonblock(1000) # not gets which blocks
  rescue IO::WaitReadable
    @output = ''
  end

  def close
    @socket&.close
  end
end

describe GoFishSocketServer do
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
end

def create_client(name) # rubocop:disable Lint/UnusedMethodArgument
  client = MockGoFishSocketClient.new(@server.port_number)
  @clients.push(client)
  @server.accept_new_client
  client
end
