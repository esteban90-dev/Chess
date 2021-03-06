require "./lib/queen.rb"

describe Queen do

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
end