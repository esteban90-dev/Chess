require "./lib/board.rb"

describe Board do

  
  let(:grid) { Array.new(8){ Array.new(8) } }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations)


  context "#initialize" do
    it "Does not raise an exception when initialized with an empty {}" do 
      expect{ Board.new({}) }.not_to raise_error(KeyError)
    end

    it "Contains 8 rows by default" do
      board1 = Board.new
      expect(board1.grid.size).to eql(8)
    end

    it "Each row has a length of 8 by defaul" do
      board1 = Board.new
      board1.grid.each do |row|
        expect(row.size).to eql(8)
      end
    end
  end

  context "#contents" do
    it "Returns the contents of a filled cell" do
      black_pawn_1 = TestPiece1.new("black","pawn", [])
      grid[0][0] = black_pawn_1
      board1 = Board.new({:grid=>grid})
      expect(board1.contents([0,0])).to eql(black_pawn_1)
    end

    it "Returns nil for an empty cell" do
      grid[3][3] = nil
      board1 = Board.new({:grid=>grid})
      expect(board1.contents([3,3])).to eql(nil)
    end
  end

  context "#location" do
    it "returns the location of an object on the board, if it exists" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      grid[3][3] = white_pawn_1
      board1 = Board.new({:grid=>grid})
      expect(board1.location(white_pawn_1)).to eql([3,3])
    end

    it "returns all locations of an object on the board, if it exists in multiple places" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      white_pawn_2 = TestPiece1.new("white","pawn", [])
      grid[0][0] = white_pawn_1
      grid[3][3] = white_pawn_2
      board1 = Board.new({:grid=>grid})
      expect(board1.location(white_pawn_1)).to eql([[0,0],[3,3]])
    end

    it "returns nil if an object doesn't exist on the board" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      black_pawn_1 = TestPiece1.new("black","pawn", [])
      grid[3][3] = white_pawn_1
      board1 = Board.new({:grid=>grid})
      expect(board1.location(black_pawn_1)).to eql(nil)
    end
  end

  context "#valid_location?" do
    it "[1,3] returns true" do 
      board1 = Board.new({:grid=>grid})
      expect(board1.valid_location?([1,3])).to eql(true)
    end

    it "[8,8] returns false" do 
      board1 = Board.new({:grid=>grid})
      expect(board1.valid_location?([8,8])).to eql(false)
    end

    it "[-1,1] returns false" do 
      board1 = Board.new({:grid=>grid})
      expect(board1.valid_location?([-1,1])).to eql(false)
    end
  end

  context "#active_color, #swap_color" do
    it "returns 'white' if it's white's turn (white goes first)" do
      board1 = Board.new({:grid=>grid})
      expect(board1.active_color).to eql('white')
    end

    it "returns 'black' if it's black's turn" do
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      expect(board1.active_color).to eql('black')
    end
  end

  context "#allied_pieces" do
    it "returns an array of the pieces on the board that match the active color" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      white_pawn_2 = TestPiece1.new("white","pawn", [])
      white_pawn_3 = TestPiece1.new("white","pawn", []) 
      black_pawn_1 = TestPiece1.new("black","pawn", []) 
      grid[0][0] = white_pawn_1
      grid[4][5] = white_pawn_2
      grid[7][7] = white_pawn_3
      grid[2][2] = black_pawn_1
      board1 = Board.new({:grid=>grid})
      expect(board1.allied_pieces).to eql([white_pawn_1, white_pawn_2, white_pawn_3])
    end

    it "returns [] if no pieces are on the board that match the active color" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      white_pawn_2 = TestPiece1.new("white","pawn", [])
      white_pawn_3 = TestPiece1.new("white","pawn", []) 
      grid[0][0] = white_pawn_1
      grid[4][5] = white_pawn_2
      grid[7][7] = white_pawn_3
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      expect(board1.allied_pieces).to eql([])
    end
  end

  context "#enemy_pieces" do
    it "returns an array of the pieces on the board that don't match the active color" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      white_pawn_2 = TestPiece1.new("white","pawn", [])
      white_pawn_3 = TestPiece1.new("white","pawn", [])
      black_pawn_1 = TestPiece1.new("black","pawn", [])
      black_pawn_2 = TestPiece1.new("black","pawn", [])
      grid[0][0] = white_pawn_1
      grid[4][5] = white_pawn_2
      grid[7][7] = white_pawn_3
      grid[2][2] = black_pawn_1
      grid[2][3] = black_pawn_2
      board1 = Board.new({:grid=>grid})
      expect(board1.enemy_pieces).to eql([black_pawn_1, black_pawn_2])
    end

    it "returns [] if there are no pieces on the board that don't match the active color" do
      white_pawn = TestPiece1.new("white","pawn", [])
      grid[0][0] = white_pawn
      grid[4][5] = white_pawn
      grid[7][7] = white_pawn
      board1 = Board.new({:grid=>grid})
      expect(board1.enemy_pieces).to eql([])
    end
  end

  context "#under_threat?" do
    it "returns true if the given position can be reached by any enemy piece" do
      black_pawn = TestPiece1.new("black","pawn",[[0,0],[1,1]])
      grid[0][1] = black_pawn
      board1 = Board.new({:grid=>grid})
      expect(board1.under_threat?([0,0])).to eql(true)
    end

    it "returns false if the given position can't be reached by any enemy piece" do
      black_pawn = TestPiece1.new("black","pawn",[[0,0],[1,1]])
      white_pawn = TestPiece1.new("white","pawn",[3,3])
      grid[0][1] = black_pawn
      grid[2][2] = white_pawn
      board1 = Board.new({:grid=>grid})
      expect(board1.under_threat?([3,3])).to eql(false)
    end
  end

  context "#active_color_in_check?" do
    it "returns true if the active color's (white) king position can be reached by any enemy pieces" do
      black_queen = TestPiece1.new("black","queen",[[0,0],[1,1],[3,3]])
      white_king = TestPiece1.new("white","king",[])
      grid[0][3] = black_queen
      grid[3][3] = white_king
      board1 = Board.new({:grid=>grid})
      expect(board1.active_color_in_check?).to eql(true)
    end

    it "returns true if the active color's (black) king position can be reached by any enemy pieces" do
      white_queen = TestPiece1.new("white","queen",[[0,0],[1,1],[3,3]])
      black_king = TestPiece1.new("black","king",[])
      grid[0][3] = white_queen
      grid[3][3] = black_king
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      expect(board1.active_color_in_check?).to eql(true)
    end

    it "returns false if the active color's (white) king position can't be reached by any enemy pieces" do
      black_queen = TestPiece1.new("black","queen",[[0,0],[1,1]])
      white_king = TestPiece1.new("white","king",[])
      grid[0][3] = black_queen
      grid[3][3] = white_king
      board1 = Board.new({:grid=>grid})
      expect(board1.active_color_in_check?).to eql(false)
    end

    it "returns false if the active color's (black) king position can't be reached by any enemy pieces" do
      white_queen = TestPiece1.new("white","queen",[[0,0],[1,1]])
      black_king = TestPiece1.new("black","king",[])
      grid[0][3] = white_queen
      grid[3][3] = black_king
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      expect(board1.active_color_in_check?).to eql(false)
    end

    it "returns false if there is no allied king on the board - for testing purposes" do
      board1 = Board.new({:grid=>grid})
      expect(board1.active_color_in_check?).to eql(false)
    end
  end

  context "#disables_check?" do
    it "returns true if the active color is in check and the given move disables a check condition" do
      black_queen = TestPiece1.new("black","queen",[[0,0],[1,1],[3,3]])
      white_king = TestPiece1.new("white","king",[[3,4]])
      grid[0][3] = black_queen
      grid[3][3] = white_king
      board1 = Board.new({:grid=>grid})
      expect(board1.disables_check?([3,3],[3,4])).to eql(true)
    end

    it "returns nil if the active color is not in check" do 
      white_king = TestPiece1.new("white","king",[])
      white_pawn = TestPiece1.new("white","pawn",[[2,6]])
      black_pawn = TestPiece1.new("black","pawn",[[4,5]])
      grid[3][7] = white_pawn
      grid[4][0] = white_king
      grid[3][6] = black_pawn
      board1 = Board.new({:grid=>grid})
      expect(board1.disables_check?([3,7],[2,6])).to eql(nil)
    end
  end

  context "#enables_check?" do
    it "returns true if the active color is not check and the given move enables a check condition" do
      black_king = TestPiece1.new("black","king",[[4,5]])
      white_rook = TestPiece1.new("white","rook",[[3,5],[4,5]])
      grid[2][5] = white_rook
      grid[4][4] = black_king
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      expect(board1.enables_check?([4,4],[4,5])).to eql(true)
    end

    it "returns nil if the active color is already in check" do 
      white_king = TestPiece1.new("white","king",[[4,6]])
      black_rook = TestPiece1.new("black","rook",[[3,5],[4,5]])
      grid[2][5] = black_rook
      grid[4][5] = white_king
      board1 = Board.new({:grid=>grid})
      expect(board1.enables_check?([4,5],[4,6])).to eql(nil)
    end
  end

  context "#move" do
    it "moves a white piece that makes no capture" do
      white_pawn = TestPiece1.new("white","pawn",[[5,1],[4,1]])
      grid[6][1] = white_pawn
      board1 = Board.new({:grid=>grid})
      board1.move([6,1],[5,1])
      expect(board1.history.last).to eql([white_pawn, [6,1], [5,1], nil])
    end

    it "moves a white piece to capture a black piece" do
      white_pawn = TestPiece1.new("white","pawn",[[5,1],[5,2],[4,1]])
      black_pawn = TestPiece1.new("black","pawn",[])
      grid[6][1] = white_pawn
      grid[5][2] = black_pawn
      board1 = Board.new({:grid=>grid})
      board1.move([6,1],[5,2])
      expect(board1.history.last).to eql([white_pawn, [6,1], [5,2], black_pawn])
    end

    it "moves a black piece that makes no capture" do
      black_pawn = TestPiece1.new("black","pawn",[[2,1],[3,1]])
      grid[1][1] = black_pawn
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      board1.move([1,1],[3,1])
      expect(board1.history.last).to eql([black_pawn, [1,1], [3,1], nil])
    end

    it "moves a black piece to capture a white piece" do
      black_pawn = TestPiece1.new("black","pawn",[[4,3],[4,4]])
      white_pawn = TestPiece1.new("white","pawn",[])
      grid[3][3] = black_pawn
      grid[4][4] = white_pawn
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      board1.move([3,3],[4,4])
      expect(board1.history.last).to eql([black_pawn, [3,3], [4,4], white_pawn])
    end

    it "moves a white pawn en_passant (+x direction) to capture a black piece" do
      white_pawn = TestPiece1.new("white","pawn",[[2,3],[2,4]])
      black_pawn = TestPiece1.new("black","pawn",[])
      grid[3][3] = white_pawn
      grid[3][4] = black_pawn
      board1 = Board.new({:grid=>grid})
      board1.move([3,3],[2,4])
      expect(board1.history.last).to eql([white_pawn, [3,3], [2,4], black_pawn])
    end

    it "moves a white pawn en_passant (-x direction) to capture a black piece" do
      white_pawn = TestPiece1.new("white","pawn",[[2,3],[2,4]])
      black_pawn = TestPiece1.new("black","pawn",[])
      grid[3][4] = white_pawn
      grid[3][3] = black_pawn
      board1 = Board.new({:grid=>grid})
      board1.move([3,4],[2,3])
      expect(board1.history.last).to eql([white_pawn, [3,4], [2,3], black_pawn])
    end

    it "moves a black pawn en_passant (+x direction) to capture a white piece" do
      white_pawn = TestPiece1.new("white","pawn",[])
      black_pawn = TestPiece1.new("black","pawn",[[5,1],[5,2]])
      grid[4][1] = black_pawn
      grid[4][2] = white_pawn
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      board1.move([4,1],[5,2])
      expect(board1.history.last).to eql([black_pawn, [4,1], [5,2], white_pawn])
    end

    it "moves a black pawn en_passant (-x direction) to capture a white piece" do
      white_pawn = TestPiece1.new("white","pawn",[])
      black_pawn = TestPiece1.new("black","pawn",[[5,2],[5,3]])
      grid[4][3] = black_pawn
      grid[4][2] = white_pawn
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      board1.move([4,3],[5,2])
      expect(board1.history.last).to eql([black_pawn, [4,3], [5,2], white_pawn])
    end

    it "moves a king and a rook in a king side castling move (white)" do
      white_king = TestPiece1.new("white","king",[[7,6]])
      white_rook_1 = TestPiece1.new("white","rook",[[7,5]])
      white_rook_2 = TestPiece1.new("white","rook",[[7,2]])
      grid[7][0] = white_rook_2
      grid[7][4] = white_king
      grid[7][7] = white_rook_1
      board1 = Board.new({:grid=>grid})
      board1.move([7,4],[7,6])
      expect(board1.history[0..1]).to eql([[white_king, [7,4], [7,6], nil], [white_rook_1, [7,7], [7,5], nil]])
    end

    it "moves a king and a rook in a king side castling move (black)" do
      black_king = TestPiece1.new("black","king",[[0,6]])
      black_rook_1 = TestPiece1.new("black","rook",[[0,5]])
      black_rook_2 = TestPiece1.new("black","rook",[[0,2]])
      grid[0][0] = black_rook_2
      grid[0][4] = black_king
      grid[0][7] = black_rook_1
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      board1.move([0,4],[0,6])
      expect(board1.history[0..1]).to eql([[black_king, [0,4], [0,6], nil], [black_rook_1, [0,7], [0,5], nil]])
    end

    it "moves a king and a rook in a queen side castling move (white)" do
      white_king = TestPiece1.new("white","king",[[7,1]])
      white_rook_1 = TestPiece1.new("white","rook",[[7,5]])
      white_rook_2 = TestPiece1.new("white","rook",[[7,2]])
      grid[7][0] = white_rook_2
      grid[7][4] = white_king
      grid[7][7] = white_rook_1
      board1 = Board.new({:grid=>grid})
      board1.move([7,4],[7,1])
      expect(board1.history[0..1]).to eql([[white_king, [7,4], [7,1], nil], [white_rook_2, [7,0], [7,2], nil]])
    end

    it "moves a king and a rook in a queen side castling move (black)" do
      black_king = TestPiece1.new("black","king",[[0,1]])
      black_rook_1 = TestPiece1.new("black","rook",[[0,5]])
      black_rook_2 = TestPiece1.new("black","rook",[[0,2]])
      grid[0][0] = black_rook_2
      grid[0][4] = black_king
      grid[0][7] = black_rook_1
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      board1.move([0,4],[0,1])
      expect(board1.history[0..1]).to eql([[black_king, [0,4], [0,1], nil], [black_rook_2, [0,0], [0,2], nil]])
    end

    it "records error message if the source cell is empty" do
      board1 = Board.new({:grid=>grid})
      board1.move([0,0],[1,0])
      expect(board1.history.last).to eql("invalid move - source cell empty")
    end

    it "records error message if the source cell is an enemy piece" do
      black_rook_1 = TestPiece1.new("black","rook",[[0,5]])
      grid[0][4] = black_rook_1
      board1 = Board.new({:grid=>grid})
      board1.move([0,4],[0,5])
      expect(board1.history.last).to eql("invalid move - source cell contains enemy piece")
    end

    it "records error message if the source cell matches the destination cell" do
      black_rook_1 = TestPiece1.new("black","rook",[[0,5]])
      grid[0][4] = black_rook_1
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      board1.move([0,4],[0,4])
      expect(board1.history.last).to eql("invalid move - source cell matches destination cell")
    end

    it "records error message if the source piece can't move to the destination" do
      white_pawn_1 = TestPiece1.new("white","pawn",[[5,1],[4,1]])
      grid[6][1] = white_pawn_1
      board1 = Board.new({:grid=>grid})
      board1.move([6,1],[3,1])
      expect(board1.history.last).to eql("invalid move - white pawn can't move from [6, 1] to [3, 1]")
    end
  end
end