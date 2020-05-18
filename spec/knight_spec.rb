require "./lib/knight.rb"
require "./lib/board.rb"

describe Knight do


  let(:grid) { Array.new(8){ Array.new(8) } }
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
      grid[0][0] = black_knight
      board1 = Board.new({:grid=>grid})
      expect(black_knight.valid_destinations(board1)).to eql([[2,1],[1,2]])
    end

=begin
    it "Returns the proper destination(s) if located at initial board configuration" do 
      #black_knight = Knight.new({:color=>"black"})
    
      #expect(knight1.valid_destinations(board)).to eql([[2,2],[2,0]])
    end

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