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

  def valid_location?(location)
    return false if location[0] < 0 || location[0] > grid.length
    return false if location[1] < 0 || location[1] > grid[0].length
    true
  end

  private

  def default_grid
    Array.new(8){ Array.new(8) }
  end
end