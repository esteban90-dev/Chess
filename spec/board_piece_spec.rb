require "./lib/board.rb"
require "./lib/piece.rb"
require "./lib/pawn.rb" 
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
end