class Game
  attr_reader :board, :console

  def self.load(fname)
    file = File.open(fname)
    load = YAML.load(file)
    console.write(load_message)
    self.new(load)
  end

  def self.welcome 
    console.write(welcome_message)
  end

  def initialize(input)
    @board = input.fetch(:board)
    @console = input.fetch(:console)
  end

  public

  def play
    loop do
      console.write(board.formatted)

      input = ''
      result = nil
      while result.nil?
        input = console.prompt(move_message)
        if valid_move_input?(input)
          result = board.move_an(input) 
          console.write(board.formatted_history)
        end
      end

      board.swap_color
      break if game_over?
    end
    console.write(board.formatted)
    console.write(result)
  end

  def save(fname)
    #create save file in YAML format
    save_file = File.open(fname, "w")
    save_file.puts YAML.dump({
      :board => board,
      :console => console
    })
    save_file.close
    console.write(save_message)
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

  def load_message
    str = ''
    str << " Game loaded. \n"
    str
  end

  def save_message
    str = ''
    str << " Game saved. \n"
    str
  end
end