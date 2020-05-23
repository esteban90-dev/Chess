class Pawn
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'pawn'
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
    return "\u265f" if color == 'black'
    "\u2659"
  end

  def all_destinations(board, current_position)
    destinations = []

    #set direction: + if white, - if black
    direction = 1  if self.color == 'white'
    direction = -1 if self.color == 'black'

    #add cell in the +1 forward direction if empty
    forward_cell_position_1 = [current_position[0] + direction, current_position[1]]
    destinations << forward_cell_position_1 if board.contents(forward_cell_position_1).nil?

    #if pawn hasn't moved yet, and forward_cell_position_1 is empty - add cell in the +2 forward direction if empty
    if board.history.none?{ |entry| entry[0] == self }
      forward_cell_position_2 = [current_position[0] + (direction*2), current_position[1]]
      destinations << forward_cell_position_2 unless destinations.empty?
    end

    #add diagonal cell (+x direction) if it is a valid location and contains an enemy
    diagonal_cell_pos_position = [current_position[0] + direction, current_position[1] + 1]
    if board.valid_location?(diagonal_cell_pos_position) && board.contents(diagonal_cell_pos_position)
      destinations << diagonal_cell_pos_position if board.contents(diagonal_cell_pos_position).color != self.color
    end

    #add diagonal cell (-x direction) if it is a valid location and contains an enemy
    diagonal_cell_neg_position = [current_position[0] + direction, current_position[1] - 1]
    if board.valid_location?(diagonal_cell_neg_position) && board.contents(diagonal_cell_neg_position)
      destinations << diagonal_cell_neg_position if board.contents(diagonal_cell_neg_position).color != self.color
    end

    destinations
  end
end