require "./lib/board.rb"

describe Board do

  context "#initialize" do
    it "Does not raise an exception when initialized with an empty {}" do 
      expect{ Board.new({}) }.not_to raise_error(KeyError)
    end

    it "Contains 8 rows by default" do
      board1 = Board.new
      expect(board1.grid.size).to eql(8)
    end

    it "Each row has a length of 8 by defaul" do
      board1 = Board.new
      board1.grid.each do |row|
        expect(row.size).to eql(8)
      end
    end
  end






end