require "./lib/knight.rb"
require "./lib/board.rb"

describe Knight do


  let(:empty_grid) { Array.new(8){ Array.new(8) } }
  let(:initial_grid) { build_initial_grid }
  TestPiece1 = Struct.new(:color, :name, :valid_destinations)


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

  context "#valid_destinations" do
    it "Returns the proper destination(s) if located at [0,0] on an empty board" do
      black_knight = Knight.new({:color=>"black"})
      empty_grid[0][1] = black_knight
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(black_knight.valid_destinations(board1)).to eql([[2,1],[1,2]])
    end

    it "Returns the proper destination(s) if located at initial board configuration" do 
      black_knight = Knight.new({:color=>"black"})
      initial_grid[0][1] = black_knight
      board1 = Board.new({:grid=>initial_grid})
      board1.swap_color
      expect(black_knight.valid_destinations(board1)).to eql([[2,2],[2,0]])
    end

=begin
    it "Returns the proper destination(s) if black is in check and only moving to [5,4] will remove check" do 
      knight1 = Knight.new({:color=>"black"})
      #allow(board).to receive(:location).and_return([3,3])
      #allow(board).to receive(:valid_location?).and_return(true, true, true, true, true, true, true, true)
      #allow(board).to receive(:contents).and_return(false, white_piece, nil, false, black_piece, false, white_piece, nil, nil, nil, nil, nil, nil)
      #allow(board).to receive(:active_color_in_check?).and_return(true)
      #allow(board).to receive(:removes_check?).and_return(true, false, false, false, false, false, false, false)
      expect(knight1.valid_destinations(board)).to eql([[5,4]])
    end

    it "Returns the proper destination(s) if black is in check and no moves will remove check" do 
      knight1 = Knight.new({:color=>"black"})
      #allow(board).to receive(:location).and_return([3,3])
      #allow(board).to receive(:valid_location?).and_return(true, true, true, true, true, true, true, true)
      #allow(board).to receive(:contents).and_return(nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
      #allow(board).to receive(:active_color_in_check?).and_return(true)
      #allow(board).to receive(:removes_check?).and_return(false, false, false, false, false, false, false, false)
      expect(knight1.valid_destinations(board)).to eql([])
    end
=end    



  end

end



def build_initial_grid
  initial_grid = Array.new(8){ Array.new(8) }
  black_rook_1 = TestPiece1.new("black", "rook", [])
  black_rook_2 = TestPiece1.new("black", "rook", [])
  black_knight_1 = TestPiece1.new("black", "knight", [])
  black_knight_2 = TestPiece1.new("black", "knight", [])
  black_bishop_1 = TestPiece1.new("black", "bishop", [])
  black_bishop_2 = TestPiece1.new("black", "bishop", [])
  black_queen = TestPiece1.new("black", "queen", [])
  black_king = TestPiece1.new("black", "king", [])
  black_pawn_1 = TestPiece1.new("black", "pawn", [])
  black_pawn_2 = TestPiece1.new("black", "pawn", [])
  black_pawn_3 = TestPiece1.new("black", "pawn", [])
  black_pawn_4 = TestPiece1.new("black", "pawn", [])
  black_pawn_5 = TestPiece1.new("black", "pawn", [])
  black_pawn_6 = TestPiece1.new("black", "pawn", [])
  black_pawn_7 = TestPiece1.new("black", "pawn", [])
  black_pawn_8 = TestPiece1.new("black", "pawn", [])
  initial_grid[0][0] = black_rook_1
  initial_grid[0][1] = black_knight_1
  initial_grid[0][2] = black_bishop_1
  initial_grid[0][3] = black_queen
  initial_grid[0][4] = black_king
  initial_grid[0][5] = black_bishop_2  
  initial_grid[0][6] = black_knight_2
  initial_grid[0][7] = black_rook_2 
  initial_grid[1][0] = black_pawn_1
  initial_grid[1][1] = black_pawn_2 
  initial_grid[1][2] = black_pawn_3 
  initial_grid[1][3] = black_pawn_4 
  initial_grid[1][4] = black_pawn_5 
  initial_grid[1][5] = black_pawn_6 
  initial_grid[1][6] = black_pawn_7 
  initial_grid[1][7] = black_pawn_8 

  white_rook_1 = TestPiece1.new("white", "rook", [])
  white_rook_2 = TestPiece1.new("white", "rook", [])
  white_knight_1 = TestPiece1.new("white", "knight", [])
  white_knight_2 = TestPiece1.new("white", "knight", [])
  white_bishop_1 = TestPiece1.new("white", "bishop", [])
  white_bishop_2 = TestPiece1.new("white", "bishop", [])
  white_queen = TestPiece1.new("white", "queen", [])
  white_king = TestPiece1.new("white", "king", [])
  white_pawn_1 = TestPiece1.new("white", "pawn", [])
  white_pawn_2 = TestPiece1.new("white", "pawn", [])
  white_pawn_3 = TestPiece1.new("white", "pawn", [])
  white_pawn_4 = TestPiece1.new("white", "pawn", [])
  white_pawn_5 = TestPiece1.new("white", "pawn", [])
  white_pawn_6 = TestPiece1.new("white", "pawn", [])
  white_pawn_7 = TestPiece1.new("white", "pawn", [])
  white_pawn_8 = TestPiece1.new("white", "pawn", [])
  initial_grid[7][0] = white_rook_1
  initial_grid[7][1] = white_knight_1
  initial_grid[7][2] = white_bishop_1
  initial_grid[7][3] = white_queen
  initial_grid[7][4] = white_king
  initial_grid[7][5] = white_bishop_2  
  initial_grid[7][6] = white_knight_2
  initial_grid[7][7] = white_rook_2 
  initial_grid[6][0] = white_pawn_1
  initial_grid[6][1] = white_pawn_2 
  initial_grid[6][2] = white_pawn_3 
  initial_grid[6][3] = white_pawn_4 
  initial_grid[6][4] = white_pawn_5 
  initial_grid[6][5] = white_pawn_6 
  initial_grid[6][6] = white_pawn_7 
  initial_grid[6][7] = white_pawn_8 

  initial_grid
end