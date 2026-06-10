class GameSession
  attr_reader :clients

  def initialize(clients)
    @clients = clients
  end
end
