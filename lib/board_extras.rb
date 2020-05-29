def grid_map(input)
  map = {
  "a1" => [7,0],
  "a2" => [6,0],
  "a3" => [5,0],
  "a4" => [4,0],
  "a5" => [3,0],
  "a6" => [2,0],
  "a7" => [1,0],
  "a8" => [0,0],
  "b1" => [7,1],
  "b2" => [6,1],
  "b3" => [5,1],
  "b4" => [4,1],
  "b5" => [3,1],
  "b6" => [2,1],
  "b7" => [1,1],
  "b8" => [0,1],
  "c1" => [7,2],
  "c2" => [6,2],
  "c3" => [5,2],
  "c4" => [4,2],
  "c5" => [3,2],
  "c6" => [2,2],
  "c7" => [1,2],
  "c8" => [0,2],
  "d1" => [7,3],
  "d2" => [6,3],
  "d3" => [5,3],
  "d4" => [4,3],
  "d5" => [3,3],
  "d6" => [2,3],
  "d7" => [1,3],
  "d8" => [0,3],
  "e1" => [7,4],
  "e2" => [6,4],
  "e3" => [5,4],
  "e4" => [4,4],
  "e5" => [3,4],
  "e6" => [2,4],
  "e7" => [1,4],
  "e8" => [0,4],
  "f1" => [7,5],
  "f2" => [6,5],
  "f3" => [5,5],
  "f4" => [4,5],
  "f5" => [3,5],
  "f6" => [2,5],
  "f7" => [1,5],
  "f8" => [0,5],
  "g1" => [7,6],
  "g2" => [6,6],
  "g3" => [5,6],
  "g4" => [4,6],
  "g5" => [3,6],
  "g6" => [2,6],
  "g7" => [1,6],
  "g8" => [0,6],
  "h1" => [7,7],
  "h2" => [6,7],
  "h3" => [5,7],
  "h4" => [4,7],
  "h5" => [3,7],
  "h6" => [2,7],
  "h7" => [1,7],
  "h8" => [0,7]
  }
  map[input]
end


def default_grid
  grid = Array.new(8){ Array.new(8) }

  black_pawn_1 = Pawn.new({:color=>'black', :symbol=>'P*'})
  black_pawn_2 = Pawn.new({:color=>'black', :symbol=>'P*'})
  black_pawn_3 = Pawn.new({:color=>'black', :symbol=>'P*'})
  black_pawn_4 = Pawn.new({:color=>'black', :symbol=>'P*'})
  black_pawn_5 = Pawn.new({:color=>'black', :symbol=>'P*'})
  black_pawn_6 = Pawn.new({:color=>'black', :symbol=>'P*'})
  black_pawn_7 = Pawn.new({:color=>'black', :symbol=>'P*'})
  black_pawn_8 = Pawn.new({:color=>'black', :symbol=>'P*'})
  black_rook_1 = Rook.new({:color=>'black', :symbol=>'R*'})
  black_rook_2 = Rook.new({:color=>'black', :symbol=>'R*'})
  black_knight_1 = Knight.new({:color=>'black', :symbol=>'N*'})
  black_knight_2 = Knight.new({:color=>'black', :symbol=>'N*'})
  black_bishop_1 = Bishop.new({:color=>'black', :symbol=>'B*'})
  black_bishop_2 = Bishop.new({:color=>'black', :symbol=>'B*'})
  black_king = King.new({:color=>'black', :symbol=>'K*'})
  black_queen = Queen.new({:color=>'black', :symbol=>'Q*'})

  grid[0][0] = black_rook_1
  grid[0][1] = black_knight_1
  grid[0][2] = black_bishop_1
  grid[0][3] = black_queen
  grid[0][4] = black_king
  grid[0][5] = black_bishop_2
  grid[0][6] = black_knight_2
  grid[0][7] = black_rook_2
  grid[1][0] = black_pawn_1
  grid[1][1] = black_pawn_2
  grid[1][2] = black_pawn_3
  grid[1][3] = black_pawn_4
  grid[1][4] = black_pawn_5
  grid[1][5] = black_pawn_6
  grid[1][6] = black_pawn_7
  grid[1][7] = black_pawn_8

  white_pawn_1 = Pawn.new({:color=>'white', :symbol=>'P'})
  white_pawn_2 = Pawn.new({:color=>'white', :symbol=>'P'})
  white_pawn_3 = Pawn.new({:color=>'white', :symbol=>'P'})
  white_pawn_4 = Pawn.new({:color=>'white', :symbol=>'P'})
  white_pawn_5 = Pawn.new({:color=>'white', :symbol=>'P'})
  white_pawn_6 = Pawn.new({:color=>'white', :symbol=>'P'})
  white_pawn_7 = Pawn.new({:color=>'white', :symbol=>'P'})
  white_pawn_8 = Pawn.new({:color=>'white', :symbol=>'P'})
  white_rook_1 = Rook.new({:color=>'white', :symbol=>'R'})
  white_rook_2 = Rook.new({:color=>'white', :symbol=>'R'})
  white_knight_1 = Knight.new({:color=>'white', :symbol=>'N'})
  white_knight_2 = Knight.new({:color=>'white', :symbol=>'N'})
  white_bishop_1 = Bishop.new({:color=>'white', :symbol=>'B'})
  white_bishop_2 = Bishop.new({:color=>'white', :symbol=>'B'})
  white_king = King.new({:color=>'white', :symbol=>'K'})
  white_queen = Queen.new({:color=>'white', :symbol=>'Q'})

  grid[7][0] = white_rook_1
  grid[7][1] = white_knight_1
  grid[7][2] = white_bishop_1
  grid[7][3] = white_queen
  grid[7][4] = white_king
  grid[7][5] = white_bishop_2
  grid[7][6] = white_knight_2
  grid[7][7] = white_rook_2
  grid[6][0] = white_pawn_1
  grid[6][1] = white_pawn_2
  grid[6][2] = white_pawn_3
  grid[6][3] = white_pawn_4
  grid[6][4] = white_pawn_5
  grid[6][5] = white_pawn_6
  grid[6][6] = white_pawn_7
  grid[6][7] = white_pawn_8

  grid
end