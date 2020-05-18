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
    destinations = all_moves(current_position)
    
    #remove locations not on board
    destinations.select!{ |destination| board.valid_location?(destination) } 
    
    #remove locations that contain allies
    destinations.reject!{ |destination| board.allied_pieces.include?(destination) }

    #If in check, select only the locations that result in the removal of check
    if board.active_color_in_check?
      destinations.select!{ |destination| board.removes_check?(current_position, destination) } 
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
      result << [ position.first[0] + delta_y[i], position.first[1] + delta_x[i] ]
      i += 1
    end
    result
  end


end


require "./lib/board.rb"
black_knight = Knight.new({:color=>"black"})
grid = Array.new(8){ Array.new(8) }
grid[0][0] = black_knight
board1 = Board.new({:grid=>grid})
puts black_knight.valid_destinations(board1)