require "./lib/piece.rb"

describe Piece do

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Piece.new({}) }.to raise_error(KeyError)
    end

    it "Doesn't raise an exception when initialized with a proper {}" do 
      expect{ Piece.new({:color => 'black', :name => 'pawn', :symbol => 'P' }) }.not_to raise_error(KeyError)
    end
  end

  #Piece is functioning as an abstract class and the remaining functionality will be tested 
  #by the subclasses

end