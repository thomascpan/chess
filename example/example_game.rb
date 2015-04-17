require_relative "../lib/chess.rb"

x = Chess::Board.new
x.formatted_grid
x.move_piece([1,0], [3,0])
x.formatted_grid
x.move_piece([6,1], [4,1])
x.formatted_grid
x.move_piece([3,0], [4,1])
x.formatted_grid
x.move_piece([0,0], [6,0])
x.formatted_grid
x.move_piece([6,3], [4,3])
x.formatted_grid
x.move_piece([7,3], [5,3])
x.formatted_grid
x.move_piece([6,0], [6,2])
x.formatted_grid
x.move_piece([7,2], [5,0])
x.formatted_grid
x.move_piece([5,3], [2,0])
x.formatted_grid
x.move_piece([0,1], [2,2])
x.formatted_grid
x.move_piece([2,2], [4,3])
x.formatted_grid