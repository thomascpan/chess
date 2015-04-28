require_relative "../lib/chess.rb"

player_one = Chess::Player.new("player_one", "B")
player_two = Chess::Player.new("player_two", "W")
players = [player_one, player_two]
x = Chess::Game.new(players).menu

# x = Chess::Board.new
# x.grid[0][0] = Chess::Cell.new
# x.grid[0][5] = Chess::Cell.new
# x.grid[0][6] = Chess::Cell.new
# x.grid[0][7] = Chess::Cell.new
# x.grid[1][4] = Chess::Cell.new
# x.grid[1][5] = Chess::Cell.new
# x.grid[1][6] = Chess::Cell.new
# x.grid[1][7] = Chess::Cell.new

# x.grid[0][1] = Chess::Cell.new
# x.grid[0][2] = Chess::Cell.new
# x.grid[0][3] = Chess::Cell.new
# x.grid[7][1] = Chess::Cell.new
# x.grid[7][2] = Chess::Cell.new
# x.grid[1][2] = Chess::Cell.new
# x.grid[6][2] = Chess::Cell.new
# x.grid[1][0] = Chess::Cell.new
# x.grid[1][1] = Chess::Cell.new
# x.grid[1][3] = Chess::Cell.new
# x.grid[6][3] = Chess::Cell.new
# x.grid[6][1] = Chess::Cell.new
# x.grid[6][7] = Chess::Cell.new
# x.grid[6][0] = Chess::Cell.new
# x.formatted_grid
# x.move_piece([7,3], [7,1])
# x.formatted_grid
# x.move_piece([0,4], [0,3])
# x.formatted_grid
# x.move_piece([0,3], [0,2])
# x.formatted_grid
# x.move_piece([7,7], [5,7])
# x.formatted_grid
# # x.move_piece([0,0], [1,0])
# # x.formatted_grid
# x.move_piece([5,7], [5,3])
# x.formatted_grid
# x.move_piece([7,0], [6,0])
# x.formatted_grid
# x.move_piece([6,0], [6,2])
# x.formatted_grid
# x.move_piece([6,2], [2,2])
# x.formatted_grid
# x.move_piece([2,2], [2,1])
# x.formatted_grid
# x.move_piece([5,3], [2,3])
# x.formatted_grid
# x.move_piece([7,1], [7,0])
# x.formatted_grid
# x.move_piece([7,0], [1,0])
# x.formatted_grid
# puts x.check?("B")
# if x.check?("B")
# 	puts x.checkmate?("B")
# end

# x.formatted_grid
# x.move_piece([1,0], [3,0])
# x.formatted_grid
# x.move_piece([6,1], [4,1])
# x.formatted_grid
# x.move_piece([3,0], [4,1])
# x.formatted_grid
# x.move_piece([0,0], [6,0])
# x.formatted_grid
# x.move_piece([6,3], [4,3])
# x.formatted_grid
# x.move_piece([7,3], [5,3])
# x.formatted_grid
# x.move_piece([6,0], [6,2])
# x.formatted_grid
# x.move_piece([7,2], [5,0])
# x.formatted_grid
# x.move_piece([5,3], [2,0])
# x.formatted_grid
# x.move_piece([0,1], [2,2])
# x.formatted_grid
# x.move_piece([2,2], [4,3])
# x.formatted_grid