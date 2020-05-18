class Board
  attr_accessor :grid, :active_color, :history

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
    return false if allied_king.nil?
    allied_king_location = location(allied_king)
    return under_threat?(allied_king_location.first)
  end

  def move(source, destination)
    result = check_input(source, destination)
    if result
      history << result
      return
    end
  
    captured_piece = nil

    #if this is a normal capture move, store captured enemy piece for history
    if !contents(destination).nil? && contents(destination).color != active_color
      captured_piece = contents(destination)
    end

    #if this was an en_passant move, store captured pawn for history
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

    #move piece from source to destination
    grid[destination[0]][destination[1]] = contents(source)
    grid[source[0]][source[1]] = nil

    #update history
    history << [contents(destination), source, destination, captured_piece]

    #move rook too if most recent move was castling
    king_side_castle_move if king_side_castling?
    queen_side_castle_move if queen_side_castling?
  end

  def removes_check?(source, destination)
    return nil if !active_color_in_check?
    return nil if contents(source).nil?
    return nil if contents(source).color != active_color

    result = false
    grid_snapshot = grid.clone
    history_snapshot = history.clone

    #move piece to destination
    move(source, destination)
    
    #see if check cleared
    result = true unless active_color_in_check?

    #return the grid and history back to where it was
    self.grid = grid_snapshot
    self.history = history_snapshot
    
    result
  end

  private

  def default_grid
    Array.new(8){ Array.new(8) }
  end

  def en_passant?(source, destination)
    return true if en_passant_pos?(source, destination)
    return true if en_passant_neg?(source, destination)
    false
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

  def king_side_castling?
    #returns true if last move was a king moving two spaces to the right
    return true if history.last[0].name == 'king' && history.last[2][1] - history.last[1][1] == 2 
    false
  end

  def king_side_castle_move
    rook_current_position = [history.last[2][0], history.last[2][1] + 1]
    rook_new_position = [history.last[2][0], history.last[2][1] - 1]
    move(rook_current_position, rook_new_position)
  end

  def queen_side_castling?
    #returns true if last move was a king moving three spaces to the left
    return true if history.last[0].name == 'king' && history.last[2][1] - history.last[1][1] == -3
    false
  end

  def queen_side_castle_move
    rook_current_position = [history.last[2][0], history.last[2][1] - 1]
    rook_new_position = [history.last[2][0], history.last[2][1] + 1]
    move(rook_current_position, rook_new_position)
  end

  def check_input(source, destination)
    return "invalid move - source cell empty" if contents(source).nil?
    return "invalid move - source cell contains enemy piece" if contents(source).color != active_color
    return "invalid move - source cell matches destination cell" if source == destination
    return "invalid move - #{contents(source).color} #{contents(source).name} can't move from #{source} to #{destination}" if !contents(source).valid_destinations.include?(destination)
    nil
  end
end












