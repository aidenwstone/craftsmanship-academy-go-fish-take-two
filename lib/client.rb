class Client
  attr_reader :socket

  def initialize(socket)
    @socket = socket
  end

  def read_socket(delay = 0.1)
    sleep(delay)
    socket.read_nonblock(1000).chomp
  rescue IO::WaitReadable # rubocop:disable Lint/SuppressedException
  end

  def write_socket(message)
    socket.puts message
  end
end
