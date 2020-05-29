class Game
  attr_reader :board, :console

  def initialize(input)
    @board = input.fetch(:board)
    @console = input.fetch(:console)
  end

  public

  private

end