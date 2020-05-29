require "./lib/game.rb"

describe Game do

  let (:board1) { double("board") }
  let (:console1) { double("console") }

  context "#initialize" do
    it "Raises an exception when initialized with an empty {}" do 
      expect{ Game.new({}) }.to raise_error(KeyError)
    end
    
    it "Does not raise an exception when initialized with a valid input {}" do
      expect{ Game.new({ :board =>  board1, :console => console1 }) }.not_to raise_error(KeyError)
    end
  end

  context "#game_over?" do 
    it "returns true if the board detects checkmate" do
      allow(board1).to receive(:checkmate?).and_return(true)
      game1 = Game.new({:board => board1, :console => console1 })
      expect(game1.game_over?).to eql(true)
    end

    it "returns true if the board detects stalemate" do
      allow(board1).to receive(:checkmate?).and_return(false)
      allow(board1).to receive(:stalemate?).and_return(true)
      game1 = Game.new({:board => board1, :console => console1 })
      expect(game1.game_over?).to eql(true)
    end

    it "returns false if the board doesn't detect checkmate or stalemate" do
      allow(board1).to receive(:checkmate?).and_return(false)
      allow(board1).to receive(:stalemate?).and_return(false)
      game1 = Game.new({:board => board1, :console => console1 })
      expect(game1.game_over?).to eql(false)
    end
  end
end