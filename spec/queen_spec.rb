require "./lib/queen.rb"
require "./lib/board.rb"
require "./spec/reference/build_initial_grid.rb"

describe Queen do

  let(:empty_grid) { Array.new(8){ Array.new(8) } }
  let(:initial_grid) { build_initial_grid }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations, :id)

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Queen.new({}) }.to raise_error(KeyError)
    end

    it "Doesn't raise an exception when initialized with a proper {}" do 
      expect{ Queen.new({:color => 'black'}) }.not_to raise_error(KeyError)
    end

    it "Name is set to 'queen' by default" do
      black_queen = Queen.new({:color => 'black'})
      expect(black_queen.name).to eql('queen')
    end

    it "If black queen: symbol is set to black queen unicode character by default" do 
      queen1 = Queen.new({:color=>'black'})
      expect(queen1.symbol).to eql("\u265b")
    end

    it "If white queen: symbol is set to white queen unicode character by default" do 
      queen1 = Queen.new({:color=>'white'})
      expect(queen1.symbol).to eql("\u2655")
    end
  end

  context "#valid_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      white_queen = Queen.new({:color=>"white"})
      empty_grid[0][0] = white_queen
      board1 = Board.new({:grid=>empty_grid})
      expected = [[1,0],[2,0],[3,0],[4,0],[5,0],[6,0],[7,0],
                  [0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],
                  [1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7]]
      expect(white_queen.valid_destinations(board1)).to eql(expected)
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
      expect(black_queen.valid_destinations(board1)).to eql(expected)
    end

    it "Returns the proper destination(s) if located at [4,5] and the board is also populated with allies and enemies" do
      black_queen = Queen.new({:color=>"queen"})
      black_pawn = TestPiece1.new("black","pawn",[],"1")
      white_pawn = TestPiece1.new("white","pawn",[],"1")
      white_knight_1 = TestPiece1.new("white","knight",[],"1")
      white_knight_2 = TestPiece1.new("white","knight",[],"2")
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
      expect(black_queen.valid_destinations(board1)).to eql(expected)
    end
  end

end