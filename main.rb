require "./lib/board.rb"
require "./lib/rook.rb"
require "./lib/bishop.rb"
require "./lib/piece.rb"
require "./lib/pawn.rb"
require "./lib/knight.rb"
require "./lib/king.rb"
require "./lib/queen.rb"
require "./lib/game.rb"
require "yaml"


board1 = Board.new
puts Game.welcome
input = ''
until input.match?(/^[y]$|^[n]$/)
  puts Game.load_prompt_message
  input = gets.chomp.downcase
end

game1 = input == 'y' ? Game.load('./saves/save_file') : Game.new({:board => board1})
game1.play