require "./lib/board.rb"

describe Board do

  TestPiece = Struct.new(:color)
  let(:white_piece_1) { TestPiece.new("white") }
  let(:white_piece_2) { TestPiece.new("white") }
  let(:white_piece_3) { TestPiece.new("white") }
  let(:black_piece_1) { TestPiece.new("black") }
  let(:black_piece_2) { TestPiece.new("black") }
  let(:black_piece_3) { TestPiece.new("black") }

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
      board1.grid[0][0] = black_piece_1
      expect(board1.contents([0,0])).to eql(black_piece_1)
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
      board1.grid[3][3] = white_piece_1
      expect(board1.location(white_piece_1)).to eql([[3,3]])
    end

    it "returns all locations of an object on the board, if it exists in multiple places" do
      board1 = Board.new
      board1.grid[0][0] = white_piece_1
      board1.grid[3][3] = white_piece_1
      expect(board1.location(white_piece_1)).to eql([[0,0],[3,3]])
    end

    it "returns nil if an object doesn't exist on the board" do
      board1 = Board.new
      board1.grid[3][3] = white_piece_1
      expect(board1.location(black_piece_1)).to eql(nil)
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

  context "#allied_pieces" do
    it "returns an array of the pieces on the board that match the active color" do
      grid = Array.new(8){ Array.new(8) }
      grid[0][0] = white_piece_1
      grid[4][5] = white_piece_2
      grid[7][7] = white_piece_3
      grid[2][2] = black_piece_1
      board1 = Board.new({:grid=>grid})
      expect(board1.allied_pieces).to eql([white_piece_1, white_piece_2, white_piece_3])
    end

    it "returns [] if no pieces are on the board that match the active color" do 
      grid = Array.new(8){ Array.new(8) }
      grid[0][0] = white_piece_1
      grid[4][5] = white_piece_2
      grid[7][7] = white_piece_3
      board1 = Board.new({:grid=>grid})
      board1.swap_color
      expect(board1.allied_pieces).to eql([])
    end
  end

  context "#enemy_pieces" do
    it "returns an array of the pieces on the board that don't match the active color" do
      grid = Array.new(8){ Array.new(8) }
      grid[0][0] = white_piece_1
      grid[4][5] = white_piece_2
      grid[7][7] = white_piece_3
      grid[2][2] = black_piece_1
      grid[2][3] = black_piece_2
      board1 = Board.new({:grid=>grid})
      expect(board1.enemy_pieces).to eql([black_piece_1, black_piece_2])
    end

    it "returns [] if there are no pieces on the board that don't match the active color" do
      grid = Array.new(8){ Array.new(8) }
      grid[0][0] = white_piece_1
      grid[4][5] = white_piece_2
      grid[7][7] = white_piece_3
      board1 = Board.new({:grid=>grid})
      expect(board1.enemy_pieces).to eql([])
    end
  end






end