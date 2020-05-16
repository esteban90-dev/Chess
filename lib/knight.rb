class Knight
  attr_reader :color, :symbol

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
  end

  public

  def valid_destinations(board)
    current_position = board.location(self)
    destinations = all_moves(current_position)

    #remove locations not on board
    destinations.reject!{ |destination| !board.valid_location?(destination) } 
    
    #remove locations that contain allies
    destinations.reject!{ |destination| board.contents.nil? ? false : board.contents(destination).color == self.color } 

    #If in check, remove any locations that don't result in the removal of check
    if board.active_color_in_check?
      destinations.reject!{ |destination| !board.removes_check?(current_position, destination) } 
    end

    destinations
  end

  private

  def default_symbol
    return "\u265e" if color == 'black'
    "\u2658"
  end

  def all_moves(position)
    #given the grid location, return all possible moves that the knight could make
    delta_x = [1,2,2,1,-1,-2,-2,-1]
    delta_y = [2,1,-1,-2,-2,-1,1,2]
    result = []
    i = 0
    while i < delta_x.length
      result << [ position[0] + delta_y[i], position[1] + delta_x[i] ]
      i += 1
    end
    result
  end


end
