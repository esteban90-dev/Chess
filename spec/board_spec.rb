require "./lib/board.rb"

describe Board do

  TestPiece = Struct.new(:color)
  let(:white_piece) { TestPiece.new("white") }
  let(:black_piece) { TestPiece.new("black") }

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


  context "#contents" do
    it "Returns the contents of a filled cell" do
      board1 = Board.new
      board1.grid[0][0] = black_piece
      expect(board1.contents([0,0])).to eql(black_piece)
    end

    it "Returns nil for an empty cell" do
      board1 = Board.new
      board1.grid[3][3] = nil
      expect(board1.contents([3,3])).to eql(nil)
    end
  end

  context "#location" do
    it "returns the location of an object on the board, if it exists" do
      board1 = Board.new
      board1.grid[3][3] = white_piece
      expect(board1.location(white_piece)).to eql([[3,3]])
    end

    it "returns all locations of an object on the board, if it exists in multiple places" do
      board1 = Board.new
      board1.grid[0][0] = white_piece
      board1.grid[3][3] = white_piece
      expect(board1.location(white_piece)).to eql([[0,0],[3,3]])
    end

    it "returns nil if an object doesn't exist on the board" do
      board1 = Board.new
      board1.grid[3][3] = white_piece
      expect(board1.location(black_piece)).to eql(nil)
    end
  end

  context "#valid_location?" do
    it "returns true if a grid location exists on the board" do 
      board1 = Board.new
      expect(board1.valid_location?([1,3])).to eql(true)
    end

    it "returns false if a grid location doesn't exist on the board (i.e. out of bounds)" do 
      board1 = Board.new
      expect(board1.valid_location?([-1,1])).to eql(false)
    end
  end

  context "#active_color, #swap_color" do
    it "returns 'white' if it's white's turn (white goes first)" do
      board1 = Board.new
      expect(board1.active_color).to eql('white')
    end

    it "returns 'black' if it's black's turn" do
      board1 = Board.new
      board1.swap_color
      expect(board1.active_color).to eql('black')
    end
  end






end