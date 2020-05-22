class Knight
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'knight'
  end

  public

  def valid_destinations(board)
    current_position = board.location(self)

    #get all possible destinations
    destinations = all_destinations(board, current_position)

    #If in check, select only the locations that result in the removal of check
    if board.active_color_in_check?
      destinations.select!{ |destination| board.disables_check?(current_position, destination) } 
    end

    #If not in check, reject locations that would result in check
    if !board.active_color_in_check?
      destinations.reject!{ |destination| board.enables_check?(current_position, destination) }
    end

    destinations
  end

  private

  def default_symbol
    return "\u265e" if color == 'black'
    "\u2658"
  end

  def all_destinations(board, current_position)
    delta_x = [1,2,2,1,-1,-2,-2,-1]
    delta_y = [2,1,-1,-2,-2,-1,1,2]
    destinations = []
    i = 0

    while i < delta_x.length
      destinations << [ current_position[0] + delta_y[i], current_position[1] + delta_x[i] ]
      i += 1
    end

    #remove locations not on board
    destinations.select!{ |destination| board.valid_location?(destination) } 
    
    #remove locations that contain allies
    allied_locations = board.allied_pieces.map{ |ally| board.location(ally) }
    destinations.reject!{ |destination| allied_locations.include?(destination) }

    destinations
  end
end

