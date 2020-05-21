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
  end

end