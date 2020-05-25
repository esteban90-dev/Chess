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
    result = result.first if result.length == 1
    result    
  end

  def valid_location?(location)
    return false if location[0] < 0 || location[0] > grid.length - 1
    return false if location[1] < 0 || location[1] > grid[0].length - 1
    true
  end

  def swap_color
    if active_color == 'white'
      self.active_color = 'black' 
    else
      self.active_color = 'white'
    end
  end

  def allied_pieces(color)
    grid.flatten.reject{ |element| element.nil? }.select{ |element| element.color == color }
  end

  def enemy_pieces(color)
    grid.flatten.reject{ |element| element.nil? }.select{ |element| element.color != color }
  end

  def active_color_in_check?
    #returns true if any enemy piece can reach the allied king's position
    allied_king = allied_pieces(active_color).select{ |element| element.name == 'king' }.first
    return false if allied_king.nil?
    allied_king_location = location(allied_king)
    return enemy_pieces(active_color).any?{ |piece| piece.reachable_destinations(self).include?(allied_king_location) }
  end

  def move(source, destination)
    #allow the usage of a block if you want custom guard logic
    if block_given?
      result = yield(source, destination)
    else
      result = check_move_input(source, destination)
    end

    if result
      history << result
      return
    end
  
    captured_piece = nil
    captured_position = nil

    #if this is a normal capture move, store captured enemy piece for history
    if !contents(destination).nil? && contents(destination).color != active_color
      captured_piece = contents(destination)
      captured_position = location(captured_piece)
    end

    #if this was an en_passant move, store captured pawn for history
    if en_passant?(source, destination)
      if en_passant_pos?(source, destination)
        captured_position = [source[0], source[1] + 1]
        captured_piece = contents(captured_position)
        grid[source[0]][source[1] + 1] = nil
      elsif en_passant_neg?(source, destination)
        captured_position = [source[0], source[1] - 1]
        captured_piece = contents(captured_position)
        grid[source[0]][source[1] - 1] = nil
      end
    end

    #move piece from source to destination
    grid[destination[0]][destination[1]] = contents(source)
    grid[source[0]][source[1]] = nil

    #update history
    history << [contents(destination), source, destination, captured_piece, captured_position]

    #move rook too if most recent move was castling
    king_side_castle_move if king_side_castling?(history.last)
    queen_side_castle_move if queen_side_castling?(history.last)
  end

  def disables_check?(source, destination)
    return nil if !active_color_in_check?
    result = false

    #make the move
    move(source, destination){ check_test_move_input(source, destination) }

    #see if check cleared
    result = true unless active_color_in_check?

    #put the grid back to where it was
    undo_last_move

    result
  end

  def enables_check?(source, destination)
    return nil if active_color_in_check?
    result = false
    
    #move piece to destination
    move(source, destination){ check_test_move_input(source, destination) }
    
    #see if check condition is active
    result = true if active_color_in_check?
  
    #put the grid back to where it was
    undo_last_move
    
    result
  end

  def formatted
    i = 0
    result = []
    letter_line = "  " + "   A    B    C    D    E    F    G    H   "
    border_line = "   " + "+----+----+----+----+----+----+----+----+"
    result << letter_line
    while i < grid.length
      result << border_line
      result << " #{grid.length - i} " + "| " + "#{grid[i].map{ |cell| cell.nil? ? "  " : formatted_symbol(cell.symbol) }.join(" | ")}" + 
        " |" + " #{grid.length - i} "
      i += 1
    end
    result << border_line
    result << letter_line
    result.join("\n")
  end

  def undo_last_move
    return nil if history.empty?

    if last_moves_castling?
      #move rook back to original position
      rook_piece = history.last[0]    
      rook_new_location = history.last[2]
      rook_old_location = history.last[1]
      grid[rook_new_location[0]][rook_new_location[1]] = nil
      grid[rook_old_location[0]][rook_old_location[1]] = rook_piece

      #move king back to original position
      king_piece = history[-2][0]
      king_new_location = history[-2][2]
      king_old_location = history[-2][1]
      grid[king_new_location[0]][king_new_location[1]] = nil
      grid[king_old_location[0]][king_old_location[1]] = king_piece

      #clear two history entries since castling spans two entries
      history.pop
      history.pop

    elsif last_move_en_passant?
      #move source piece back to original location
      piece = history.last[0]
      piece_new_location = history.last[2]
      piece_old_location = history.last[1]
      grid[piece_new_location[0]][piece_new_location[1]] = nil
      grid[piece_old_location[0]][piece_old_location[1]] = piece

      #replace captured pawn
      pawn = history.last[3]
      pawn_old_location = history.last[4]
      grid[pawn_old_location[0]][pawn_old_location[1]] = pawn

      #clear recent history entry
      history.pop

    else
      #this was a normal move
      #move source piece back to original location
      piece = history.last[0]
      piece_new_location = history.last[2]
      piece_old_location = history.last[1]
      grid[piece_new_location[0]][piece_new_location[1]] = nil
      grid[piece_old_location[0]][piece_old_location[1]] = piece

      #return captured piece (if applicable) back to original location
      captured_piece = history.last[3]
      if captured_piece
        captured_piece_old_location = history.last[4]
        grid[captured_piece_old_location[0]][captured_piece_old_location[1]] = captured_piece
      end

      #if no piece was captured, clear destination cell
      destination = history.last[2]
      if captured_piece.nil?
        grid[destination[0]][destination[1]] = nil
      end

      #clear recent history entry
      history.pop
    end
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

  def king_side_castling?(entry)
    #returns true if given history entry was a king moving two spaces to the right
    return true if entry[0].name == 'king' && entry[2][1] - entry[1][1] == 2 
    false
  end

  def king_side_castle_move
    rook_current_position = [history.last[2][0], history.last[2][1] + 1]
    rook_new_position = [history.last[2][0], history.last[2][1] - 1]
    move(rook_current_position, rook_new_position){ check_test_move_input(rook_current_position, rook_new_position) }
  end

  def last_moves_castling?
    #returns true if the last two entries in the history dealt with castling
    return false if history.empty?
    return false if history.length < 2
    return true if king_side_castling?(history[-2]) || queen_side_castling?(history[-2])
    false
  end

  def last_move_en_passant?
    #returns true if the last entry in the history was an en passant move
    return false if history.empty?
    return false if history.last[3].nil?
    return false if history.last[2] == history.last[4]
    true
  end

  def queen_side_castling?(entry)
    #returns true if given history entry was a king moving three spaces to the left
    return true if entry[0].name == 'king' && entry[2][1] - entry[1][1] == -3
    false
  end

  def queen_side_castle_move
    rook_current_position = [history.last[2][0], history.last[2][1] - 1]
    rook_new_position = [history.last[2][0], history.last[2][1] + 1]
    move(rook_current_position, rook_new_position){ check_test_move_input(rook_current_position, rook_new_position) }
  end

  def check_move_input(source, destination)
    return "invalid move - source cell empty" if contents(source).nil?
    return "invalid move - source cell contains enemy piece" if contents(source).color != active_color
    return "invalid move - source cell matches destination cell" if source == destination
    return "invalid move - #{contents(source).color} #{contents(source).name} can't move from #{source} to #{destination}" if !contents(source).moveable_destinations(self).include?(destination)
    nil
  end

  def check_test_move_input(source, destination)
    #if we are doing a test move as part of #enables_check?, #disables_check, or the automatic rook movement with castling,
    #then don't check moveable_destinations
    return "invalid move - source cell empty" if contents(source).nil?
    return "invalid move - source cell contains enemy piece" if contents(source).color != active_color
    return "invalid move - source cell matches destination cell" if source == destination
    nil
  end

  def formatted_symbol(symbol)
    symbol.length > 1 ? symbol : " " + "#{symbol}"
  end
end













