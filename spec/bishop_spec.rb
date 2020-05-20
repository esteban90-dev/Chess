require "./lib/bishop.rb"
require "./lib/board.rb"
require "./lib/build_initial_grid.rb"

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
  end

end