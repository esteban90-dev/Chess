require "./lib/bishop.rb"
require "./lib/board.rb"
require "./spec/reference/build_initial_grid.rb"

describe Bishop do

  let(:empty_grid) { Array.new(8){ Array.new(8) } }
  let(:initial_grid) { build_initial_grid }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations, :id)

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Bishop.new({}) }.to raise_error(KeyError)
    end

    it "Doesn't raise an exception when initialized with a proper {}" do 
      expect{ Bishop.new({:color => 'black'}) }.not_to raise_error(KeyError)
    end

    it "Name is set to 'bishop' by default" do
      black_bishop = Bishop.new({:color => 'black'})
      expect(black_bishop.name).to eql('bishop')
    end

    it "If black bishop: symbol is set to black bishop unicode character by default" do 
      bishop1 = Bishop.new({:color=>'black'})
      expect(bishop1.symbol).to eql("\u265d")
    end

    it "If white bishop: symbol is set to white bishop unicode character by default" do 
      bishop1 = Bishop.new({:color=>'white'})
      expect(bishop1.symbol).to eql("\u2657")
    end
  end

  context "#valid_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      white_bishop = Bishop.new({:color=>"white"})
      empty_grid[0][0] = white_bishop
      board1 = Board.new({:grid=>empty_grid})
      expect(white_bishop.valid_destinations(board1)).to eql([[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]])
    end

    it "Returns the proper destination(s) if located at [3,3] on an empty board" do
      black_bishop = Bishop.new({:color=>"black"})
      empty_grid[3][3] = black_bishop
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      correct_destinations = [[4, 4], [5, 5], [6, 6], [7, 7], [4, 2], [5, 1], [6, 0], [2, 4], [1, 5], [0, 6], [2, 2], [1, 1], [0, 0]]
      expect(black_bishop.valid_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if located at [2,4] and the board is also populated with allies and enemies" do
      white_bishop = Bishop.new({:color=>"white"})
      white_pawn_1 = TestPiece1.new("white","pawn",[],"1")
      white_pawn_2 = TestPiece1.new("white","pawn",[],"2")
      black_pawn_1 = TestPiece1.new("black","pawn",[],"1")
      black_pawn_2 = TestPiece1.new("black","pawn",[],"2")
      empty_grid[2][0] = white_pawn_1
      empty_grid[5][1] = white_pawn_2 
      empty_grid[4][2] = white_bishop
      empty_grid[2][4] = black_pawn_1
      empty_grid[6][4] = black_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      correct_destinations = [[5, 3], [6, 4], [3, 3], [2, 4], [3,1]]
      expect(white_bishop.valid_destinations(board1)).to eql(correct_destinations)
    end

    it "Returns the proper destination(s) if in check" do
      black_bishop = Bishop.new({:color=>"black"})
      white_pawn = TestPiece1.new("white","pawn",[],"1")
      white_rook = TestPiece1.new("white","rook",[[3,7]],"1")
      black_king = TestPiece1.new("black","king",[],"1")
      empty_grid[0][5] = black_bishop
      empty_grid[2][3] = white_pawn
      empty_grid[2][7] = white_rook
      empty_grid[3][7] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_bishop.valid_destinations(board1)).to eql([[2, 7]])
    end
  end

end