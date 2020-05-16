class Board
  attr_reader :grid

  def initialize(input={})
    @grid = input.fetch(:grid, default_grid)
  end

  public

  def contents(input)
    grid[input[0]][input[1]]
  end


  private

  def default_grid
    Array.new(8){ Array.new(8) }
  end


end