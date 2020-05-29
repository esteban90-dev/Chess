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

end