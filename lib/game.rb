class Game
  SAVE_PATH = './saves/save_file'
  
  attr_reader :board 

  def self.load(fname)
    file = File.open(fname)
    load = YAML.load(file)
    load_obj = self.new(load)
    puts load_done_message
    load_obj
  end

  def self.welcome 
    welcome_message
  end

  def self.load_prompt_message
    str = ''
    str << " Would you like to load a game? Enter y/n."
    str
  end

  def self.load_done_message
    str = ''
    str << " Game loaded. \n"
    str
  end

  def initialize(input)
    @board = input.fetch(:board)
  end

  public

  def play
    loop do
      puts board.formatted

      input = ''
      result = nil
      while result.nil?
        puts move_message
        input = gets.chomp
        if valid_move_input?(input)
          result = board.move_an(input) 
          puts board.formatted_history
        end
      end

      board.swap_color
      break if game_over?

      until valid_save_load_input?(input)
        puts save_prompt_message
        input = gets.chomp
      end
      save(SAVE_PATH) if input.downcase == 'y'
    end
    puts board.formatted
    puts result
  end

  def save(fname)
    #create save file in YAML format
    save_file = File.open(fname, "w")
    save_file.puts YAML.dump({
      :board => board
    })
    save_file.close
    puts save_done_message
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

  def valid_save_load_input?(input)
    #returns true if input is y,Y,n, or N
    input.match?(/^[yY]|[nN]$/)
  end

  private

  def self.welcome_message
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

  def save_prompt_message
    str = ''
    str << " Would you like to save the game? Enter y/n."
    str
  end

  def save_done_message
    str = ''
    str << " Game saved. \n"
    str
  end
end