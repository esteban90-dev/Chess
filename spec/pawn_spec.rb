require "./lib/pawn.rb"

describe Pawn do

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
end