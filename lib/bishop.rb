class Bishop
  attr_reader :color, :symbol, :name

  def initialize(input)
    @color = input.fetch(:color)
    @symbol = input.fetch(:symbol, default_symbol)
    @name = 'bishop'
  end

  public

  private

  def default_symbol
    return "\u265d" if color == 'black'
    "\u2657"
  end

end