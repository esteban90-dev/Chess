require "./lib/piece.rb"

class Queen < Piece
=begin  
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'queen'
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

=end  

  private

  def default_symbol
    return "\u265b" if color == 'black'
    "\u2655"
  end

  def all_destinations(board, current_position)
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
    
    y_direction = [1,1,-1,-1]
    x_direction = [1,-1,1,-1]
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

end