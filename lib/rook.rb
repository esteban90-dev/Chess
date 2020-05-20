class Rook
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'rook'
  end

  public

  def valid_destinations(board)
    #get all moves
    current_position = board.location(self)
    destinations = []
    destinations = horz_vert(board, current_position)

    #If in check, select only the locations that result in the removal of check
    if board.active_color_in_check?
      destinations.select!{ |destination| board.disables_check?(current_position, destination) } 
    end

    #If not in check, reject locations that would result in check
    if !board.active_color_in_check?
      destinations.each{ |destination| board.enables_check?(current_position, destination) }
    end

    destinations
  end

  private

  def horz_vert(board, position)
    #return all horizontal and vertical positions until 
    #board limit or another piece is reached.  
    current_position = position
    result = []
    i = 0
    y_direction = [1,0,-1, 0]
    x_direction = [0,1, 0,-1]
    
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

  def default_symbol
    return "\u265c" if color == 'black'
    "\u2656"
  end

end