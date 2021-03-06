require "./lib/board_extras.rb"

class Board
  attr_accessor :grid, :active_color, :history

  def initialize(input={})
    @grid = input.fetch(:grid, build_grid)
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

  def move_an(input)
    source, destination = translate_coordinates(input)
    return move_yx(source, destination)
  end

  def move_yx(source, destination)
    #allow the usage of a block if you want custom guard logic
    if block_given?
      result = yield(source, destination)
    else
      result = check_move_input(source, destination)
    end

    if result
      history << result
      #return nil if move unsuccessful
      return nil
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
        place(captured_position, nil)
      elsif en_passant_neg?(source, destination)
        captured_position = [source[0], source[1] - 1]
        captured_piece = contents(captured_position)
        place(captured_position, nil)
      end
    end

    #move piece from source to destination
    place(destination, contents(source))
    place(source, nil)

    #update history
    history << [contents(destination), source, destination, captured_piece, captured_position]

    #move rook too if most recent move was castling
    king_side_castle_move if king_side_castling?(history.last)
    queen_side_castle_move if queen_side_castling?(history.last)

    #return 1 if successful move
    1
  end

  def disables_check?(source, destination)
    return nil if !active_color_in_check?
    result = false

    #make the move
    move_yx(source, destination){ check_test_move_input(source, destination) }

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
    move_yx(source, destination){ check_test_move_input(source, destination) }
    
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

  def formatted_history
    return nil if history.length == 0
    return history.last if history.last.class == String
    result = "#{history.last[0].color} #{history.last[0].name} moved from #{yx_to_an(history.last[1])} to #{yx_to_an(history.last[2])}"
    result << " and captured #{history.last[3].color} #{history.last[3].name}" unless history.last[3].nil?
    result
  end

  def undo_last_move
    return nil if history.empty?

    if last_moves_castling?
      #move rook back to original position
      rook_piece = history.last[0]    
      rook_new_location = history.last[2]
      rook_old_location = history.last[1]
      place(rook_new_location, nil)
      place(rook_old_location, rook_piece)

      #move king back to original position
      king_piece = history[-2][0]
      king_new_location = history[-2][2]
      king_old_location = history[-2][1]
      place(king_new_location, nil)
      place(king_old_location, king_piece)

      #clear two history entries since castling spans two entries
      history.pop
      history.pop

    elsif last_move_en_passant?
      #move source piece back to original location
      piece = history.last[0]
      piece_new_location = history.last[2]
      piece_old_location = history.last[1]
      place(piece_new_location, nil)
      place(piece_old_location, piece)

      #replace captured pawn
      pawn = history.last[3]
      pawn_old_location = history.last[4]
      #grid[pawn_old_location[0]][pawn_old_location[1]] = pawn
      place(pawn_old_location, pawn)

      #clear recent history entry
      history.pop

    else
      #this was a normal move
      #move source piece back to original location
      piece = history.last[0]
      piece_new_location = history.last[2]
      piece_old_location = history.last[1]
      place(piece_new_location, nil)
      place(piece_old_location, piece)

      #return captured piece (if applicable) back to original location
      captured_piece = history.last[3]
      if captured_piece
        captured_piece_old_location = history.last[4]
        place(captured_piece_old_location, captured_piece)
      end

      #if no piece was captured, clear destination cell
      destination = history.last[2]
      if captured_piece.nil?
        place(destination, nil)
      end

      #clear recent history entry
      history.pop
    end
  end

  def checkmate?
    #returns true if the active color is in check and all allied pieces have no valid moves
    return false unless active_color_in_check?
    return true unless allied_pieces(active_color).any?{ |piece| piece.moveable_destinations(self).length > 0 }
    false
  end

  def stalemate?
    #returns true if the active color is not in check and all allied pieces have no valid moves
    return false if active_color_in_check?
    return false if allied_pieces(active_color).any?{ |piece| piece.moveable_destinations(self).length > 0 }
    true
  end

  def promotion?
    #returns true if a pawn reaches the other side of the board
    return true if grid[0].any?{ |element| element.nil? ? false : element.color == 'white' && element.name == 'pawn' }
    return true if grid[7].any?{ |element| element.nil? ? false : element.color == 'black' && element.name == 'pawn' }
    false
  end

  def promote(selection)
    return nil unless promotion?
    promotion_location = location(history.last[0])
    place(promotion_location, create_piece(selection))
  end

  def place(location, input)
    return nil unless valid_location?(location)
    grid[location[0]][location[1]] = input
  end

  def an_to_yx(input)
    grid_map[input]
  end

  def yx_to_an(input)
    grid_map.key(input)
  end

  private

  def build_grid
    default_grid
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
    return false if history.empty?
    return false if entry.include?('invalid')
    return true if entry[0].name == 'king' && entry[2][1] - entry[1][1] == 2 
    false
  end

  def king_side_castle_move
    rook_current_position = [history.last[2][0], history.last[2][1] + 1]
    rook_new_position = [history.last[2][0], history.last[2][1] - 1]
    move_yx(rook_current_position, rook_new_position){ check_test_move_input(rook_current_position, rook_new_position) }
  end

  def queen_side_castling?(entry)
    #returns true if given history entry was a king moving three spaces to the left
    return false if history.empty?
    return false if entry.include?('invalid')
    return true if entry[0].name == 'king' && entry[2][1] - entry[1][1] == -3
    false
  end

  def queen_side_castle_move
    rook_current_position = [history.last[2][0], history.last[2][1] - 1]
    rook_new_position = [history.last[2][0], history.last[2][1] + 1]
    move_yx(rook_current_position, rook_new_position){ check_test_move_input(rook_current_position, rook_new_position) }
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

  def check_move_input(source, destination)
    return "invalid move - source cell empty" if contents(source).nil?
    return "invalid move - source cell contains enemy piece" if contents(source).color != active_color
    return "invalid move - source cell matches destination cell" if source == destination
    return "invalid move - #{contents(source).color} #{contents(source).name} can't move from #{yx_to_an(source)} to #{yx_to_an(destination)}" if !contents(source).moveable_destinations(self).include?(destination)
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

  def create_piece(selection, color=active_color)
    case selection
    when 'pawn'
      return Pawn.new({:color => color, :symbol=> color == "white" ? "P" : "P*" })
    when 'rook'
      return Rook.new({:color => color, :symbol=> color == "white" ? "R" : "R*" })
    when 'knight'
      return Knight.new({:color => color, :symbol=> color == "white" ? "N" : "N*" })
    when 'bishop'
      return Bishop.new({:color => color, :symbol=> color == "white" ? "B" : "B*" })
    when 'queen'
      return Queen.new({:color => color, :symbol=> color == "white" ? "Q" : "Q*" })
    end
  end

  def translate_coordinates(input)
    result = []
    source = an_to_yx(input[0..1])
    destination = an_to_yx(input[3..4])
    result << source
    result << destination
    result
  end
end













