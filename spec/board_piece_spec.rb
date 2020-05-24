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

  context "Board#under_threat?" do
    it "returns true if the given position can be reached by any enemy piece" do
      black_rook = Rook.new({:color=>'black'})
      empty_grid[0][5] = black_rook
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.under_threat?([0,0])).to eql(true)
    end

    it "returns false if the given position can't be reached by any enemy piece" do
      black_pawn = Pawn.new({:color=>'black'})
      white_pawn = Pawn.new({:color=>'white'})
      empty_grid[0][1] = black_pawn
      empty_grid[2][2] = white_pawn
      board1 = Board.new({:grid=>empty_grid})
      expect(board1.under_threat?([3,3])).to eql(false)
    end
  end

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
end