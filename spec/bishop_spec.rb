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
end