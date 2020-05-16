require "./lib/knight.rb"

describe Knight do

  TestPiece = Struct.new(:color)
  let(:white_piece) { TestPiece.new("white") }
  let(:black_piece) { TestPiece.new("black") }
  let(:board) { double("Board")} 

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Knight.new({}) }.to raise_error(KeyError)
    end

    it "Doesn't raise an exception when initialized with a proper {}" do 
      expect{ Knight.new({:color => 'black'}) }.not_to raise_error(KeyError)
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
      knight1 = Knight.new({:color=>"black"})
      #allow(board).to receive(:location).and_return([0,0])
      #allow(board).to receive(:valid_location?).and_return(true, true, false, false, false, false, false, false)
      #allow(board).to receive(:contents).and_return(nil, nil)
      #allow(board).to receive(:active_color_in_check?).and_return(false)
      expect(knight1.valid_destinations(board)).to eql([[2,1],[1,2]])
    end

    it "Returns the proper destination(s) if located at initial board configuration" do 
      knight1 = Knight.new({:color=>"black"})
      #allow(board).to receive(:location).and_return([0,1])
      #allow(board).to receive(:valid_location?).and_return(true, false, false, false, false, false, false, true)
      #allow(board).to receive(:contents).and_return(nil,nil)
      #allow(board).to receive(:active_color_in_check?).and_return(false)
      expect(knight1.valid_destinations(board)).to eql([[2,2],[2,0]])
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



  end

end