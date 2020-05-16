class Board
  attr_reader :grid

  def initialize(input={})
    @grid = input.fetch(:grid, default_grid)
  end

  public

  def contents(input)
    grid[input[0]][input[1]]
  end

  def location(piece)
    i = 0
    j = 0
    result = []
    while i < grid.length
      while j < grid[i].length
        result << [i,j] if grid[i][j] == piece
        j += 1
      end
      i += 1
      j = 0
    end
    return nil if result.empty?
    result
  end


  private

  def default_grid
    Array.new(8){ Array.new(8) }
  end


end