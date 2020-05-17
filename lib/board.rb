class Board
  attr_reader :grid
  attr_accessor :active_color

  def initialize(input={})
    @grid = input.fetch(:grid, default_grid)
    @active_color = 'white'
  end

  public

  def contents(input)
    grid[input[0]][input[1]]
  end

  def location(piece)
    i = 0
    j = 0
    result = []
    while i < grid.length
      while j < grid[i].length
        result << [i,j] if grid[i][j] == piece
        j += 1
      end
      i += 1
      j = 0
    end
    return nil if result.empty?
    result    
  end

  def valid_location?(location)
    return false if location[0] < 0 || location[0] > grid.length
    return false if location[1] < 0 || location[1] > grid[0].length
    true
  end

  def swap_color
    if active_color == 'white'
      self.active_color = 'black' 
    else
      self.active_color = 'white'
    end
  end

  def allied_pieces
    grid.flatten.reject{ |element| element.nil? }.select{ |element| element.color == active_color }
  end

  def enemy_pieces
    grid.flatten.reject{ |element| element.nil? }.select{ |element| element.color != active_color }
  end

  def under_threat?(location)
    enemy_pieces.any?{ |piece| piece.valid_destinations.include?(location) }
  end

  def active_color_in_check?
    allied_king = allied_pieces.select{ |element| element.name == 'king' }.first
    allied_king_location = location(allied_king)
    return under_threat?(allied_king_location.first)
  end

  def removes_check?(source, destination)
    return nil if !active_color_in_check?
    return nil if contents(source).nil?
    return nil if contents(source).color != active_color

    result = false
    temp = nil

    #store capture enemy piece temporarily if applicable
    if !contents(destination).nil? && contents(destination).color != active_color
      temp = contents(destination)
    end

    #move piece
    grid[source[0]][source[1]] = nil
    grid[destination[0]][destination[1]] = contents(source) 

    #if this was an en_passant move, store captured pawn temporarily

    
  end

  def en_passant?(source, destination)
    return false if contents(source).nil?
    return false if contents(source).name != "pawn"
    return false if contents(destination)
    return true if (destination[1] - source[1]).abs == 1 && (destination[0] - source[0]).abs == 1
    false
  end

  private

  def default_grid
    Array.new(8){ Array.new(8) }
  end
end
