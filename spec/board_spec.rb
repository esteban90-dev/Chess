require "./lib/board.rb"

describe Board do

  
  let(:empty_grid) { Array.new(8){ Array.new(8) } }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations)


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
      black_pawn_1 = TestPiece1.new("black","pawn", [])
      empty_grid[0][0] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.contents([0,0])).to eql(black_pawn_1)
    end

    it "Returns nil for an empty cell" do
      empty_grid[3][3] = nil
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.contents([3,3])).to eql(nil)
    end
  end

  context "#location" do
    it "returns the location of an object on the board, if it exists" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      empty_grid[3][3] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.location(white_pawn_1)).to eql([3,3])
    end

    it "returns all locations of an object on the board, if it exists in multiple places" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      white_pawn_2 = TestPiece1.new("white","pawn", [])
      empty_grid[0][0] = white_pawn_1
      empty_grid[3][3] = white_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.location(white_pawn_1)).to eql([[0,0],[3,3]])
    end

    it "returns nil if an object doesn't exist on the board" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      black_pawn_1 = TestPiece1.new("black","pawn", [])
      empty_grid[3][3] = white_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.location(black_pawn_1)).to eql(nil)
    end
  end

  context "#valid_location?" do
    it "[1,3] returns true" do 
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.valid_location?([1,3])).to eql(true)
    end

    it "[8,8] returns false" do 
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.valid_location?([8,8])).to eql(false)
    end

    it "[-1,1] returns false" do 
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.valid_location?([-1,1])).to eql(false)
    end
  end

  context "#active_color, #swap_color" do
    it "returns 'white' if it's white's turn (white goes first)" do
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.active_color).to eql('white')
    end

    it "returns 'black' if it's black's turn" do
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.active_color).to eql('black')
    end
  end

  context "#allied_pieces" do
    it "returns an array of the pieces on the board that match the supplied color" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      white_pawn_2 = TestPiece1.new("white","pawn", [])
      white_pawn_3 = TestPiece1.new("white","pawn", []) 
      black_pawn_1 = TestPiece1.new("black","pawn", []) 
      empty_grid[0][0] = white_pawn_1
      empty_grid[4][5] = white_pawn_2
      empty_grid[7][7] = white_pawn_3
      empty_grid[2][2] = black_pawn_1
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.allied_pieces(board1.active_color)).to eql([white_pawn_1, white_pawn_2, white_pawn_3])
    end

    it "returns [] if no pieces are on the board that match the supplied color" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      white_pawn_2 = TestPiece1.new("white","pawn", [])
      white_pawn_3 = TestPiece1.new("white","pawn", []) 
      empty_grid[0][0] = white_pawn_1
      empty_grid[4][5] = white_pawn_2
      empty_grid[7][7] = white_pawn_3
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.allied_pieces(board1.active_color)).to eql([])
    end
  end

  context "#enemy_pieces" do
    it "returns an array of the pieces on the board that don't match the supplied color" do
      white_pawn_1 = TestPiece1.new("white","pawn", [])
      white_pawn_2 = TestPiece1.new("white","pawn", [])
      white_pawn_3 = TestPiece1.new("white","pawn", [])
      black_pawn_1 = TestPiece1.new("black","pawn", [])
      black_pawn_2 = TestPiece1.new("black","pawn", [])
      empty_grid[0][0] = white_pawn_1
      empty_grid[4][5] = white_pawn_2
      empty_grid[7][7] = white_pawn_3
      empty_grid[2][2] = black_pawn_1
      empty_grid[2][3] = black_pawn_2
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.enemy_pieces(board1.active_color)).to eql([black_pawn_1, black_pawn_2])
    end

    it "returns [] if there are no pieces on the board that don't match the active color" do
      white_pawn = TestPiece1.new("white","pawn", [])
      empty_grid[0][0] = white_pawn
      empty_grid[4][5] = white_pawn
      empty_grid[7][7] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.enemy_pieces(board1.active_color)).to eql([])
    end
  end

  context "#formatted" do
    it "returns the board formatted as a string" do
      board1 = Board.new
      expect(board1.formatted).to be_a(String)
    end
  end

  context "#place" do 
    it "updates the board at the given location with the given item" do
      board1 = Board.new
      board1.place([0,0],'test')
      expect(board1.contents([0,0])).to eql('test')
    end

    it "returns nil if the given location is not on the board" do
      board1 = Board.new
      expect(board1.place([-1,0],'test')).to eql(nil)
    end
  end

  context "#an_to_yx" do
    it "converts a coordinate described in algebraic notation to yx" do
      board1 = Board.new
      expect(board1.an_to_yx('b5')).to eql([3,1])
    end
  end

  context "#yx_to_an" do
    it "converts a yx coordinate to algebraic notation" do
      board1 = Board.new
      expect(board1.yx_to_an([3,1])).to eql('b5')
    end
  end
end