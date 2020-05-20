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
    destinations = diagonals(board, current_position)
    destinations
  end

  private

  def default_symbol
    return "\u265d" if color == 'black'
    "\u2657"
  end

  def diagonals(board, position)
    #return all diagonal positions until 
    #board limit or another piece is reached.  
    current_position = position
    result = []
    i = 0
    y_direction = [1,1,-1,-1]
    x_direction = [1,-1,1,-1]
    
    while i < y_direction.length
      loop do
        current_position = [current_position[0] + y_direction[i], current_position[1] + x_direction[i]]
        break unless board.valid_location?(current_position)
        break unless board.contents(current_position).nil?
        result << current_position
      end

      #if last position is on the board and contains an enemy piece, add it too
      if board.valid_location?(current_position) && board.contents(current_position)
        result << current_position if board.contents(current_position).color != board.active_color
      end

      current_position = position
      i += 1
    end
    result
  end

end