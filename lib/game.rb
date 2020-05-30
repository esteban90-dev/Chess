class Game
  attr_reader :board, :console

  def initialize(input)
    @board = input.fetch(:board)
    @console = input.fetch(:console)
  end

  public

  def play
    console.write(welcome_message)
    loop do
      console.write(board.formatted)
      console.write(board.formatted_history)
      input = console.prompt(move_message)
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

  def valid_promotion_input?(input)
    ['rook','bishop','knight','queen'].any?{ |word| input.downcase.match?(word) }
  end

  private

  def welcome_message
    str = ''
    str << "\n"
    str << " Welcome to Chess! \n"
    str << " White always goes first. \n"
    str << " The game is over when one color puts the other in checkmate, \n"
    str << " or there is a stalemate condition (draw). \n"
    str << " For detailed rules, see https://en.wikipedia.org/wiki/Rules_of_chess \n"
    str << "\n"
    str
  end

  def move_message
    str = ''
    str << " It is #{board.active_color}'s move. Enter a move in the following format: 'a2:b3' \n"
    str
  end
end