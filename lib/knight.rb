class Knight
  attr_reader :color, :symbol

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
  end

  private

  def default_symbol
    return "\u265e" if color == 'black'
    "\u2658"
  end

end