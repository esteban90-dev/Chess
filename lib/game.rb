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

  def result
    return nil unless game_over?
    return "Checkmate! Black wins!" if board.checkmate? && board.active_color == "white"
    return "Checkmate! White wins!" if board.checkmate? && board.active_color == "black"
    return "Stalemate! Game is a draw." if board.stalemate? 
  end

  def valid_move_input?(input)
    #returns true if input matches the algebraic notation format 'a2:b3'
    input.match?(/^[A-Ha-h][1-8][:][A-Ha-h][1-8]$/)
  end

  private

end