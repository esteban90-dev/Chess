require "./lib/piece.rb"

class Knight < Piece
  public

  def reachable_destinations(board)
    current_position = board.location(self)
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
  
  private

  def default_symbol
    return "\u265e" if color == 'black'
    "\u2658"
  end
end

