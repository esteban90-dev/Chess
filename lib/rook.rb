require "./lib/piece.rb"

class Rook < Piece 
  public 

  def reachable_destinations(board, current_position)
    y_direction = [1,0,-1, 0]
    x_direction = [0,1, 0,-1]
    destinations = []
    i = 0
    
    while i < y_direction.length
      new_position = current_position
      loop do
        new_position = [new_position[0] + y_direction[i], new_position[1] + x_direction[i]]
        break unless board.valid_location?(new_position)
        break unless board.contents(new_position).nil?
        destinations << new_position
      end

      #if last position is on the board and contains an enemy piece, add it too
      if board.valid_location?(new_position) && board.contents(new_position)
        destinations << new_position if board.contents(new_position).color != board.active_color
      end
      i += 1
    end
    destinations
  end

  private

  def default_symbol
    return "\u265c" if color == 'black'
    "\u2656"
  end
end