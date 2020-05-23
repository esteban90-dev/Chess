class Piece
attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = input.fetch(:name, self.class.to_s.downcase )
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
    raise NotImplementedError.new('You must implement #default_symbol')
  end

  def all_destinations(board, current_position)
    raise NotImplementedError.new('You must implement #all_destinations')
  end
end


