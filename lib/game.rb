class Game
  attr_reader :board, :console

  def initialize(input)
    @board = input.fetch(:board)
    @console = input.fetch(:console)
  end

  public

  def play
    loop do
      console.write(board.formatted)
      console.write(board.formatted_history)
      input = console.prompt("Make a move:")
      board.move_an(input)
      board.swap_color
      break if board.checkmate?
      break if board.stalemate?
    end
  end

  def game_over?
    return true if board.checkmate?
    return true if board.stalemate?
    false
  end

  private

end