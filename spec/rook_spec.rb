require "./lib/rook.rb"
require "./lib/board.rb"
require "./spec/reference/build_initial_grid.rb"

describe Rook do

  let(:empty_grid) { Array.new(8){ Array.new(8) } }
  let(:initial_grid) { build_initial_grid }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations, :id)

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Rook.new({}) }.to raise_error(KeyError)
    end

    it "Doesn't raise an exception when initialized with a proper {}" do 
      expect{ Rook.new({:color => 'black'}) }.not_to raise_error(KeyError)
    end

    it "Name is set to 'rook' by default" do
      black_rook = Rook.new({:color => 'black'})
      expect(black_rook.name).to eql('rook')
    end

    it "If black rook: symbol is set to black rook unicode character by default" do 
      rook1 = Rook.new({:color=>'black'})
      expect(rook1.symbol).to eql("\u265c")
    end

    it "If white rook: symbol is set to white rook unicode character by default" do 
      rook1 = Rook.new({:color=>'white'})
      expect(rook1.symbol).to eql("\u2656")
    end
  end

  context "#valid_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      rook1 = Rook.new({:color=>'black'})
      empty_grid[0][0] = rook1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      correct_destinations = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], 
              [7, 0], [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]]
      expect(rook1.valid_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if located at [3,3] on an empty board" do
      white_rook = Rook.new({:color=>"white"})
      empty_grid[3][3] = white_rook
      board1 = Board.new({:grid=>empty_grid})
      correct_destinations = [[4, 3], [5, 3], [6, 3], [7, 3], [3, 4], [3, 5], 
              [3, 6], [3, 7], [2, 3], [1, 3], [0, 3], [3, 2], [3, 1], [3, 0]]
      expect(white_rook.valid_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if located at [3,3] and the board is also populated with allies and enemies" do
      white_rook = Rook.new({:color=>"white"})
      white_pawn = TestPiece1.new("white","pawn",[],"1")
      white_knight = TestPiece1.new("white","knight",[],"1")
      black_pawn_1 = TestPiece1.new("black","pawn",[],"1")
      black_pawn_2 = TestPiece1.new("black","pawn",[],"2")
      empty_grid[1][3] = black_pawn_1
      empty_grid[3][4] = black_pawn_2
      empty_grid[5][3] = white_pawn
      empty_grid[3][3] = white_rook
      empty_grid[3][1] = white_knight
      board1 = Board.new({:grid=>empty_grid})
      correct_destinations = [[4, 3], [3, 4], [2, 3], [1, 3], [3, 2]]
      expect(white_rook.valid_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if in check" do
      black_rook = Rook.new({:color=>"black"})
      white_pawn = TestPiece1.new("white","pawn",[],"1")
      white_knight = TestPiece1.new("white","knight",[[3,0]],"1")
      black_king = TestPiece1.new("black","king",[],"1")
      empty_grid[1][1] = white_knight
      empty_grid[3][1] = black_rook
      empty_grid[3][0] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_rook.valid_destinations(board1)).to eql([[1, 1]])
    end

    it "Returns [] if there are no valid destinations" do
      white_rook = Rook.new({:color=>"white"})
      white_pawn = TestPiece1.new("white","pawn",[],"1")
      white_knight = TestPiece1.new("white","knight",[],"1")
      empty_grid[7][7] = white_rook
      empty_grid[7][6] = white_knight
      empty_grid[6][7] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      expect(white_rook.valid_destinations(board1)).to eql([])
    end
  end

end