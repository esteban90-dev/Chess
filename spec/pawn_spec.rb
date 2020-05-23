require "./lib/pawn.rb"
require "./lib/board.rb"
require "./spec/reference/build_initial_grid.rb"

describe Pawn do

  let(:empty_grid) { Array.new(8){ Array.new(8) } }
  let(:initial_grid) { build_initial_grid }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations, :id)

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Pawn.new({}) }.to raise_error(KeyError)
    end

    it "Doesn't raise an exception when initialized with a proper {}" do 
      expect{ Pawn.new({:color => 'black'}) }.not_to raise_error(KeyError)
    end

    it "Name is set to 'pawn' by default" do
      black_pawn = Pawn.new({:color => 'black'})
      expect(black_pawn.name).to eql('pawn')
    end

    it "If black pawn: symbol is set to black pawn unicode character by default" do 
      pawn1 = Pawn.new({:color=>'black'})
      expect(pawn1.symbol).to eql("\u265f")
    end

    it "If white pawn: symbol is set to white pawn unicode character by default" do 
      pawn1 = Pawn.new({:color=>'white'})
      expect(pawn1.symbol).to eql("\u2659")
    end
  end

  context "#valid_destinations" do
    it "Returns the proper destination(s) if white pawn is located at [2,0] on an empty board" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[2][0] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.valid_destinations(board1)).to eql([[3,0],[4,0]])
    end

    it "Returns the proper destination(s) if black pawn is located at [6,3] on an empty board" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[6][3] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.valid_destinations(board1)).to eql([[5,3],[4,3]])
    end

    it "Returns the proper destination(s) if white pawn is located at [3,0] on an empty board and has already moved" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[3][0] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn_1, [2,0], [3,0], nil]
      expect(white_pawn_1.valid_destinations(board1)).to eql([[4,0]])
    end

    it "Returns the proper destination(s) if black pawn is located at [5,3] on an empty board and has already moved" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      empty_grid[5][3] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.history << [black_pawn_1, [6,3], [5,3], nil]
      expect(black_pawn_1.valid_destinations(board1)).to eql([[4,3]])
    end

    it "Returns [] if white pawn is located at [3,1] and there is an enemy at [4,1]" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = TestPiece1.new("black","pawn",[],"1")
      empty_grid[3][1] = white_pawn_1
      empty_grid[4][1] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.valid_destinations(board1)).to eql([])
    end

    it "Returns the proper destination(s) if white pawn is located at [1,1] and there is an enemy at [2,2]" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = TestPiece1.new("black","pawn",[],"1")
      empty_grid[1][1] = white_pawn_1
      empty_grid[2][2] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.valid_destinations(board1)).to eql([[2,1],[3,1],[2,2]])
    end

    it "Returns the proper destination(s) if black pawn is located at [6,4] and there is an enemy at [5,5]" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = TestPiece1.new("white","pawn",[],"1")
      empty_grid[6][4] = black_pawn_1
      empty_grid[5][5] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.valid_destinations(board1)).to eql([[5,4],[4,4],[5,5]])
    end

    it "Returns the proper destination(s) if white pawn is located at [1,1] and there is an enemy at [2,0]" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = TestPiece1.new("black","pawn",[],"1")
      empty_grid[1][1] = white_pawn_1
      empty_grid[2][0] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.valid_destinations(board1)).to eql([[2,1],[3,1],[2,0]])
    end

    it "Returns the proper destination(s) if black pawn is located at [6,4] and there is an enemy at [5,3]" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = TestPiece1.new("white","pawn",[],"1")
      empty_grid[6][4] = black_pawn_1
      empty_grid[5][3] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.valid_destinations(board1)).to eql([[5,4],[4,4],[5,3]])
    end

    it "Returns the proper destination(s) if white pawn located at [1,1] and there are enemies at [2,0] and [2,2]" do
      white_pawn_1 = Pawn.new({:color=>'white'})
      black_pawn_1 = TestPiece1.new("black","pawn",[],"1")
      black_pawn_2 = TestPiece1.new("black","pawn",[],"1")
      empty_grid[1][1] = white_pawn_1
      empty_grid[2][0] = black_pawn_1
      empty_grid[2][2] = black_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      expect(white_pawn_1.valid_destinations(board1)).to eql([[2,1],[3,1],[2,2],[2,0]])
    end

    it "Returns the proper destination(s) if black pawn is located at [6,4] and there is are enemies at [5,3] and [5,5]" do
      black_pawn_1 = Pawn.new({:color=>'black'})
      white_pawn_1 = TestPiece1.new("white","pawn",[],"1")
      white_pawn_2 = TestPiece1.new("white","pawn",[],"2")
      empty_grid[6][4] = black_pawn_1
      empty_grid[5][3] = white_pawn_1
      empty_grid[5][5] = white_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_pawn_1.valid_destinations(board1)).to eql([[5,4],[4,4],[5,5],[5,3]])
    end
  end

end