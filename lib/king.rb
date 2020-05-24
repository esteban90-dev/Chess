require "./lib/piece.rb"

class King < Piece
  public

  def reachable_destinations(board, current_position)
    delta_y = [1, 1, 0,-1,-1,-1,0,1]
    delta_x = [0,-1,-1,-1, 0, 1,1,1]
    destinations = []
    i = 0

    while i < delta_y.length
      new_position = [current_position[0] + delta_y[i], current_position[1] + delta_x[i]]
      destinations << new_position
      i += 1
    end

    #add location if kingside castling is allowed
    destinations << [current_position[0], current_position[1] + 2] if kingside_castling_allowed?(board, current_position)

    #add location if queenside castling is allowed
    destinations << [current_position[0], current_position[1] - 3] if queenside_castling_allowed?(board, current_position)

    #remove locations not on board
    destinations.select!{ |destinations| board.valid_location?(destinations) } 

    #remove locations that contain allies
    allied_locations = board.allied_pieces.map{ |ally| board.location(ally) }
    destinations.reject!{ |move| allied_locations.include?(move) }

    destinations
  end

  private

  def default_symbol
    return "\u265a" if color == 'black'
    "\u2654"
  end

  def kingside_castling_allowed?(board, current_position)
    return false if board.history.any?{ |entry| entry[0] == self }
    rook_position = [current_position[0], current_position[1] + 3]
    return false unless castling_rook?(board, rook_position)
    return false unless row_space_between?(board, current_position, rook_position)
    true
  end

  def queenside_castling_allowed?(board, current_position)
    return false if board.history.any?{ |entry| entry[0] == self }
    rook_position = [current_position[0], current_position[1] - 4]
    return false unless castling_rook?(board, rook_position)
    return false unless row_space_between?(board, current_position, rook_position)
    true
  end

  def castling_rook?(board, rook_position)
    return false if board.contents(rook_position).nil?
    return false if board.contents(rook_position).name != "rook"
    return false if board.history.any?{ |entry| entry[0] == board.contents(rook_position) }
    true
  end

  def row_space_between?(board, position_1, position_2)
    return false if position_1 == position_2
    result = 0
    if position_1[1] < position_2[1]
      current_position = position_1
      direction = 1
      until current_position == position_2
        result = true
        result = false if board.contents(current_position)
        current_position = [current_position[0],current_position[1] + direction]
      end
    else
      current_position = position_2
      direction = -1
      until current_position == position_2
        result = true
        result = false if board.contents(current_position)
        current_position = [current_position[0],current_position[1] + direction]
      end
    end
    result
  end

end