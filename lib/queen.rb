class Queen
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'queen'
  end

  public

  private

  def default_symbol
    return "\u265b" if color == 'black'
    "\u2655"
  end

end