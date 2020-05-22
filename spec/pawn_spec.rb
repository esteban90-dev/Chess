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
    it "Returns the proper destination(s) if located at [2,0] on an empty board" do
      pawn_1 = Pawn.new({:color=>'white'})
      empty_grid[2][0] = pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(pawn_1.valid_destinations(board1)).to eql([[3,0],[4,0]])
    end
  end

end