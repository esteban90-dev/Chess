require "./lib/game.rb"

describe Game do

  let (:board1) { double("board") }

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Game.new({}) }.to raise_error(KeyError)
    end
    
    it "Does not raise an exception when initialized with a valid input {}" do
      expect{ Game.new({ :board =>  board1}) }.not_to raise_error(KeyError)
    end
  end

  context "#game_over?" do 
    it "returns true if the board detects checkmate" do
      allow(board1).to receive(:checkmate?).and_return(true)
      game1 = Game.new({:board => board1})
      expect(game1.game_over?).to eql(true)
    end

    it "returns true if the board detects stalemate" do
      allow(board1).to receive(:checkmate?).and_return(false)
      allow(board1).to receive(:stalemate?).and_return(true)
      game1 = Game.new({:board => board1})
      expect(game1.game_over?).to eql(true)
    end

    it "returns false if the board doesn't detect checkmate or stalemate" do
      allow(board1).to receive(:checkmate?).and_return(false)
      allow(board1).to receive(:stalemate?).and_return(false)
      game1 = Game.new({:board => board1})
      expect(game1.game_over?).to eql(false)
    end
  end

  context "#result" do
    it "returns nil if game_over? returns false" do
      allow(board1).to receive(:checkmate?).and_return(false)
      allow(board1).to receive(:stalemate?).and_return(false)
      game1 = Game.new({:board => board1})
      expect(game1.result).to eql(nil)
    end

    it "returns a message indicating that black is the winner if white is in checkmate" do
      allow(board1).to receive(:checkmate?).and_return(true)
      allow(board1).to receive(:active_color).and_return('white')
      game1 = Game.new({:board => board1})
      expect(game1.result).to eql('Checkmate! Black wins!')
    end

    it "returns a message indicating that white is the winner if black is in checkmate" do
      allow(board1).to receive(:checkmate?).and_return(true)
      allow(board1).to receive(:active_color).and_return('black')
      game1 = Game.new({:board => board1})
      expect(game1.result).to eql('Checkmate! White wins!')
    end

    it "returns a message indicating a draw if stalemate is detected" do
      allow(board1).to receive(:checkmate?).and_return(false)
      allow(board1).to receive(:stalemate?).and_return(true)
      game1 = Game.new({:board => board1})
      expect(game1.result).to eql('Stalemate! Game is a draw.')
    end
  end

  context "#valid_move_input?" do
    it "returns true if the given input matches the format 'a2:b3'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_move_input?('a2:b3')).to eql(true)
    end

    it "returns false if the given input does not match the format 'a2:b3'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_move_input?('a2b3')).to eql(false)
    end

    it "accepts capital letters" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_move_input?('A2:B3')).to eql(true)
    end
  end

  context "#valid_promotion_input?" do
    it "returns true if given input is 'rook'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_promotion_input?('rook')).to eql(true)
    end

    it "returns true if given input is 'BISHOP'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_promotion_input?('BISHOP')).to eql(true)
    end

    it "returns false if the given input is 'Pawn'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_promotion_input?('Pawn')).to eql(false)
    end
  end

  context "#valid_save_load_input?" do
    it "returns true when given input is 'y'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_save_load_input?('y')).to eql(true)
    end

    it "returns true when given input is 'Y'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_save_load_input?('Y')).to eql(true)
    end

    it "returns true when given input is 'n'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_save_load_input?('n')).to eql(true)
    end

    it "returns false when given input is 'z'" do
      game1 = Game.new({:board => board1})
      expect(game1.valid_save_load_input?('z')).to eql(false)
    end
  end
end