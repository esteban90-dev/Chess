class Rook
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'rook'
  end

  public

  private

  def default_symbol
    return "\u265c" if color == 'black'
    "\u2656"
  end

end