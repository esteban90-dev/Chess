require "./lib/rook.rb"

describe Rook do

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
end