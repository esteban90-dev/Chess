class Board
  attr_reader :history
  attr_accessor :grid, :active_color

  def initialize(input={})
    @grid = input.fetch(:grid, default_grid)
    @active_color = 'white'
    @history = []
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

  def move(source, destination)
    return 'invalid' if contents(source).nil?
    return 'invalid' if contents(source).color != active_color
    return 'invalid' unless contents(source).valid_destinations.include?(destination)
    captured_piece = nil

    #if this was a normal capture move, store captured enemy piece temporarily for history
    if !contents(destination).nil? && contents(destination).color != active_color
      captured_piece = contents(destination)
    end

    #if this was an en_passant move, store captured pawn temporarily for history
    if en_passant?(source, destination)
      if en_passant_pos?(source, destination)
        capture_position = [source[0], source[1] + 1]
        captured_piece = contents(capture_position)
        grid[source[0]][source[1] + 1] = nil
      elsif en_passant_neg?(source, destination)
        capture_position = [source[0], source[1] - 1]
        captured_piece = contents(capture_position)
        grid[source[0]][source[1] - 1] = nil
      end
    end

    #move piece to destination
    grid[destination[0]][destination[1]] = contents(source)
    grid[source[0]][source[1]] = nil

    #move rook too if this is a king that is castling

    #update history
    history << [contents(destination), source, destination, captured_piece]
  end

  def removes_check?(source, destination)
    return nil if !active_color_in_check?
    return nil if contents(source).nil?
    return nil if contents(source).color != active_color

    result = false
    temp = nil
    grid_snapshot = grid.clone

    #if this was a normal capture move, store capture enemy piece temporarily
    if !contents(destination).nil? && contents(destination).color != active_color
      temp = contents(destination)
    end

    #if this was an en_passant move, store captured pawn temporarily
    if en_passant?(source, destination)
      if en_passant_pos?(source, destination)
        capture_position = [source[0], source[0] + 1]
        temp = contents(capture_position)
        grid[source[0]][source[0] + 1] = nil
      elsif en_passant_neg?(source, destination)
        capture_position = [source[0], source[0] - 1]
        temp = contents(capture_position)
        grid[source[0]][source[0] + 1] = nil
      end
    end

    #move piece to destination
    grid[destination[0]][destination[1]] = contents(source)
    grid[source[0]][source[1]] = nil
    
    #see if check cleared
    result = true unless active_color_in_check?

    #put the grid back to where it was
    self.grid = grid_snapshot
    
    result
  end

  def en_passant?(source, destination)
    return true if en_passant_pos?(source, destination)
    return true if en_passant_neg?(source, destination)
    false
  end

  private

  def default_grid
    Array.new(8){ Array.new(8) }
  end

  def en_passant_pos?(source, destination)
    return false if contents(source).nil?
    return false unless contents(destination).nil?
    return false if contents(source).name != "pawn"
    return true if destination[0] - source[0] == -1 && destination[1] - source[1] == 1
    return true if destination[0] - source[0] == 1 && destination[1] - source[1] == 1
    false 
  end

  def en_passant_neg?(source, destination)
    return false if contents(source).nil?
    return false unless contents(destination).nil?
    return false if contents(source).name != "pawn"
    return true if destination[0] - source[0] == -1 && destination[1] - source[1] == -1
    return true if destination[0] - source[0] == 1 && destination[1] - source[1] == -1
    false 
  end
end






