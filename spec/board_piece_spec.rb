require "./lib/board.rb"
require "./lib/piece.rb"
require "./lib/pawn.rb" 
require "./lib/knight.rb"
require "./lib/king.rb"
require "./lib/bishop.rb"
require "./lib/queen.rb"
require "./lib/rook.rb"
 
describe "Board-Piece integration" do 

  let(:empty_grid) { Array.new(8){ Array.new(8) } }

  context "Board#active_color_in_check?" do
    it "returns true if the active color's (white) king position can be reached by any enemy pieces" do
      black_queen = Queen.new({:color=>'black'})
      white_king = King.new({:color=>'white'})
      empty_grid[0][3] = black_queen
      empty_grid[3][3] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.active_color_in_check?).to eql(true)
    end

    it "returns true if the active color's (black) king position can be reached by any enemy pieces" do
      white_queen = Queen.new({:color=>'white'})
      black_king = King.new({:color=>'black'})
      empty_grid[0][3] = white_queen
      empty_grid[3][3] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.active_color_in_check?).to eql(true)
    end

    it "returns false if the active color's (white) king position can't be reached by any enemy pieces" do
      black_queen = Queen.new({:color=>'black'})
      white_king = King.new({:color=>'white'})
      empty_grid[0][3] = black_queen
      empty_grid[3][2] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.active_color_in_check?).to eql(false)
    end

    it "returns false if the active color's (black) king position can't be reached by any enemy pieces" do
      white_queen = Queen.new({:color=>'white'})
      black_king = King.new({:color=>'black'})
      empty_grid[0][3] = white_queen
      empty_grid[3][2] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.active_color_in_check?).to eql(false)
    end

    it "returns false if there is no allied king on the board - for testing purposes" do
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.active_color_in_check?).to eql(false)
    end
  end

  context "Board#disables_check?" do
    it "returns true if the active color is in check and the given move disables a check condition" do
      black_queen = Queen.new({:color=>'black'})
      white_king = King.new({:color=>'white'})
      empty_grid[0][3] = black_queen
      empty_grid[3][3] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.disables_check?([3,3],[3,4])).to eql(true)
    end

    it "returns nil if the active color is not in check" do 
      white_king = King.new({:color=>'white'})
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[3][7] = white_pawn
      empty_grid[4][0] = white_king
      empty_grid[3][6] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.disables_check?([3,7],[2,6])).to eql(nil)
    end
  end

  context "Board#enables_check?" do
    it "returns true if the active color is not check and the given move enables a check condition" do
      black_king = King.new({:color=>'black'})
      white_rook = Rook.new({:color=>'white'})
      empty_grid[2][5] = white_rook
      empty_grid[4][4] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.enables_check?([4,4],[4,5])).to eql(true)
    end

    it "returns nil if the active color is already in check" do 
      white_king = King.new({:color=>'white'})
      black_rook = Rook.new({:color=>'black'})
      empty_grid[2][5] = black_rook
      empty_grid[4][5] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.enables_check?([4,5],[4,6])).to eql(nil)
    end
  end

  context "Board#move_yx" do
    it "moves a white piece that makes no capture" do
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[6][1] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.move_yx([6,1],[5,1])
      expect(board1.history.last).to eql([white_pawn, [6,1], [5,1], nil, nil])
    end

    it "moves a white piece to capture a black piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[6][1] = white_pawn
      empty_grid[5][2] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.move_yx([6,1],[5,2])
      expect(board1.history.last).to eql([white_pawn, [6,1], [5,2], black_pawn, [5,2]])
    end

    it "moves a black piece that makes no capture" do
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[1][1] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move_yx([1,1],[3,1])
      expect(board1.history.last).to eql([black_pawn, [1,1], [3,1], nil, nil])
    end

    it "moves a black piece to capture a white piece" do
      black_pawn = Pawn.new({:color=>'black'})
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[3][3] = black_pawn
      empty_grid[4][4] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move_yx([3,3],[4,4])
      expect(board1.history.last).to eql([black_pawn, [3,3], [4,4], white_pawn, [4,4]])
    end

    it "moves a white pawn en_passant (+x direction) to capture a black piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[3][3] = white_pawn
      empty_grid[3][4] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [black_pawn, [4,1], [4,3], nil, nil]
      board1.move_yx([3,3],[2,4])
      expect(board1.history.last).to eql([white_pawn, [3,3], [2,4], black_pawn, [3,4]])
    end

    it "moves a white pawn en_passant (-x direction) to capture a black piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[3][4] = white_pawn
      empty_grid[3][3] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [black_pawn, [3,1], [3,3], nil, nil]
      board1.move_yx([3,4],[2,3])
      expect(board1.history.last).to eql([white_pawn, [3,4], [2,3], black_pawn, [3,3]])
    end

    it "moves a black pawn en_passant (+x direction) to capture a white piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[4][1] = black_pawn
      empty_grid[4][2] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn, [6,2], [6,4], nil, nil]
      board1.swap_color
      board1.move_yx([4,1],[5,2])
      expect(board1.history.last).to eql([black_pawn, [4,1], [5,2], white_pawn, [4,2]])
    end

    it "moves a black pawn en_passant (-x direction) to capture a white piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[4][3] = black_pawn
      empty_grid[4][2] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn, [6,2], [6,4], nil, nil]
      board1.swap_color
      board1.move_yx([4,3],[5,2])
      expect(board1.history.last).to eql([black_pawn, [4,3], [5,2], white_pawn, [4,2]])
    end

    it "moves a king and a rook in a king side castling move (white)" do
      white_king = King.new({:color=>'white'})
      white_rook_1 = Rook.new({:color=>'white'})
      white_rook_2 = Rook.new({:color=>'white'})
      empty_grid[7][0] = white_rook_2
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook_1
      board1 = Board.new({:grid=>empty_grid})
      board1.move_yx([7,4],[7,6])
      expect(board1.history[0..1]).to eql([[white_king, [7,4], [7,6], nil, nil], [white_rook_1, [7,7], [7,5], nil, nil]])
    end

    it "moves a king and a rook in a king side castling move (black)" do
      black_king = King.new({:color=>'black'})
      black_rook_1 = Rook.new({:color=>'black'})
      black_rook_2 = Rook.new({:color=>'black'})
      empty_grid[0][0] = black_rook_2
      empty_grid[0][4] = black_king
      empty_grid[0][7] = black_rook_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move_yx([0,4],[0,6])
      expect(board1.history[0..1]).to eql([[black_king, [0,4], [0,6], nil, nil], [black_rook_1, [0,7], [0,5], nil, nil]])
    end

    it "moves a king and a rook in a queen side castling move (white)" do
      white_king = King.new({:color=>'white'})
      white_rook_1 = Rook.new({:color=>'white'})
      white_rook_2 = Rook.new({:color=>'white'})
      empty_grid[7][0] = white_rook_2
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook_1
      board1 = Board.new({:grid=>empty_grid})
      board1.move_yx([7,4],[7,1])
      expect(board1.history[0..1]).to eql([[white_king, [7,4], [7,1], nil, nil], [white_rook_2, [7,0], [7,2], nil, nil]])
    end

    it "moves a king and a rook in a queen side castling move (black)" do
      black_king = King.new({:color=>'black'})
      black_rook_1 = Rook.new({:color=>'black'})
      black_rook_2 = Rook.new({:color=>'black'})
      empty_grid[0][0] = black_rook_2
      empty_grid[0][4] = black_king
      empty_grid[0][7] = black_rook_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move_yx([0,4],[0,1])
      expect(board1.history[0..1]).to eql([[black_king, [0,4], [0,1], nil, nil], [black_rook_2, [0,0], [0,2], nil, nil]])
    end

    it "records error message if the source cell is empty" do
      board1 = Board.new({:grid=>empty_grid})
      board1.move_yx([0,0],[1,0])
      expect(board1.history.last).to eql("invalid move - source cell empty")
    end

    it "records error message if the source cell is an enemy piece" do
      black_rook = Rook.new({:color=>'black'})
      empty_grid[0][4] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.move_yx([0,4],[0,5])
      expect(board1.history.last).to eql("invalid move - source cell contains enemy piece")
    end

    it "records error message if the source cell matches the destination cell" do
      black_rook = Rook.new({:color=>'black'})
      empty_grid[0][4] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move_yx([0,4],[0,4])
      expect(board1.history.last).to eql("invalid move - source cell matches destination cell")
    end

    it "records error message if the source piece can't move to the destination" do
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[6][1] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.move_yx([6,1],[3,1])
      expect(board1.history.last).to eql("invalid move - white pawn can't move from [6, 1] to [3, 1]")
    end
  end

  context "Board#move_an" do
    it "makes a move when the source/destination is supplied in algebraic notation" do
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[6][1] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.move_an('b2:b4')
      expect(board1.grid[4][1]).to eql(white_pawn)
    end
  end

  context "Board#undo_last_move" do 
    it "undoes the previous move - regular move, no capture" do
      white_bishop = Bishop.new({:color=>"white"})
      empty_grid[7][2] = white_bishop
      board1 = Board.new({:grid=>empty_grid})
      original_board = board1.formatted
      board1.move_yx([7,2],[5,4])
      board1.undo_last_move
      expect(board1.formatted).to eql(original_board)
    end

    it "undoes the previous move - regular move, with capture" do
      black_rook = Rook.new({:color=>"black"})
      white_pawn = Pawn.new({:color=>"white"})
      empty_grid[0][0] = black_rook
      empty_grid[6][0] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      original_board = board1.formatted
      board1.move_yx([0,0],[6,0])
      board1.undo_last_move
      expect(board1.formatted).to eql(original_board)
    end

    it "undoes the previous move - en_passant +x direction" do
      black_pawn = Pawn.new({:color=>"black"})
      white_pawn = Pawn.new({:color=>"white"})
      empty_grid[3][1] = black_pawn
      empty_grid[3][0] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [black_pawn, [1,1], [3,1], nil, nil]
      original_board = board1.formatted
      board1.move_yx([3,0],[2,1])
      board1.undo_last_move
      expect(board1.formatted).to eql(original_board)
    end

    it "undoes the previous move - en_passant +x direction" do
      black_pawn = Pawn.new({:color=>"black"})
      white_pawn = Pawn.new({:color=>"white"})
      empty_grid[4][6] = black_pawn
      empty_grid[4][5] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.history << [white_pawn, [6,5], [4,5], nil, nil]
      original_board = board1.formatted
      board1.move_yx([4,6],[5,5])
      board1.undo_last_move
      expect(board1.formatted).to eql(original_board)
    end

    it "undoes the previous move - kingside castling" do
      white_king = King.new({:color=>"white"})
      white_rook_1 = Rook.new({:color=>"white"})
      white_rook_2 = Rook.new({:color=>"white"})
      empty_grid[0][0] = white_rook_1
      empty_grid[0][4] = white_king
      empty_grid[0][7] = white_rook_2
      board1 = Board.new({:grid=>empty_grid})
      original_board = board1.formatted
      board1.move_yx([0,4],[0,6])
      board1.undo_last_move
      expect(board1.formatted).to eql(original_board)
    end

    it "undoes the previous move - queenside castling" do
      black_king = King.new({:color=>"black"})
      black_rook_1 = Rook.new({:color=>"black"})
      black_rook_2 = Rook.new({:color=>"black"})
      empty_grid[7][0] = black_rook_1
      empty_grid[7][4] = black_king
      empty_grid[7][7] = black_rook_2
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      original_board = board1.formatted
      board1.move_yx([7,4],[7,1])
      board1.undo_last_move
      expect(board1.formatted).to eql(original_board)
    end

    it "returns nil if the board history is empty" do
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.undo_last_move).to eql(nil)
    end
  end

  context "Board#checkmate?" do
    it "returns true if black is in check and there are no moves that can be made to remove check" do
      black_king = King.new({:color=>"black"})
      white_rook = Rook.new({:color=>"white"})
      white_queen = Queen.new({:color=>"white"})
      empty_grid[0][4] = black_king
      empty_grid[1][0] = white_queen
      empty_grid[0][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.checkmate?).to eql(true)
    end

    it "returns true if white is in check and there are no moves that can be made to remove check" do
      white_king = King.new({:color=>"white"})
      black_queen = Queen.new({:color=>"black"})
      black_knight = Knight.new({:color=>"black"})
      black_pawn = Pawn.new({:color=>"black"})
      empty_grid[5][0] = black_queen
      empty_grid[5][2] = black_knight
      empty_grid[5][3] = black_pawn
      empty_grid[7][1] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.checkmate?).to eql(true)
    end
  end

  context "Board#stalemate" do
    it "returns true if black is not in check but there are no legal moves that can be made" do
      white_king = King.new({:color=>"white"})
      black_king = King.new({:color=>"black"})
      white_bishop = Bishop.new({:color=>"white"})
      empty_grid[3][0] = black_king
      empty_grid[3][1] = white_bishop
      empty_grid[3][2] = white_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.stalemate?).to eql(true)
    end

    it "returns true if white is not in check but there are no legal moves that can be made" do
      white_king = King.new({:color=>"white"})
      black_queen = Queen.new({:color=>"black"})
      black_knight = Knight.new({:color=>"black"})
      empty_grid[5][4] = black_knight
      empty_grid[7][4] = white_king
      empty_grid[6][6] = black_queen
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.stalemate?).to eql(true)
    end
  end

  context "Board#promotion?" do
    it "returns true if a white pawn reaches the other side of the board" do
      white_pawn = Pawn.new({:color=>"white"})
      empty_grid[0][4] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.promotion?).to eql(true)
    end

    it "returns true if a black pawn reaches the other side of the board" do
      black_pawn = Pawn.new({:color=>"black"})
      empty_grid[7][4] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.promotion?).to eql(true)
    end
  end

  context "Board#promote" do
    it "replaces a white pawn that reaches the other side of the board with a new piece of the player's choice" do
      white_pawn = Pawn.new({:color=>"white"})
      empty_grid[1][4] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn, [2,4], [1,4], nil, nil]
      board1.move_yx([1,4],[0,4])
      board1.promote('queen')
      expect(board1.contents([0,4]).name).to eql('queen')
      expect(board1.contents([0,4]).color).to eql('white')
    end

    it "replaces a white pawn that reaches the other side of the board with a new piece of the player's choice" do
      black_pawn = Pawn.new({:color=>"black"})
      empty_grid[6][7] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.history << [black_pawn, [5,7], [6,7], nil, nil]
      board1.move_yx([6,7],[7,7])
      board1.promote('rook')
      expect(board1.contents([7,7]).name).to eql('rook')
      expect(board1.contents([7,7]).color).to eql('black')
    end
  end

  context "Bishop#moveable_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      white_bishop = Bishop.new({:color=>"white"})
      empty_grid[0][0] = white_bishop
      board1 = Board.new({:grid=>empty_grid})
      expect(white_bishop.moveable_destinations(board1)).to eql([[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]])
    end

    it "Returns the proper destination(s) if located at [3,3] on an empty board" do
      black_bishop = Bishop.new({:color=>"black"})
      empty_grid[3][3] = black_bishop
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      correct_destinations = [[4, 4], [5, 5], [6, 6], [7, 7], [4, 2], [5, 1], [6, 0], [2, 4], [1, 5], [0, 6], [2, 2], [1, 1], [0, 0]]
      expect(black_bishop.moveable_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if located at [2,4] and the board is also populated with allies and enemies" do
      white_bishop = Bishop.new({:color=>"white"})
      white_pawn_1 = Pawn.new({:color=>"white"})
      white_pawn_2 = Pawn.new({:color=>"white"})
      black_pawn_1 = Pawn.new({:color=>"black"})
      black_pawn_2 = Pawn.new({:color=>"black"})
      empty_grid[2][0] = white_pawn_1
      empty_grid[5][1] = white_pawn_2 
      empty_grid[4][2] = white_bishop
      empty_grid[2][4] = black_pawn_1
      empty_grid[6][4] = black_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      correct_destinations = [[5, 3], [6, 4], [3, 3], [2, 4], [3,1]]
      expect(white_bishop.moveable_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if in check" do
      black_bishop = Bishop.new({:color=>"black"})
      white_pawn = Pawn.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      black_king = King.new({:color=>"black"})
      empty_grid[0][5] = black_bishop
      empty_grid[2][3] = white_pawn
      empty_grid[2][7] = white_rook
      empty_grid[3][7] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_bishop.moveable_destinations(board1)).to eql([[2, 7]])
    end

    it "Removes destinations that would result in check" do
      white_bishop = Bishop.new({:color=>"white"})
      white_king = King.new({:color=>"white"})
      black_queen = Queen.new({:color=>"black"})
      empty_grid[7][4] = white_king
      empty_grid[6][5] = white_bishop
      empty_grid[4][7] = black_queen
      board1 = Board.new({:grid=>empty_grid})
      expect(white_bishop.moveable_destinations(board1)).to eql([[5,6],[4,7]])
    end

    it "Returns [] if there are no valid destinations" do
      white_bishop = Bishop.new({:color=>"white"})
      white_pawn_1 = Pawn.new({:color=>"white"})
      white_pawn_2 = Pawn.new({:color=>"white"})
      empty_grid[7][5] = white_bishop
      empty_grid[6][4] = white_pawn_1
      empty_grid[6][6] = white_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      expect(white_bishop.moveable_destinations(board1)).to eql([])
    end
  end

  context "Rook#moveable_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      rook1 = Rook.new({:color=>'black'})
      empty_grid[0][0] = rook1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      correct_destinations = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], 
              [7, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
      expect(rook1.moveable_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if located at [3,3] on an empty board" do
      white_rook = Rook.new({:color=>"white"})
      empty_grid[3][3] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      correct_destinations = [[4, 3], [5, 3], [6, 3], [7, 3], [3, 4], [3, 5], 
              [3, 6], [3, 7], [2, 3], [1, 3], [0, 3], [3, 2], [3, 1], [3, 0]]
      expect(white_rook.moveable_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if located at [3,3] and the board is also populated with allies and enemies" do
      white_rook = Rook.new({:color=>"white"})
      white_pawn = Pawn.new({:color=>"white"})
      white_knight = Knight.new({:color=>"white"})
      black_pawn_1 = Pawn.new({:color=>"black"})
      black_pawn_2 = Pawn.new({:color=>"black"})
      empty_grid[1][3] = black_pawn_1
      empty_grid[3][4] = black_pawn_2
      empty_grid[5][3] = white_pawn
      empty_grid[3][3] = white_rook
      empty_grid[3][1] = white_knight
      board1 = Board.new({:grid=>empty_grid})
      correct_destinations = [[4, 3], [3, 4], [2, 3], [1, 3], [3, 2]]
      expect(white_rook.moveable_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if in check" do
      black_rook = Rook.new({:color=>"black"})
      white_knight = Knight.new({:color=>"white"})
      black_king = King.new({:color=>"black"})
      empty_grid[1][1] = white_knight
      empty_grid[3][1] = black_rook
      empty_grid[3][0] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_rook.moveable_destinations(board1)).to eql([[1, 1]])
    end

    it "Removes destinations that would result in check" do
      black_rook = Rook.new({:color=>"black"})
      white_queen = Queen.new({:color=>"white"})
      black_king = King.new({:color=>"black"})
      empty_grid[3][1] = black_rook
      empty_grid[3][0] = black_king
      empty_grid[3][3] = white_queen
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_rook.moveable_destinations(board1)).to eql([[3,2],[3,3]])
    end

    it "Returns [] if there are no valid destinations" do
      white_rook = Rook.new({:color=>"white"})
      white_pawn = Pawn.new({:color=>"white"})
      white_knight = Knight.new({:color=>"white"})
      empty_grid[7][7] = white_rook
      empty_grid[7][6] = white_knight
      empty_grid[6][7] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      expect(white_rook.moveable_destinations(board1)).to eql([])
    end
  end

  context "Knight#moveable_destinations" do 
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      black_knight = Knight.new({:color=>"black"})
      empty_grid[0][0] = black_knight
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_knight.moveable_destinations(board1)).to eql([[2,1],[1,2]])
    end

    it "Returns the proper destination(s) if located at [7,7] on an empty board" do
      black_knight = Knight.new({:color=>"black"})
      empty_grid[7][7] = black_knight
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_knight.moveable_destinations(board1)).to eql([[5,6],[6,5]])
    end

    it "Returns the proper destination(s) if surrounded by allies and enemies" do
      white_knight = Knight.new({:color=>"white"})
      white_pawn_1 = Pawn.new({:color=>"white"})
      white_pawn_2 = Pawn.new({:color=>"white"})
      white_pawn_3 = Pawn.new({:color=>"white"})
      white_pawn_4 = Pawn.new({:color=>"white"})
      black_pawn_1 = Pawn.new({:color=>"black"})
      black_pawn_2 = Pawn.new({:color=>"black"})
      black_pawn_3 = Pawn.new({:color=>"black"})
      black_pawn_4 = Pawn.new({:color=>"black"})
      empty_grid[3][4] = white_knight
      empty_grid[1][3] = white_pawn_1
      empty_grid[2][2] = black_pawn_1
      empty_grid[4][2] = black_pawn_2
      empty_grid[5][3] = white_pawn_2
      empty_grid[5][5] = black_pawn_3
      empty_grid[4][6] = white_pawn_3
      empty_grid[2][6] = white_pawn_4
      empty_grid[1][5] = black_pawn_4
      board1 = Board.new({:grid=>empty_grid})
      expect(white_knight.moveable_destinations(board1)).to eql([[5,5],[1,5],[2,2],[4,2]])
    end

    it "Returns the proper destination(s) if in check" do
      white_knight = Knight.new({:color=>"white"})
      white_king = King.new({:color=>"white"})
      black_pawn = Pawn.new({:color=>"black"})
      empty_grid[3][4] = white_king
      empty_grid[2][3] = black_pawn
      empty_grid[4][2] = white_knight
      board1 = Board.new({:grid=>empty_grid})
      expect(white_knight.moveable_destinations(board1)).to eql([[2,3]])
    end

    it "Removes destinations that would result in check" do
      white_knight = Knight.new({:color=>"white"})
      white_king = King.new({:color=>"white"})
      black_bishop = Bishop.new({:color=>"black"})
      empty_grid[3][3] = white_king
      empty_grid[7][7] = black_bishop
      empty_grid[5][5] = white_knight
      board1 = Board.new({:grid=>empty_grid})
      expect(white_knight.moveable_destinations(board1)).to eql([])
    end

    it "Returns [] if there are no valid destinations" do
      black_knight = Knight.new({:color=>"black"})
      black_pawn_1 = Pawn.new({:color=>"black"})
      black_pawn_2 = Pawn.new({:color=>"black"})
      black_pawn_3 = Pawn.new({:color=>"black"})
      empty_grid[0][1] = black_knight
      empty_grid[2][0] = black_pawn_1
      empty_grid[2][2] = black_pawn_2
      empty_grid[1][3] = black_pawn_3
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_knight.moveable_destinations(board1)).to eql([])
    end
  end

  context "King#moveable_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      white_king = King.new({:color=>"white"})
      empty_grid[0][0] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(white_king.moveable_destinations(board1)).to eql([[1, 0], [0, 1], [1, 1]])
    end

    it "Returns the proper destination(s) if located at [4,4] on an empty board" do
      black_king = King.new({:color=>"black"})
      empty_grid[4][4] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[5, 4], [5, 3], [4, 3], [3, 3], [3, 4], [3, 5], [4, 5], [5, 5]]
      expect(black_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if located at [4,5] and the board is also populated with allies and enemies" do
      white_king = King.new({:color=>"white"})
      white_pawn_1 = Pawn.new({:color=>"white"})
      white_pawn_2 = Pawn.new({:color=>"white"})
      black_pawn_1 = Pawn.new({:color=>"black"})
      empty_grid[3][7] = white_king 
      empty_grid[2][7] = white_pawn_1
      empty_grid[4][6] = white_pawn_2
      empty_grid[4][7] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expected = [[4,7],[3,6],[2,6]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if in check" do
      black_king = King.new({:color=>"black"})
      white_queen = Queen.new({:color=>"white"})
      empty_grid[0][4] = black_king
      empty_grid[7][4] = white_queen
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[1,3],[0,3],[0,5],[1,5]]
      expect(black_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Removes destinations that would result in check" do
      black_king = King.new({:color=>"black"})
      white_queen = Queen.new({:color=>"white"})
      empty_grid[0][3] = black_king
      empty_grid[7][4] = white_queen
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[1,3],[1,2],[0,2]]
      expect(black_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is allowed - white" do
      white_king = King.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5],[7,6]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is allowed - white" do
      white_king = King.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      empty_grid[7][4] = white_king
      empty_grid[7][0] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5],[7,1]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is allowed - black" do
      black_king = King.new({:color=>"black"})
      black_rook = Rook.new({:color=>"black"})
      empty_grid[0][4] = black_king
      empty_grid[0][7] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[1,4],[1,3],[0,3],[0,5],[1,5],[0,6]]
      expect(black_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is allowed - black" do
      black_king = King.new({:color=>"black"})
      black_rook = Rook.new({:color=>"black"})
      empty_grid[0][4] = black_king
      empty_grid[0][0] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[1,4],[1,3],[0,3],[0,5],[1,5],[0,1]]
      expect(black_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is NOT allowed - king already moved" do
      white_king = King.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_king,[7,4],[7,5],nil]
      board1.history << [white_king,[7,5],[7,4],nil]
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is NOT allowed - king already moved" do
      white_king = King.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      empty_grid[7][4] = white_king
      empty_grid[7][0] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_king,[7,4],[7,5],nil]
      board1.history << [white_king,[7,5],[7,4],nil]
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is NOT allowed - rook already moved" do
      white_king = King.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_rook,[7,7],[7,6],nil]
      board1.history << [white_king,[7,6],[7,7],nil]
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is NOT allowed - rook already moved" do
      white_king = King.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      empty_grid[7][4] = white_king
      empty_grid[7][0] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_rook,[7,0],[7,1],nil]
      board1.history << [white_king,[7,1],[7,0],nil]
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is NOT allowed - piece in the way" do
      white_king = King.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      white_knight = Knight.new({:color=>"white"})
      empty_grid[7][4] = white_king
      empty_grid[7][6] = white_knight
      empty_grid[7][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is NOT allowed - piece in the way" do
      white_king = King.new({:color=>"white"})
      white_rook = Rook.new({:color=>"white"})
      white_knight = Knight.new({:color=>"white"})
      empty_grid[7][4] = white_king
      empty_grid[7][1] = white_knight
      empty_grid[7][0] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns [] if there are no valid destinations" do
      black_king = King.new({:color=>"black"})
      black_knight = Knight.new({:color=>"black"})
      black_pawn_1 = Pawn.new({:color=>"black"})
      black_pawn_2 = Pawn.new({:color=>"black"})
      empty_grid[0][0] = black_king
      empty_grid[0][1] = black_knight
      empty_grid[1][0] = black_pawn_1
      empty_grid[1][1] = black_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_king.moveable_destinations(board1)).to eql([])
    end
  end

  context "Pawn#moveable_destinations" do
    it "Returns the proper destination(s) if black pawn is located at [2,0] on an empty board" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[2][0] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.moveable_destinations(board1)).to eql([[3,0],[4,0]])
    end

    it "Returns the proper destination(s) if white pawn is located at [6,3] on an empty board" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[6][3] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[5,3],[4,3]])
    end

    it "Returns the proper destination(s) if black pawn is located at [3,0] on an empty board and has already moved" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[3][0] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.history << [black_pawn_1, [2,0], [3,0], nil]
      expect(black_pawn_1.moveable_destinations(board1)).to eql([[4,0]])
    end

    it "Returns the proper destination(s) if white pawn is located at [5,3] on an empty board and has already moved" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[5][3] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn_1, [6,3], [5,3], nil]
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[4,3]])
    end

    it "Returns [] if black pawn is located at [3,1] and there is an enemy at [4,1]" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[3][1] = black_pawn_1
      empty_grid[4][1] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.moveable_destinations(board1)).to eql([])
    end

    it "Returns the proper destination(s) if black pawn is located at [1,1] and there is an enemy at [2,2]" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[1][1] = black_pawn_1
      empty_grid[2][2] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.moveable_destinations(board1)).to eql([[2,1],[3,1],[2,2]])
    end

    it "Returns the proper destination(s) if white pawn is located at [6,4] and there is an enemy at [5,5]" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[6][4] = white_pawn_1
      empty_grid[5][5] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[5,4],[4,4],[5,5]])
    end

    it "Returns the proper destination(s) if black pawn is located at [1,1] and there is an enemy at [2,0]" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[1][1] = black_pawn_1
      empty_grid[2][0] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.moveable_destinations(board1)).to eql([[2,1],[3,1],[2,0]])
    end

    it "Returns the proper destination(s) if white pawn is located at [6,4] and there is an enemy at [5,3]" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[6][4] = white_pawn_1
      empty_grid[5][3] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[5,4],[4,4],[5,3]])
    end

    it "Returns the proper destination(s) if black pawn located at [1,1] and there are enemies at [2,0] and [2,2]" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = Pawn.new({:color=>'white'})
      white_pawn_2 = Pawn.new({:color=>'white'})
      empty_grid[1][1] = black_pawn_1
      empty_grid[2][0] = white_pawn_1
      empty_grid[2][2] = white_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.moveable_destinations(board1)).to eql([[2,1],[3,1],[2,2],[2,0]])
    end

    it "Returns the proper destination(s) if white pawn is located at [6,4] and there is are enemies at [5,3] and [5,5]" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = Pawn.new({:color=>'black'})
      black_pawn_2 = Pawn.new({:color=>'black'})
      empty_grid[6][4] = white_pawn_1
      empty_grid[5][3] = black_pawn_1
      empty_grid[5][5] = black_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[5,4],[4,4],[5,5],[5,3]])
    end

    it "Returns the proper destination(s) if white pawn is located at [3,2] and en passant to [2,1] is allowed" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[3][2] = white_pawn_1
      empty_grid[3][1] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn_1, [4,2], [3,2], nil]
      board1.history << [black_pawn_1, [1,1], [3,1], nil]
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[2,2],[2,1]])
    end

    it "Returns the proper destination(s) if black pawn is located at [4,4] and en passant to [5,3] is allowed" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[4][4] = black_pawn_1
      empty_grid[4][3] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.history << [black_pawn_1, [3,4], [4,4], nil]
      board1.history << [white_pawn_1, [6,3], [4,3], nil]
      expect(black_pawn_1.moveable_destinations(board1)).to eql([[5,4],[5,3]])
    end

    it "Returns the proper destination(s) if white pawn is located at [3,2] and en passant to [2,3] is allowed" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[3][2] = white_pawn_1
      empty_grid[3][3] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn_1, [4,2], [3,2], nil]
      board1.history << [black_pawn_1, [1,1], [3,3], nil]
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[2,2],[2,3]])
    end

    it "Returns the proper destination(s) if black pawn is located at [4,4] and en passant to [5,5] is allowed" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[4][4] = black_pawn_1
      empty_grid[4][5] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.history << [black_pawn_1, [3,4], [4,4], nil]
      board1.history << [white_pawn_1, [6,5], [4,5], nil]
      expect(black_pawn_1.moveable_destinations(board1)).to eql([[5,4],[5,5]])
    end

    it "Returns the proper destination(s) if white pawn is located at [3,2] and en passant to [2,1] is not allowed (enemy pawn move not most recent)" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = Pawn.new({:color=>'black'})
      black_pawn_2 = Pawn.new({:color=>'black'})
      empty_grid[3][2] = white_pawn_1
      empty_grid[3][1] = black_pawn_1
      empty_grid[6][2] = black_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn_1, [4,2], [3,2], nil]
      board1.history << [black_pawn_1, [1,1], [3,1], nil]
      board1.history << [black_pawn_2, [6,1], [6,2], nil]
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[2,2]])
    end

    it "Returns the proper destination(s) if white pawn is located at [3,2] and en passant to [2,1] is not allowed (enemy pawn moved more than once)" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[3][2] = white_pawn_1
      empty_grid[3][1] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn_1, [4,2], [3,2], nil]
      board1.history << [black_pawn_1, [1,1], [2,1], nil]
      board1.history << [black_pawn_1, [2,1], [3,1], nil]
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[2,2]])
    end

    it "Returns the proper destination(s) if white pawn is located at [4,2] and en passant to [3,1] is not allowed (this pawn is not on his 5th rank)" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[4][2] = white_pawn_1
      empty_grid[4][1] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn_1, [5,2], [4,2], nil]
      board1.history << [black_pawn_1, [3,1], [4,1], nil]
      expect(white_pawn_1.moveable_destinations(board1)).to eql([[3,2]])
    end

    it "Removes destinations that would result in check" do
      black_pawn = Pawn.new({:color=>'black'})
      black_king = King.new({:color=>'black'})
      white_bishop = Bishop.new({:color=>'white'})
      empty_grid[0][4] = black_king
      empty_grid[1][5] = black_pawn
      empty_grid[3][7] = white_bishop
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn.moveable_destinations(board1)).to eql([])
    end

    it "Returns [] if there are no valid destinations" do
      black_pawn = Pawn.new({:color=>'black'})
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[2][1] = white_pawn
      empty_grid[1][1] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn.moveable_destinations(board1)).to eql([])
    end
  end

  context "Queen#moveable_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      white_queen = Queen.new({:color=>"white"})
      empty_grid[0][0] = white_queen
      board1 = Board.new({:grid=>empty_grid})
      expected = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
                  [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
                  [1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]]
      expect(white_queen.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if located at [4,4] on an empty board" do
      black_queen = Queen.new({:color=>"black"})
      empty_grid[4][4] = black_queen
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[5,4],[6,4],[7,4],[4,5],[4,6],[4,7],[3,4],
                  [2,4],[1,4],[0,4],[4,3],[4,2],[4,1],[4,0],
                  [5,5],[6,6],[7,7],[5,3],[6,2],[7,1],[3,5],
                  [2,6],[1,7],[3,3],[2,2],[1,1],[0,0]]
      expect(black_queen.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if located at [4,5] and the board is also populated with allies and enemies" do
      black_queen = Queen.new({:color=>"black"})
      black_pawn = Pawn.new({:color=>'black'})
      white_pawn = Pawn.new({:color=>'white'})
      white_knight_1 = Knight.new({:color=>'white'})
      white_knight_2 = Knight.new({:color=>'white'})
      empty_grid[4][5] = black_queen
      empty_grid[2][5] = black_pawn
      empty_grid[4][2] = white_knight_1
      empty_grid[5][5] = white_pawn
      empty_grid[5][6] = white_knight_2
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[5,5],[4,6],[4,7],[3,5],[4,4],[4,3],[4,2],
                  [5,6],[5,4],[6,3],[7,2],[3,6],[2,7],[3,4],
                  [2,3],[1,2],[0,1]]
      expect(black_queen.moveable_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if in check" do
      black_queen = Queen.new({:color=>"black"})
      white_queen = Queen.new({:color=>"white"})
      black_king = King.new({:color=>"black"})
      empty_grid[4][5] = black_queen
      empty_grid[4][2] = white_queen
      empty_grid[2][2] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_queen.moveable_destinations(board1)).to eql([[4,2]])
    end

    it "Removes destinations that would result in check" do
      white_queen = Queen.new({:color=>"white"})
      black_bishop = Bishop.new({:color=>"black"})
      white_king = King.new({:color=>"white"})
      empty_grid[2][6] = black_bishop
      empty_grid[4][4] = white_queen
      empty_grid[5][3] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(white_queen.moveable_destinations(board1)).to eql([[3,5],[2,6]])
    end

    it "Returns [] if there are no valid destinations" do
      white_queen = Queen.new({:color=>"white"})
      white_pawn_1 = Pawn.new({:color=>'white'})
      white_pawn_2 = Pawn.new({:color=>'white'})
      white_pawn_3 = Pawn.new({:color=>'white'})
      empty_grid[0][0] = white_queen
      empty_grid[0][1] = white_pawn_1
      empty_grid[1][0] = white_pawn_2
      empty_grid[1][1] = white_pawn_3
      board1 = Board.new({:grid=>empty_grid})
      expect(white_queen.moveable_destinations(board1)).to eql([])
    end
  end
end