require "./lib/board.rb"
require "./lib/piece.rb"
require "./lib/pawn.rb" 
require "./lib/knight.rb"
require "./lib/king.rb"
require "./lib/bishop.rb"
require "./lib/queen.rb"
require "./lib/rook.rb"

 
describe "Board-Piece integration" do 

  let(:empty_grid) { Array.new(8){ Array.new(8) } }

  context "Board#active_color_in_check?" do
    it "returns true if the active color's (white) king position can be reached by any enemy pieces" do
      black_queen = Queen.new({:color=>'black'})
      white_king = King.new({:color=>'white'})
      empty_grid[0][3] = black_queen
      empty_grid[3][3] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.active_color_in_check?).to eql(true)
    end

    it "returns true if the active color's (black) king position can be reached by any enemy pieces" do
      white_queen = Queen.new({:color=>'white'})
      black_king = King.new({:color=>'black'})
      empty_grid[0][3] = white_queen
      empty_grid[3][3] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.active_color_in_check?).to eql(true)
    end

    it "returns false if the active color's (white) king position can't be reached by any enemy pieces" do
      black_queen = Queen.new({:color=>'black'})
      white_king = King.new({:color=>'white'})
      empty_grid[0][3] = black_queen
      empty_grid[3][2] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.active_color_in_check?).to eql(false)
    end

    it "returns false if the active color's (black) king position can't be reached by any enemy pieces" do
      white_queen = Queen.new({:color=>'white'})
      black_king = King.new({:color=>'black'})
      empty_grid[0][3] = white_queen
      empty_grid[3][2] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.active_color_in_check?).to eql(false)
    end

    it "returns false if there is no allied king on the board - for testing purposes" do
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.active_color_in_check?).to eql(false)
    end
  end

  context "Board#disables_check?" do
    it "returns true if the active color is in check and the given move disables a check condition" do
      black_queen = Queen.new({:color=>'black'})
      white_king = King.new({:color=>'white'})
      empty_grid[0][3] = black_queen
      empty_grid[3][3] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.disables_check?([3,3],[3,4])).to eql(true)
    end

    it "returns nil if the active color is not in check" do 
      white_king = King.new({:color=>'white'})
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[3][7] = white_pawn
      empty_grid[4][0] = white_king
      empty_grid[3][6] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.disables_check?([3,7],[2,6])).to eql(nil)
    end
  end

  context "Board#enables_check?" do
    it "returns true if the active color is not check and the given move enables a check condition" do
      black_king = King.new({:color=>'black'})
      white_rook = Rook.new({:color=>'white'})
      empty_grid[2][5] = white_rook
      empty_grid[4][4] = black_king
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      expect(board1.enables_check?([4,4],[4,5])).to eql(true)
    end

    it "returns nil if the active color is already in check" do 
      white_king = King.new({:color=>'white'})
      black_rook = Rook.new({:color=>'black'})
      empty_grid[2][5] = black_rook
      empty_grid[4][5] = white_king
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.enables_check?([4,5],[4,6])).to eql(nil)
    end
  end

  context "Board#move" do
    it "moves a white piece that makes no capture" do
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[6][1] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.move([6,1],[5,1])
      expect(board1.history.last).to eql([white_pawn, [6,1], [5,1], nil, nil])
    end

    it "moves a white piece to capture a black piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[6][1] = white_pawn
      empty_grid[5][2] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.move([6,1],[5,2])
      expect(board1.history.last).to eql([white_pawn, [6,1], [5,2], black_pawn, [5,2]])
    end

    it "moves a black piece that makes no capture" do
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[1][1] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move([1,1],[3,1])
      expect(board1.history.last).to eql([black_pawn, [1,1], [3,1], nil, nil])
    end

    it "moves a black piece to capture a white piece" do
      black_pawn = Pawn.new({:color=>'black'})
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[3][3] = black_pawn
      empty_grid[4][4] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move([3,3],[4,4])
      expect(board1.history.last).to eql([black_pawn, [3,3], [4,4], white_pawn, [4,4]])
    end

    it "moves a white pawn en_passant (+x direction) to capture a black piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[3][3] = white_pawn
      empty_grid[3][4] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [black_pawn, [4,1], [4,3], nil, nil]
      board1.move([3,3],[2,4])
      expect(board1.history.last).to eql([white_pawn, [3,3], [2,4], black_pawn, [3,4]])
    end

    it "moves a white pawn en_passant (-x direction) to capture a black piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[3][4] = white_pawn
      empty_grid[3][3] = black_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [black_pawn, [3,1], [3,3], nil, nil]
      board1.move([3,4],[2,3])
      expect(board1.history.last).to eql([white_pawn, [3,4], [2,3], black_pawn, [3,3]])
    end

    it "moves a black pawn en_passant (+x direction) to capture a white piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[4][1] = black_pawn
      empty_grid[4][2] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn, [6,2], [6,4], nil, nil]
      board1.swap_color
      board1.move([4,1],[5,2])
      expect(board1.history.last).to eql([black_pawn, [4,1], [5,2], white_pawn, [4,2]])
    end

    it "moves a black pawn en_passant (-x direction) to capture a white piece" do
      white_pawn = Pawn.new({:color=>'white'})
      black_pawn = Pawn.new({:color=>'black'})
      empty_grid[4][3] = black_pawn
      empty_grid[4][2] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.history << [white_pawn, [6,2], [6,4], nil, nil]
      board1.swap_color
      board1.move([4,3],[5,2])
      expect(board1.history.last).to eql([black_pawn, [4,3], [5,2], white_pawn, [4,2]])
    end

    it "moves a king and a rook in a king side castling move (white)" do
      white_king = King.new({:color=>'white'})
      white_rook_1 = Rook.new({:color=>'white'})
      white_rook_2 = Rook.new({:color=>'white'})
      empty_grid[7][0] = white_rook_2
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook_1
      board1 = Board.new({:grid=>empty_grid})
      board1.move([7,4],[7,6])
      expect(board1.history[0..1]).to eql([[white_king, [7,4], [7,6], nil, nil], [white_rook_1, [7,7], [7,5], nil, nil]])
    end

    it "moves a king and a rook in a king side castling move (black)" do
      black_king = King.new({:color=>'black'})
      black_rook_1 = Rook.new({:color=>'black'})
      black_rook_2 = Rook.new({:color=>'black'})
      empty_grid[0][0] = black_rook_2
      empty_grid[0][4] = black_king
      empty_grid[0][7] = black_rook_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move([0,4],[0,6])
      expect(board1.history[0..1]).to eql([[black_king, [0,4], [0,6], nil, nil], [black_rook_1, [0,7], [0,5], nil, nil]])
    end

    it "moves a king and a rook in a queen side castling move (white)" do
      white_king = King.new({:color=>'white'})
      white_rook_1 = Rook.new({:color=>'white'})
      white_rook_2 = Rook.new({:color=>'white'})
      empty_grid[7][0] = white_rook_2
      empty_grid[7][4] = white_king
      empty_grid[7][7] = white_rook_1
      board1 = Board.new({:grid=>empty_grid})
      board1.move([7,4],[7,1])
      expect(board1.history[0..1]).to eql([[white_king, [7,4], [7,1], nil, nil], [white_rook_2, [7,0], [7,2], nil, nil]])
    end

    it "moves a king and a rook in a queen side castling move (black)" do
      black_king = King.new({:color=>'black'})
      black_rook_1 = Rook.new({:color=>'black'})
      black_rook_2 = Rook.new({:color=>'black'})
      empty_grid[0][0] = black_rook_2
      empty_grid[0][4] = black_king
      empty_grid[0][7] = black_rook_1
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move([0,4],[0,1])
      expect(board1.history[0..1]).to eql([[black_king, [0,4], [0,1], nil, nil], [black_rook_2, [0,0], [0,2], nil, nil]])
    end

    it "records error message if the source cell is empty" do
      board1 = Board.new({:grid=>empty_grid})
      board1.move([0,0],[1,0])
      expect(board1.history.last).to eql("invalid move - source cell empty")
    end

    it "records error message if the source cell is an enemy piece" do
      black_rook = Rook.new({:color=>'black'})
      empty_grid[0][4] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.move([0,4],[0,5])
      expect(board1.history.last).to eql("invalid move - source cell contains enemy piece")
    end

    it "records error message if the source cell matches the destination cell" do
      black_rook = Rook.new({:color=>'black'})
      empty_grid[0][4] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      board1.swap_color
      board1.move([0,4],[0,4])
      expect(board1.history.last).to eql("invalid move - source cell matches destination cell")
    end

    it "records error message if the source piece can't move to the destination" do
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[6][1] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      board1.move([6,1],[3,1])
      expect(board1.history.last).to eql("invalid move - white pawn can't move from [6, 1] to [3, 1]")
    end
  end
end