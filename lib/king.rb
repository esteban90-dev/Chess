class King
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'king'
  end

  public

  private

  def default_symbol
    return "\u265a" if color == 'black'
    "\u2654"
  end

end