require_relative "../lib/chess.rb"

x = Chess::Board.new
x.formatted_grid
x.move_piece([0,0], [3,0])
x.formatted_grid
x.move_piece([1,0], [2,0])
x.formatted_grid
x.move_piece([1,1], [2,1])
x.formatted_grid
x.move_piece([3,0], [3,4])
x.formatted_grid