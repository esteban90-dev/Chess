require "./lib/king.rb"
require "./lib/board.rb"
require "./spec/reference/build_initial_grid.rb"

describe King do

  let(:empty_grid) { Array.new(8){ Array.new(8) } }
  let(:initial_grid) { build_initial_grid }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations, :id)

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ King.new({}) }.to raise_error(KeyError)
    end

    it "Doesn't raise an exception when initialized with a proper {}" do 
      expect{ King.new({:color => 'black'}) }.not_to raise_error(KeyError)
    end

    it "Name is set to 'king' by default" do
      black_king = King.new({:color => 'black'})
      expect(black_king.name).to eql('king')
    end

    it "If black king: symbol is set to black king unicode character by default" do 
      king1 = King.new({:color=>'black'})
      expect(king1.symbol).to eql("\u265a")
    end

    it "If white king: symbol is set to white king unicode character by default" do 
      king1 = King.new({:color=>'white'})
      expect(king1.symbol).to eql("\u2654")
    end
  end

  context "#valid_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      white_king = King.new({:color=>"white"})
      empty_grid[0][0] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(white_king.valid_destinations(board1)).to eql([[1, 0], [0, 1], [1, 1]])
    end

    it "Returns the proper destination(s) if located at [4,4] on an empty board" do
      black_king = King.new({:color=>"black"})
      empty_grid[4][4] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[5, 4], [5, 3], [4, 3], [3, 3], [3, 4], [3, 5], [4, 5], [5, 5]]
      expect(black_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if located at [4,5] and the board is also populated with allies and enemies" do
      white_king = King.new({:color=>"white"})
      white_pawn_1 = TestPiece1.new("white","pawn",[],"1")
      white_pawn_2 = TestPiece1.new("white","pawn",[],"2")
      black_pawn_1 = TestPiece1.new("black","pawn",[],"1")
      empty_grid[3][7] = white_king 
      empty_grid[2][7] = white_pawn_1
      empty_grid[4][6] = white_pawn_2
      empty_grid[4][7] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expected = [[4,7],[3,6],[2,6]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if in check" do
      black_king = King.new({:color=>"black"})
      white_queen = TestPiece1.new("white","queen",[[0,4],[1,4]],"1")
      empty_grid[0][4] = black_king
      empty_grid[7][4] = white_queen
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[1,3],[0,3],[0,5],[1,5]]
      expect(black_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if not in check, and rejects those that would enable check" do
      black_king = King.new({:color=>"black"})
      white_queen = TestPiece1.new("white","queen",[[0,4],[1,4]],"1")
      empty_grid[0][3] = black_king
      empty_grid[7][4] = white_queen
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[1,3],[1,2],[0,2]]
      expect(black_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is allowed - white" do
      white_king = King.new({:color=>"white"})
      white_rook = TestPiece1.new("white","rook",[],"1")
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5],[7,6]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is allowed - white" do
      white_king = King.new({:color=>"white"})
      white_rook = TestPiece1.new("white","rook",[],"1")
      empty_grid[7][4] = white_king
      empty_grid[7][0] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5],[7,1]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is allowed - black" do
      black_king = King.new({:color=>"black"})
      black_rook = TestPiece1.new("black","rook",[],"1")
      empty_grid[0][4] = black_king
      empty_grid[0][7] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[1,4],[1,3],[0,3],[0,5],[1,5],[0,6]]
      expect(black_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is allowed - black" do
      black_king = King.new({:color=>"black"})
      black_rook = TestPiece1.new("black","rook",[],"1")
      empty_grid[0][4] = black_king
      empty_grid[0][0] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expected = [[1,4],[1,3],[0,3],[0,5],[1,5],[0,1]]
      expect(black_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is NOT allowed - king already moved" do
      white_king = King.new({:color=>"white"})
      white_rook = TestPiece1.new("white","rook",[],"1")
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_king,[7,4],[7,5],nil]
      board1.history << [white_king,[7,5],[7,4],nil]
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is NOT allowed - king already moved" do
      white_king = King.new({:color=>"white"})
      white_rook = TestPiece1.new("white","rook",[],"1")
      empty_grid[7][4] = white_king
      empty_grid[7][0] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_king,[7,4],[7,5],nil]
      board1.history << [white_king,[7,5],[7,4],nil]
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is NOT allowed - rook already moved" do
      white_king = King.new({:color=>"white"})
      white_rook = TestPiece1.new("white","rook",[],"1")
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_rook,[7,7],[7,6],nil]
      board1.history << [white_king,[7,6],[7,7],nil]
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is NOT allowed - rook already moved" do
      white_king = King.new({:color=>"white"})
      white_rook = TestPiece1.new("white","rook",[],"1")
      empty_grid[7][4] = white_king
      empty_grid[7][0] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_rook,[7,0],[7,1],nil]
      board1.history << [white_king,[7,1],[7,0],nil]
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if kingside castling is NOT allowed - piece in the way" do
      white_king = King.new({:color=>"white"})
      white_rook = TestPiece1.new("white","rook",[],"1")
      white_knight = TestPiece1.new("white","knight",[],"1")
      empty_grid[7][4] = white_king
      empty_grid[7][6] = white_knight
      empty_grid[7][7] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if queenside castling is NOT allowed - piece in the way" do
      white_king = King.new({:color=>"white"})
      white_rook = TestPiece1.new("white","rook",[],"1")
      white_knight = TestPiece1.new("white","knight",[],"1")
      empty_grid[7][4] = white_king
      empty_grid[7][1] = white_knight
      empty_grid[7][0] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      expected = [[7,3],[6,3],[6,4],[6,5],[7,5]]
      expect(white_king.valid_destinations(board1)).to eql(expected)
    end

    it "Returns [] if there are no valid destinations" do
      black_king = King.new({:color=>"black"})
      initial_grid[0][4] = black_king
      board1 = Board.new({:grid=>initial_grid})
      board1.swap_color
      expect(black_king.valid_destinations(board1)).to eql([])
    end
  end
end