require "./lib/piece.rb"

class Pawn < Piece 
  public

  def reachable_destinations(board, current_position)
    destinations = []

    #set direction: + if white, - if black
    y_direction = -1  if self.color == 'white'
    y_direction = 1 if self.color == 'black'

    #add cell in the +1 y_direction if empty
    forward_cell_position_1 = [current_position[0] + y_direction, current_position[1]]
    destinations << forward_cell_position_1 if board.contents(forward_cell_position_1).nil?

    #if pawn hasn't moved yet, and forward_cell_position_1 is empty - add cell in the +2 y_direction if empty
    if board.history.none?{ |entry| entry[0] == self }
      forward_cell_position_2 = [current_position[0] + (y_direction*2), current_position[1]]
      destinations << forward_cell_position_2 unless destinations.empty?
    end

    #add adjacent diagonal cell (+x direction) if it is a valid location and contains an enemy, or if empty cell and en_passant is allowed
    diagonal_pos_position = [current_position[0] + y_direction, current_position[1] + 1]
    if board.valid_location?(diagonal_pos_position) && board.contents(diagonal_pos_position)
      destinations << diagonal_pos_position if board.contents(diagonal_pos_position).color != self.color
    elsif board.valid_location?(diagonal_pos_position) && board.contents(diagonal_pos_position).nil?
      destinations << diagonal_pos_position if en_passant_allowed?(board, current_position, 1)
    end

    #add adjacent diagonal cell (-x direction) if it is a valid location and contains an enemy, or if empty cell and en_passant is allowed
    diagonal_neg_position = [current_position[0] + y_direction, current_position[1] - 1]
    if board.valid_location?(diagonal_neg_position) && board.contents(diagonal_neg_position)
      destinations << diagonal_neg_position if board.contents(diagonal_neg_position).color != self.color
    elsif board.valid_location?(diagonal_neg_position) && board.contents(diagonal_neg_position).nil?
      destinations << diagonal_neg_position if en_passant_allowed?(board, current_position, -1)
    end

    destinations
  end

  private

  def default_symbol
    return "\u265f" if color == 'black'
    "\u2659"
  end

  def en_passant_allowed?(board, current_position, x_direction)
    #set direction: + if white, - if black
    y_direction = -1  if self.color == 'white'
    y_direction = 1 if self.color == 'black'

    #this pawn must be on his 5th rank
    return false if current_position[0] != 3 if self.color == 'white'
    return false if current_position[0] != 4 if self.color == 'black'

    #the adjacent diagonal cell must be empty
    diagonal_position = [current_position[0] + y_direction, current_position[1] + x_direction]
    return false unless board.contents(diagonal_position).nil?

    #there must be an enemy pawn in the adjacent cell
    enemy_position = [current_position[0], current_position[1] + x_direction]
    contents = board.contents(enemy_position)
    return false if contents.nil? || contents.color == self.color || contents.name != 'pawn'
    
    #the adjacent enemy pawn should only have moved once
    return false unless board.history.count{ |entry| entry[0] == contents} == 1
    
    #the adjacent enemy pawn move should be the most recent move made
    return false unless board.history.last[0] == contents
    true
  end
end