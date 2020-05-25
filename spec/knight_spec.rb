require "./lib/knight.rb"
require "./lib/board.rb"
require "./spec/reference/build_initial_grid.rb"

describe Knight do


  let(:empty_grid) { Array.new(8){ Array.new(8) } }
  let(:initial_grid) { build_initial_grid }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations, :id)


  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Knight.new({}) }.to raise_error(KeyError)
    end

    it "Doesn't raise an exception when initialized with a proper {}" do 
      expect{ Knight.new({:color => 'black'}) }.not_to raise_error(KeyError)
    end

    it "Name is set to 'knight' by default" do
      black_knight = Knight.new({:color => 'black'})
      expect(black_knight.name).to eql('knight')
    end

    it "If black knight: symbol is set to black knight unicode character by default" do 
      knight1 = Knight.new({:color=>'black'})
      expect(knight1.symbol).to eql("\u265e")
    end

    it "If white knight: symbol is set to white knight unicode character by default" do 
      knight1 = Knight.new({:color=>'white'})
      expect(knight1.symbol).to eql("\u2658")
    end
  end
end



