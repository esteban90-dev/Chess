class Bishop
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'bishop'
  end

  public

  def valid_destinations(board)
    #get all moves
    current_position = board.location(self)
    destinations = []
    destinations += diag_posy_posx(board, current_position)
    destinations += diag_posy_negx(board, current_position)
    destinations += diag_negy_posx(board, current_position)
    destinations += diag_negy_negx(board, current_position)
    destinations
  end

  private

  def default_symbol
    return "\u265d" if color == 'black'
    "\u2657"
  end

  def diag_posy_posx(board, position)
    #return all positions starting from position and moving in the +y+x until
    #the board limit or another piece is reached.  
    current_position = position
    result = []

    loop do
      current_position = [current_position[0] + 1, current_position[1] + 1]
      break unless board.valid_location?(current_position)
      break unless board.contents(current_position).nil?
      result << current_position
    end

    #if last position is on the board and contains an enemy piece, add it too
    if board.valid_location?(current_position) && board.contents(current_position)
      result << current_position if board.contents(current_position).color == board.active_color
    end
    result
  end

  def diag_posy_negx(board, position)
    #return all positions starting from position and moving in the +y-x until
    #the board limit or another piece is reached.  
    current_position = position
    result = []

    loop do
      current_position = [current_position[0] + 1, current_position[1] - 1]
      break unless board.valid_location?(current_position)
      break unless board.contents(current_position).nil?
      result << current_position
    end

    #if last position is on the board and contains an enemy piece, add it too
    if board.valid_location?(current_position) && board.contents(current_position)
      result << current_position if board.contents(current_position).color == board.active_color
    end
    result
  end

  def diag_negy_posx(board, position)
    #return all positions starting from position and moving in the -y+x until
    #the board limit or another piece is reached.  
    current_position = position
    result = []

    loop do
      current_position = [current_position[0] - 1, current_position[1] + 1]
      break unless board.valid_location?(current_position)
      break unless board.contents(current_position).nil?
      result << current_position
    end

    #if last position is on the board and contains an enemy piece, add it too
    if board.valid_location?(current_position) && board.contents(current_position)
      result << current_position if board.contents(current_position).color == board.active_color
    end
    result
  end

  def diag_negy_negx(board, position)
    #return all positions starting from position and moving in the -y-x until
    #the board limit or another piece is reached.  
    current_position = position
    result = []

    loop do
      current_position = [current_position[0] - 1, current_position[1] - 1]
      break unless board.valid_location?(current_position)
      break unless board.contents(current_position).nil?
      result << current_position
    end

    #if last position is on the board and contains an enemy piece, add it too
    if board.valid_location?(current_position) && board.contents(current_position)
      result << current_position if board.contents(current_position).color == board.active_color
    end
    result
  end

end