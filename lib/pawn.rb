class Pawn
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'pawn'
  end

  private

  def default_symbol
    return "\u265f" if color == 'black'
    "\u2659"
  end
end